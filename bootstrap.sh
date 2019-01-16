# Update and utils/packages
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update && sudo apt upgrade -y
sudo apt install git vim tmux -y
sudo apt install npm nodejs curl net-tools openssh-server nginx python-certbot-nginx -y

# SSH
echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "Port 22" | sudo tee -a /etc/ssh/sshd_config
sudo service ssh restart

# Anaconda
# https://conda.io/docs/user-guide/install/macos.html#install-macos-silent
curl -O https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
sudo bash Anaconda3-5.2.0-Linux-x86_64.sh -b -p /opt/anaconda3
echo "export PATH=\"/opt/anaconda3/bin:$PATH\"" | sudo tree -a /etc/bash.bashrc
sudo cp /etc/bash.bashrc /etc/bash.bashrc-backup

# Jupyter
# https://jupyterhub.readthedocs.io/en/stable/quickstart.html
sudo /opt/anaconda3/bin/python -m pip install jupyterhub notebook
sudo npm install -g configurable-http-proxy

# https://jupyterhub.readthedocs.io/en/stable/getting-started/config-basics.html
sudo mkdir /etc/jupyterhub
sudo cp jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

# https://github.com/jupyterhub/jupyterhub/wiki/Run-jupyterhub-as-a-system-service
sudo cp jupyterhub.service /etc/systemd/system/jupyterhub.service
sudo systemctl daemon-reload
sudo systemctl start jupyterhub
sudo systemctl enable jupyterhub

# Ngnix
# https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04
sudo cp godel.margagl.io /etc/nginx/sites-available/godel.margagl.io

# https://www.digitalocean.com/community/tutorials/how-to-set-up-let-s-encrypt-with-nginx-server-blocks-on-ubuntu-16-04
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo certbot --nginx -n -d godel.margagl.io

# Tensorflow
# https://www.tensorflow.org/install/gpu

# https://github.com/williamFalcon/tensorflow-gpu-install-ubuntu-16.04
sudo apt install openjdk-8-jdk build-essential swig python-wheel libcurl3-dev -y

# NVIDIA Drivers
sudo ubuntu-drivers autoinstall
sudo reboot

# CUDNN
wget https://s3.amazonaws.com/open-source-william-falcon/cudnn-9.0-linux-x64-v7.3.1.20.tgz
sudo tar -xzvf cudnn-9.0-linux-x64-v7.3.1.20.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# CUPTI
echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" | sudo tree -a /etc/bash.bashrc
echo export CUDA_HOME=/usr/local/cuda | sudo tree -a /etc/bash.bashrc
echo export PATH=\"$PATH:/usr/local/cuda/bin\" | sudo tree -a /etc/bash.bashrc
source ~/.bashrc