-- Stored Procedure
-- Esqueleto da procedure

/* 
USE lojalg;

DELIMITER $$
CREATE PROCEDURE nome_da_procedure(IN variavelIN INT, OUT variavelOut VARCHAR(45))
BEGIN

END $$

DELIMITER ;
CALL nome_da_procedure(1, @variavelOUT);
SELECT @variavelOUT;
*/

-- 1. Procedure com IN
-- Crie uma procedure que receba o nome de um estado como parâmetro e exiba todos os clientes que residem nesse estado.
DELIMITER $$
CREATE PROCEDURE sp_residentesDeEstado(IN estadoInserido VARCHAR(45))
BEGIN

SELECT C.nome
FROM Clientes C 
WHERE C.estado = estadoInserido;

END $$

DELIMITER ;
CALL sp_residentesDeEstado('Rio de Janeiro');

-- 2. Procedure com OUT
-- Crie uma procedure que calcule o total de vendas realizadas até o momento e retorne esse valor.
DELIMITER $$
CREATE PROCEDURE sp_totalVendas(OUT totalVendasAtualmente INT)
BEGIN

SELECT COUNT(V.idVenda) INTO totalVendasAtualmente
FROM Vendas V;

END $$

DELIMITER ;
CALL sp_totalVendas(@totalVendasAtualmente);
SELECT @totalVendasAtualmente;

-- 3. Procedure com IN e OUT
-- Crie uma procedure que receba o ID de um cliente e retorne o total de vendas realizadas por ele.
DELIMITER $$
CREATE PROCEDURE sp_totalVendasPorCliente(IN idClienteInserido INT, OUT totalVendasCliente INT)
BEGIN
SELECT COUNT(V.idVenda) INTO totalVendasCliente
FROM Vendas V 
INNER JOIN Clientes C 
ON C.idCliente = V.fk_idCliente 
WHERE C.idCliente = idClienteInserido;

END $$

DELIMITER ;
CALL sp_totalVendasPorCliente(5, @totalVendasCliente);
SELECT @totalVendasCliente;

