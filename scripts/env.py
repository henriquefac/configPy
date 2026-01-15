import os
from dataclasses import dataclass
from threading import Lock
from typing import ClassVar, TypeVar, Type, Callable, Any
from dotenv import load_dotenv

# Carrega as variáveis do arquivo .env
load_dotenv()

# --- Funções Utilitárias ---


def _get_required_env(key: str) -> str:
    """Busca uma variável de ambiente e levanta um erro se não for encontrada."""
    value = os.getenv(key)
    if value is None:
        raise EnvironmentError(
            f"Variável de ambiente obrigatória '{key}' não encontrada. "
            "Verifique seu arquivo '.env' ou as variáveis do sistema."
        )
    return value


def _get_optional_env(key: str, default: Any) -> Any:
    """Busca uma variável de ambiente, retornando um default se não for encontrada."""
    return os.getenv(key, default)


# --- Classes de Domínio ---


@dataclass(frozen=True)  # frozen=True garante imutabilidade após a criação
class ENVDomain:
    """Classe base abstrata para domínios de variáveis de ambiente."""

    pass


@dataclass(frozen=True)
class HuggingFaceEnv(ENVDomain):
    """Domínio para variáveis de ambiente relacionadas ao HuggingFace."""

    HF_TOKEN: str
    HF_MODEL_CACHE: str

@dataclass(frozen=True)
class AzureEnv(ENVDomain):
    """Domínio para variáveis de ambiente relacionadas ao HuggingFace."""
    AZURE_ENDPOINT: str
    AZURE_OPENAI_API_KEY: str
    AZURE_OPENAI_API_VERSION: str
    MODEL_NAME: str
    EMBEDDING_MODEL: str


@dataclass(frozen=True)
class DatabaseEnv(ENVDomain):
    """Domínio para variáveis de ambiente relacionadas ao Banco de Dados."""

    DB_HOST: str
    DB_PORT: int
    DB_USER: str


# --- Mapeamento de Domínios ---


# Função para carregar as variáveis do domínio HuggingFaceEnv
def load_huggingface_env() -> HuggingFaceEnv:
    return HuggingFaceEnv(
        HF_TOKEN=_get_required_env("HF_TOKEN"),
        # Exemplo de variável opcional com conversão de tipo implícita
        HF_MODEL_CACHE=_get_optional_env("HF_MODEL_CACHE", "cache_dir"),
    )


# Função para carregar as variáveis do domínio DatabaseEnv
def load_database_env() -> DatabaseEnv:
    return DatabaseEnv(
        DB_HOST=_get_required_env("DB_HOST"),
        # Exemplo de conversão de tipo explícita para inteiro
        DB_PORT=int(_get_required_env("DB_PORT")),
        DB_USER=_get_required_env("DB_USER"),
    )

def load_database_env() -> AzureEnv:
    return AzureEnv(
        AZURE_ENDPOINT=_get_required_env("AZURE_ENDPOINT"),
        AZURE_OPENAI_API_KEY=_get_optional_env("AZURE_OPENAI_API_KEY"),
        AZURE_OPENAI_API_VERSION=_get_required_env("AZURE_OPENAI_API_VERSION"),
        MODEL_NAME=_get_required_env("MODEL_NAME"),
        EMBEDDING_MODEL=_get_required_env("EMBEDDING_MODEL")

    )

# Tipo genérico para as classes de domínio
D = TypeVar("D", bound=ENVDomain)

# Dicionário de mapeamento: Onde a chave é a CLASSE e o valor é a FUNÇÃO DE CARREGAMENTO.
DOMAIN_LOADERS: dict[Type[ENVDomain], Callable[[], ENVDomain]] = {
    AzureEnv: load_database_env,
    # Adicione novos domínios aqui para torná-los acessíveis
}


# --- Manager Singleton ---


class EnvManager:
    """
    Singleton central para gerenciar e fornecer acesso aos domínios de variáveis.
    """

    _instance: ClassVar["EnvManager|None"] = None
    _lock: ClassVar[Lock] = Lock()
    _domains: dict[Type[ENVDomain], ENVDomain]

    def __new__(cls, *args, **kwargs) -> "EnvManager":
        """Implementa o padrão Singleton thread-safe."""
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    # Cria a instância
                    cls._instance = super().__new__(cls)
                    # Inicializa o dicionário para armazenar as instâncias de domínio
                    cls._instance._domains = {}
        return cls._instance

    # Novo método de classe (ou estático) para acessar a única instância
    @classmethod
    def get_instance(cls) -> "EnvManager":
        """
        Garante que o Singleton seja criado e retorna a única instância.
        Pode ser chamado como EnvManager.get_instance().
        """
        if cls._instance is None:
            # Chama o __new__ para inicializar e criar a instância
            cls()
        return cls._instance  # type: ignore

    # Refatorado: Deixamos a lógica de carregamento como método de instância,
    # mas o acesso a ele será feito via o método de classe.
    def _load_domain_instance(self, domain_class: Type[D]) -> D:
        """Carrega e armazena uma instância de domínio (Lazy Loading)."""
        if domain_class not in self._domains:
            if domain_class not in DOMAIN_LOADERS:
                raise ValueError(
                    f"Domínio '{domain_class.__name__}' não mapeado no DOMAIN_LOADERS."
                )

            loader_func = DOMAIN_LOADERS[domain_class]
            self._domains[domain_class] = loader_func()

        return self._domains[domain_class]  # type: ignore

    # --- Métodos de Acesso (Classmethods) ---
    @classmethod
    def azure(cls) -> AzureEnv:
        manager_instance = cls.get_instance()
        return manager_instance._load_domain_instance(AzureEnv)

    # --- Método Genérico (para customização) ---

    @classmethod
    def get_domain(cls, domain_class: Type[D]) -> D:
        """Acesso genérico a qualquer domínio configurado via classmethod."""
        manager_instance = cls.get_instance()
        return manager_instance._load_domain_instance(domain_class)
