#!/bin/bash
# Update system packages
dnf update -y
# Install Apache web server
dnf install -y httpd
# Start Apache service
systemctl start httpd
# Enable Apache on system startup
systemctl enable httpd
# Create website homepage
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Project 1 - AWS Web Server</title>
</head>
<body>
<h1>Welcome to My AWS Web Server!</h1>
<h2>Project 1: EC2 Web Server using Terraform</h2>
<p>Successfully deployed on Amazon Linux 2023.</p>
<p>Apache Web Server is running successfully.</p>
</body>
</html>
EOF
