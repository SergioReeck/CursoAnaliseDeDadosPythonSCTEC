-- Selecionar todas as colunas da tabela de produtos.
SELECT * FROM produtos;

-- Selecionar colunas específicas.
SELECT nome, preco FROM produtos;
SELECT estoque, preco, nome FROM produtos;

-- Selecionar colunas e filtrar resultados.
SELECT nome, preco, estoque FROM produtos WHERE preco > 500;
SELECT nome, preco, estoque FROM produtos WHERE preco = 4999.00;
SELECT nome, preco, estoque FROM produtos WHERE nome = 'Galaxy S24';
SELECT nome, preco, estoque FROM produtos WHERE estoque <> 10;

-- Selecionar colunas com filtros e ordenação dos resultados.
SELECT id_produto, nome, preco, estoque 
FROM produtos 
WHERE estoque >= 15 
ORDER BY estoque ASC;

SELECT id_produto, nome, preco, estoque 
FROM produtos 
WHERE estoque >= 15 
ORDER BY estoque DESC;

SELECT id_produto, nome, preco, estoque 
FROM produtos 
WHERE estoque >= 15 
ORDER BY nome ASC;

-- Selecionar dados com operadores lógicos.
SELECT * FROM produtos WHERE preco > 500 AND estoque > 15;
SELECT * FROM produtos WHERE preco > 500 OR estoque > 15;
SELECT * FROM produtos WHERE NOT estoque = 6;


-- Consulta com JOIN
SELECT
    pedidos.id_pedido,
    clientes.nome AS cliente,
    produtos.nome AS produto,
    itens_pedido.quantidade,
    itens_pedido.preco_unitario
FROM pedidos
JOIN clientes
    ON pedidos.id_cliente = clientes.id_cliente
JOIN itens_pedido
    ON pedidos.id_pedido = itens_pedido.id_pedido
JOIN produtos
    ON itens_pedido.id_produto = produtos.id_produto;


