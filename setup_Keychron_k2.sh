sudo echo "options hid_apple fnmode=1 swap_opt_cmd=1" > /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u
echo "Reboot to enable changes"
