# Pipewire on Devuan
A brief guide to running Pipewire on Devuan due to the lack of much documentation on the topic. This can solve many issues, such as audio devices connecting, but not outputting, on Devuan - and in general, Pipewire is far better than Pulse anyway.

This script currently only supports **sysvinit** and **OpenRC**.

1.  Clone this repository either by clicking at the top right "Download as Zip" or by following the command below. Clone or extract the repository into /home.
```
git clone https://github.com/arkhiwarkhi/Pipewire-on-Devuan && cd Pipewire-on-Devuan
```
2. Make install-pipewire.sh executable.
```
chmod +x install-pipewire.sh
```
3. Run the shell script with root privileges.
```
doas ./install-pipewire.sh
```
4. All done! Reboot if necessary.
