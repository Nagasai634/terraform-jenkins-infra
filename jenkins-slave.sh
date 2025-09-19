#!/bin/bash
set -e

# Update system
apt-get update -y


# Install Java 21 (OpenJDK)
apt-get install -y openjdk-21-jdk

# Install Terraform
TERRAFORM_VERSION="1.12.1"
curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
unzip terraform.zip
chmod +x terraform
mv terraform /usr/local/bin/
rm terraform.zip

echo "Java version:"
java -version

echo "Terraform installed:"
terraform -version

# Create Jenkins directory
mkdir -p /home/ubuntu/jenkins
chown ubuntu:ubuntu /home/ubuntu/jenkins

echo "Jenkins slave node ready with Java 21 and Terraform"