import os
from dotenv import load_dotenv

load_dotenv()




class EnvManager:
    # 1. Padrão Singleton: Garante que só há uma instância
    _instance = None

    def __new__(cls):
        # Implementação do Singleton
        if cls._instance is None:
            cls._instance = super(EnvManager, cls).__new__(cls)
        return cls._instance

    def _get_required_env(self, key: str) -> str:
        """
        Busca uma variável de ambiente pelo nome (key).
        Levanta um erro se a variável não estiver definida.
        """
        value = os.getenv(key)
        if value is None:
            # Mensagem de erro clara para depuração
            raise EnvironmentError(
                f"Variável de ambiente obrigatória '{key}' não encontrada. "
                "Verifique seu arquivo 'token.env' ou as variáveis do sistema."
            )
        return value

    def _get_optional_env(self, key: str, default: str| None = None) -> str | None:
        """
        Busca uma variável de ambiente opcional.
        Retorna um valor padrão (default) se não estiver definida.
        """
        return os.getenv(key, default)


