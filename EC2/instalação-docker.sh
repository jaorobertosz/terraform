!#/bin/bash
NOME='hostname'
SRV='SGD-APP'

  DEBIAN_FRONTEND=noninteractive sudo apt-get update
    sleep 15s
  echo "Update Finalizado"
    sleep 2s
  echo "Iniciando Alteração de nome"
  sudo hostname ; echo "Nome da maquina ${NOME}" ; sudo hostnamectl set-hostname $SRV ; echo "Nome da instancia alterado para ${SRV}"; sudo hostname; echo "Nome da maquina ${SRV}"
  sleep 5s
  echo "Instalando pacotes WGET, CURL, GIT, VIM, NET-TOOLS"
  sleep 5s
  DEBIAN_FRONTEND=noninteractive sudo apt install -y wget curl git vim net-tools  
  echo "Iniciando Instalação Docker"
  sudo apt-get update
  sleep 5s
  sudo apt-get install ca-certificates curl
  sleep 5s
  sudo install -m 0755 -d /etc/apt/keyrings
  sleep 5s
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sleep 5s
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  sleep 5s
  echo "Add the repository to Apt sources:"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sleep 5s
  DEBIAN_FRONTEND=noninteractive sudo apt update
  sleep 5s
  DEBIAN_FRONTEND=noninteractive sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sleep 5s
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
   sleep 5s
   sudo chmod g+rwx "$HOME/.docker" -R
   sleep 5s
   sudo groupadd docker ; sudo usermod -aG docker $USER ; sudo newgrp docker
    sleep 5s
    sudo systemctl enable docker.service
     sudo systemctl enable containerd.service
     echo "Finalizado instalação do Docker"


