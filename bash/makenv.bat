@echo off
echo Iniciando projeto

:: --- Criacao de Diretorios ---
echo --- Configurando Diretorios ---

:: Diretório "files"
if not exist "files" (
    echo Criando diretorio 'files'
    mkdir files
    echo Diretorio reservado para dados brutos ou auxiliares> files\data_dir.txt
) else (
    echo Diretorio 'files' ja existe.
)

:: Diretório "src"
if not exist "src" (
    echo Criando diretorio 'src' para scripts
    mkdir src
    echo Diretorio reservado para scripts e codigo-fonte> src\src_dir.txt
) else (
    echo Diretorio 'src' ja existe.
)

:: Diretório "files/output"
if not exist "files\output" (
    echo Criando diretorio 'files/output'
    mkdir files\output
    echo Diretorio reservado para os resultados do processamento> files\output\output.txt
) else (
    echo Diretorio 'files/output' ja existe.
)


:: --- Configuracao do Ambiente Virtual ---
echo --- Configurando Ambiente Python (.venv) ---

if not exist ".venv" (
    echo Criando ambiente virtual Python (.venv)...
    python -m venv .venv

    echo Ativando ambiente virtual temporariamente...
    call .venv\Scripts\activate

    :: Adiciona variáveis no activate.bat para serem aplicadas sempre que ativar o venv
    echo.>> .venv\Scripts\activate.bat
    echo :: Variaveis adicionadas pelo script de setup>> .venv\Scripts\activate.bat
    echo set PYTHONPATH=%cd%>> .venv\Scripts\activate.bat
    echo set JUPYTER_PATH=%cd%>> .venv\Scripts\activate.bat

    echo Instalando pacote python-dotenv...
    pip install python-dotenv

    if exist "requirements.txt" (
        echo Instalando dependencias de requirements.txt...
        pip install -r configPy/requirements.txt
        pip install -r requirements.txt
    ) else (
        echo Aviso: requirements.txt nao encontrado. Nenhum pacote adicional instalado.
    )

    echo Desativando ambiente...
    deactivate

) else (
    echo Ambiente virtual '.venv' ja existe.
)

echo Ativando ambiente virtual para uso atual...
call .venv\Scripts\activate

echo ---
echo Setup concluido! O ambiente virtual esta ATIVADO.
echo Para desativar, use: deactivate
