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
  if getent group "$group" > /dev/null; then
    echo "Group '$group' already exists. Skipping."
  elif sudo groupadd "$group"; then
    echo "Group '$group' created."
    getent group "$group"
  else
    echo "Group '$group' could NOT be created."
  fi
done

echo -e "\n========== Creating Users =========="
#Creating multiple users
#command option for useradd: -c for comment, -e for account expiration, -d for home directory path, -s for specified shell
#group	/etc/group	  getent group <groupname>
#passwd	/etc/passwd	  getent passwd <username>
#shadow	/etc/shadow	  sudo getent shadow <username>
for user in manish phillip amin ario herve; do
    if getent passwd "${user}"> /dev/null; then
      echo "User '$user' already exist. Skipping."
    elif sudo useradd -m -c "${user} user" -d "/home/${user}" -s /bin/bash "$user"; then
      echo "User '$user' created."
      getent passwd "$user"
      ls -ld "/home/$user"
    else
      echo "User '$user' could not be created."
    fi
done

echo -e "\n========== Setting Primary Group =========="
#Note: primary group always get stored in /etc/passwd
#command:  usermod -g <group-name> <user-name>
target="developers"
for user in manish amin; do
    if [ "$(id -gn "$user")" = "$target" ]; then
        echo "User '$user': primary group is already '$target'. Skipping."
    elif sudo usermod -g "$target" "$user"; then
        echo "User '$user': primary group changed to '$target'."
        id "$user"
    else
        echo "User '$user': could NOT change primary group."
    fi
done

target="qa"
for user in ario herve; do
    if [ "$(id -gn "$user")" = "$target" ]; then
        echo "User '$user': primary group is already '$target'. Skipping."
    elif sudo usermod -g "$target" "$user"; then
        echo "User '$user': primary group changed to '$target'."
        id "$user"
    else
        echo "User '$user': could NOT change primary group."
    fi
done

target="devops"
devops_user="phillip";
if [ "$(id -gn $devops_user)" = "$target" ]; then
        echo "User '$devops_user': primary group is already '$target'. Skipping."
    elif sudo usermod -g "$target" "$devops_user"; then
        echo "User '$devops_user': primary group changed to '$target'."
        id "$devops_user"
    else
        echo "User '$devops_user': could NOT change primary group."
fi


echo -e "\n========== Add Supplementary Group =========="
#Note: primary group always get stored in /etc/group
#command:  usermod -aG <group-name> <user-name>
supp_target="qa"
supp_users=("manish")
for user in "${supp_users[@]}"; do
    if id -nG "$user" | grep -qw "$supp_target"; then
        echo "'$user' already in '$supp_target' group so skipping."
    elif sudo usermod -aG "$supp_target" "$user"; then
        echo "Added '$user' to '$supp_target' group."
        id "$user"
        getent group "$supp_target"
    else
        echo "Could NOT add '$user' to '$supp_target'."
    fi
done

echo -e "\n========== Remove User From Group =========="
target_group="qa"
target_users=("manish")
for user in "${target_users[@]}"; do
  if ! id -nG "$user" | grep -qw "$target_group"; then
    echo "'$user' not in '$target_group' group so skipping."
  elif sudo gpasswd -d "$user" "$target_group"; then
    echo "Deleted '$user' from '$target_group' group."
    id "$user"
    getent group "$target_group"
  else
     echo "Could NOT remove '$user' from '$target_group'."
  fi
done

echo -e "\n========== Change Ownership =========="
#Creating a text file
file="ownership.txt"
if [ -f "$file" ]; then
  echo "file '$file' already exist. Skipping."
elif echo "This is my sample file to check ownership." > "$file" ; then
  echo "File '$file' created."
  ls -l "$file"
else
  echo "Unable to create '$file'"
fi

#Stat command shows file metadata
owner="manish"
group="developers"
if [ "$(stat -c '%U:%G' "$file")" = "$owner:$group" ]; then
  echo "File '$file' already owned by '$owner' and '$group'. Skipping."
elif sudo chown "$owner:$group" "$file"; then
  echo "Successfully change owner of '$file'"
  ls -l "$file"
else
  echo "Unable to change the owner of '$file'"
fi


echo -e "\n========== Deleting Created File 'ownership.txt' =========="
sudo rm ownership.txt
if [ -f ownership.txt ]; then
    echo "File 'ownership.txt' still exist."
else
    echo "File 'ownership.txt' deleted successfully."
fi
echo ""


users=("manish" "phillip" "amin" "ario" "herve")
groups=("developers" "qa" "devops")

echo -e "\n========== Deleting users ==========\n"
for user in "${users[@]}"; do
    if ! getent passwd "$user" > /dev/null; then
        echo "User '$user' does not exist. Skipping."
    else
        sudo userdel -r "$user"
        # verify the RESULT, not just the exit code
        if getent passwd "$user" > /dev/null; then
            echo "User '$user' could NOT be deleted."
        else
            echo "User '$user' deleted."
        fi
    fi
done

echo -e "\n========== Deleting leftover private groups ==========\n"
for group in "${users[@]}"; do
    if ! getent group "$group" > /dev/null; then
        echo "No leftover group '$group'. Skipping."
    elif sudo groupdel "$group"; then
        echo "Leftover group '$group' deleted."
    else
        echo "Group '$group' could NOT be deleted."
    fi
done

echo -e "\n========== Deleting custom groups ==========\n"
for group in "${groups[@]}"; do
    if ! getent group "$group" > /dev/null; then
        echo "Group '$group' does not exist. Skipping."
    elif sudo groupdel "$group"; then
        echo "Group '$group' deleted."
    else
        echo "Group '$group' could NOT be deleted."
    fi
done

echo -e "\n========== Removing leftover home dirs ==========\n"
for user in "${users[@]}"; do
    dir="/home/${user:?}"
    if [ ! -d "$dir" ]; then
        echo "No leftover dir '$dir'. Skipping."
    elif sudo rm -rf -- "$dir"; then
        echo "Leftover dir '$dir' removed."
    else
        echo "Dir '$dir' could NOT be removed."
    fi
done

echo -e "\n========== Verify (empty output = clean) ==========\n"
echo "--- Users still present:"
getent passwd "${users[@]}"
echo "--- Groups still present:"
getent group "${users[@]}" "${groups[@]}"
echo "--- /home contents (only your own login user should be here):"
ls -A /home
echo "--- Orphaned files (owner or group no longer exists):"
sudo find / -xdev \( -nouser -o -nogroup \) 2>/dev/null
echo -e "\nCleanup finished."