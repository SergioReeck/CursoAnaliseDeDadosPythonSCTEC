# Revisão - Manipulação de Arquivos, Regex, Datetime e Funções

## Objetivo

Neste exemplo, simulamos uma situação comum na área de Análise de Dados: o processamento de um relatório de vendas exportado de um sistema.

O arquivo contém informações úteis, mas também possui cabeçalhos, separadores e registros que não devem ser considerados na análise. O objetivo é organizar os dados e calcular o valor total vendido no mês.

## Conteúdos revisados

* Manipulação de arquivos (`open()` e `with open()`)
* Expressões regulares (Regex)
* Datas com `datetime`
* Criação e utilização de funções
* Importação de módulos (`re` e `datetime`)

## Estrutura do projeto

```text
.
├── vendas_julho.txt    # Relatório exportado pelo sistema
├── revisao.ipynb       # Código da revisão
└── README.md
```

## O que o código faz?

1. Lê o arquivo de vendas.
2. Ignora registros cancelados.
3. Extrai pedido, data, cliente e valor utilizando expressões regulares.
4. Converte a data para o tipo `datetime`.
5. Converte o valor para o tipo `float`.
6. Armazena os registros em uma lista.
7. Calcula e exibe o valor total vendido no período.

## Resultado esperado

Ao executar o programa, serão exibidas as vendas válidas e o total vendido no mês.

Este exemplo representa uma etapa comum do processo de ETL (Extração, Transformação e Carga), preparando os dados para futuras análises com a biblioteca **Pandas**.
