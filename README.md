# rpi_morse_ip
A bash startup script that will flash the Pi Zero W's IP address in morse code using its single onboard LED. This is useful for LAN's that block addressing by hostname (eg `ssh pi@raspberrypi.local` fails to locate your Pi connected to the wifi) and in situations where you do not have a monitor or monitor cable but wish to use the Pi Zero as an IOT device.

##Usage
1. Configure wpa_supplicant.conf in /etc/wpa_supplicant so the Pi can connect to your wifi network on startup.
2. Add the line `./etc/init.d/morse_ip.sh &` to the /etc/rc.local file on your Pi's SD card (you'll have to mount it using a Linux machine that supports the RPi's filesystem, not macOS or Windows. Use a free VirtualBox Ubuntu VM if you don't have an installation already). Or, if you haven't customized rc.local before, just switch it out with the rc.local file included in this repository.
3. Place morse_ip.sh in your Pi's /etc/init.d/ folder, making sure its permissions are `755` to allow execution by the system.
4. Replace its MicroSD card and boot your Pi. Wait about 60 seconds for it to boot up and start flashing the IP, and take down the morse code on a notepad, then translate to a numerical IP address. Note that all numbers follow standard international morse code, but for simplicity, a full stop character is rendered as `dot dash dot dash dot dash` (0 1 0 1 0 1 in the script).

<a href="https://jake.glass">jake.glass</a>
