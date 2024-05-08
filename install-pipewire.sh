#!/usr/bin/env bash

preferences_file="/etc/apt/preferences.d/pulseaudio-block.pref"
block_pulse="Package: pulseaudio
Pin: release o=Devuan
Pin-Priority: -10"

if [ "$EUID" -ne 0 ]; then
	echo "Please run this script with sudo, doas, or as root."
	exit 1
fi

chmod +x wire
chmod_status_wire_script=$?
if [ $chmod_status_wire_script -eq 0 ]; then
	chmod +x wire.desktop
 	chmod_status_wire_desktop=$?
  	if [ $chmod_status_wire_desktop -eq 0 ]; then
   		echo "Updating repositories..."
     		apt-get update -y
       		apt_status_update=$?
	 	if [ $apt_status_update -eq 0 ]; then
   			echo "Installing pipewire-audio..."
   			apt-get install -y "pipewire-audio"
			apt_status_install=$?
   			if [ $apt_status_install -eq 0 ]; then
      				echo "Installed pipewire successfully! Removing remnant pulseaudio services."
				if [ -x /sbin/openrc ]; then
    					rc-update del pulseaudio-enable-autospawn
	 				openrc_status_remove=$?
      					if [ $openrc_status_remove -eq 0 ]; then
	   					echo ""
					else
     						echo "Could not disable the pulseaudio-enable-autospawn service"
	   				fi
	 			elif [ -x /sbin/init ]; then
     					update-rc.d -f pulseaudio-enable-autospawn remove
	  				sysv_status_remove=$?
       					if [ $sysv_status_remove -eq 0 ]; then
	    					echo ""
	  				else
       						echo "Could not disable the pulseaudio-enable-autospawn service"
	     				fi
	  			else
      					echo "Init system not supported at this time"
	   				exit
	   			fi
      			else
				echo "Could not install pipewire-audio"
    				exit 1
  			fi
     		else
       			echo "Could not update repositories"
	  		exit 1
       		fi
    	else
     		echo "Could not change execute permissions on wire.desktop"
       		exit 1
     	fi
else
	echo "Could not change execute permissions on script 'wire'"
 	exit 1
fi

rm /etc/init.d/pulseaudio-enable-autospawn/*
remove_status_autospawn=$?
if [ $remove_status_autospawn -eq 0 ]; then
	rmdir /etc/init.d/pulseaudio-enable-autospawn
 	removedir_status_autospawn=$?
  	if [ $removedir_status_autospawn -eq 0 ]; then
		mv wire $HOME
  		move_status_wire=$?
    		if [ $move_status_wire -eq 0 ]; then
      			mv wire.desktop $XDG_CONFIG_HOME/autostart
	 		move_status_desktop=$?
    			if [ $move_status_desktop -eq 0 ]; then
				echo "$block_pulse" | sudo tee "$preferences_file" > /dev/null
    				block_status_pulse=$?
				if [ $block_status_pulse -eq 0 ]; then
    					echo "Pulseaudio has been blocked from installation! All done."
	 			else
     					echo "Unable to block installation of Pulseaudio."
	  				exit 1
	  			fi
	  		else
     				echo "XDG_CONFIG_HOME not set, trying to accommodate..."
				${XDG_CONFIG_HOME:=$HOME/.config}
    				mv wire.desktop $XDG_CONFIG_HOME/autostart
				move_status_retry_desktop=$?
    				if [ $move_status_retry_desktop -eq 0 ]; then
					echo "XDG_CONFIG_HOME found."
     					echo "$block_pulse" | sudo tee "$preferences_file" > /dev/null
	  				block_status_pulse=$?
       					if [ $block_status_pulse -eq 0 ]; then
						echo "Pulseaudio has been blocked from installation! All done."
	 				else
						echo "Unable to block installation of Pulseaudio."
      						exit 1
	  				fi
     					
   				else
					echo "Unable to set an XDG_CONFIG_HOME."
     					exit 1
       				fi
			fi
		else
			echo "Could not move wire to '$HOME'."
    		fi
    	else
		echo "Could not remove pulseaudio-enable-autospawn directory"
  		exit 1
     	fi
else
	echo "Unable to remove pulseaudio-enable-autospawn."
 	exit 1
fi
