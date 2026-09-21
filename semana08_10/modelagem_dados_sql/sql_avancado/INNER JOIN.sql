-- USANDO JOIN COM TABELA DE PEDIDOS E CLIENTES

SELECT c.nome AS nome_cliente, 
       c.cidade AS cidade_cliente, 
	   p.data_pedido, 
	   p.status, 
	   p.valor_total 
FROM pedidos AS p
JOIN clientes AS c 
	 ON p.id_cliente = c.id_cliente;

-- USANDO JOIN COM TABELAS DE PEDIDOS, ITENS PEDIDOS, PRODUTOS E CATEGORIAS

SELECT 
	p.id_pedido,
	p.data_pedido,
	ip.id_item,
	ip.id_produto,
	pr.nome AS produto,
	pr.id_categoria,
	c.nome AS categoria,
	ip.quantidade,
	ip.preco_unitario 
FROM pedidos AS p
JOIN itens_pedido AS ip 
	ON p.id_pedido = ip.id_pedido
JOIN produtos AS pr
	ON pr.id_produto = ip.id_produto
JOIN categorias AS c
	ON	pr.id_categoria = c.id_categoria;
