import os 
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

# Configurações do Banco de Dados ERP

engine_erp = create_engine(
    f"postgresql+psycopg2://"
    f"{os.getenv('ERP_USUARIO')}:{os.getenv('ERP_SENHA')}"
    f"@{os.getenv('ERP_HOST')}:{os.getenv('ERP_PORTA')}"
    f"/{os.getenv('ERP_BANCO')}"
) # "postgresql+psycopg2://usuario:senha@local:porta/banco_de_dados"


# Configurações do Banco de Dados DW

engine_dw = create_engine(
    f"postgresql+psycopg2://"
    f"{os.getenv('DW_USUARIO')}:{os.getenv('DW_SENHA')}"
    f"@{os.getenv('DW_HOST')}:{os.getenv('DW_PORTA')}"
    f"/{os.getenv('DW_BANCO')}"
) # "postgresql+psycopg2://usuario:senha@local:porta/banco_de_dados"
