#!/usr/bin/env bash

if [ "$EUID" -ne 0]; then
	echo "Please run this script with sudo, doas, or as root."
	exit 1
fi

chmod +x wire
chmod +x wire.desktop

echo "Installing pipewire-audio.."
apt-get update -y
apt-get install -y "pipewire-audio"

if [ -x /sbin/openrc ]; then
	rc-update del pulseaudio-enable-autospawn
elif [ -x /sbin/init ]; then
	update-rc.d -f pulseaudio-enable-autospawn remove
else
	echo "Init system not supported at this time"
fi

rm /etc/init.d/pulseaudio-enable-autospawn/*

rmdir /etc/init.d/pulseaudio-enable-autospawn
#intended dest is user home
mv wire ..
#intended dest is user home /.config/autostart
mv wire.desktop ../.config/autostart

preferences_file="/etc/apt/preferences.d/pulseaudio-block"
#permanently block installation of pulseaudio on all release versions.

content="Package: pulseaudio
Pin: release o=Devuan
Pin-Priority: -10"

echo "$content" | sudo tee "$preferences_file" > /dev/null

echo "Finished installing pipewire!"
