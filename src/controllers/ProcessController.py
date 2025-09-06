from .BaseController import BaseController
from .ProjectController import ProjectController
import os
from langchain_community.document_loaders import PyPDFLoader, TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from models import ProcessingSignal
from models.AssetModel import AssetModel
from bson.objectid import ObjectId


class ProcessController(BaseController):

    def __init__(self,project_id:str, db_client=None):
        super().__init__()
        self.project_id = project_id
        self.project_path = ProjectController().get_project_path(project_id=project_id)
        self.db_client = db_client

    def get_file_extension(self,filename:str):
        return os.path.splitext(filename)[-1]
    
    async def get_file_loader(self,file_id:str):
        # First, get the asset from database to find the actual filename
        asset_model = await AssetModel.create_instance(db_client=self.db_client)
        asset = await asset_model.get_asset_by_id(ObjectId(file_id))
        
        if not asset:
            return None
            
        # Use the asset_name (which contains the actual filename with extension)
        filename = asset.asset_name
        file_ext = self.get_file_extension(filename)
        file_path = os.path.join(self.project_path, filename)
        
        if file_ext == ProcessingSignal.TXT.value:
            return TextLoader(file_path, encoding="utf-8")
        if file_ext == ProcessingSignal.PDF.value:
            return PyPDFLoader(file_path)

        return None

    async def get_file_content(self, file_id):
        loader = await self.get_file_loader(file_id=file_id)
        if loader is None:
            raise ValueError(f"No loader found for file_id: {file_id}")
        return loader.load()
    
    def process_file_content(self,file_content:list,
                             file_id:str,chunk_size:int=100,
                             overlap_size:int=20):
        
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=overlap_size,
            length_function=len,
        )
        file_content_texts= [
            rec.page_content
            for rec in file_content
        ]
        file_content_metadata=[
            rec.metadata
            for rec in file_content
        ]
        
        chunks = text_splitter.create_documents(
            file_content_texts,
            metadatas=file_content_metadata
            )
        return chunks