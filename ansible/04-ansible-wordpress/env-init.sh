## CORE INSTALLATION
apt-get -y update && \
apt-get install -y software-properties-common && \
apt-add-repository -y ppa:ansible/ansible && \
apt-get -y update && \
apt-get install -y ansible && \
cd /home/scrapbook/tutorial
echo "Ready!"
