from .BaseController import BaseController
from .ProjectController import ProjectController
import os
from langchain_community.document_loaders import PyPDFLoader, TextLoader
from models import ProcessingEnum


class ProcessController(BaseController):

    def __init__(self,project_id:str):
        super().__init__()
        self.project_id = project_id
        self.project_path = ProjectController().get_project_path(project_id=project_id)

    def get_file_extension(self,file_id:str):
        return os.path.splitext(file_id)[-1]
    
    def get_file_loader(self,file_id:str,file_path):
        file_ext = self.get_file_extension(file_id=file_id)
        file_path = os.path.join(self.project_path,file_id)
        
        if file_ext== ProcessingEnum.TXT.value:
            return TextLoader(file_path,encoding="utf-8")
        if file_ext== ProcessingEnum.PDF.value:
            return PyPDFLoader(file_path)

        return None

    def get_file_content(self,file_id:str):
        loader = self.get_file_loader(file_id=file_id)
        return loader.load()