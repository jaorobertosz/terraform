import subprocess
import os

def run_command(command):
    subprocess.run(command, shell=True, check=True)

def main():
    NOME = 'hostname'
    SRV = 'SGD-APP'

    run_command('DEBIAN_FRONTEND=noninteractive sudo apt-get update')
    print("Update Finalizado")
    print("Iniciando Alteração de nome")
    run_command(f'echo "{os.getenv("USER")}" | sudo -S hostname; echo "Nome da maquina {NOME}"; sudo -S hostnamectl set-hostname {SRV}; echo "Nome da instancia alterado para {SRV}"; sudo -S hostname; echo "Nome da maquina {SRV}"')
    print("Instalando pacotes WGET, CURL, GIT, VIM, NET-TOOLS")
    run_command('DEBIAN_FRONTEND=noninteractive sudo apt install -y wget curl git vim')
    print("ADICIONANDO REPOSITORIO DOCKER")
    run_command('sudo apt-get install ca-certificates curl')
    run_command('sudo install -m 0755 -d /etc/apt/keyrings')
    run_command('sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc')
    print("Iniciando Instalação Docker")

    # Obter o codinome da versão do Ubuntu
    ubuntu_codename = subprocess.check_output(['lsb_release', '-cs']).decode('utf-8').strip()

    # Modificar o comando para obter o codinome da versão do Ubuntu
    run_command(f'echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null')
    run_command('DEBIAN_FRONTEND=noninteractive sudo apt update')
    run_command('DEBIAN_FRONTEND=noninteractive sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose')
    run_command('sudo systemctl enable docker.service')
    run_command('sudo systemctl enable containerd.service')
    print("Finalizado instalação do Docker")
    print("Iniciando o docker")
    docker_config_dir = os.path.expanduser('~/.docker')
    os.makedirs(docker_config_dir, exist_ok=True)
    run_command(f'rm -rf {docker_config_dir}; mkdir {docker_config_dir}; sudo chown "$USER":"$USER" {docker_config_dir} -R ; touch {docker_config_dir}/config.json ; echo \'{{\n\
    "auths": {{\n\
        "https://index.docker.io/v1/": {{\n\
            "auth": "am9hbzIxOTpAWSFuZ3NpeDEy"\n\
        }}\n\
    }}\n\
}}\' >> {docker_config_dir}/config.json')
    run_command(f'sudo chown "$USER":"$USER" {docker_config_dir} -R ; chmod g+rwx "{docker_config_dir}" -R; sudo usermod -aG docker "$USER"; newgrp docker')
    run_command('docker login')
    print("Login no Docker realizado com sucesso")
    run_command(f'reboot')

if __name__ == "__main__":
    main()