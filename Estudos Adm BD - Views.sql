-- Views
-- Esqueleto para as Views

/* 
USE 'database';
CREATE OR REPLACE VIEW nome da view AS 
SELECT ...;
SELECT * FROM nome da view;
*/

-- Visão para mostrar todos os clientes do Rio de Janeiro
USE lojalg;
CREATE OR REPLACE VIEW clientesCariocas AS 
SELECT C.nome FROM clientes C
WHERE C.estado = 'Rio de Janeiro';
SELECT * FROM clientesCariocas;

-- 6. View: vw_clientes_por_categoria
-- Lista os clientes agrupados por suas categorias (bronze, prata, ouro).
-- Colunas: categoria, nome_cliente, estado.
USE lojalg;
CREATE OR REPLACE VIEW vw_clientes_por_categoria AS 
SELECT C.nome, C.categoria, C.estado FROM clientes C 
ORDER BY C.categoria ASC;
SELECT * FROM vw_clientes_por_categoria;


-- 7. View: vw_produtos_mais_vendidos
-- Exibe os produtos mais vendidos, ordenados pela quantidade total vendida.
-- Colunas: nome_produto, quantidade_vendida.
USE lojalg;
CREATE OR REPLACE VIEW vw_produtos_mais_vendidos AS 
SELECT P.nome, SUM(IV.quantidade) AS 'Quantidade Vendida' FROM PRODUTOS P
INNER JOIN Itens_Venda IV 
ON P.idProduto = IV.fk_idProduto
GROUP BY P.nome
ORDER BY 'Quantidade Vendida' DESC;
SELECT * FROM vw_produtos_mais_vendidos;

-- 8. View: vw_valor_total_vendas_por_data
-- Mostra o valor total de vendas por data.
-- Colunas: data_venda, valor_total_vendas.
USE lojalg;
CREATE OR REPLACE VIEW vw_valor_total_vendas_por_data AS 
SELECT V.dataVenda, SUM(V.totalVenda) AS 'Total do Dia' FROM Vendas V 
GROUP BY V.dataVenda
ORDER BY V.dataVenda ASC;
SELECT * FROM vw_valor_total_vendas_por_data;

-- Testar a view com mais compras no mesmo dia
INSERT INTO VENDAS (dataVenda, totalVenda, fk_idCliente, statusPagamento)
VALUES 
('2024-11-01', 40.00, 1, 'Pago');

-- 9. View: vw_vendas_pendentes
-- Lista todas as vendas que ainda estão com o status de pagamento pendente.
-- Colunas: id_venda, data_venda, nome_cliente, total_venda.
USE lojalg;
CREATE OR REPLACE VIEW vw_vendas_pendentes AS 
SELECT V.idVenda, V.dataVenda, C.nome, V.totalVenda FROM clientes C 
INNER JOIN Vendas V 
ON C.idCliente = V.fk_idCliente
WHERE V.statusPagamento = 'Pendente'
ORDER BY C.nome ASC;
SELECT * FROM vw_vendas_pendentes;


-- 10. View: vw_lucro_por_produto
-- Calcula o lucro bruto por produto, considerando o preço de compra e o preço de venda.
-- Colunas: nome_produto, lucro_unitario, quantidade_vendida, lucro_total.
USE lojalg;
CREATE OR REPLACE VIEW vw_lucro_por_produto AS 
SELECT P.nome, (P.preco_venda - P.preco_compra) AS lucro_unitario, SUM(IV.quantidade) AS quantidade_vendida, (P.preco_venda - P.preco_compra) * SUM(IV.quantidade) AS lucro_total FROM Produtos P 
INNER JOIN itens_venda IV 
ON P.idProduto = IV.fk_idProduto
GROUP BY P.idProduto, P.nome, P.preco_venda, P.preco_compra
ORDER BY lucro_unitario;
SELECT * FROM vw_lucro_por_produto;
