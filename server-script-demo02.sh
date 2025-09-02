
#!/bin/bash -x

# Install dependencies
sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y 
sudo yum install maven -y

# Clone or update repo
if [ -d "addressbook-v1" ]; then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin npd-demo02
else 
  git clone https://github.com/nprabhu/addressbook-v1.git
  cd addressbook-v1
  git checkout npd-demo02
fi

# Compile project
cd /home/ec2-user/addressbook-v1
mvn compile
