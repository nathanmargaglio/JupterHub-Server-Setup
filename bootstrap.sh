# Update and packages
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update && sudo apt upgrade -y
sudo apt install npm nodejs curl net-tools openssh-server nginx python-certbot-nginx -y

# SSH
echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "Port 22" | sudo tee -a /etc/ssh/sshd_config
sudo ufw allow ssh
sudo service ssh restart

# Anaconda
# https://conda.io/docs/user-guide/install/macos.html#install-macos-silent
curl -O https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
sudo bash Anaconda3-5.2.0-Linux-x86_64.sh -b -p /opt/anaconda3
echo "export PATH=\"/opt/anaconda3/bin:$PATH\"" | sudo tree -a /etc/bash.bashrc
sudo cp /etc/bash.bashrc /etc/bash.bashrc-backup

# Tensorflow
# https://www.tensorflow.org/install/gpu

# https://github.com/williamFalcon/tensorflow-gpu-install-ubuntu-16.04
sudo apt install openjdk-8-jdk build-essential swig python-wheel libcurl3-dev -y

# NVIDIA Drivers
#sudo ubuntu-drivers autoinstall
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo dpkg -i ./cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt update
sudo apt install cuda-9-0 -y
sudo reboot

# CUDNN
wget https://s3.amazonaws.com/open-source-william-falcon/cudnn-9.0-linux-x64-v7.3.1.20.tgz
sudo tar -xzvf cudnn-9.0-linux-x64-v7.3.1.20.tgz
sudo ln -s /usr/local/cuda-9.0 /usr/local/cuda
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# CUPTI
echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" | sudo tee -a /etc/bash.bashrc
echo export CUDA_HOME=/usr/local/cuda | sudo tee -a /etc/bash.bashrc
echo export PATH=\"$PATH:/usr/local/cuda/bin\" | sudo tee -a /etc/bash.bashrc
source ~/.bashrc

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
sudo certbot --nginx -n -d godel.margagl.io
sudo service nginx restart

# Utilities
sudo apt install git vim tmux -y

# vim Plugin
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# tmux Plugin
echo export EDITOR=vim | sudo tree -a /etc/bash.bashrc
echo export TERM=xterm-256color | sudo tree -a /etc/bash.bashrc
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .