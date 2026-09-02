# Análise de Dados com Python - Miniprojeto Avaliativo - Módulo 1 - Semana 07

---

# 📊 Miniprojeto - Análise Exploratória de Dados de Varejo

Este projeto realiza uma **Análise Exploratória de Dados (EDA)** sobre uma base de dados de varejo. O objetivo é importar, verificar, limpar, transformar e analisar os dados, identificando possíveis problemas de qualidade e explorando padrões relacionados aos clientes, produtos e vendas.

## 📁 Arquivo principal

```Python
Miniprojeto_Analise_Exploratoria.ipynb
```

O projeto foi desenvolvido em formato de **Jupyter Notebook**.

---

# 🎯 Objetivos

O projeto tem como principais objetivos:

* Importar uma base de dados de varejo;
* Verificar a estrutura e as informações gerais do conjunto de dados;
* Identificar valores nulos, vazios e incorretos;
* Verificar registros duplicados;
* Validar valores;
* Realizar a limpeza e o tratamento dos dados;
* Gerar uma nova base de dados tratada;
* Calcular estatísticas descritivas;
* Explorar padrões utilizando agrupamentos com `groupby()`.

---

# 🛠️ Tecnologias e bibliotecas utilizadas

O projeto utiliza Python e as seguintes bibliotecas:

* **Pandas**
* **KaggleHub**
* **Jupyter Notebook**

### Instalação das dependências

```bash
pip install pandas kagglehub
```

---

# 📥 Importação dos dados

A base de dados é obtida a partir do Kaggle utilizando a biblioteca `kagglehub`.

```python
import kagglehub
import pandas as pd
```

O download da base é realizado com:

```python
path = kagglehub.dataset_download("namespaiva/base-varejo")
```

Em seguida, o arquivo CSV é carregado:

```python
df = pd.read_csv(
    path + "/Base Varejo.csv",
    sep=";",
    encoding="utf-8"
)
```

Também existe uma alternativa para carregar o arquivo localmente:

```python
df = pd.read_csv(
    "Base Varejo.csv",
    sep=";",
    encoding="utf-8"
)
```

> Essa opção pode ser utilizada caso a importação via internet esteja indisponível.

---

# 🔍 Exploração inicial dos dados

Após carregar a base, são realizadas verificações iniciais para compreender sua estrutura.

## Primeiras linhas

```python
df.head()
```

## Últimas linhas

```python
df.tail()
```

## Nomes das colunas

```python
df.columns
```

## Tipos de dados

```python
df.dtypes
```

## Quantidade de linhas e colunas

```python
df.shape
```

## Informações gerais

```python
df.info()
```

Essas verificações permitem identificar a estrutura do DataFrame, os tipos de dados presentes e possíveis problemas antes do processo de limpeza.

---

# ✅ Validação e verificação dos dados

## Valores nulos

A quantidade de valores nulos por coluna é verificada com:

```python
df.isnull().sum()
```

---

## Remoção de espaços extras nos nomes das colunas

O projeto verifica os nomes das colunas utilizando:

```python
df.columns.str.strip()

print(df.columns.tolist())
```

Essa etapa auxilia na identificação de espaços indesejados nos nomes das colunas.

---

## Verificação de valores incorretos

São procurados valores que representam informações ausentes ou indefinidas, como:

* `n/a`
* `n/d`
* `não informado`
* `não disponível`
* `indisponível`

A verificação percorre todas as colunas e identifica os registros que contêm esses valores.

---

## Verificação de linhas duplicadas

O projeto identifica registros duplicados utilizando:

```python
df.duplicated().sum()
```

Também são exibidas as linhas consideradas duplicadas.

---

## Verificação de datas vazias

A coluna `DATA` é analisada para verificar valores nulos:

```python
df["DATA"].isnull().sum()
```

---

## Verificação de datas inválidas

O projeto utiliza uma expressão regular para verificar se as datas seguem o formato:

```
DD/MM/AAAA
```

A validação é realizada com:

```python
data_valida = r"^\d{2}/\d{2}/\d{4}$"
```

Os registros que não seguem esse padrão são identificados e exibidos.

---

## Verificação de valores vazios

Além dos valores nulos, o projeto verifica células contendo strings vazias ou espaços em branco.

A análise percorre todas as colunas e informa a quantidade de registros vazios encontrados em cada uma.

---

# 🧹 Tratamento e limpeza dos dados

## Substituição de valores indefinidos

Os valores considerados indefinidos são substituídos por:

```
"SEM CATEGORIA"
```

Também são preenchidos os valores nulos:

```python
df = df.fillna("SEM CATEGORIA")
```

---

## Remoção de registros duplicados

As linhas duplicadas são removidas utilizando:

```python
df = df.drop_duplicates()
```

Antes da remoção, o projeto informa a quantidade de registros duplicados encontrados.

---

## Conversão da coluna `DATA`

A coluna `DATA` é convertida para o formato `datetime`:

```python
df["DATA"] = pd.to_datetime(
    df["DATA"],
    dayfirst=True
)
```

Após a conversão, é verificado o tipo resultante:

```python
df["DATA"].dtype
```

---

## Salvamento da base tratada

A base processada é salva em formato CSV:

```python
df.to_csv(
    "base_varejo_limpa.csv",
    sep=";",
    index=False
)
```

Posteriormente, o notebook também realiza o carregamento de uma base limpa local:

```python
df = pd.read_csv(
    "base_varejo_limpa.csv",
    sep=";",
    encoding="utf-8"
)
```

---

# 📈 Estatísticas da quantidade de filhos

O projeto realiza uma análise descritiva da coluna:

```
"CL_FHL"
```

Essa coluna representa a **quantidade de filhos dos cliente**.

São calculadas as seguintes medidas:

## Média

```python
df["CL_FHL"].mean().round(2)
```

## Mediana

```python
df["CL_FHL"].median()
```

## Desvio padrão

```python
df["CL_FHL"].std().round(2)
```

## Moda

```python
df["CL_FHL"].mode()[0]
```

## Valor máximo

```python
df["CL_FHL"].max()
```

## Valor mínimo

```python
df["CL_FHL"].min()
```

## Quantidade de registros

```python
df["CL_FHL"].count()
```

---

## Quartis

Também são calculados os quartis da distribuição:

```python
q1 = df["CL_FHL"].quantile(0.25)
q2 = df["CL_FHL"].quantile(0.50)
q3 = df["CL_FHL"].quantile(0.75)
```

Os valores representam:

* **Q1:** 25% dos dados;
* **Q2:** 50% dos dados, equivalente à mediana;
* **Q3:** 75% dos dados.

---

## Estatísticas descritivas completas

O método `describe()` é utilizado para apresentar as principais estatísticas de forma consolidada:

```python
df["CL_FHL"].describe().round(2)
```

Também é realizada uma contagem dos valores existentes:

```python
df["CL_FHL"].value_counts().sort_index()
```

---

# 👥 Análise exploratória com `groupby()`

O projeto utiliza agrupamentos para explorar padrões entre clientes, produtos, categorias e segmentação.

## Gênero e categoria de produtos

É realizada uma contagem agrupando:

```
"PR_CAT" + "CL_GENERO"
```

Código:

```python
df.groupby(
    ["PR_CAT", "CL_GENERO"]
)["PR_NOME"].count()
```

Essa análise permite explorar a quantidade de compras por categoria e gênero.

---

## Produtos por categoria

Também é feita uma contagem utilizando:

```
"PR_CAT" + "PR_NOME"
```

Código:

```python
df.groupby(
    ["PR_CAT", "PR_NOME"]
)["CL_GENERO"].count()
```

Essa etapa permite identificar a quantidade de ocorrências dos produtos dentro de suas categorias.

---

## Produtos e segmentação social

O volume de registros é explorado a partir do agrupamento entre:

```
"PR_NOME" + "CL_SEG"
```

Código:

```python
df.groupby(
    ["PR_NOME", "CL_SEG"]
)["PR_CAT"].count()
```

Uma versão com o índice reorganizado também é gerada:

```python
df.groupby(
    ["PR_NOME", "CL_SEG"]
)["PR_CAT"].count().reset_index()
```

---

# 🗂️ Principais campos utilizados

Durante a análise, são utilizadas colunas relacionadas a clientes e produtos, como:

| Coluna        | Descrição utilizada no projeto  |
| ------------- | --------------------------------- |
| `DATA`      | Data do registro/venda            |
| `CL_GENERO` | Gênero do cliente                |
| `CL_FHL`    | Quantidade de filhos dos clientes |
| `CL_SEG`    | Segmentação do cliente          |
| `PR_CAT`    | Categoria do produto              |
| `PR_NOME`   | Nome do produto                   |

---

# ▶️ Como executar o projeto

## 1. Clone ou baixe o projeto

Certifique-se de possuir o arquivo:

```HTTP
https://github.com/SergioReeck/Miniprojeto_SergioRobertoReeckFilho_Analise_de_Dados_T3.git
```

## 2. Instale as dependências

```bash
pip install pandas kagglehub
```

## 3. Abra o Jupyter Notebook

```bash
jupyter notebook
```

## 4. Execute o arquivo

Abra:

```Python
Miniprojeto_Analise_Exploratoria.ipynb
```

E execute as células na ordem em que aparecem no notebook.

---

# 📂 Arquivos gerados

Durante o processamento, o projeto pode gerar arquivos CSV tratados, incluindo:

```
base_varejo_limpa.csv
```

O notebook também utiliza o arquivo:

```
base_varejo_limpa.csv
```

para continuar a análise após o processo de limpeza.

---

# 🔄 Fluxo do projeto

```
Base de dados
      ↓
Importação
      ↓
Exploração inicial
      ↓
Verificação de valores nulos
      ↓
Validação de valores e datas
      ↓
Identificação de duplicidades
      ↓
Limpeza e tratamento
      ↓
Conversão da coluna DATA
      ↓
Salvamento da base tratada
      ↓
Análise estatística da coluna CL_FHL
      ↓
Agrupamentos com groupby()
      ↓
Exploração de padrões
```

---

# 📌 Conclusão



* **A base passou por uma etapa importante de limpeza**, com verificação de valores nulos, vazios, valores indefinidos, datas fora do padrão e registros duplicados.
* **Os dados de datas foram padronizados para o tipo `datetime`**, facilitando futuras análises temporais e reduzindo problemas relacionados ao tratamento de datas como texto.
* **A variável "número de filhos dos clientes" foi analisada estatisticamente** por meio de média, mediana, desvio padrão, moda, valores mínimo e máximo e quartis, permitindo compreender sua distribuição.
* **Os agrupamentos entre categoria de produto, gênero e segmentação social permitem identificar padrões de frequência** entre diferentes perfis de clientes e produtos.
* **Como possível problema remanescente**, a substituição de valores ausentes ou indefinidos por `"SEM CATEGORIA"` pode mascarar diferenças entre tipos distintos de ausência de informação.
* **Outra limitação é que os resultados numéricos e agrupamentos devem ser interpretados com cautela**, pois o notebook verifica a qualidade dos dados, mas não apresenta validações adicionais para possíveis valores extremos ou inconsistências específicas em todas as variáveis.
