sudo add-apt-repository universe 2>/dev/null
sudo apt update 2>/dev/null
sudo apt install -y python2 2>/dev/null
sudo update-alternatives --remove-all python 2>/dev/null
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 1 2>/dev/null