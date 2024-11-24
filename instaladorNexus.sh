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

echo "Verificando dependências e serviços necessários..."

# Instalando o Git
if ! git --version &> /dev/null; then
  echo "Git não encontrado. Instalando Git..."
  sudo apt update -y
  sudo apt install -y git || { echo "Erro ao instalar Git"; exit 1; }
  echo "Git instalado com sucesso."
else
  echo "Git já está instalado."
fi

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
if ! docker compose version &> /dev/null && ! docker-compose --version &> /dev/null; then
  echo "Docker Compose não encontrado. Instalando Docker Compose..."

  # Atualiza pacotes e instala o plugin do docker-compose
  sudo apt update -y
  sudo apt install -y docker-compose-plugin || { echo "Erro ao instalar Docker Compose"; exit 1; }

  echo "Docker Compose instalado com sucesso."
else
  echo "Docker Compose já está instalado."
fi


# Construindo e iniciando containers com Docker Compose
echo "Construindo e iniciando containers com Docker Compose..."
cd nexusEnergy-app
clear

sudo docker-compose up --build || { echo "Erro ao subir os containers"; exit 1; }


echo "Aplicação instalada e executada com sucesso."





