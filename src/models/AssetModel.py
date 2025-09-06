from .BaseDataModel import BaseDataModel
from .db_schemes import Asset , Project
from.enums.DataBaseEnum import DataBaseEnum
from bson.objectid import ObjectId

class AssetModel(BaseDataModel):
    def __init__(self,db_client:object):
        super().__init__(db_client=db_client)
        self.collection =self.db_client[DataBaseEnum.COLLECTION_ASSET_NAME.value]   
        
    @classmethod
    async def create_instance(cls,db_client:object):
        instance = cls(db_client)
        await instance.init_collection()
        return instance
    
    async def init_collection(self):
        all_collections = await self.db_client.list_collection_names()
        if DataBaseEnum.COLLECTION_ASSET_NAME.value not in all_collections:
            self.collection =self.db_client[DataBaseEnum.COLLECTION_ASSET_NAME.value]
            indexes =Asset.get_indexes()
            for index in indexes:
                await self.collection.create_index(
                    index['key'],
                    name=index['name'],
                    unique=index['unique']
                )
    async def create_asset(self,asset:Asset):
        result = await self.collection.insert_one(asset.dict(by_alias=True,exclude_unset=True))
        asset.id = result.inserted_id
        return asset
    
    async def get_asset_by_id(self, asset_id: ObjectId):
        result = await self.collection.find_one({"_id": asset_id})
        if result:
            return Asset(**result)
        return None
    
    async def get_all_project_assets(self,asse_project_id:str):
        
        return await self.collection.find(
            {"asset_project_id":ObjectId(asse_project_id) if isinstance(asse_project_id , str) else asse_project_id}
        ).to_list(length=None)