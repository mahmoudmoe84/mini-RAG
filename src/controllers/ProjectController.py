from .BaseController import BaseController
from fastapi import UploadFile
from models import ResponseSignal
from helpers.config import get_settings , Settings
import os

class ProjectController(BaseController):
    
    def __init__(self):
        super().__init__()
        self.app_settings = get_settings()

    def get_project_path(self,project_id:str):
        project_dir = os.path.join(self.file_dir,project_id)
        if not os.path.exists(project_dir):
            os.makedirs(project_dir)
        return project_dir