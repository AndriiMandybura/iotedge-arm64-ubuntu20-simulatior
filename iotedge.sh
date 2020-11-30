#!/bin/bash
#
echo "##########################################"
echo "#        Install pre requirements        #"
echo "##########################################"

echo "##########################################"
echo "#           Install Docker CE            #"
echo "##########################################"

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

echo "##########################################"
echo "#             Install rustup             #"
echo "##########################################"

curl https://sh.rustup.rs -sSf | sh
echo $PATH > temp-env && sed -e 's/$/:~/.cargo/env/' temp-env > temp-env2 && export $PATH=$(cat temp-env2) && rm temp-*

echo "##########################################"
echo "#           Install iotedge            #"
echo "##########################################"

wget https://github.com/Azure/azure-iotedge/releases/download/1.0.10.2/iotedge_1.0.10.2-1_debian9_arm64.deb
wget https://github.com/Azure/azure-iotedge/releases/download/1.0.10.2/libiothsm-std_1.0.10.2-1-1_debian9_arm64.deb

sudo apt-get install ./libiothsm-std_1.0.10.2-1-1_debian9_arm64.deb
sudo apt-get install ./iotedge_1.0.10.2-1_debian9_arm64.deb

echo "##########################################"
echo "#           Configure iotedge            #"
echo "##########################################"

sudo sed -i 's/azureiotedge-agent:1.0/azureiotedge-agent:1.0.9-linux-arm64v8/g' /etc/iotedge/config.yaml
sudo sed -i 's/<ADD DEVICE CONNECTION STRING HERE>/HostName=armisv-iot-hub.azure-devices.net;DeviceId=armisv-device-simulation;SharedAccessKey=YrTlhO7o514zgFeZOx5oeRXNUdH7nDiuB+ZbKi2AI+Q=/g' /etc/iotedge/config.yaml

sudo systemctl restart iotedge
sudo systemctl status iotedge