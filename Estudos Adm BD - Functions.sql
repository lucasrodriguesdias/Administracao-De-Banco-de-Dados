-- Function
-- Esqueleto para as funções
/*
USE lojalg;

DELIMITER $$
CREATE FUNCTION nome da funcao(variavel_parametro INT)
RETURNS INT DETERMINISTIC
BEGIN

RETURN variavel_retorno;
END $$

DELIMITER ;
SELECT nome da funcao (valor_parametro);
*/

-- 6. Função: fn_categoria_cliente
-- Crie uma função que receba o ID de um cliente e retorne sua categoria (bronze, prata ou ouro).
-- Exemplo de Uso: SELECT fn_categoria_cliente(2);
DELIMITER $$
CREATE FUNCTION fn_categoria_cliente(idClienteInserido INT)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN
DECLARE categoriaCliente VARCHAR(45);

SELECT C.categoria INTO categoriaCliente 
FROM Clientes C 
WHERE C.idCliente = idClienteInserido;

RETURN categoriaCliente;
END $$
DELIMITER ;

SELECT fn_categoria_cliente(2);

-- 7. Função: fn_total_vendas_data
-- Crie uma função que receba uma data como parâmetro e retorne o valor total de vendas realizadas nesse dia.
-- Exemplo de Uso: SELECT fn_total_vendas_data('2024-11-01');
DELIMITER $$
CREATE FUNCTION fn_total_vendas_data(dataInserida DATE)
RETURNS INT DETERMINISTIC
BEGIN
DECLARE totalVendasResultado INT;

SET totalVendasResultado = (SELECT COUNT(V.idVenda) FROM Vendas V
							WHERE V.dataVenda = dataInserida);

RETURN totalVendasResultado;
END $$

DELIMITER ;
SELECT fn_total_vendas_data('2024-11-01');

-- 8. Função: fn_produtos_estoque_baixo
-- Crie uma função que retorne o numero de produtos com quantidade em estoque menor que 40.
-- Exemplo de Uso: SELECT fn_produtos_estoque_baixo();
DELIMITER $$
CREATE FUNCTION fn_produtos_estoque_baixo()
RETURNS INT DETERMINISTIC 
BEGIN
DECLARE ProdutosEmBaixa INT;

SELECT COUNT(P.idProduto) INTO ProdutosEmBaixa 
FROM Produtos P 
WHERE P.quantidade < 40;

RETURN ProdutosEmBaixa;
END $$

DELIMITER ;
SELECT fn_produtos_estoque_baixo();

-- 9. Função: fn_vendas_por_estado
-- Crie uma função que receba o nome de um estado e retorne o valor total de vendas realizadas para clientes desse estado.
-- Exemplo de Uso: SELECT fn_vendas_por_estado('São Paulo');
DELIMITER $$
CREATE FUNCTION fn_vendas_por_estado(estadoInserido VARCHAR(45))
RETURNS DOUBLE DETERMINISTIC 
BEGIN
DECLARE valorVendasPorEstado DOUBLE;

SET valorVendasPorEstado = (SELECT SUM(V.totalVenda) FROM Vendas V 
							INNER JOIN Clientes C 
                            ON C.idCliente = V.fk_idCliente
                            WHERE C.estado = estadoInserido);
RETURN valorVendasPorEstado;
END $$

DELIMITER ;
SELECT fn_vendas_por_estado('São Paulo');

-- 10. Função: fn_produto_mais_vendido
-- Crie uma função que retorne o nome do produto mais vendido até agora.
-- Exemplo de Uso:SELECT fn_produto_mais_vendido();
DELIMITER $$
CREATE FUNCTION fn_produto_mais_vendido()
RETURNS VARCHAR(45) DETERMINISTIC 
BEGIN
DECLARE quantidadeProdutoMaisVendido VARCHAR(45);

SET quantidadeProdutoMaisVendido = (SELECT P.nome FROM Produtos P
									INNER JOIN itens_venda IV
                                    ON P.idProduto = IV.fk_idProduto
                                    GROUP BY P.idProduto
                                    ORDER BY SUM(IV.quantidade) DESC
                                    LIMIT 1
									);
RETURN quantidadeProdutoMaisVendido;
END $$ 

DELIMITER ;
SELECT fn_produto_mais_vendido();
