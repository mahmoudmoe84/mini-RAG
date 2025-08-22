# mini-RAG
building a mini-RAG to use it on my private documents and books

## Requirements 

- Python 3.11 or later


#### Install Python Using DevContainer

1 - create .devcontainer folder
2 - make sure you have the right setup inside the devcontainer
3- add postcreatecommand
4- mise package handler to be added to create venv and intall helm & other needed kubernestes packages

### Installation

1- UV installation using uv sync
2- pyproject.toml is created
3- add fastapi and uvicorn[standard]

### Setup enviroment variables

```bash
$ cp .env.example .env

set your enviroment variables in the .env such as OPENAI_API_KEY
