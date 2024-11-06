  GNU nano 7.2                                                                                                                                                                                                                                                                                                       ./instaladorNexus.sh                                                                                                                                                                                                                                                                                                                 
#!/bin/bash

echo "Seja bem-vindo ao instalador do NexusEnergy"
echo "O script é responsável por fazer a instalação de nossas aplicações..."
echo "Tem certeza que deseja continuar? (s/n)"
read confirmacao

if [[ "$confirmacao" != "s" ]]; then
  echo "Instalação cancelada."
  exit 1
fi

# Atualizando repositórios e pacotes do sistema
echo "Atualizando repositórios e pacotes do sistema..."
sudo apt update && sudo apt upgrade -y
echo "Atualização concluída..."
clear



# Instalando o Git
echo "Instalando o Git e clonando o repositório do projeto..."
sudo apt install -y git || { echo "Erro ao instalar Git"; exit 1; }
git clone https://github.com/NexusEnergyy/nexusEnergy-app.git || { echo "Erro ao clonar o repositório"; exit 1; }
clear

# Verificando a instalação do Docker
if ! command -v docker &> /dev/null
then
  echo "Docker não encontrado. Instalando Docker..."
  sudo apt install -y docker.io || { echo "Erro ao instalar Docker"; exit 1; }
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "Docker instalado com sucesso."
else
  echo "Docker já está instalado."
fi

# Verificando a instalação do Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null
then
  echo "Docker Compose não encontrado. Instalando Docker Compose..."
  sudo apt install -y docker-compose-plugin || { echo "Erro ao instalar Docker Compose"; exit 1; }
  echo "Docker Compose instalado com sucesso."
else
  echo "Docker Compose já está instalado."
fi
clear


# Construindo e iniciando containers com Docker Compose
echo "Construindo e iniciando containers com Docker Compose..."
cd nexusEnergy-app
clear

# Configurando credenciais temporárias da AWS
echo "Insira suas credenciais AWS para configuração."
read -p "AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
read -p "AWS Session Token: " AWS_SESSION_TOKEN
clear

# Salvando variáveis de ambiente localmente na máquina
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

# Salvando variáveis de ambiente no arquivo .env
echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> .env
echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> .env
echo "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}" >> .env

echo "Variáveis de ambiente da AWS configuradas no arquivo .env."


sudo docker-compose up --build || { echo "Erro ao subir os containers"; exit 1; }


echo "Aplicação instalada e executada com sucesso."




