import os
import json
from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    APP_NAME: str
    APP_VERSION: str
    APP_ENV: str
    OPENAI_API_KEY: str
    FILE_ALLOWED_TYPES: str 
    FILE_MAX_SIZE: int
    FILE_DEFAULT_CHUNK_SIZE: int
    MONGODB_URL: str
    MONGODB_DATABASE: str

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"

# Create settings instance
settings = Settings()

@property
def file_allowed_types_list(self) -> List[str]:
    """Parse FILE_ALLOWED_TYPES string into list"""
    try:
        return json.loads(settings.FILE_ALLOWED_TYPES)
    except (json.JSONDecodeError, TypeError):
        # Fallback to comma-separated or default
        if settings.FILE_ALLOWED_TYPES:
            return [t.strip() for t in settings.FILE_ALLOWED_TYPES.split(",")]
        return ["text/plain", "application/pdf"]

def get_settings() -> Settings:
    return settings 