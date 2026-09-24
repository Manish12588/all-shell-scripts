#!/bin/bash
#================================
#Author: Manish
#================================

echo "================================"
echo "         USER MANAGEMENT        "
echo "================================"

#Creating multiple groups
echo -e "\n========== Creating groups ==========\n"
groups=("developers" "qa" "devops")
for group in "${groups[@]}"; do
        sudo groupadd "$group"
        if grep -q "^${group}:" /etc/group; then
            echo "Group '$group' created."
            grep "$group" /etc/group
        else
            echo "Group '$group' not created."
        fi
done

echo -e "\n========== Creating Users =========="
#Creating multiple users
#command option for useradd: -c for comment, -e for account expiration, -d for home directory path, -s for specified shell
for user in manish phillip amin ario herve; do
        sudo useradd -c "${user} user" -d /home/${user} -s /bin/bash "$user"
        if grep -q "^${user}:" /etc/passwd; then
             echo ""
             echo "User '$user' created."
             grep "$user" /etc/passwd
        else
             echo "User '$user' not created."
        fi
done

echo -e "\n========== Setting Primary Group =========="
sudo gpasswd -M manish,amin developers
echo "Primary group for user 'manish' and 'amin' is ${groups[0]}."
grep "${groups[0]}" /etc/group
echo -e "\n"

for user in ario herve; do
        sudo usermod -aG "${groups[1]}" "$user"
        if grep -q "^${groups[1]}:" /etc/group; then
            echo "User '${user}' added to '${groups[1]}' group."
        else
            echo "User '${user}' not added to '${groups[1]}' group."
        fi
done
echo "Primary group for user 'ario' and 'herve' is ${groups[1]}."
grep "${groups[1]}" /etc/group
echo -e "\n"

sudo gpasswd -M phillip devops
echo "Primary group for user 'phillip' is 'devops'"
grep "phillip" /etc/group
echo -e "\n"

echo -e "\n========== Add Supplementary Group =========="
sudo usermod -aG "${groups[1]}" manish
echo "Supplementary group for user 'manish' ${groups[1]}."
grep "${groups[1]}" /etc/group
echo -e "\n"

echo -e "\n========== Remove User From Group =========="
echo -e "Before Delete: $(grep "${groups[1]}" /etc/group )"
echo ""
sudo gpasswd -d manish "${groups[1]}"
echo -e "After Delete: $(grep "${groups[1]}" /etc/group )"
echo ""

echo -e "\n========== Change Ownership =========="
echo "This is my sample file to check ownership" > ownership.txt
if [ -f ownership.txt ]; then
    echo "File 'ownership.txt' created successfully."
else
    echo "Failed to create file 'ownership.txt'."
fi
echo -e "Current Owner: $(ls -l ownership.txt)"
#sudo chown USER:GROUP FILE
sudo chown manish:"${groups[0]}" ownership.txt
echo -e "After Owner Change: $(ls -l ownership.txt)"
echo ""

echo -e "\n========== Deleting Created File 'ownership.txt' =========="
sudo rm ownership.txt
if [ -f ownership.txt ]; then
    echo "File 'ownership.txt' still exist."
else
    echo "File 'ownership.txt' deleted successfully."
fi
echo ""

echo -e "\n========== Delete User =========="
#Users
#command option for userdel command: -r delete the home directory for user
for user in manish phillip amin ario herve; do
        if grep -q "^${user}:" /etc/passwd; then
            sudo userdel -r "$user" > /dev/null 2>&1
            if grep -q "^${user}:" /etc/passwd; then
                echo "User '$user' NOT deleted."
            else
                echo "User '$user' deleted successfully."
            fi
        else
            echo "User '$user' does not exist. Nothing to delete."
        fi
done

echo -e "\n========== Delete Group =========="
#Now Deleting Group and users
#Groups
for group in "${groups[@]}"; do
        sudo groupdel "$group"
        if grep -q "^${group}:" /etc/group; then
           echo "Group '$group' not deleted."
           grep "$group" /etc/group
        else
           echo "Group '$group' deleted."
        fi
done