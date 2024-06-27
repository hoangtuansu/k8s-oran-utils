#!/bin/bash

username=$1
password=123

# Create the user with the specified username
sudo useradd -m -s /bin/bash $username

# Set the user's password
echo "$username:$password" | sudo chpasswd

sudo gpasswd -a $username docker
sudo gpasswd -a $username student
newgrp docker
newgrp system

echo "User '$username' has been created with the password '$password'"