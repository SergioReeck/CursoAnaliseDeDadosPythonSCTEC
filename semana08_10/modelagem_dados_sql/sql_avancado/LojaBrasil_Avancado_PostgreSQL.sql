-- ============================================================
-- LOJA BRASIL - BASE DIDÁTICA DE SQL AVANÇADO
-- PostgreSQL | Dados fictícios brasileiros
--
-- Objetivo: praticar DDL, DML, DQL e, na Semana 10,
-- JOINs, GROUP BY, agregações, DISTINCT, HAVING,
-- subconsultas, CTEs, funções de data/texto e Views.
-- ============================================================

-- ============================================================
-- 0. CRIAR BASE DE DADOS
-- ============================================================
CREATE DATABASE loja_brasil;

-- ============================================================
-- 1. LIMPEZA E CRIAÇÃO DOS SCHEMAS
-- ============================================================
DROP SCHEMA IF EXISTS financeiro CASCADE;
DROP SCHEMA IF EXISTS estoque CASCADE;
DROP SCHEMA IF EXISTS compras CASCADE;
DROP SCHEMA IF EXISTS producao CASCADE;
DROP SCHEMA IF EXISTS vendas CASCADE;
DROP SCHEMA IF EXISTS cadastro CASCADE;
DROP SCHEMA IF EXISTS rh CASCADE;
CREATE SCHEMA cadastro;
CREATE SCHEMA vendas;
CREATE SCHEMA compras;
CREATE SCHEMA estoque;
CREATE SCHEMA producao;
CREATE SCHEMA rh;
CREATE SCHEMA financeiro;

-- ============================================================
-- 2. DDL - TABELAS
-- ============================================================
CREATE TABLE cadastro.clientes (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE cadastro.categorias (
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE cadastro.marcas (
    id_marca INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE cadastro.produtos (
    id_produto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    id_categoria INTEGER NOT NULL REFERENCES cadastro.categorias(id_categoria),
    id_marca INTEGER NOT NULL REFERENCES cadastro.marcas(id_marca),
    preco_venda NUMERIC(10,2) NOT NULL CHECK (preco_venda > 0),
    estoque_minimo INTEGER NOT NULL DEFAULT 10 CHECK (estoque_minimo >= 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE cadastro.fornecedores (
    id_fornecedor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    cidade VARCHAR(80),
    estado CHAR(2),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE rh.departamentos (
    id_departamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE rh.cargos (
    id_cargo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    salario_minimo NUMERIC(10,2) NOT NULL,
    salario_maximo NUMERIC(10,2) NOT NULL,
    CHECK (salario_maximo >= salario_minimo)
);

CREATE TABLE rh.funcionarios (
    id_funcionario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    sobrenome VARCHAR(80) NOT NULL,
    id_departamento INTEGER NOT NULL REFERENCES rh.departamentos(id_departamento),
    id_cargo INTEGER NOT NULL REFERENCES rh.cargos(id_cargo),
    data_admissao DATE NOT NULL,
    salario NUMERIC(10,2) NOT NULL CHECK (salario > 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE vendas.pedidos (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES cadastro.clientes(id_cliente),
    id_funcionario INTEGER REFERENCES rh.funcionarios(id_funcionario),
    data_pedido DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado')
    ),
    valor_frete NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (valor_frete >= 0)
);

CREATE TABLE vendas.itens_pedido (
    id_item INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES vendas.pedidos(id_pedido),
    id_produto INTEGER NOT NULL REFERENCES cadastro.produtos(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    desconto NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (desconto BETWEEN 0 AND 100)
);

CREATE TABLE vendas.pagamentos (
    id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES vendas.pedidos(id_pedido),
    forma_pagamento VARCHAR(30) NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento DATE,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Pendente', 'Pago', 'Estornado')
    )
);

CREATE TABLE compras.pedidos_compra (
    id_pedido_compra INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_fornecedor INTEGER NOT NULL REFERENCES cadastro.fornecedores(id_fornecedor),
    id_funcionario INTEGER REFERENCES rh.funcionarios(id_funcionario),
    data_pedido DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Aberto', 'Recebido', 'Cancelado')
    )
);

CREATE TABLE compras.itens_pedido_compra (
    id_item_compra INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido_compra INTEGER NOT NULL REFERENCES compras.pedidos_compra(id_pedido_compra),
    id_produto INTEGER NOT NULL REFERENCES cadastro.produtos(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    custo_unitario NUMERIC(10,2) NOT NULL CHECK (custo_unitario > 0)
);

CREATE TABLE estoque.movimentacoes (
    id_movimentacao INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_produto INTEGER NOT NULL REFERENCES cadastro.produtos(id_produto),
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('Entrada', 'Saida')),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    data_movimentacao DATE NOT NULL,
    origem VARCHAR(50) NOT NULL
);

CREATE TABLE producao.ordens_producao (
    id_ordem INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_produto INTEGER NOT NULL REFERENCES cadastro.produtos(id_produto),
    quantidade_planejada INTEGER NOT NULL CHECK (quantidade_planejada > 0),
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Planejada', 'Em produção', 'Concluída', 'Cancelada')
    )
);

CREATE TABLE producao.etapas_producao (
    id_etapa INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_ordem INTEGER NOT NULL REFERENCES producao.ordens_producao(id_ordem),
    nome_etapa VARCHAR(80) NOT NULL,
    sequencia INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Pendente', 'Em andamento', 'Concluída')
    )
);

CREATE TABLE financeiro.contas_receber (
    id_conta_receber INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER REFERENCES vendas.pedidos(id_pedido),
    descricao VARCHAR(150) NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Aberta', 'Paga', 'Atrasada', 'Cancelada')
    )
);

CREATE TABLE financeiro.contas_pagar (
    id_conta_pagar INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_fornecedor INTEGER REFERENCES cadastro.fornecedores(id_fornecedor),
    descricao VARCHAR(150) NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('Aberta', 'Paga', 'Atrasada', 'Cancelada')
    )
);

-- ============================================================
-- 3. DML - CARGA DE DADOS
-- ============================================================
INSERT INTO cadastro.categorias (nome) VALUES
    ('Camisetas'),
    ('Calças'),
    ('Vestidos'),
    ('Jaquetas'),
    ('Calçados'),
    ('Acessórios');

INSERT INTO cadastro.marcas (nome) VALUES
    ('Viva Moda'),
    ('Estilo Brasil'),
    ('Urban'),
    ('Serra Sul'),
    ('Essencial'),
    ('Movimento');

INSERT INTO cadastro.clientes (nome, email, cidade, estado, data_cadastro) VALUES
    ('Ana Paula Martins', 'ana.martins@email.com', 'Blumenau', 'SC', '2025-01-05'),
    ('Bruno Henrique Souza', 'bruno.souza@email.com', 'Pomerode', 'SC', '2025-01-16'),
    ('Camila Rodrigues', 'camila.rodrigues@email.com', 'Joinville', 'SC', '2025-01-27'),
    ('Daniel Oliveira', 'daniel.oliveira@email.com', 'Itajaí', 'SC', '2025-02-07'),
    ('Eduarda Fernandes', 'eduarda.fernandes@email.com', 'Florianópolis', 'SC', '2025-02-18'),
    ('Felipe Almeida', 'felipe.almeida@email.com', 'Brusque', 'SC', '2025-03-01'),
    ('Gabriela Costa', 'gabriela.costa@email.com', 'Blumenau', 'SC', '2025-03-12'),
    ('Henrique Martins', 'henrique.martins@email.com', 'Jaraguá do Sul', 'SC', '2025-03-23'),
    ('Isabela Santos', 'isabela.santos@email.com', 'Rio do Sul', 'SC', '2025-04-03'),
    ('João Pedro Lima', 'joao.lima@email.com', 'Timbó', 'SC', '2025-04-14'),
    ('Karina Souza', 'karina.souza@email.com', 'Gaspar', 'SC', '2025-04-25'),
    ('Lucas Pereira', 'lucas.pereira@email.com', 'Indaial', 'SC', '2025-05-06'),
    ('Mariana Alves', 'mariana.alves@email.com', 'Blumenau', 'SC', '2025-05-17'),
    ('Natália Rocha', 'natalia.rocha@email.com', 'São José', 'SC', '2025-05-28'),
    ('Otávio Ribeiro', 'otavio.ribeiro@email.com', 'Chapecó', 'SC', '2025-06-08'),
    ('Patrícia Mendes', 'patricia.mendes@email.com', 'Blumenau', 'SC', '2025-06-19'),
    ('Rafael Gomes', 'rafael.gomes@email.com', 'Pomerode', 'SC', '2025-06-30'),
    ('Sabrina Teixeira', 'sabrina.teixeira@email.com', 'Itajaí', 'SC', '2025-07-11'),
    ('Thiago Nunes', 'thiago.nunes@email.com', 'Balneário Camboriú', 'SC', '2025-07-22'),
    ('Vanessa Cardoso', 'vanessa.cardoso@email.com', 'Brusque', 'SC', '2025-08-02');

INSERT INTO cadastro.fornecedores (razao_social, email, cidade, estado) VALUES
    ('Malharia Blumenau Ltda.', 'contato@malhariablumenau.com.br', 'Blumenau', 'SC'),
    ('Tecidos Vale do Itajaí Ltda.', 'vendas@tecidosvale.com.br', 'Gaspar', 'SC'),
    ('Calçados Sul Brasil Ltda.', 'comercial@calcadosul.com.br', 'São João Batista', 'SC'),
    ('Acessórios Catarinenses Ltda.', 'atendimento@acessoriossc.com.br', 'Brusque', 'SC'),
    ('Confecções Serra Azul Ltda.', 'vendas@serraazul.com.br', 'Rio do Sul', 'SC');

INSERT INTO cadastro.produtos (nome, id_categoria, id_marca, preco_venda, estoque_minimo) VALUES
    ('Camiseta Básica Algodão', 1, 1, 59.90, 20),
    ('Camiseta Polo Masculina', 1, 2, 89.90, 13),
    ('Camiseta Cropped Feminina', 1, 3, 69.90, 15),
    ('Calça Jeans Slim', 2, 1, 149.90, 11),
    ('Calça Sarja Masculina', 2, 2, 139.90, 10),
    ('Calça Mom Feminina', 2, 3, 159.90, 10),
    ('Vestido Midi Floral', 3, 4, 189.90, 10),
    ('Vestido Curto Casual', 3, 5, 129.90, 10),
    ('Jaqueta Jeans', 4, 1, 219.90, 10),
    ('Jaqueta Corta-Vento', 4, 6, 249.90, 10),
    ('Tênis Casual Branco', 5, 3, 199.90, 10),
    ('Tênis Esportivo', 5, 6, 279.90, 10),
    ('Cinto de Couro', 6, 4, 79.90, 11),
    ('Bolsa Transversal', 6, 5, 169.90, 10),
    ('Boné Casual', 6, 2, 49.90, 16),
    ('Carteira Masculina', 6, 4, 69.90, 12),
    ('Meia Esportiva', 6, 6, 29.90, 25),
    ('Cachecol Tricot', 6, 1, 54.90, 10);

INSERT INTO rh.departamentos (nome) VALUES
    ('Administração'),
    ('Comercial'),
    ('Financeiro'),
    ('Tecnologia'),
    ('Recursos Humanos'),
    ('Produção'),
    ('Logística');

INSERT INTO rh.cargos (nome, salario_minimo, salario_maximo) VALUES
    ('Analista Administrativo', 2800, 4200),
    ('Analista Comercial', 3200, 5200),
    ('Analista Financeiro', 3500, 5800),
    ('Analista de Dados', 5000, 8500),
    ('Analista de RH', 3300, 5600),
    ('Operador de Produção', 2200, 3400),
    ('Assistente de Logística', 2400, 3900),
    ('Supervisor de Produção', 4800, 7200);

INSERT INTO rh.funcionarios (nome, sobrenome, id_departamento, id_cargo, data_admissao, salario) VALUES
    ('Marcos', 'Silva', 2, 2, '2021-03-15', 4800),
    ('Juliana', 'Ferreira', 3, 3, '2022-05-10', 5100),
    ('Ricardo', 'Mendes', 4, 4, '2020-08-17', 6900),
    ('Aline', 'Costa', 5, 5, '2023-01-09', 4200),
    ('Carlos', 'Ramos', 6, 8, '2019-11-04', 6500),
    ('Beatriz', 'Oliveira', 6, 6, '2022-02-21', 3100),
    ('Diego', 'Souza', 7, 7, '2024-04-08', 3300),
    ('Fernanda', 'Alves', 1, 1, '2021-07-12', 3900),
    ('Gustavo', 'Pereira', 2, 2, '2023-06-19', 4100),
    ('Larissa', 'Martins', 3, 3, '2024-02-05', 3600),
    ('Mateus', 'Rocha', 6, 6, '2020-10-26', 2900),
    ('Renata', 'Cardoso', 4, 4, '2025-01-13', 5700),
    ('Samuel', 'Nunes', 7, 7, '2022-09-01', 3500),
    ('Tatiane', 'Gomes', 5, 5, '2021-12-06', 4500),
    ('Vinícius', 'Lima', 6, 8, '2018-05-21', 7100);

INSERT INTO vendas.pedidos (id_cliente, id_funcionario, data_pedido, status, valor_frete) VALUES
    (8, 4, '2025-02-10', 'Pendente', 9.90),
    (15, 7, '2025-02-19', 'Entregue', 14.90),
    (2, 10, '2025-02-28', 'Enviado', 19.90),
    (9, 13, '2025-03-09', 'Cancelado', 0),
    (16, 1, '2025-03-18', 'Entregue', 9.90),
    (3, 4, '2025-03-27', 'Entregue', 14.90),
    (10, 7, '2025-04-05', 'Pago', 19.90),
    (17, 10, '2025-04-14', 'Pendente', 0),
    (4, 13, '2025-04-23', 'Entregue', 9.90),
    (11, 1, '2025-05-02', 'Enviado', 14.90),
    (18, 4, '2025-05-11', 'Cancelado', 19.90),
    (5, 7, '2025-05-20', 'Entregue', 0),
    (12, 10, '2025-05-29', 'Entregue', 9.90),
    (19, 13, '2025-06-07', 'Pago', 14.90),
    (6, 1, '2025-06-16', 'Pendente', 19.90),
    (13, 4, '2025-06-25', 'Entregue', 0),
    (20, 7, '2025-07-04', 'Enviado', 9.90),
    (7, 10, '2025-07-13', 'Cancelado', 14.90),
    (14, 13, '2025-07-22', 'Entregue', 19.90),
    (1, 1, '2025-07-31', 'Entregue', 0),
    (8, 4, '2025-08-09', 'Pago', 9.90),
    (15, 7, '2025-08-18', 'Pendente', 14.90),
    (2, 10, '2025-08-27', 'Entregue', 19.90),
    (9, 13, '2025-09-05', 'Enviado', 0),
    (16, 1, '2025-09-14', 'Cancelado', 9.90),
    (3, 4, '2025-09-23', 'Entregue', 14.90),
    (10, 7, '2025-10-02', 'Entregue', 19.90),
    (17, 10, '2025-10-11', 'Pago', 0),
    (4, 13, '2025-10-20', 'Pendente', 9.90),
    (11, 1, '2025-10-29', 'Entregue', 14.90),
    (18, 4, '2025-11-07', 'Enviado', 19.90),
    (5, 7, '2025-11-16', 'Cancelado', 0),
    (12, 10, '2025-11-25', 'Entregue', 9.90),
    (19, 13, '2025-12-04', 'Entregue', 14.90),
    (6, 1, '2025-12-13', 'Pago', 19.90),
    (13, 4, '2025-12-22', 'Pendente', 0),
    (20, 7, '2025-02-04', 'Entregue', 9.90),
    (7, 10, '2025-02-13', 'Enviado', 14.90),
    (14, 13, '2025-02-22', 'Cancelado', 19.90),
    (1, 1, '2025-03-03', 'Entregue', 0),
    (8, 4, '2025-03-12', 'Entregue', 9.90),
    (15, 7, '2025-03-21', 'Pago', 14.90),
    (2, 10, '2025-03-30', 'Pendente', 19.90),
    (9, 13, '2025-04-08', 'Entregue', 0),
    (16, 1, '2025-04-17', 'Enviado', 9.90),
    (3, 4, '2025-04-26', 'Cancelado', 14.90),
    (10, 7, '2025-05-05', 'Entregue', 19.90),
    (17, 10, '2025-05-14', 'Entregue', 0),
    (4, 13, '2025-05-23', 'Pago', 9.90),
    (11, 1, '2025-06-01', 'Pendente', 14.90),
    (18, 4, '2025-06-10', 'Entregue', 19.90),
    (5, 7, '2025-06-19', 'Enviado', 0),
    (12, 10, '2025-06-28', 'Cancelado', 9.90),
    (19, 13, '2025-07-07', 'Entregue', 14.90),
    (6, 1, '2025-07-16', 'Entregue', 19.90),
    (13, 4, '2025-07-25', 'Pago', 0),
    (20, 7, '2025-08-03', 'Pendente', 9.90),
    (7, 10, '2025-08-12', 'Entregue', 14.90),
    (14, 13, '2025-08-21', 'Enviado', 19.90),
    (1, 1, '2025-08-30', 'Cancelado', 0);

INSERT INTO vendas.itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, desconto) VALUES
    (1, 6, 2, 159.90, 0),
    (1, 13, 3, 79.90, 5),
    (1, 2, 4, 89.90, 10),
    (2, 11, 3, 199.90, 5),
    (2, 18, 4, 54.90, 10),
    (2, 7, 1, 189.90, 0),
    (2, 14, 2, 169.90, 0),
    (3, 16, 4, 69.90, 10),
    (3, 5, 1, 139.90, 0),
    (4, 3, 1, 69.90, 0),
    (4, 10, 2, 249.90, 0),
    (4, 17, 3, 29.90, 5),
    (5, 8, 2, 129.90, 0),
    (5, 15, 3, 49.90, 5),
    (5, 4, 4, 149.90, 10),
    (5, 11, 1, 199.90, 0),
    (6, 13, 3, 79.90, 5),
    (6, 2, 4, 89.90, 10),
    (7, 18, 4, 54.90, 10),
    (7, 7, 1, 189.90, 0),
    (7, 14, 2, 169.90, 0),
    (8, 5, 1, 139.90, 0),
    (8, 12, 2, 279.90, 0),
    (8, 1, 3, 59.90, 5),
    (8, 8, 4, 129.90, 10),
    (9, 10, 2, 249.90, 0),
    (9, 17, 3, 29.90, 5),
    (10, 15, 3, 49.90, 5),
    (10, 4, 4, 149.90, 10),
    (10, 11, 1, 199.90, 0),
    (11, 2, 4, 89.90, 10),
    (11, 9, 1, 219.90, 0),
    (11, 16, 2, 69.90, 0),
    (11, 5, 3, 139.90, 5),
    (12, 7, 1, 189.90, 0),
    (12, 14, 2, 169.90, 0),
    (13, 12, 2, 279.90, 0),
    (13, 1, 3, 59.90, 5),
    (13, 8, 4, 129.90, 10),
    (14, 17, 3, 29.90, 5),
    (14, 6, 4, 159.90, 10),
    (14, 13, 1, 79.90, 0),
    (14, 2, 2, 89.90, 0),
    (15, 4, 4, 149.90, 10),
    (15, 11, 1, 199.90, 0),
    (16, 9, 1, 219.90, 0),
    (16, 16, 2, 69.90, 0),
    (16, 5, 3, 139.90, 5),
    (17, 14, 2, 169.90, 0),
    (17, 3, 3, 69.90, 5),
    (17, 10, 4, 249.90, 10),
    (17, 17, 1, 29.90, 0),
    (18, 1, 3, 59.90, 5),
    (18, 8, 4, 129.90, 10),
    (19, 6, 4, 159.90, 10),
    (19, 13, 1, 79.90, 0),
    (19, 2, 2, 89.90, 0),
    (20, 11, 1, 199.90, 0),
    (20, 18, 2, 54.90, 0),
    (20, 7, 3, 189.90, 5),
    (20, 14, 4, 169.90, 10),
    (21, 16, 2, 69.90, 0),
    (21, 5, 3, 139.90, 5),
    (22, 3, 3, 69.90, 5),
    (22, 10, 4, 249.90, 10),
    (22, 17, 1, 29.90, 0),
    (23, 8, 4, 129.90, 10),
    (23, 15, 1, 49.90, 0),
    (23, 4, 2, 149.90, 0),
    (23, 11, 3, 199.90, 5),
    (24, 13, 1, 79.90, 0),
    (24, 2, 2, 89.90, 0),
    (25, 18, 2, 54.90, 0),
    (25, 7, 3, 189.90, 5),
    (25, 14, 4, 169.90, 10),
    (26, 5, 3, 139.90, 5),
    (26, 12, 4, 279.90, 10),
    (26, 1, 1, 59.90, 0),
    (26, 8, 2, 129.90, 0),
    (27, 10, 4, 249.90, 10),
    (27, 17, 1, 29.90, 0),
    (28, 15, 1, 49.90, 0),
    (28, 4, 2, 149.90, 0),
    (28, 11, 3, 199.90, 5),
    (29, 2, 2, 89.90, 0),
    (29, 9, 3, 219.90, 5),
    (29, 16, 4, 69.90, 10),
    (29, 5, 1, 139.90, 0),
    (30, 7, 3, 189.90, 5),
    (30, 14, 4, 169.90, 10),
    (31, 12, 4, 279.90, 10),
    (31, 1, 1, 59.90, 0),
    (31, 8, 2, 129.90, 0),
    (32, 17, 1, 29.90, 0),
    (32, 6, 2, 159.90, 0),
    (32, 13, 3, 79.90, 5),
    (32, 2, 4, 89.90, 10),
    (33, 4, 2, 149.90, 0),
    (33, 11, 3, 199.90, 5),
    (34, 9, 3, 219.90, 5),
    (34, 16, 4, 69.90, 10),
    (34, 5, 1, 139.90, 0),
    (35, 14, 4, 169.90, 10),
    (35, 3, 1, 69.90, 0),
    (35, 10, 2, 249.90, 0),
    (35, 17, 3, 29.90, 5),
    (36, 1, 1, 59.90, 0),
    (36, 8, 2, 129.90, 0),
    (37, 6, 2, 159.90, 0),
    (37, 13, 3, 79.90, 5),
    (37, 2, 4, 89.90, 10),
    (38, 11, 3, 199.90, 5),
    (38, 18, 4, 54.90, 10),
    (38, 7, 1, 189.90, 0),
    (38, 14, 2, 169.90, 0),
    (39, 16, 4, 69.90, 10),
    (39, 5, 1, 139.90, 0),
    (40, 3, 1, 69.90, 0),
    (40, 10, 2, 249.90, 0),
    (40, 17, 3, 29.90, 5),
    (41, 8, 2, 129.90, 0),
    (41, 15, 3, 49.90, 5),
    (41, 4, 4, 149.90, 10),
    (41, 11, 1, 199.90, 0),
    (42, 13, 3, 79.90, 5),
    (42, 2, 4, 89.90, 10),
    (43, 18, 4, 54.90, 10),
    (43, 7, 1, 189.90, 0),
    (43, 14, 2, 169.90, 0),
    (44, 5, 1, 139.90, 0),
    (44, 12, 2, 279.90, 0),
    (44, 1, 3, 59.90, 5),
    (44, 8, 4, 129.90, 10),
    (45, 10, 2, 249.90, 0),
    (45, 17, 3, 29.90, 5),
    (46, 15, 3, 49.90, 5),
    (46, 4, 4, 149.90, 10),
    (46, 11, 1, 199.90, 0),
    (47, 2, 4, 89.90, 10),
    (47, 9, 1, 219.90, 0),
    (47, 16, 2, 69.90, 0),
    (47, 5, 3, 139.90, 5),
    (48, 7, 1, 189.90, 0),
    (48, 14, 2, 169.90, 0),
    (49, 12, 2, 279.90, 0),
    (49, 1, 3, 59.90, 5),
    (49, 8, 4, 129.90, 10),
    (50, 17, 3, 29.90, 5),
    (50, 6, 4, 159.90, 10),
    (50, 13, 1, 79.90, 0),
    (50, 2, 2, 89.90, 0),
    (51, 4, 4, 149.90, 10),
    (51, 11, 1, 199.90, 0),
    (52, 9, 1, 219.90, 0),
    (52, 16, 2, 69.90, 0),
    (52, 5, 3, 139.90, 5),
    (53, 14, 2, 169.90, 0),
    (53, 3, 3, 69.90, 5),
    (53, 10, 4, 249.90, 10),
    (53, 17, 1, 29.90, 0),
    (54, 1, 3, 59.90, 5),
    (54, 8, 4, 129.90, 10),
    (55, 6, 4, 159.90, 10),
    (55, 13, 1, 79.90, 0),
    (55, 2, 2, 89.90, 0),
    (56, 11, 1, 199.90, 0),
    (56, 18, 2, 54.90, 0),
    (56, 7, 3, 189.90, 5),
    (56, 14, 4, 169.90, 10),
    (57, 16, 2, 69.90, 0),
    (57, 5, 3, 139.90, 5),
    (58, 3, 3, 69.90, 5),
    (58, 10, 4, 249.90, 10),
    (58, 17, 1, 29.90, 0),
    (59, 8, 4, 129.90, 10),
    (59, 15, 1, 49.90, 0),
    (59, 4, 2, 149.90, 0),
    (59, 11, 3, 199.90, 5),
    (60, 13, 1, 79.90, 0),
    (60, 2, 2, 89.90, 0);

INSERT INTO vendas.pagamentos (id_pedido, forma_pagamento, valor, data_pagamento, status) VALUES
    (1, 'Cartão de crédito', 881.05, NULL, 'Pendente'),
    (2, 'Cartão de débito', 1311.96, '2025-02-20', 'Pago'),
    (3, 'Boleto', 411.44, '2025-03-01', 'Pago'),
    (4, 'Pix', 654.92, '2025-03-10', 'Estornado'),
    (5, 'Cartão de crédito', 1151.46, '2025-03-19', 'Pago'),
    (6, 'Cartão de débito', 566.25, '2025-03-28', 'Pago'),
    (7, 'Boleto', 747.24, '2025-04-06', 'Pago'),
    (8, 'Pix', 1338.06, NULL, 'Pendente'),
    (9, 'Cartão de crédito', 594.91, '2025-04-24', 'Pago'),
    (10, 'Cartão de débito', 896.65, '2025-05-03', 'Pago'),
    (11, 'Boleto', 1101.96, '2025-05-12', 'Estornado'),
    (12, 'Pix', 529.70, '2025-05-21', 'Pago'),
    (13, 'Cartão de crédito', 1208.06, '2025-05-30', 'Pago'),
    (14, 'Cartão de débito', 935.46, '2025-06-08', 'Pago'),
    (15, 'Boleto', 759.44, NULL, 'Pendente'),
    (16, 'Pix', 758.42, '2025-06-26', 'Pago'),
    (17, 'Cartão de crédito', 1478.46, '2025-07-05', 'Pago'),
    (18, 'Cartão de débito', 653.25, '2025-07-14', 'Estornado'),
    (19, 'Boleto', 855.24, '2025-07-23', 'Pago'),
    (20, 'Pix', 1462.55, '2025-08-01', 'Pago'),
    (21, 'Cartão de crédito', 548.42, '2025-08-10', 'Pago'),
    (22, 'Cartão de débito', 1143.66, NULL, 'Pendente'),
    (23, 'Boleto', 1406.96, '2025-08-28', 'Pago'),
    (24, 'Pix', 259.70, '2025-09-06', 'Pago'),
    (25, 'Cartão de crédito', 1272.56, '2025-09-15', 'Estornado'),
    (26, 'Cartão de débito', 1740.96, '2025-09-24', 'Pago'),
    (27, 'Boleto', 949.44, '2025-10-03', 'Pago'),
    (28, 'Pix', 919.41, '2025-10-12', 'Pago'),
    (29, 'Cartão de crédito', 1207.96, NULL, 'Pendente'),
    (30, 'Cartão de débito', 1167.76, '2025-10-30', 'Pago'),
    (31, 'Boleto', 1347.24, '2025-11-08', 'Pago'),
    (32, 'Pix', 901.06, '2025-11-17', 'Estornado'),
    (33, 'Cartão de crédito', 879.42, '2025-11-26', 'Pago'),
    (34, 'Cartão de débito', 1033.15, '2025-12-05', 'Pago'),
    (35, 'Boleto', 1286.45, '2025-12-14', 'Pago'),
    (36, 'Pix', 319.70, NULL, 'Pendente'),
    (37, 'Cartão de crédito', 881.05, '2025-02-05', 'Pago'),
    (38, 'Cartão de débito', 1311.96, '2025-02-14', 'Pago'),
    (39, 'Boleto', 411.44, '2025-02-23', 'Estornado'),
    (40, 'Pix', 654.92, '2025-03-04', 'Pago'),
    (41, 'Cartão de crédito', 1151.46, '2025-03-13', 'Pago'),
    (42, 'Cartão de débito', 566.25, '2025-03-22', 'Pago'),
    (43, 'Boleto', 747.24, NULL, 'Pendente'),
    (44, 'Pix', 1338.06, '2025-04-09', 'Pago'),
    (45, 'Cartão de crédito', 594.91, '2025-04-18', 'Pago'),
    (46, 'Cartão de débito', 896.65, '2025-04-27', 'Estornado'),
    (47, 'Boleto', 1101.96, '2025-05-06', 'Pago'),
    (48, 'Pix', 529.70, '2025-05-15', 'Pago'),
    (49, 'Cartão de crédito', 1208.06, '2025-05-24', 'Pago'),
    (50, 'Cartão de débito', 935.46, NULL, 'Pendente'),
    (51, 'Boleto', 759.44, '2025-06-11', 'Pago'),
    (52, 'Pix', 758.42, '2025-06-20', 'Pago'),
    (53, 'Cartão de crédito', 1478.46, '2025-06-29', 'Estornado'),
    (54, 'Cartão de débito', 653.25, '2025-07-08', 'Pago'),
    (55, 'Boleto', 855.24, '2025-07-17', 'Pago'),
    (56, 'Pix', 1462.55, '2025-07-26', 'Pago'),
    (57, 'Cartão de crédito', 548.42, NULL, 'Pendente'),
    (58, 'Cartão de débito', 1143.66, '2025-08-13', 'Pago'),
    (59, 'Boleto', 1406.96, '2025-08-22', 'Pago'),
    (60, 'Pix', 259.70, '2025-08-31', 'Estornado');

INSERT INTO compras.pedidos_compra (id_fornecedor, id_funcionario, data_pedido, status) VALUES
    (3, 5, '2025-02-06', 'Recebido'),
    (5, 9, '2025-02-23', 'Recebido'),
    (2, 13, '2025-03-12', 'Aberto'),
    (4, 2, '2025-03-29', 'Cancelado'),
    (1, 6, '2025-04-15', 'Recebido'),
    (3, 10, '2025-05-02', 'Recebido'),
    (5, 14, '2025-05-19', 'Recebido'),
    (2, 3, '2025-06-05', 'Aberto'),
    (4, 7, '2025-06-22', 'Cancelado'),
    (1, 11, '2025-07-09', 'Recebido'),
    (3, 15, '2025-07-26', 'Recebido'),
    (5, 4, '2025-08-12', 'Recebido'),
    (2, 8, '2025-08-29', 'Aberto'),
    (4, 12, '2025-09-15', 'Cancelado'),
    (1, 1, '2025-10-02', 'Recebido'),
    (3, 5, '2025-10-19', 'Recebido'),
    (5, 9, '2025-11-05', 'Recebido'),
    (2, 13, '2025-01-26', 'Aberto'),
    (4, 2, '2025-02-12', 'Cancelado'),
    (1, 6, '2025-03-01', 'Recebido');

INSERT INTO compras.itens_pedido_compra (id_pedido_compra, id_produto, quantidade, custo_unitario) VALUES
    (1, 4, 27, 89.50),
    (1, 9, 34, 100.22),
    (2, 7, 34, 97.47),
    (2, 12, 41, 140.32),
    (3, 10, 41, 154.79),
    (3, 15, 48, 30.22),
    (4, 13, 48, 52.35),
    (4, 18, 55, 25.80),
    (5, 16, 55, 38.24),
    (5, 3, 62, 31.93),
    (6, 1, 62, 29.97),
    (6, 6, 69, 90.54),
    (7, 4, 69, 68.37),
    (7, 9, 76, 109.01),
    (8, 7, 76, 113.84),
    (8, 12, 23, 161.04),
    (9, 10, 23, 125.13),
    (9, 15, 30, 29.22),
    (10, 13, 30, 50.83),
    (10, 18, 37, 24.79),
    (11, 16, 37, 44.41),
    (11, 3, 44, 42.68),
    (12, 1, 44, 31.64),
    (12, 6, 51, 77.67),
    (13, 4, 51, 100.46),
    (13, 9, 58, 115.98),
    (14, 7, 58, 89.51),
    (14, 12, 65, 132.18),
    (15, 10, 65, 161.17),
    (15, 15, 72, 29.38),
    (16, 13, 72, 50.79),
    (16, 18, 79, 33.92),
    (17, 16, 79, 40.08),
    (17, 3, 26, 47.10),
    (18, 1, 26, 32.17),
    (18, 6, 33, 92.26),
    (19, 4, 33, 96.05),
    (19, 9, 40, 130.24),
    (20, 7, 40, 123.09),
    (20, 12, 47, 163.12);

INSERT INTO estoque.movimentacoes (id_produto, tipo, quantidade, data_movimentacao, origem) VALUES
    (12, 'Entrada', 9, '2025-01-14', 'Compra'),
    (5, 'Entrada', 13, '2025-01-18', 'Compra'),
    (16, 'Saida', 17, '2025-01-22', 'Venda'),
    (9, 'Entrada', 21, '2025-01-26', 'Compra'),
    (2, 'Entrada', 25, '2025-01-30', 'Compra'),
    (13, 'Saida', 29, '2025-02-03', 'Venda'),
    (6, 'Entrada', 33, '2025-02-07', 'Compra'),
    (17, 'Entrada', 37, '2025-02-11', 'Compra'),
    (10, 'Saida', 41, '2025-02-15', 'Venda'),
    (3, 'Entrada', 5, '2025-02-19', 'Compra'),
    (14, 'Entrada', 9, '2025-02-23', 'Compra'),
    (7, 'Saida', 13, '2025-02-27', 'Venda'),
    (18, 'Entrada', 17, '2025-03-03', 'Compra'),
    (11, 'Entrada', 21, '2025-03-07', 'Compra'),
    (4, 'Saida', 25, '2025-03-11', 'Venda'),
    (15, 'Entrada', 29, '2025-03-15', 'Compra'),
    (8, 'Entrada', 33, '2025-03-19', 'Compra'),
    (1, 'Saida', 37, '2025-03-23', 'Venda'),
    (12, 'Entrada', 41, '2025-03-27', 'Compra'),
    (5, 'Entrada', 5, '2025-03-31', 'Compra'),
    (16, 'Saida', 9, '2025-04-04', 'Venda'),
    (9, 'Entrada', 13, '2025-04-08', 'Compra'),
    (2, 'Entrada', 17, '2025-04-12', 'Compra'),
    (13, 'Saida', 21, '2025-04-16', 'Venda'),
    (6, 'Entrada', 25, '2025-04-20', 'Compra'),
    (17, 'Entrada', 29, '2025-04-24', 'Compra'),
    (10, 'Saida', 33, '2025-04-28', 'Venda'),
    (3, 'Entrada', 37, '2025-05-02', 'Compra'),
    (14, 'Entrada', 41, '2025-05-06', 'Compra'),
    (7, 'Saida', 5, '2025-05-10', 'Venda'),
    (18, 'Entrada', 9, '2025-05-14', 'Compra'),
    (11, 'Entrada', 13, '2025-05-18', 'Compra'),
    (4, 'Saida', 17, '2025-05-22', 'Venda'),
    (15, 'Entrada', 21, '2025-05-26', 'Compra'),
    (8, 'Entrada', 25, '2025-05-30', 'Compra'),
    (1, 'Saida', 29, '2025-06-03', 'Venda'),
    (12, 'Entrada', 33, '2025-06-07', 'Compra'),
    (5, 'Entrada', 37, '2025-06-11', 'Compra'),
    (16, 'Saida', 41, '2025-06-15', 'Venda'),
    (9, 'Entrada', 5, '2025-06-19', 'Compra'),
    (2, 'Entrada', 9, '2025-06-23', 'Compra'),
    (13, 'Saida', 13, '2025-06-27', 'Venda'),
    (6, 'Entrada', 17, '2025-07-01', 'Compra'),
    (17, 'Entrada', 21, '2025-07-05', 'Compra'),
    (10, 'Saida', 25, '2025-07-09', 'Venda'),
    (3, 'Entrada', 29, '2025-07-13', 'Compra'),
    (14, 'Entrada', 33, '2025-07-17', 'Compra'),
    (7, 'Saida', 37, '2025-07-21', 'Venda'),
    (18, 'Entrada', 41, '2025-07-25', 'Compra'),
    (11, 'Entrada', 5, '2025-07-29', 'Compra'),
    (4, 'Saida', 9, '2025-08-02', 'Venda'),
    (15, 'Entrada', 13, '2025-08-06', 'Compra'),
    (8, 'Entrada', 17, '2025-08-10', 'Compra'),
    (1, 'Saida', 21, '2025-08-14', 'Venda'),
    (12, 'Entrada', 25, '2025-08-18', 'Compra'),
    (5, 'Entrada', 29, '2025-08-22', 'Compra'),
    (16, 'Saida', 33, '2025-08-26', 'Venda'),
    (9, 'Entrada', 37, '2025-08-30', 'Compra'),
    (2, 'Entrada', 41, '2025-09-03', 'Compra'),
    (13, 'Saida', 5, '2025-09-07', 'Venda'),
    (6, 'Entrada', 9, '2025-09-11', 'Compra'),
    (17, 'Entrada', 13, '2025-09-15', 'Compra'),
    (10, 'Saida', 17, '2025-09-19', 'Venda'),
    (3, 'Entrada', 21, '2025-09-23', 'Compra'),
    (14, 'Entrada', 25, '2025-09-27', 'Compra'),
    (7, 'Saida', 29, '2025-10-01', 'Venda'),
    (18, 'Entrada', 33, '2025-10-05', 'Compra'),
    (11, 'Entrada', 37, '2025-10-09', 'Compra'),
    (4, 'Saida', 41, '2025-10-13', 'Venda'),
    (15, 'Entrada', 5, '2025-10-17', 'Compra'),
    (8, 'Entrada', 9, '2025-10-21', 'Compra'),
    (1, 'Saida', 13, '2025-10-25', 'Venda'),
    (12, 'Entrada', 17, '2025-10-29', 'Compra'),
    (5, 'Entrada', 21, '2025-11-02', 'Compra'),
    (16, 'Saida', 25, '2025-11-06', 'Venda'),
    (9, 'Entrada', 29, '2025-11-10', 'Compra'),
    (2, 'Entrada', 33, '2025-11-14', 'Compra'),
    (13, 'Saida', 37, '2025-11-18', 'Venda'),
    (6, 'Entrada', 41, '2025-11-22', 'Compra'),
    (17, 'Entrada', 5, '2025-11-26', 'Compra'),
    (10, 'Saida', 9, '2025-11-30', 'Venda'),
    (3, 'Entrada', 13, '2025-12-04', 'Compra'),
    (14, 'Entrada', 17, '2025-12-08', 'Compra'),
    (7, 'Saida', 21, '2025-12-12', 'Venda'),
    (18, 'Entrada', 25, '2025-12-16', 'Compra'),
    (11, 'Entrada', 29, '2025-12-20', 'Compra'),
    (4, 'Saida', 33, '2025-12-24', 'Venda'),
    (15, 'Entrada', 37, '2025-01-12', 'Compra'),
    (8, 'Entrada', 41, '2025-01-16', 'Compra'),
    (1, 'Saida', 5, '2025-01-20', 'Venda');

INSERT INTO producao.ordens_producao (id_produto, quantidade_planejada, data_inicio, data_fim, status) VALUES
    (3, 41, '2025-03-14', '2025-03-20', 'Concluída'),
    (5, 52, '2025-03-27', NULL, 'Em produção'),
    (7, 63, '2025-04-09', NULL, 'Planejada'),
    (9, 74, '2025-04-22', '2025-05-01', 'Concluída'),
    (1, 85, '2025-05-05', '2025-05-15', 'Concluída'),
    (3, 96, '2025-05-18', NULL, 'Em produção'),
    (5, 107, '2025-05-31', NULL, 'Planejada'),
    (7, 118, '2025-06-13', '2025-06-20', 'Concluída'),
    (9, 129, '2025-06-26', '2025-07-04', 'Concluída'),
    (1, 40, '2025-07-09', NULL, 'Em produção'),
    (3, 51, '2025-07-22', NULL, 'Planejada'),
    (5, 62, '2025-08-04', '2025-08-09', 'Concluída'),
    (7, 73, '2025-08-17', '2025-08-23', 'Concluída'),
    (9, 84, '2025-08-30', NULL, 'Em produção'),
    (1, 95, '2025-09-12', NULL, 'Planejada'),
    (3, 106, '2025-09-25', '2025-10-04', 'Concluída'),
    (5, 117, '2025-10-08', '2025-10-18', 'Concluída'),
    (7, 128, '2025-10-21', NULL, 'Em produção'),
    (9, 39, '2025-11-03', NULL, 'Planejada'),
    (1, 50, '2025-03-11', '2025-03-18', 'Concluída');

INSERT INTO producao.etapas_producao (id_ordem, nome_etapa, sequencia, status) VALUES
    (1, 'Corte', 1, 'Concluída'),
    (1, 'Costura', 2, 'Concluída'),
    (1, 'Acabamento', 3, 'Em andamento'),
    (1, 'Inspeção', 4, 'Pendente'),
    (1, 'Embalagem', 5, 'Pendente'),
    (2, 'Corte', 1, 'Concluída'),
    (2, 'Costura', 2, 'Concluída'),
    (2, 'Acabamento', 3, 'Concluída'),
    (2, 'Inspeção', 4, 'Em andamento'),
    (2, 'Embalagem', 5, 'Pendente'),
    (3, 'Corte', 1, 'Concluída'),
    (3, 'Costura', 2, 'Concluída'),
    (3, 'Acabamento', 3, 'Concluída'),
    (3, 'Inspeção', 4, 'Concluída'),
    (3, 'Embalagem', 5, 'Em andamento'),
    (4, 'Corte', 1, 'Concluída'),
    (4, 'Costura', 2, 'Concluída'),
    (4, 'Acabamento', 3, 'Concluída'),
    (4, 'Inspeção', 4, 'Concluída'),
    (4, 'Embalagem', 5, 'Concluída'),
    (5, 'Corte', 1, 'Concluída'),
    (5, 'Costura', 2, 'Em andamento'),
    (5, 'Acabamento', 3, 'Pendente'),
    (5, 'Inspeção', 4, 'Pendente'),
    (5, 'Embalagem', 5, 'Pendente'),
    (6, 'Corte', 1, 'Concluída'),
    (6, 'Costura', 2, 'Concluída'),
    (6, 'Acabamento', 3, 'Em andamento'),
    (6, 'Inspeção', 4, 'Pendente'),
    (6, 'Embalagem', 5, 'Pendente'),
    (7, 'Corte', 1, 'Concluída'),
    (7, 'Costura', 2, 'Concluída'),
    (7, 'Acabamento', 3, 'Concluída'),
    (7, 'Inspeção', 4, 'Em andamento'),
    (7, 'Embalagem', 5, 'Pendente'),
    (8, 'Corte', 1, 'Concluída'),
    (8, 'Costura', 2, 'Concluída'),
    (8, 'Acabamento', 3, 'Concluída'),
    (8, 'Inspeção', 4, 'Concluída'),
    (8, 'Embalagem', 5, 'Em andamento'),
    (9, 'Corte', 1, 'Concluída'),
    (9, 'Costura', 2, 'Concluída'),
    (9, 'Acabamento', 3, 'Concluída'),
    (9, 'Inspeção', 4, 'Concluída'),
    (9, 'Embalagem', 5, 'Concluída'),
    (10, 'Corte', 1, 'Concluída'),
    (10, 'Costura', 2, 'Em andamento'),
    (10, 'Acabamento', 3, 'Pendente'),
    (10, 'Inspeção', 4, 'Pendente'),
    (10, 'Embalagem', 5, 'Pendente'),
    (11, 'Corte', 1, 'Concluída'),
    (11, 'Costura', 2, 'Concluída'),
    (11, 'Acabamento', 3, 'Em andamento'),
    (11, 'Inspeção', 4, 'Pendente'),
    (11, 'Embalagem', 5, 'Pendente'),
    (12, 'Corte', 1, 'Concluída'),
    (12, 'Costura', 2, 'Concluída'),
    (12, 'Acabamento', 3, 'Concluída'),
    (12, 'Inspeção', 4, 'Em andamento'),
    (12, 'Embalagem', 5, 'Pendente'),
    (13, 'Corte', 1, 'Concluída'),
    (13, 'Costura', 2, 'Concluída'),
    (13, 'Acabamento', 3, 'Concluída'),
    (13, 'Inspeção', 4, 'Concluída'),
    (13, 'Embalagem', 5, 'Em andamento'),
    (14, 'Corte', 1, 'Concluída'),
    (14, 'Costura', 2, 'Concluída'),
    (14, 'Acabamento', 3, 'Concluída'),
    (14, 'Inspeção', 4, 'Concluída'),
    (14, 'Embalagem', 5, 'Concluída'),
    (15, 'Corte', 1, 'Concluída'),
    (15, 'Costura', 2, 'Em andamento'),
    (15, 'Acabamento', 3, 'Pendente'),
    (15, 'Inspeção', 4, 'Pendente'),
    (15, 'Embalagem', 5, 'Pendente'),
    (16, 'Corte', 1, 'Concluída'),
    (16, 'Costura', 2, 'Concluída'),
    (16, 'Acabamento', 3, 'Em andamento'),
    (16, 'Inspeção', 4, 'Pendente'),
    (16, 'Embalagem', 5, 'Pendente'),
    (17, 'Corte', 1, 'Concluída'),
    (17, 'Costura', 2, 'Concluída'),
    (17, 'Acabamento', 3, 'Concluída'),
    (17, 'Inspeção', 4, 'Em andamento'),
    (17, 'Embalagem', 5, 'Pendente'),
    (18, 'Corte', 1, 'Concluída'),
    (18, 'Costura', 2, 'Concluída'),
    (18, 'Acabamento', 3, 'Concluída'),
    (18, 'Inspeção', 4, 'Concluída'),
    (18, 'Embalagem', 5, 'Em andamento'),
    (19, 'Corte', 1, 'Concluída'),
    (19, 'Costura', 2, 'Concluída'),
    (19, 'Acabamento', 3, 'Concluída'),
    (19, 'Inspeção', 4, 'Concluída'),
    (19, 'Embalagem', 5, 'Concluída'),
    (20, 'Corte', 1, 'Concluída'),
    (20, 'Costura', 2, 'Em andamento'),
    (20, 'Acabamento', 3, 'Pendente'),
    (20, 'Inspeção', 4, 'Pendente'),
    (20, 'Embalagem', 5, 'Pendente');

INSERT INTO financeiro.contas_receber (id_pedido, descricao, valor, data_vencimento, data_pagamento, status) VALUES
    (1, 'Venda referente ao pedido 1', 881.05, '2025-03-12', '2025-03-09', 'Paga'),
    (2, 'Venda referente ao pedido 2', 1311.96, '2025-03-21', NULL, 'Aberta'),
    (3, 'Venda referente ao pedido 3', 411.44, '2025-03-30', NULL, 'Atrasada'),
    (5, 'Venda referente ao pedido 5', 1151.46, '2025-04-17', '2025-04-15', 'Paga'),
    (6, 'Venda referente ao pedido 6', 566.25, '2025-04-26', NULL, 'Aberta'),
    (7, 'Venda referente ao pedido 7', 747.24, '2025-05-05', NULL, 'Atrasada'),
    (8, 'Venda referente ao pedido 8', 1338.06, '2025-05-14', '2025-05-09', 'Paga'),
    (9, 'Venda referente ao pedido 9', 594.91, '2025-05-23', '2025-05-17', 'Paga'),
    (10, 'Venda referente ao pedido 10', 896.65, '2025-06-01', NULL, 'Aberta'),
    (12, 'Venda referente ao pedido 12', 529.70, '2025-06-19', '2025-06-15', 'Paga'),
    (13, 'Venda referente ao pedido 13', 1208.06, '2025-06-28', '2025-06-23', 'Paga'),
    (14, 'Venda referente ao pedido 14', 935.46, '2025-07-07', NULL, 'Aberta'),
    (15, 'Venda referente ao pedido 15', 759.44, '2025-07-16', NULL, 'Atrasada'),
    (16, 'Venda referente ao pedido 16', 758.42, '2025-07-25', '2025-07-22', 'Paga'),
    (17, 'Venda referente ao pedido 17', 1478.46, '2025-08-03', '2025-07-30', 'Paga'),
    (19, 'Venda referente ao pedido 19', 855.24, '2025-08-21', NULL, 'Atrasada'),
    (20, 'Venda referente ao pedido 20', 1462.55, '2025-08-30', '2025-08-28', 'Paga'),
    (21, 'Venda referente ao pedido 21', 548.42, '2025-09-08', '2025-09-05', 'Paga'),
    (22, 'Venda referente ao pedido 22', 1143.66, '2025-09-17', NULL, 'Aberta'),
    (23, 'Venda referente ao pedido 23', 1406.96, '2025-09-26', NULL, 'Atrasada'),
    (24, 'Venda referente ao pedido 24', 259.70, '2025-10-05', '2025-09-29', 'Paga'),
    (26, 'Venda referente ao pedido 26', 1740.96, '2025-10-23', NULL, 'Aberta'),
    (27, 'Venda referente ao pedido 27', 949.44, '2025-11-01', NULL, 'Atrasada'),
    (28, 'Venda referente ao pedido 28', 919.41, '2025-11-10', '2025-11-05', 'Paga'),
    (29, 'Venda referente ao pedido 29', 1207.96, '2025-11-19', '2025-11-13', 'Paga'),
    (30, 'Venda referente ao pedido 30', 1167.76, '2025-11-28', NULL, 'Aberta'),
    (31, 'Venda referente ao pedido 31', 1347.24, '2025-12-07', NULL, 'Atrasada'),
    (33, 'Venda referente ao pedido 33', 879.42, '2025-12-25', '2025-12-20', 'Paga'),
    (34, 'Venda referente ao pedido 34', 1033.15, '2026-01-03', NULL, 'Aberta'),
    (35, 'Venda referente ao pedido 35', 1286.45, '2026-01-12', NULL, 'Atrasada'),
    (36, 'Venda referente ao pedido 36', 319.70, '2026-01-21', '2026-01-18', 'Paga'),
    (37, 'Venda referente ao pedido 37', 881.05, '2025-03-06', '2025-03-02', 'Paga'),
    (38, 'Venda referente ao pedido 38', 1311.96, '2025-03-15', NULL, 'Aberta'),
    (40, 'Venda referente ao pedido 40', 654.92, '2025-04-02', '2025-03-31', 'Paga');

INSERT INTO financeiro.contas_pagar (id_fornecedor, descricao, valor, data_vencimento, data_pagamento, status) VALUES
    (4, 'Compra de materiais - fornecedor 4', 621.30, '2025-02-18', '2025-02-19', 'Paga'),
    (2, 'Compra de materiais - fornecedor 2', 742.60, '2025-03-03', NULL, 'Aberta'),
    (5, 'Compra de materiais - fornecedor 5', 863.90, '2025-03-16', NULL, 'Atrasada'),
    (3, 'Compra de materiais - fornecedor 3', 985.20, '2025-03-29', '2025-03-29', 'Paga'),
    (1, 'Compra de materiais - fornecedor 1', 1106.50, '2025-04-11', '2025-04-12', 'Paga'),
    (4, 'Compra de materiais - fornecedor 4', 1227.80, '2025-04-24', NULL, 'Aberta'),
    (2, 'Compra de materiais - fornecedor 2', 1349.10, '2025-05-07', NULL, 'Atrasada'),
    (5, 'Compra de materiais - fornecedor 5', 1470.40, '2025-05-20', '2025-05-20', 'Paga'),
    (3, 'Compra de materiais - fornecedor 3', 1591.70, '2025-06-02', '2025-06-03', 'Paga'),
    (1, 'Compra de materiais - fornecedor 1', 1713.00, '2025-06-15', NULL, 'Aberta'),
    (4, 'Compra de materiais - fornecedor 4', 1834.30, '2025-06-28', NULL, 'Atrasada'),
    (2, 'Compra de materiais - fornecedor 2', 1955.60, '2025-07-11', '2025-07-11', 'Paga'),
    (5, 'Compra de materiais - fornecedor 5', 2076.90, '2025-07-24', '2025-07-25', 'Paga'),
    (3, 'Compra de materiais - fornecedor 3', 2198.20, '2025-08-06', NULL, 'Aberta'),
    (1, 'Compra de materiais - fornecedor 1', 2319.50, '2025-08-19', NULL, 'Atrasada'),
    (4, 'Compra de materiais - fornecedor 4', 2440.80, '2025-09-01', '2025-09-01', 'Paga'),
    (2, 'Compra de materiais - fornecedor 2', 2562.10, '2025-09-14', '2025-09-15', 'Paga'),
    (5, 'Compra de materiais - fornecedor 5', 2683.40, '2025-09-27', NULL, 'Aberta'),
    (3, 'Compra de materiais - fornecedor 3', 2804.70, '2025-10-10', NULL, 'Atrasada'),
    (1, 'Compra de materiais - fornecedor 1', 2926.00, '2025-10-23', '2025-10-23', 'Paga'),
    (4, 'Compra de materiais - fornecedor 4', 3047.30, '2025-11-05', '2025-11-06', 'Paga'),
    (2, 'Compra de materiais - fornecedor 2', 3168.60, '2025-11-18', NULL, 'Aberta'),
    (5, 'Compra de materiais - fornecedor 5', 3289.90, '2025-12-01', NULL, 'Atrasada'),
    (3, 'Compra de materiais - fornecedor 3', 3411.20, '2025-12-14', '2025-12-14', 'Paga'),
    (1, 'Compra de materiais - fornecedor 1', 532.50, '2025-02-10', '2025-02-11', 'Paga');

-- ============================================================
-- 4. CONSULTAS DE REVISÃO - SEMANA 9
-- ============================================================
-- SELECT * FROM cadastro.clientes;
-- SELECT nome, cidade FROM cadastro.clientes;
-- SELECT * FROM cadastro.produtos WHERE preco_venda > 150;
-- SELECT * FROM vendas.pedidos ORDER BY data_pedido DESC;
-- UPDATE cadastro.produtos SET preco_venda = preco_venda * 1.05 WHERE id_categoria = 1;
-- DELETE FROM cadastro.clientes WHERE id_cliente = 20;

-- ============================================================
-- 5. CONSULTAS-GUIA - SEMANA 10
-- ============================================================
-- INNER JOIN: cliente + pedido
-- SELECT c.nome, p.id_pedido, p.data_pedido, p.status
-- FROM cadastro.clientes c
-- INNER JOIN vendas.pedidos p
--     ON c.id_cliente = p.id_cliente;

-- LEFT JOIN: todos os clientes, mesmo sem pedidos
-- SELECT c.nome, p.id_pedido
-- FROM cadastro.clientes c
-- LEFT JOIN vendas.pedidos p
--     ON c.id_cliente = p.id_cliente;

-- JOIN de várias tabelas
-- SELECT
--     p.id_pedido,
--     c.nome AS cliente,
--     pr.nome AS produto,
--     i.quantidade,
--     i.preco_unitario
-- FROM vendas.pedidos p
-- JOIN cadastro.clientes c ON c.id_cliente = p.id_cliente
-- JOIN vendas.itens_pedido i ON i.id_pedido = p.id_pedido
-- JOIN cadastro.produtos pr ON pr.id_produto = i.id_produto;

-- GROUP BY + SUM
-- SELECT
--     pr.nome,
--     SUM(i.quantidade) AS unidades_vendidas
-- FROM vendas.itens_pedido i
-- JOIN cadastro.produtos pr ON pr.id_produto = i.id_produto
-- GROUP BY pr.nome
-- ORDER BY unidades_vendidas DESC;

-- GROUP BY + COUNT + HAVING
-- SELECT
--     c.cidade,
--     COUNT(p.id_pedido) AS quantidade_pedidos
-- FROM cadastro.clientes c
-- LEFT JOIN vendas.pedidos p ON p.id_cliente = c.id_cliente
-- GROUP BY c.cidade
-- HAVING COUNT(p.id_pedido) >= 3
-- ORDER BY quantidade_pedidos DESC;

-- DISTINCT
-- SELECT DISTINCT cidade
-- FROM cadastro.clientes
-- ORDER BY cidade;

-- Subconsulta: produtos acima do preço médio
-- SELECT nome, preco_venda
-- FROM cadastro.produtos
-- WHERE preco_venda > (
--     SELECT AVG(preco_venda)
--     FROM cadastro.produtos
-- )
-- ORDER BY preco_venda DESC;

-- Subconsulta: clientes que já fizeram pedidos
-- SELECT nome
-- FROM cadastro.clientes
-- WHERE id_cliente IN (
--     SELECT id_cliente
--     FROM vendas.pedidos
-- );

-- CTE: faturamento por cliente
-- WITH faturamento AS (
--     SELECT
--         p.id_cliente,
--         SUM(i.quantidade * i.preco_unitario *
--             (1 - i.desconto / 100)) AS total
--     FROM vendas.pedidos p
--     JOIN vendas.itens_pedido i ON i.id_pedido = p.id_pedido
--     WHERE p.status <> 'Cancelado'
--     GROUP BY p.id_cliente
-- )
-- SELECT c.nome, f.total
-- FROM faturamento f
-- JOIN cadastro.clientes c ON c.id_cliente = f.id_cliente
-- ORDER BY f.total DESC;

-- DATE_TRUNC: faturamento mensal
-- SELECT
--     DATE_TRUNC('month', p.data_pedido)::date AS mes,
--     SUM(i.quantidade * i.preco_unitario *
--         (1 - i.desconto / 100)) AS faturamento
-- FROM vendas.pedidos p
-- JOIN vendas.itens_pedido i ON i.id_pedido = p.id_pedido
-- WHERE p.status <> 'Cancelado'
-- GROUP BY DATE_TRUNC('month', p.data_pedido)
-- ORDER BY mes;

-- CONCAT: nome completo do funcionário
-- SELECT CONCAT(nome, ' ', sobrenome) AS funcionario
-- FROM rh.funcionarios;

-- SUBSTRING
-- SELECT nome, SUBSTRING(nome FROM 1 FOR 10) AS trecho
-- FROM cadastro.produtos;
-- Ou SUBSTRING(nome, 1, 10)

-- VIEW: consulta detalhada de vendas
-- CREATE VIEW vendas.vw_vendas_detalhadas AS
-- SELECT
--     p.id_pedido,
--     p.data_pedido,
--     c.nome AS cliente,
--     c.cidade,
--     pr.nome AS produto,
--     cat.nome AS categoria,
--     i.quantidade,
--     i.preco_unitario,
--     i.desconto,
--     ROUND(
--         (i.quantidade * i.preco_unitario * (1 - i.desconto / 100))::numeric,
--         2
--     ) AS valor_item
-- FROM vendas.pedidos p
-- JOIN cadastro.clientes c ON c.id_cliente = p.id_cliente
-- JOIN vendas.itens_pedido i ON i.id_pedido = p.id_pedido
-- JOIN cadastro.produtos pr ON pr.id_produto = i.id_produto
-- JOIN cadastro.categorias cat ON cat.id_categoria = pr.id_categoria;

-- Consultando a View
-- SELECT *
-- FROM vendas.vw_vendas_detalhadas
-- ORDER BY data_pedido DESC;

-- ============================================================
-- 6. DESAFIOS
-- ============================================================
-- 1. Liste todos os clientes e a quantidade de pedidos de cada um.
-- 2. Mostre os 10 produtos mais vendidos em quantidade.
-- 3. Descubra quais cidades possuem mais pedidos.
-- 4. Mostre o faturamento por cidade.
-- 5. Encontre os produtos cujo preço é maior que a média.
-- 6. Mostre os clientes que fizeram pelo menos 3 pedidos.
-- 7. Mostre o faturamento de cada mês de 2025 usando DATE_TRUNC.
-- 8. Descubra o mês com maior faturamento usando uma subconsulta ou CTE.
-- 9. Liste produtos que nunca aparecem em itens de pedido.
-- 10. Crie uma CTE com o faturamento por produto e mostre somente os produtos acima de R$ 5.000,00.
-- 11. Crie uma VIEW com pedido, data, cliente, cidade, produto, categoria, quantidade e valor do item.
-- 12. Crie uma VIEW com resumo de faturamento por cliente.

-- ============================================================
-- 7. MAPA DO BANCO
-- ============================================================
-- cadastro    -> clientes, produtos, categorias, marcas, fornecedores
-- vendas      -> pedidos, itens_pedido, pagamentos
-- compras     -> pedidos_compra, itens_pedido_compra
-- estoque     -> movimentacoes
-- producao    -> ordens_producao, etapas_producao
-- rh          -> funcionarios, cargos, departamentos
-- financeiro  -> contas_receber, contas_pagar
-- ============================================================
