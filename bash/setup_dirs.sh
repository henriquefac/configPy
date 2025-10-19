#!/bin/bash
# Script para criar a estrutura de diretórios do projeto.

echo "--- Configurando Estrutura de Diretórios ---"

# Verifica e cria 'files'
if [[ ! -d "files" ]]; then
	echo "  - Criando diretório 'files'"
	mkdir files
	touch files/data_dir.txt
	echo "Diretório reservado para dados brutos ou auxiliares" >> files/data_dir.txt
else
	echo "  - Diretório 'files' já existe."
fi

# Verifica e cria 'src'
if [[ ! -d "src" ]]; then
	echo "  - Criando diretório 'src' para scripts"
	mkdir src
	touch src/src_dir.txt
	echo "Diretório reservado para scripts e código-fonte" >> src/data_dir.txt
else
	echo "  - Diretório 'src' já existe."
fi

# Verifica e cria 'files/output'
if [[ ! -d "files/output" ]]; then
	echo "  - Criando diretório 'files/output'"
	mkdir files/output
	touch files/output/output.txt
	echo "Diretório resevardo para os resultados do processamento" >> files/output/output.txt
else
	echo "  - Diretório 'files/output' já existe"
fi
