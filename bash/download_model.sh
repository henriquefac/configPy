#!/bin/bash
# Script para verificar e baixar modelos externos.

echo "--- Verificando e Baixando Modelo RNNoise ---"

MODEL_DIR="rnnoise-models/somnolent-hogwash-2018-09-01"
MODEL_FILE="$MODEL_DIR/sh.rnnn"

if [[ ! -f "$MODEL_FILE" ]]; then
	echo "  - Baixando modelo RNNoise..."
	# Cria a estrutura de diretórios, se não existir
	mkdir -p "$MODEL_DIR"
	
	# URL CORRIGIDA (a URL no script original estava incorreta para o wget)
	wget https://raw.githubusercontent.com/GregorR/rnnoise-models/master/somnolent-hogwash-2018-09-01/sh.rnnn -O "$MODEL_FILE"
	
	echo "  - Modelo baixado em $MODEL_FILE"
else
	echo "  - Modelo já existe em $MODEL_FILE"
fi
