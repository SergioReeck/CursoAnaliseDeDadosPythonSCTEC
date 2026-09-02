--INSERT INTO categorias (nome) VALUES ('Notebooks');

--INSERT INTO categorias (nome)
--VALUES 
--	('Monitores'), 
--	('Smartphones'), 
--	('Acessórios'), 
--	('Periféricos');

SELECT * FROM categorias

--UPDATE categorias SET nome = 'Smartphones' WHERE id_categoria = 2;
--UPDATE categorias SET nome = 'Periféricos' WHERE id_categoria = 3;
--UPDATE categorias SET nome = 'Monitores' WHERE id_categoria = 4;
--UPDATE categorias SET nome = 'Acessórios' WHERE id_categoria = 5;

SELECT * FROM clientes
--INSERT INTO clientes (nome, cidade, email)
--VALUES 
--	('Ana Souza', 'Blumenau', 'ana@email.com'),
--	('Bruno Lima', 'Pomerode', 'bruno@email.com'),
--	('Carla Mendes', 'Joinville', 'carla@email.com'),
--	('Diego Santos', 'Blumenau', 'diego@email.com'),
--	('Elisa Martins', 'Jaraguá do Sul', 'elisa@email.com'),
--	('Felipe Rocha', 'Itajaí', 'felipe@email.com'),
--	('Gabriela Alves', 'Brusque', 'gabriela@email.com'),
--	('Henrique Costa', 'Blumenau', 'henrique@email.com');

SELECT * FROM produtos
--INSERT INTO produtos (nome, preco, estoque, id_categoria)
--VALUES
--	('Notebook Lenovo IdeaPad', 3299.90, 15, 1),
--    ('Notebook Dell Inspiron', 4599.90, 8, 1),
--    ('MacBook Air M2', 7999.90, 5, 1),
--    ('iPhone 15', 4999.00, 12, 2),
--    ('Galaxy S24', 3999.00, 20, 2),
--    ('Motorola Edge 50', 2499.90, 17, 2),
--    ('Mouse Logitech MX', 399.90, 35, 3),
--    ('Teclado Mecânico Redragon', 289.90, 18, 3),
--    ('Headset HyperX', 349.90, 25, 3),
--    ('Monitor LG 24"', 899.90, 10, 4),
--    ('Monitor Samsung 27"', 1399.90, 6, 4),
--    ('Webcam Logitech C920', 499.90, 7, 5),
--    ('Hub USB-C', 159.90, 30, 5),
--    ('Suporte para Notebook', 119.90, 22, 5);

-- Inserir um registro incorretamente
--INSERT INTO produtos (nome, preco, estoque, id_categoria)
--VALUES
--	('Suporte para Notebook', 119.90, 22, 4);

-- Deletar um registro incorreto
--DELETE FROM produtos WHERE id_produto = 15;

SELECT * FROM pedidos;
--INSERT INTO pedidos (id_cliente, data_pedido, status, valor_total)
--VALUES
--	(1, '2026-08-01', 'Concluído', 3299.90),
--    (2, '2026-08-02', 'Concluído', 689.80),
--    (3, '2026-08-03', 'Enviado', 4999.00),
--    (1, '2026-08-05', 'Concluído', 899.90),
--    (4, '2026-08-06', 'Processando', 4599.90),
--    (5, '2026-08-07', 'Enviado', 799.80),
--    (6, '2026-08-08', 'Cancelado', 2499.90),
--    (7, '2026-08-10', 'Concluído', 1399.90);

-- Alteação de preco de um produto
SELECT * FROM produtos WHERE id_produto = 1;
--UPDATE produtos SET preco = 3499.90 WHERE id_produto = 1;

-- Deletar um produto
SELECT * FROM produtos WHERE id_produto = 14;
--DELETE FROM produtos  WHERE id_produto = 14;

SELECT * FROM produtos;
--INSERT INTO produtos (nome, preco, estoque, id_categoria, marca)
--VALUES 
--	('Monitor AOC 27', 1200, 5, 4, 'AOC')

--UPDATE produtos SET marca = 'Apple' WHERE id_produto = 4;

INSERT INTO itens_pedido 
    (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
    -- Pedido 1 = R$ 3.299,90
    (1, 1, 1, 3299.90),
    -- Pedido 2 = R$ 689,80
    (2, 7, 1, 399.90),
    (2, 8, 1, 289.90),
    -- Pedido 3 = R$ 4.999,00
    (3, 4, 1, 4999.00),
    -- Pedido 4 = R$ 899,90
    (4, 10, 1, 899.90),
    -- Pedido 5 = R$ 4.599,90
    (5, 2, 1, 4599.90),
    -- Pedido 6 = R$ 799,80
    (6, 7, 2, 399.90),
    -- Pedido 7 = R$ 2.499,90
    (7, 6, 1, 2499.90),
    -- Pedido 8 = R$ 1.399,90
    (8, 11, 1, 1399.90);

SELECT * FROM itens_pedido;

