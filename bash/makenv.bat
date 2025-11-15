@echo off
setlocal enabledelayedexpansion

REM --- Garantir que o script execute a partir da raiz do projeto ---
pushd "%~dp0\..\.."

echo Iniciando setup do projeto

echo.
echo -----------------------------
echo --- Configurando Diretorios ---
echo -----------------------------

:: Diretório "files"
if not exist "files" (
    echo Criando diretorio 'files'
    mkdir files
    echo Diretorio reservado para dados brutos ou auxiliares> files\data_info.txt
) else (
    echo Diretorio 'files' ja existe.
)

:: Diretório "src"
if not exist "src" (
    echo Criando diretorio 'src' para scripts
    mkdir src
    echo Diretorio reservado para scripts e codigo-fonte> src\src_info.txt
) else (
    echo Diretorio 'src' ja existe.
)

:: Diretório "files/output"
if not exist "files\output" (
    echo Criando diretorio 'files/output'
    mkdir files\output
    echo Diretorio reservado para output de processamentos> files\output\output_info.txt
) else (
    echo Diretorio 'files/output' ja existe.
)

echo.
echo ------------------------------------------------
echo --- Configurando Ambiente Python Virtual (.venv) ---
echo ------------------------------------------------


echo Criando ambiente virtual Python (.venv)...
python -m venv .venv

REM ** Chamada direta ao PIP do ambiente virtual **
REM Isso evita o erro de sintaxe dentro do bloco IF
call .venv\Scripts\activate

pip install python-dotenv


echo Instalando dependencias de requirements.txt (da raiz do projeto)...
pip install -r requirements.txt


echo.
echo --- Configurando variaveis de ambiente no activate.bat ---
echo Adicionando PYTHONPATH e JUPYTER_PATH ao activate.bat...
REM Adiciona variaveis de ambiente para ativacao automatica
echo.>> .venv\Scripts\activate.bat
echo REM Added by setup script>> .venv\Scripts\activate.bat
echo set "PYTHONPATH=%%CD%%">> .venv\Scripts\activate.bat
echo set "JUPYTER_PATH=%%CD%%">> .venv\Scripts\activate.bat
    
echo Ambiente virtual '.venv' criado e configurado.


echo.
echo ----------------------------------------
echo Ativando ambiente virtual para uso atual...
REM Ativa o ambiente novamente para o usuario


echo ----------------------------------------
echo Setup concluido! O ambiente virtual esta **ATIVADO**.
echo Para desativar, use: **deactivate**

REM Retorna ao diretório original e desativa a expansão atrasada
popd
endlocal