SELECT * FROM vendas;

SELECT produto, quantidade, valor_unitario FROM vendas;

SELECT DISTINCT produto, quantidade, valor_unitario FROM vendas WHERE valor_unitario >= 500 ORDER BY valor_unitario  DESC;

SELECT produto AS prod_venda, max(valor_total) AS maior_valor FROM vendas;

SELECT produto, sum(valor_total) AS valor_total FROM vendas GROUP BY produto;

SELECT produto, sum(valor_total) AS valor_total FROM vendas WHERE produto ='Monitor' GROUP BY produto;

-- A query abaixo seleciona dois produtos
SELECT produto, sum(valor_total) AS valor_total FROM vendas WHERE produto IN ('Monitor', 'Mouse')  GROUP BY produto;

