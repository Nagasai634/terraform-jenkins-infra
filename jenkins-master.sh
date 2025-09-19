#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install Java 21
apt-get install -y openjdk-21-jdk


# Verify Java installation
echo "Java version:"
java -version



# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
apt-get update -y
apt-get install -y jenkins

# Start Jenkins service
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins


echo "Jenkins service status:"
systemctl status jenkins --no-pager -l

# Check if Jenkins is running
if systemctl is-active --quiet jenkins; then
    echo "Jenkins is running successfully!"
    echo "Initial admin password:"
    cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Password will be available after first startup completes"
else
    echo "Jenkins failed to start. Checking logs..."
    journalctl -u jenkins --since "1 minute ago" --no-pager
fi

echo "Jenkins will be available at: http://$(curl -s ifconfig.me):8080"