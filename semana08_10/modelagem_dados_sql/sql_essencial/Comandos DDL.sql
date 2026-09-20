-- CRIAÇÃO DA BASE DE DADOS: TECHSTORE

CREATE DATABASE techstore;

-- CRIAÇÃO DA TABELA DE CLIENTES

CREATE TABLE clientes (
id_cliente SERIAL PRIMARY KEY,
nome VARCHAR(100),
cidade VARCHAR(50),
email VARCHAR(80)
);

-- CRIAÇÃO DA TABELA DE CATEGORIAS

CREATE TABLE categorias (
id_categoria SERIAL PRIMARY KEY,
nome VARCHAR(20)
);

-- CRIAÇÃO DA TABELA DE PRODUTOS

CREATE TABLE produtos (
id_produto SERIAL PRIMARY KEY,
nome VARCHAR(150),
preco NUMERIC(10,2),
estoque INTEGER,
id_categoria INTEGER, 
FOREIGN KEY (id_categoria)
	REFERENCES categorias(id_categoria)
);

-- CRIAÇÃO DA TABELA DE PEDIDOS

CREATE TABLE pedidos (
id_pedido SERIAL PRIMARY KEY,
id_cliente INTEGER NOT NULL,
data_pedido DATE,
status VARCHAR (30),
valor_total NUMERIC (10,2),
FOREIGN KEY (id_cliente)
	REFERENCES clientes (id_cliente)
);


-- CRIAR TABELA TEMPORÁRIA (SERÁ EXCLUÍDA)

CREATE TABLE temporario (
id_temp SERIAL PRIMARY KEY,
nome VARCHAR(20)
);

-- APAGAR UMA TABELA (EXCLUIR)

DROP TABLE temporario;

-- ALTERAÇÃO DA ESTRUTURA DA TABELA DE PRODUTOS (CRIAR COLUNA)

SELECT * FROM produtos;

ALTER TABLE produtos 
ADD COLUMN marca VARCHAR(20);

-- ALTERAÇÃO DA ESTRUTURA DA TABELA DE PRODUTOS (EXCLUIR COLUNA)

ALTER TABLE produtos 
DROP COLUMN marca;

-- CRIAR TABELA DE ITENS DO PEDIDO

CREATE TABLE itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);





