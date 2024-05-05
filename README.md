# Pipewire on Devuan
A brief guide to running Pipewire on Devuan due to the lack of much documentation on the topic.

1. Install the pipewire-audio metapackage via APT. Once you have done this, you probably shouldn't remove any further pulseaudio packages as APT will take care of the ones that need to be removed.
```
sudo apt-get install pipewire audio
```
2.  Clone this repository either by clicking at the top right "Download as Zip" or
```
git clone https://github.com/arkhiwarkhi/Pipewire-on-Devuan && cd Pipewire-on-Devuan
```
3. Move the "wire" file to the ~/ folder, and wire.desktop to /usr/share/applications. There are other options, like ~/.local/share/applications, or /opt/, but this will require editing wire.desktop.
```
mv wire ~/ && sudo mv wire.desktop /usr/share/applications/
```
4. Use your desktop environment's preferred method of adding autostart applications. In GNOME, this is under GNOME Tweaks > Startup Applications. In KDE, this is System Settings > Autostart. In xfce, it is xfce4-settings-manager > Application Autostart.
5. Restarting the session or a reboot may be required, depending.

# Troubleshooting
Ensure the pulseaudio-enable-autospawn service is disabled. You can either remove it or for a cleaner method (via SysVInit):
```
update-rc.d -f pulseaudio-enable-autospawn remove
```
To do the same for OpenRC:
```
rc-update del pulseaudio-enable-autospawn
```
