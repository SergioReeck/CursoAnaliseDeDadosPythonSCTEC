-- Criação de base de dados: techstore
--CREATE DATABASE techstore;


-- Criação da tabela de Clientes
CREATE TABLE clientes (
	id_cliente SERIAL PRIMARY KEY,
	nome VARCHAR(100),
	cidade VARCHAR(50),
	email VARCHAR(80)
); 

-- Criação da tabela de Categorias
CREATE TABLE categorias (
	id_categoria SERIAL PRIMARY KEY,
	nome VARCHAR(20)
);

-- Criação da tabela de Produos
CREATE TABLE produtos (
	id_produto SERIAL PRIMARY KEY,
	nome VARCHAR(150),
	preco NUMERIC(10,2),
	estoque INTEGER,
	id_categoria INTEGER,
	FOREIGN KEY (id_categoria)
		REFERENCES categorias(id_categoria)
);

-- Criação da tabela de Pedidos
CREATE TABLE pedidos (
	id_pedido SERIAL PRIMARY KEY,
	id_cliente INTEGER NOT NULL,
	data_pedido DATE,
	status VARCHAR(30),
	valor_total NUMERIC(10,2),
	FOREIGN KEY (id_cliente)
		REFERENCES clientes(id_cliente) 
);



-- Criar tabela temporária (será excluída)
CREATE TABLE temporario (
	id_temp SERIAL PRIMARY KEY,
	nome VARCHAR(20)
);

-- Apagar uma tabela - excluir
DROP TABLE temporario;

SELECT * FROM produtos;
-- Alteração da estrutura da tabela de produtos (criar coluna)
ALTER TABLE produtos 
ADD COLUMN marca VARCHAR(20);

-- Alteração da estrutura da tabela de produtos (excluir coluna)
ALTER TABLE produtos 
DROP COLUMN marca;

-- Criar tabela de Itens do Pedido
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

