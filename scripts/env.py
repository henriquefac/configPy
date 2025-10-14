import os
from dataclasses import dataclass, field
from threading import Lock
from dotenv import load_dotenv

load_dotenv()
def _get_required_env(key: str) -> str:
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
@dataclass
class OpenAIENV:
    AZURE_ENDPOINT: str
    AZURE_OPENAI_API_KEY: str
    AZURE_OPENAI_API_VERSION: str
    MODEL_NAME: str
    EMBEDDING_MODEL: str

    _instance: "OpenAIENV|None" = field(default=None, init=False, repr=False)
    _lock: Lock = field(default=Lock(), init=False, repr=False)

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
        return cls._instance
    @classmethod
    def get(cls) -> "OpenAIENV":
        if cls._instance is None:
            cls._instance = cls(
                _get_required_env("AZURE_ENDPOINT"),
                _get_required_env("AZURE_OPENAI_API_KEY"),
                _get_required_env("AZURE_OPENAI_API_VERSION"),
                _get_required_env("MODEL_NAME"),
                _get_required_env("EMBEDDING_MODEL")
            )
        return cls._instance

class EnvManager:
    _instance: "EnvManager|None" = None
    _lock: Lock = Lock()
    _openai : OpenAIENV
    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                    # Initialize OpenAIENV singleton
                    cls._openai = OpenAIENV.get()
        return cls._instance

    @classmethod
    def openai_env(cls) -> OpenAIENV:
        if cls._openai is None:
            cls()
        return cls._openai    
