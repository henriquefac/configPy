from pathlib import Path
from typing import Union
import os
from dotenv import load_dotenv

class DirManager():
    def __init__(self, dir_path: Union[Path, "DirManager"]):
        self.dir_path = Path(dir_path) if isinstance(dir_path, (str, Path)) else dir_path.dir_path
    def list_dir(self)->dict[str, 'DirManager']:
        return {dir.name : DirManager(dir) for dir in self.dir_path.iterdir() if dir.is_dir()}
    def list_files(self)->dict[str, Path]:
        return {file.name : file for file in self.dir_path.iterdir() if file.is_file()}
    def __str__(self) -> str:
        return str(self.dir_path)
    def __repr__(self) -> str:
        return f"DirManager({self.dir_path})"
    def __getitem__(self, key: str)-> 'DirManager':
        dirs = self.list_dir()
        files = self.list_file()
        if key in dirs:
            return dirs[key]
        if key in files:
            return files[key]
        for sub_dir in dirs.values()
            try:
                return sub_dir[key]
            except KeyError:
                continue
        raise KeyError(f"({key}) não foi encontrado em ({self.dir_path}) e subdiretórios")

class Config:
    # carregar variáveis
    load_dotenv()
    # Paths
    BASE_PATH = Path(os.getenv(PYTHONPATH)).resolve().parent
    FILE_DIR_PATH = FILE_DIR_PATH / "files"


