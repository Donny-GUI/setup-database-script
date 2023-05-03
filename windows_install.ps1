
# Prompt for MySQL root password
$mysqlRootPassword = Read-Host "Enter MySQL root password"

# Install MySQL Server
$mysqlInstaller = "mysql-installer-community-8.0.26.0.msi"
$mysqlUrl = "https://dev.mysql.com/get/$mysqlInstaller"
Invoke-WebRequest $mysqlUrl -OutFile $mysqlInstaller
Start-Process msiexec.exe -Wait -ArgumentList "/i $mysqlInstaller /quiet /qn INSTALLDIR=C:\mysql /PASSWORD=$mysqlRootPassword"
Remove-Item $mysqlInstaller

# Configure MySQL Server
$mysqlConfig = @"
[mysqld]
bind-address = 0.0.0.0
"@ | Out-File -FilePath "C:\mysql\my.ini" -Encoding ascii
New-Item -ItemType Directory -Path C:\mysql\data
New-Item -ItemType Directory -Path C:\mysql\logs
New-Item -ItemType Directory -Path C:\mysql\tmp
Start-Process "C:\mysql\bin\mysqld.exe" --console --initialize-insecure
Start-Service mysql

# Create a new MySQL user and database
$mysqlUser = Read-Host "Enter MySQL username"
$mysqlPassword = Read-Host "Enter MySQL password" -AsSecureString
$mysqlDatabase = Read-Host "Enter MySQL database name"
$mysqlQuery = "CREATE DATABASE $mysqlDatabase; CREATE USER '$mysqlUser'@'%' IDENTIFIED BY '$mysqlPassword'; GRANT ALL PRIVILEGES ON $mysqlDatabase.* TO '$mysqlUser'@'%'; FLUSH PRIVILEGES;"
& "C:\mysql\bin\mysql.exe" -uroot -p$mysqlRootPassword -e $mysqlQuery

