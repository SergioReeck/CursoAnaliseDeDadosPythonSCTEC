WITH vendas_cliente AS (
	SELECT 
		id_cliente,
		sum(valor_total) AS total_gasto
	FROM pedidos
	GROUP BY id_cliente 
),
quantidade_pedidos AS (
	SELECT 
		id_cliente,
		count(*) AS qtd_pedidos
	FROM pedidos
	GROUP BY id_cliente 
)
SELECT 
	clientes.nome,
	vendas_cliente.total_gasto,
	quantidade_pedidos.qtd_pedidos
FROM clientes
LEFT JOIN vendas_cliente 
	ON clientes.id_cliente = vendas_cliente.id_cliente
LEFT JOIN quantidade_pedidos
	ON clientes.id_cliente = quantidade_pedidos.id_cliente 