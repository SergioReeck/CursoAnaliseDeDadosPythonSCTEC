-- SUBSELECT(SUBCONSULTA)

SELECT dados.categoria,
	'Maior'	AS tipo,
	max(dados.preco)
FROM 
	(
	SELECT
		p.id_categoria,
		p.preco,
		c.nome AS categoria
	FROM produtos p
	JOIN categorias c
		ON p.id_categoria = c.id_categoria
	) AS dados
GROUP BY dados.categoria, tipo 

UNION ALL

SELECT dados.categoria,
	'Menor' AS tipo,
	MIN(dados.preco)
FROM 
	(
	SELECT
		p.id_categoria,
		p.preco,
		c.nome AS categoria
	FROM produtos p
	JOIN categorias c
		ON p.id_categoria = c.id_categoria
	) AS dados
GROUP BY dados.categoria, tipo 

ORDER BY categoria, tipo;

-- AGREGAÇÃO COM SUM(SOMA)

SELECT 
	c.nome AS clientes,
	sum(p.valor_total) AS valor
FROM clientes c 
JOIN pedidos p 
	ON c.id_cliente = p.id_cliente 
GROUP BY c.nome; 

-- DISTINCT

SELECT DISTINCT c.nome 
FROM produtos p 
JOIN categorias c 
	ON p.id_categoria = c.id_categoria 


		