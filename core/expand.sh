echo "-*- Expanding /dev/sda Partition -*-"
(
echo d # Delete partition 
echo 1 # Delete first
echo n # New partition
echo p # Primary
echo 1 # 1 Partition
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sda | grep "Created a new partition"
echo ""
sudo resize2fs /dev/sda1
echo ""
STR1="$(df -hm | grep sda1 | awk '{print $4}')" 
echo "Free Space on the Disk: $STR1 MB"
