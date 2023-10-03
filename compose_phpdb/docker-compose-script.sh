sudo yum install docker -y
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
#sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
set -x
sudo php=$1 db=$2 docker-compose -f /home/ec2-user/compose_phpdb/docker-compose.yml up -d
