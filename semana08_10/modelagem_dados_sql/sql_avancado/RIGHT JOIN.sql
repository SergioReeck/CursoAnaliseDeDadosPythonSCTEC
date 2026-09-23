SELECT
	c.id_cliente,
	c.nome AS nome_cliente,
	c.cidade,
	p.id_pedido,
	p.id_cliente,
	p.status,
	p.valor_total
FROM clientes c 
RIGHT JOIN pedidos p 
	ON c.id_cliente = p.id_cliente;

SELECT
	c.nome AS categoria,
	p.nome AS produto
FROM produtos p 
RIGHT JOIN categorias c 
	ON c.id_categoria = p.id_categoria;

INSERT INTO categorias (nome) VALUES ('Carregadores')

SELECT * FROM categorias c;