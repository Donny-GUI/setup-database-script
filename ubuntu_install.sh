#!/bin/bash

# Check if script is being run as root
if [[ $(id -u) -ne 0 ]]; then
   echo "This script must be run as root. Please use sudo." >&2
   exit 1
fi

# Check if the script is being run with one argument
if [[ $# -ne 1 ]]; then
   echo "Usage: $0 <database name>" >&2
   exit 1
fi

# Set the database name as a variable
DBNAME=$1

# Install MySQL if not already installed
if ! command -v mysql &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y mysql-server
fi

# Create the database and a new user with privileges
sudo mysql <<EOF
CREATE DATABASE $DBNAME;
CREATE USER '$DBNAME'@'localhost' IDENTIFIED BY '$DBNAME';
GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBNAME'@'localhost';
FLUSH PRIVILEGES;
EOF

# Print success message
echo "Database $DBNAME created successfully."
