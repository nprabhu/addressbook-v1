
#!/bin/bash -x

# Install dependencies
# sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y 
# sudo yum install maven -y
sudo yum install docker -y
sudo service docker start

# Clone or update repo
if [ -d "addressbook-v1" ]; then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin npd-demo03
else 
  git clone https://github.com/nprabhu/addressbook-v1.git
  cd addressbook-v1
  git checkout npd-demo03
fi

# Compile project
cd /home/ec2-user/addressbook-v1
# mvn compile

# build the docker image and $1 is the image name to pass image name dynamically from Jenkinsfile using $BUILD_NUMBER positional parameter
sudo docker build -t $1 .