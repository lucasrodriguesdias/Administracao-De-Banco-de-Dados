-- Trigger
-- Esqueleto da Trigger

/*
DELIMITER $$

CREATE TRIGGER nome
AFTER/BEFORE INSERT/DELETE/UPDATE ON tabela
FOR EACH ROW 
BEGIN
	NEW/OLD nos atributos que serão ou foram manipulados
END $$

DELIMITER ;
*/

-- 1. Trigger para Atualizar Estoque Após Venda
-- Crie uma trigger que, ao inserir um novo item na tabela ITENS_VENDA, subtraia a quantidade vendida do estoque 
-- correspondente na tabela PRODUTOS.
DELIMITER $$

CREATE TRIGGER atualizaEstoque
AFTER INSERT ON itens_venda
FOR EACH ROW 
BEGIN

UPDATE produtos P
SET P.quantidade = P.quantidade - NEW.quantidade
WHERE P.idProduto = NEW.fk_idProduto;

END $$

DELIMITER ;

-- Testar trigger
INSERT INTO vendas(dataVenda, totalVenda, fk_idCliente, statusPagamento)
VALUES ('2024-11-24', 50.00, 1, 'Pago');

INSERT INTO itens_venda (fk_idVenda, fk_idProduto, quantidade, preco_unitario, preco_total)
VALUES (22, 1, 5, 25.00, 125.00);

-- 2. Trigger para Impedir Venda com Estoque Insuficiente
-- Crie uma trigger que impeça a inserção de um item na tabela ITENS_VENDA se a quantidade solicitada
-- for maior do que o estoque disponível na tabela PRODUTOS.
DELIMITER $$
CREATE TRIGGER estoqueInsuficiente 
BEFORE INSERT ON itens_venda
FOR EACH ROW
BEGIN

DECLARE quantidadeProdutos INT;

SELECT P.quantidade INTO quantidadeProdutos
FROM Produtos P 
WHERE P.idProduto = NEW.fk_idProduto;

IF(quantidadeProdutos < NEW.quantidade) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente. Venda não pode ser realizada';
END IF;

END $$

DELIMITER ;

-- Testar a Trigger
INSERT INTO vendas(dataVenda, totalVenda, fk_idCliente, statusPagamento)
VALUES ('2024-11-25', 50.00, 1, 'Pago');

INSERT INTO itens_venda (fk_idVenda, fk_idProduto, quantidade, preco_unitario, preco_total)
VALUES (23, 1, 46, 25.00, 125.00);

-- 3. Trigger para Registrar Mudanças no Status de Pagamento
-- Crie uma trigger que, ao atualizar o campo statusPagamento na tabela VENDAS, registre a alteração 
-- em uma tabela de histórico (HISTORICO_PAGAMENTO), com:
-- ID da venda.
-- Status anterior.
-- Novo status.
-- Data e hora da mudança.
CREATE TABLE HISTORICO_PAGAMENTO (
	idHistorico INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fk_idVendaHistorico INT NOT NULL,
    statusAnterior VARCHAR(45)  NOT NULL,
    statusNovo VARCHAR(45) NOT NULL,
    dataHoraMudanca DATETIME NOT NULL,   
    FOREIGN KEY (fk_idVendaHistorico) REFERENCES vendas(idVenda)
);


DELIMITER $$
CREATE TRIGGER mudancaStatus
AFTER UPDATE ON vendas
FOR EACH ROW
BEGIN

INSERT INTO HISTORICO_PAGAMENTO (fk_idVendaHistorico, statusAnterior, statusNovo, dataHoraMudanca)
VALUES (NEW.idVenda, OLD.statusPagamento, NEW.statusPagamento, NOW());

END $$

DELIMITER ;

-- Testar a Trigger
UPDATE vendas 
SET statusPagamento = 'Pago'
WHERE idVenda = 2;

SELECT * FROM HISTORICO_PAGAMENTO;


