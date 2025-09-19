#!/bin/bash
apt-get update
apt-get install -y unzip curl

apt-get install -y openjdk-17-jdk gnupg git

TERRAFORM_VERSION="1.12.1"
curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin/
rm terraform.zip

echo "Terraform installed:"
terraform -version