-- USANDO LEFT JOIN COM AS TABELAS DE CLIENTES E PEDIDOS

SELECT
	c.id_cliente,
	c.nome AS nome_cliente,
	c.cidade,
	p.id_pedido,
	p.id_cliente,
	p.status,
	p.valor_total
FROM clientes c 
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente; 

-- USANDO LEFT JOIN COM AS TABELAS DE CLIENTES E PEDIDOS COM FILTRO NULL

SELECT
	c.id_cliente,
	c.nome AS nome_cliente,
	c.cidade,
	p.id_pedido,
	p.id_cliente,
	p.status,
	p.valor_total
FROM clientes c 
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL;

