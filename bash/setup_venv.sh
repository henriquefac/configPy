#!/bin/bash
# Script para configurar o ambiente virtual Python e dependências.

echo "--- Configurando Ambiente Python (.venv) ---"

if [[ ! -d ".venv" ]]; then
	echo "  - Criando ambiente virtual Python (.venv)..."
	python3 -m venv .venv

	# Ativa e configura o ambiente TEMPORARIAMENTE para instalar os pacotes
	source .venv/bin/activate

	echo "  - Instalando dependências..."
	# Pacote básico
	pip install python-dotenv 

	# Instalação de requirements (checa ambos os arquivos)
	if [[ -f "configPy/requirements.txt" ]]; then
		echo "  - Instalando dependências de 'configPy/requirements.txt'"
		pip install -r configPy/requirements.txt
	fi

	if [[ -f "requirements.txt" ]]; then
		echo "  - Instalando dependências de 'requirements.txt'"
		pip install -r requirements.txt
	fi
	
	if [[ ! -f "requirements.txt" ]] && [[ ! -f "configPy/requirements.txt" ]]; then
		echo "  - Aviso: Nenhum 'requirements.txt' encontrado. Apenas 'python-dotenv' instalado."
	fi
	
	# Adiciona Variáveis de Ambiente ao script de ativação
	# O `sed -i` é usado para editar o arquivo diretamente. 
	# Usamos uma string única como delimitador (ex: ~) para evitar problemas com / no caminho
	# Adiciona as variáveis no final do arquivo de ativação do venv
	
	# Nota: A variável `LD_LIBRARY_PATH` deve ser adaptada para o seu SO (ex: python3.X)
	VENV_ACTIVATE_PATH=".venv/bin/activate"
	
	echo "  - Configurando variáveis de ambiente no script de ativação..."
	cat >> $VENV_ACTIVATE_PATH << EOF
# Variáveis adicionadas pelo script de setup
export PYTHONPATH=\$(pwd)
export JUPYTER_PATH=\$(pwd)

# Caminho correto para buscar as bibliotecas de uso da gpu (cuda)
export LD_LIBRARY_PATH=\$(pwd)/.venv/lib/python3.12/site-packages/nvidia/cublas/lib/:\$(pwd)/.venv/lib/python3.12/site-packages/nvidia/cudnn/lib:\$LD_LIBRARY_PATH

EOF

	deactivate # Desativa o ambiente TEMPORÁRIO
	echo "  - Ambiente virtual '.venv' configurado com sucesso."
else
	echo "  - Ambiente virtual '.venv' já existe."
fi
