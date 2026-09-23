-- AGREGAÇÕES

-- COUNT(CONTAGEM)

SELECT count(p.id_produto) AS contagem_produtos FROM produtos p;

SELECT p.id_categoria, c.nome AS categoria, count(p.id_produto ) AS contagem_produtos 
FROM produtos p
LEFT JOIN categorias c 
	ON p.id_categoria = c.id_categoria 
GROUP BY p.id_categoria, c.nome
ORDER BY c.nome;

-- AVG(MÉDIA)

SELECT * FROM produtos p;
SELECT avg(preco) AS media_preco FROM produtos p;

SELECT round(avg(preco),2) AS media_preco 
FROM produtos p
LEFT JOIN categorias c 
	ON p.id_categoria = c.id_categoria
GROUP BY c.nome; 

-- MIN/MAX(MÍNIMO E MÁXIMO)

SELECT 
	MAX(preco) AS valor_maximo,
	MIN(preco) AS valor_minimo
FROM produtos;


SELECT
	c.nome AS categotia,
	MAX(preco) AS valor_maximo,
	MIN(preco) AS valor_minimo
FROM produtos p
JOIN categorias c 
	ON p.id_categoria = c.id_categoria 
GROUP BY c.nome;

-- AGREGAÇÕES E AGRUPAMENTOS

SELECT
	c.nome AS categoria,
	'Maior' AS tipo,
	MAX(preco) AS preco
FROM produtos p
JOIN categorias c 
	ON p.id_categoria = c.id_categoria 
GROUP BY c.nome

UNION ALL

SELECT
	c.nome AS categoria,
	'Menor' AS tipo,
	MIN(preco) AS preco
FROM produtos p
JOIN categorias c 
	ON p.id_categoria = c.id_categoria 
GROUP BY c.nome

ORDER BY categoria; 

