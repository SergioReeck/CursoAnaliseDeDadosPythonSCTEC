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