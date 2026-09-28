-- CRIAÇÃO DE VIEW

CREATE VIEW public.vw_pedidos_clientes AS 
SELECT 
	c.nome AS cliente,
	p.id_pedido,
	p.data_pedido,
	p.status,
	f.nome AS funcinario
FROM 
cadastro.clientes c
JOIN vendas.pedidos p
	ON c.id_cliente = p.id_cliente
JOIN rh.funcionarios f
	ON f.id_funcionario = p.id_funcionario;
	
SELECT * FROM public.vw_pedidos_clientes;

CREATE OR REPLACE VIEW public.vw_pedidos_clientes AS
SELECT 
	c.nome AS cliente,
	c.cidade AS cidade_cliente,
	p.id_pedido,
	p.data_pedido,
	p.status,
	f.nome AS funcinario
FROM 
cadastro.clientes c
JOIN vendas.pedidos p
	ON c.id_cliente = p.id_cliente
JOIN rh.funcionarios f
	ON f.id_funcionario = p.id_funcionario;

DROP VIEW public.vw_pedidos_clientes;

	
	