-- ROLE

-- Exercício 1: Role para Gerente de Vendas
-- Crie uma role chamada GerenteVendas que conceda as seguintes permissões:
    -- Inserir, atualizar e visualizar registros na tabela VENDAS.
    -- Inserir e visualizar registros na tabela ITENS_VENDA.
    -- Visualizar registros nas tabelas PRODUTOS e CLIENTES.
    
CREATE ROLE 'GerenteVendas'@'%';
GRANT INSERT, UPDATE, SELECT ON lojalg.vendas TO 'GerenteVendas'@'%';
GRANT INSERT, SELECT ON lojalg.itens_venda TO 'GerenteVendas'@'%';
GRANT SELECT ON lojalg.produtos TO 'GerenteVendas'@'%';
GRANT SELECT ON lojalg.clientes TO 'GerenteVendas'@'%';
SHOW GRANTS FOR 'GerenteVendas'@'%';
SELECT * FROM mysql.user;

-- Após criar a role, atribua-a a um usuário chamado geraldo.

CREATE USER 'geraldo'@'%' IDENTIFIED BY '123456';
GRANT 'GerenteVendas'@'%' TO 'geraldo'@'%';
SET DEFAULT ROLE 'GerenteVendas'@'%' TO 'geraldo'@'%';
SHOW GRANTS FOR 'geraldo'@'%';

REVOKE 'GerenteVendas'@'%' FROM 'geraldo'@'%';

-------------------------------------------------------------------------------


-- Exercício 2: Role para Analista de Estoque
-- Crie uma role chamada AnalistaEstoque com as seguintes permissões:
    -- Visualizar e atualizar registros na tabela PRODUTOS.
    -- Inserir registros na tabela ITENS_VENDA.
    -- Visualizar registros na tabela VENDAS.
    
CREATE ROLE 'AnalistaEstoque'@'localhost';
GRANT SELECT, UPDATE ON lojalg.produtos TO 'AnalistaEstoque'@'localhost';
GRANT INSERT ON lojalg.itens_venda TO 'AnalistaEstoque'@'localhost';
GRANT SELECT ON lojalg.vendas TO 'AnalistaEstoque'@'localhost';
SHOW GRANTS FOR 'AnalistaEstoque'@'localhost';
    
-- Atribua essa role a um usuário chamado jefferson.
CREATE USER 'jefferson'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
GRANT 'AnalistaEstoque'@'localhost' TO 'jefferson'@'localhost';
SET DEFAULT ROLE 'AnalistaEstoque'@'localhost' TO 'jefferson'@'localhost';
SHOW GRANTS FOR 'jefferson'@'localhost';

-------------------------------------------------------------------------------


-- Exercício 3: Role para Auditor
-- Crie uma role chamada Auditor que tenha apenas permissões de leitura:
    -- Visualizar todos os registros de todas as tabelas do banco de dados.
    
CREATE ROLE Auditor;
GRANT ALL ON lojalg.* TO Auditor;
SHOW GRANTS FOR Auditor;

-- Atribua essa role a um usuário chamado antonio.
CREATE USER 'antonio' IDENTIFIED BY '123456';
GRANT Auditor TO 'antonio';
SET DEFAULT ROLE Auditor TO 'antonio';
SHOW GRANTS FOR 'antonio';

