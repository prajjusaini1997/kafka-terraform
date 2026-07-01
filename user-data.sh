#!/bin/bash

# Update packages
sudo apt update -y

# Install Java
sudo apt install openjdk-11-jdk -y

# Download Kafka
cd /opt

wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz

tar -xzf kafka_2.13-3.7.0.tgz

mv kafka_2.13-3.7.0 kafka

# Start Zookeeper
cd /opt/kafka

nohup bin/zookeeper-server-start.sh config/zookeeper.properties > /var/log/zookeeper.log 2>&1 &

sleep 20

# Start Kafka broker
nohup bin/kafka-server-start.sh config/server.properties > /var/log/kafka.log 2>&1 &

echo "Kafka Installed and Running" > /tmp/kafka-status.txt
