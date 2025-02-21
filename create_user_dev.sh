#!/bin/bash

username=$1
password=123

# Create the user with the specified username
useradd -m -s /bin/bash $username

# Set the user's password
echo "$username:$password" | sudo chpasswd
gpasswd -a $username docker
gpasswd -a $username student

echo "export CHART_WORKSPACE_PATH=/home/$username/.xapp_onboarder" >> /home/$username/.bashrc
echo "export KUBECONFIG=/home/$username/.kube/config" >> /home/$username/.bashrc
echo "export NS=$username" >> /home/$username/.bashrc

YAML_FILE="/home/$username/.kube/config"

mkdir -p "/home/$username/.kube/"

cat <<EOF > "$YAML_FILE"
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://10.180.113.156:6443
  name: ets-oran
contexts:
- context:
    cluster: ets-oran
    namespace: $username
    user: $username
  name: $username
current-context: $username
kind: Config
preferences: {}
users:
- name: $username
  user:
    token: $2
EOF

chown $username:$username $YAML_FILE
chmod 600 $YAML_FILE

echo "User $username has been created with the password $password"