SELECT 
	nome,
	preco
FROM produtos
WHERE preco > (
	SELECT avg(preco)
	FROM produtos
);

-- O script acima representa o resultado do script abaixo:

SELECT 
	nome,
	preco
FROM produtos
WHERE preco > 2342.63;

--

SELECT 
	nome,
	preco,
	(SELECT avg(preco) FROM produtos) AS preco_medio
FROM produtos;

--

SELECT 
	dados.id_cliente,
	dados.total_gasto
FROM (
	SELECT 
		id_cliente,
		sum(valor_total) AS total_gasto
	FROM pedidos
	WHERE id_cliente IN (3, 5, 4)
	GROUP BY id_cliente 
) AS dados;