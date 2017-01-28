#! /bin/bash
echo Setup Kiosk Mode on Raspberry Pi
echo ================================
echo
sudo apt-get install chromium x11-xserver-utils unclutter
# sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
# To disable the screensaver add a # to the beginning of the line, this comments the line out.
sudo sed -ie 's/@xscreensaver -no-splash/#@xscreensaver -no-splash/g' /etc/xdg/lxsession/LXDE-pi/autostart
sudo echo '@xset s off\n' >> /etc/xdg/lxsession/LXDE-pi/autostart
sudo echo '@xset -dpms\n' >> /etc/xdg/lxsession/LXDE-pi/autostart
sudo echo '@xset s noblank\n' >> /etc/xdg/lxsession/LXDE-pi/autostart
sudo echo '@chromium --noerrdialogs --kiosk http://sdlap11.dewhirst.grp/\n' >> /etc/xdg/lxsession/LXDE-pi/autostart
#
#@sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences
#
