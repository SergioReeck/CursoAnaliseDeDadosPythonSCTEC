""" Pipeline ETL - Fluxo de Execução """

from setup_dw import configurar_dw
from extract_erp import extrair_erp
from extract_ibge import extrair_ibge
from extract_excel import extrair_excel
from silver import processar_silver
from gold import processar_gold

def main():
    """ Função principal do pipeline ETL """
    # Configurar o Data Warehouse
    configurar_dw()

    # Extrair dados do ERP
    extrair_erp()

    # Extrair dados do IBGE
    extrair_ibge()

    # Extrair dados do Excel
    extrair_excel()

    # Transformar e carregar dados na camada Silver
    processar_silver()

    # Carregar dados na camada Gold
    processar_gold()

    print("Pipeline ETL concluído!")

if __name__ == "__main__":
    main()

# Comando para executar o pipeline ETL no terminal:
# python run_etl.py
    