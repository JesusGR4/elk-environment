#!/bin/bash

function setup_elasticsearch() {
	sudo apt-get install apt-transport-https
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
	add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
	sudo apt-get update
	sudo apt-get install elasticsearch
	less /vagrant/elasticsearch.yml > /etc/elasticsearch/elasticsearch.yml 
	sudo /bin/systemctl enable elasticsearch.service


	# Let's create a filesystem for elasticsearch index /var/lib/elasticsearch in this case ;) g n enter enter enter t y 31  p w
	sfdisk /dev/sdc < /vagrant/lvm_part_table
	pvcreate /dev/sdc1
	vgcreate elk_vg /dev/sdc1
	lvcreate -l 100%FREE elk_vg -n elasticsearch_data
	mkfs.ext4 /dev/elk_vg/elasticsearch_data
	mount /dev/elk_vg/elasticsearch_data /var/lib/elasticsearch 
	echo "/dev/elk_vg/elasticsearch_data     ext4    defaults    0 0" >> /etc/fstab
	chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
	sudo systemctl restart elasticsearch.service
}


function setup_nginx() {
	sudo apt install nginx
	sudo ufw allow 'Nginx HTTP'
	echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users
	sudo cp /vagrant/elk_ngnix_conf /etc/nginx/sites-available/elk.com
	sudo ln -s /etc/nginx/sites-available/elk.com /etc/nginx/sites-enabled/elk.com
	sudo systemctl restart nginx
	sudo ufw allow 'Nginx Full'
}

function setup_java() {
	sudo apt update
	sudo apt install default-jre
	sudo apt install default-jdk
}

function setup_logstash() {
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
	sudo apt-get install apt-transport-https
	echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
	sudo apt-get update && sudo apt-get install logstash
	sudo /bin/systemctl enable logstash.service
	sudo systemctl start logstash.service
}

function setup_kibana() {
	sudo apt-get install kibana
	sudo systemctl enable kibana
	sudo systemctl start kibana
}

if [ ! -f /etc/java-*/accessibility.properties ]; then
	setup_java
fi

if [ ! -f /etc/elasticsearch/elasticsearch.yml ]; then
    setup_elasticsearch
fi

if [ ! -f /etc/logstash/conf.d ]; then
	setup_logstash	
fi

if [ ! -d /etc/kibana ]; then
	setup_nginx
	setup_kibana
fi

exit 0