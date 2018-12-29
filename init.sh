#!/bin/bash

set -e

echo "# ------------------------------------"
echo "# RESET                               "
echo "# ------------------------------------"

read -p "Do you want to reset everything (yes/no): " RESET

if [ $RESET == "yes" ]; then
  find ssh-keys -type f ! \( -name '.gitkeep' \) -exec rm -rf {} \;
  rm -rf output.log
fi

echo "# ------------------------------------"
echo "# DROPLET                             "
echo "# ------------------------------------"

read -p "Tag Name: " TAG_NAME
read -p "Droplet Name: " DROPLET_NAME

echo "# ------------------------------------"
echo "# SSH KEY                             "
echo "# ------------------------------------"

read -p "Do you want to create ssh key (yes/no): " CREATE_SSH_KEY

if [ $CREATE_SSH_KEY == "no" ] && [ ! -f $(pwd)/ssh-keys/$(find . -name '*.pub' -exec basename \{} \;) ]; then
  echo 'Please create a new ssh key or if you already have one, please provide it'
  exit 1
fi

if [ $CREATE_SSH_KEY == "yes" ]; then
  read -p "SSH Key Username: " SSH_KEY_USERNAME

  SSH_KEY_NAME="$DROPLET_NAME-$TAG_NAME"

  ssh-keygen -t rsa -q -N "" -f $(pwd)/ssh-keys/$SSH_KEY_NAME -C $SSH_KEY_USERNAME
fi

SSH_PUBLIC_KEY=$(pwd)/ssh-keys/$(find . -name '*.pub' -exec basename \{} \;)
SSH_PRIVATE_KEY=${SSH_PUBLIC_KEY:0:${#SSH_PUBLIC_KEY}-4}

# -------------------------------------------------------------------------
# Create output file that contains terraform and ansible commands executed
# -------------------------------------------------------------------------
if [ ! -f output.log ]; then
  touch output.log
fi

echo "# ------------------------------------"
echo "# TERRAFORM                           "
echo "# ------------------------------------"

read -p "Do you want to initialize terraform (yes/no): " INITIALIZE_TERRAFORM

if [ $INITIALIZE_TERRAFORM == "yes" ]; then
  read -p "DigitalOcean Spaces Access Key: " ACCESS_KEY
  read -p "DigitalOcean Spaces Secret Key: " SECRET_KEY
  read -p "DigitalOcean Spaces Endpoint: " ENDPOINT
  read -p "DigitalOcean Spaces Bucket Name: " BUCKET
  read -p "DigitalOcean Spaces Key Name: " KEY

  REGION='us-east-1'

  TERRAFORM_INITIALIZATION_CONFIGURATION="-backend-config=\"access_key=${ACCESS_KEY}\" \\
                                          -backend-config=\"secret_key=${SECRET_KEY}\" \\
                                          -backend-config=\"endpoint=${ENDPOINT}\" \\
                                          -backend-config=\"bucket=${BUCKET}\" \\
                                          -backend-config=\"region=${REGION}\" \\
                                          -backend-config=\"key=${KEY}\""

  echo "terraform init $TERRAFORM_INITIALIZATION_CONFIGURATION" >> output.log
  eval terraform init ${TERRAFORM_INITIALIZATION_CONFIGURATION//\\/ }
fi

read -p "Do you want to execute terraform plan (yes/no): " EXECUTE_TERRAFORM_PLAN

if [ $EXECUTE_TERRAFORM_PLAN == "yes" ]; then
  read -p "DigitalOcean Token: " DIGITALOCEAN_TOKEN

  TERRAFORM_VARIABLES_CONFIGURATION="-var 'digitalocean_token=$DIGITALOCEAN_TOKEN' \\
                                      -var 'ssh_key={private_key=\"$SSH_PRIVATE_KEY\"}' \\
                                      -var 'ssh_key={public_key=\"$SSH_PUBLIC_KEY\"}' \\
                                      -var 'tag_name=$TAG_NAME' \\
                                      -var 'droplet={name=\"$DROPLET_NAME\"}'"

  echo "terraform apply -auto-approve $TERRAFORM_VARIABLES_CONFIGURATION" >> output.log
  echo "terraform destroy -auto-approve $TERRAFORM_VARIABLES_CONFIGURATION" >> output.log
  eval terraform apply -auto-approve ${TERRAFORM_VARIABLES_CONFIGURATION//\\/ }
fi
