-- FULL OUTER JOIN

SELECT
	c.nome AS categoria,
	p.nome AS produto
FROM produtos p 
FULL OUTER JOIN categorias c 
	ON c.id_categoria = p.id_categoria;

SELECT
	c.id_cliente,
	c.nome AS nome_cliente,
	c.cidade,
	p.id_pedido,
	p.id_cliente,
	p.status,
	p.valor_total
FROM clientes c 
FULL OUTER JOIN pedidos p 
	ON c.id_cliente = p.id_cliente;

-- CROSS JOIN

SELECT
	c.nome AS categoria,
	p.nome AS produto
FROM produtos p 
CROSS JOIN categorias c; 

-- CROSS JOIN COM CTE

WITH status AS (
	SELECT 'Concluído' AS status
	UNION ALL
	SELECT 'Enviado' AS status
	UNION ALL 
	SELECT 'Cancelado' AS status
)
SELECT 
	c.nome AS categoria,
	s.status
FROM categorias c 
CROSS JOIN status s; 



