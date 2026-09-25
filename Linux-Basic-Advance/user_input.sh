#!/bin/bash
set -u #undefined variable as an empty string

read -p "Do you want to create a group (yes/no): " user_response

if [[ "$user_response" == "yes" || "$user_response" == "YES" ]]; then
        echo $user_response

elif [[ "$user_response" == "no" || "$user_response" == "NO" ]]; then
        echo $user_response

else
        echo "Please pass yes/no"
fi