# Raspberry Pi Kiosk Using Chromium
==================================== 
<br>
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install chromium x11-xserver-utils unclutter

Install Chromium
================
The chromium browser includes a kiosk mode which displays the browser full screen wihout any taskbars or icons which works perfectly for a kiosk style screen.

Setting up SSH
==============
First we want to setup a static IP address for our Pi on the network. Make sure your pi is connected to your network and in a terminal window type
Now in terminal we are going to edit your network settings and setup the static address. To do this type

sudo nano /etc/network/interfaces

This will open up your network interfaces file, start by changing the line that says
iface eth0 inet dhcp to iface eth0 inet static

Now you’ll need to add 3 lines straight after if they aren’t already there.

address xxx.xxx.xxx.xxx <br>
netmask 255.255.255.0 <br>
gateway xxx.xxx.xxx.xxx <br>
network xxx.xxx.xxx.xxx <br>
broadcast xxx.xxx.xxx.xxx <br>
dns-nameservers xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx <br>

Raspberry PI Kiosk - Network Settings
=====================================
Adding in the static address you would like to use next to the address line and then your gateway address which you noted down earlier into gateway. Gateway is usually the address of your router so if you forgot to write it down you can work it out that way. Remember to use an address that isn’t in the DHCP pool for your router to avoid any conflicts later on with other users on your network. Now hit ctrl-O to write the file and then ctrl+X to get yourself back to your terminal screen.
Now that you have a static address set you can enable SSH on the pi. We’ll use the wizard that comes with raspbian to do this.
In terminal type

sudo raspi-config

First step should be to change your user password which should be option 2. The default username is pi and the default password is raspberry.

Raspberry Pi Kiosk - Raspi-Config
=================================

Once you’ve changed your password head to option 8 – Advanced Options and then option A4 – SSH and just hit enabled.

SSH is now enabled, lets test it out. Head to another computer on the same network, if you are on a mac/linux computer you can do this next step from the terminal if you are a PC user however you will need to install a SSH program, my favourite being putty.

I’ll explain the steps for using a terminal window, if you are using Putty then you can just pick the information out and fill in the correct boxes with putty to set up. It’s very straight forward.

Raspberry SSH 
=============
So still on the 2nd computer open up a terminal window and type <br>
ssh pi@xxx.xxx.xxx.xxx <br>
Where the X’s represent the static address you gave your Pi in the previous part. If it’s worked you should be asked for your password. Enter the password you chose for your Pi and cross your fingers!
Now you should be greeted with a pi@xxx command prompt, this means you are now logged in and directly controlling your Pi.

Setting up Kiosk mode
=====================
Before we start displaying anything on the screen we need to go through a few steps to setup and disable a few settings.

Firstly we should disable the screensaver and any energy saving settings as we don’t want our screen to go to sleep at all when it’s in use, wouldn’t be very useful if it went blank every 5 minutes.

While connected to your pi over SSH type

sudo nano /etc/xdg/lxsession/LXDE/autostart

Please note, some of my commenters have mentioned that if you’re using NOOBs you may need to use the LXDE-pi folder which would mean you need to use the following instead.

sudo nano /etc/xdg/lxsession/LXDE-pi/autostart

As you can probably guess this is a file that runs when your pi boots.
To disable the screensaver add a # to the beginning of the line, this comments the line out.

@xscreensaver -no-splash

Next add these lines underneath the screensaver line

@xset s off <br>
@xset -dpms <br>
@xset s noblank <br>

This disables power management settings and stops the screen blanking after a period of inactivity.

Now that is done we should prevent any error messages displaying on the screen in the instance that someone accidentally power cycles the pi without going through the shutdown procedure. To do this we add the following line underneath the lines you just added.

@sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences

Finally we need to tell chromium to start and which page to load once it boots without error dialogs and in Kiosk mode. To do this add the following line to the bottom of this autostart file.

@chromium --noerrdialogs --kiosk http://www.page-to.display

Thanks to a comment from Rikard Eriksson below it seems you may now need to add the incognito flag to ensure no warnings are displayed if you pull the power without first shutting down see below.


@chromium --noerrdialogs --kiosk http://www.page-to.display --incognito

Obviously replace page-to.display with whatever page you want to load. In my case I’m just connecting to the webserver I’ve setup on our network which has our database and my backup system.

Raspberry Pi Kisok - LXDE config

Hit ctrl-O and then ctrl-X again to write out and exit the file and now type

sudo reboot
