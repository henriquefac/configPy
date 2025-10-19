#!/bin/bash
# Script principal para coordenar a configuração do projeto.

echo "========================================="
echo "        INICIANDO SETUP DO PROJETO       "
echo "========================================="

# 1. Definir o diretório do script (SCRIPT_DIR)
# Garante que o caminho absoluto do diretório atual do script seja conhecido.
# Isso funciona mesmo se o script for executado via 'source' ou link simbólico.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(pwd)
echo "Diretório de execução do setup: $SCRIPT_DIR"
echo "Diretório RAIZ do projeto: $ROOT_DIR"
# Garante que, se um script falhar, o main.sh pare.
set -e



# --- 2. Configurar Diretórios ---
echo "PASSOS: Configurando estrutura de diretórios..."
# Usamos SCRIPT_DIR para construir o caminho absoluto para o script auxiliar
bash "$SCRIPT_DIR/setup_dirs.sh"

# --- 3. Configurar Ambiente Virtual ---
echo "PASSOS: Configurando ambiente Python (.venv)..."
# Usamos SCRIPT_DIR para construir o caminho absoluto
bash "$SCRIPT_DIR/setup_venv.sh"

# --- 4. Download de Modelos (Se necessário) ---
echo "PASSOS: Verificando e baixando modelos externos..."
# Usamos SCRIPT_DIR para construir o caminho absoluto
bash "$SCRIPT_DIR/download_model.sh"


# --- 5. Ativar Ambiente e Mensagem Final ---
# IMPORTANTE: Se o venv for criado em ../.venv (na raiz do projeto), 
# você precisa ter certeza que o PATH está correto.
# Assumindo que o venv está na raiz do projeto, um nível acima de configPy/bash/
VENV_ACTIVATE_PATH="$ROOT_DIR/.venv/bin/activate"


echo "========================================="
echo "Setup concluído! Ativando ambiente virtual..."
echo "========================================="

set +e
# NOTA: Para ATIVAR o ambiente no terminal do usuário, você DEVE usar 'source'
# na linha de comando, conforme você já estava fazendo:
# . configPy/bash/main.sh

if [[ -f "$VENV_ACTIVATE_PATH" ]]; then
    source "$VENV_ACTIVATE_PATH"
    echo "O ambiente virtual (.venv) está ATIVADO NESTE TERMINAL."
    echo "Para desativar o ambiente, use: 'deactivate'"
else
    echo "Aviso: Não foi possível encontrar o script de ativação em: $VENV_ACTIVATE_PATH"
fi
