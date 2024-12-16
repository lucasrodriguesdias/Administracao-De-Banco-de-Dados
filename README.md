# Projeto de Estudo de Administração de Banco de Dados - LojaLG

Este repositório contém o projeto de um banco de dados desenvolvido para fins de estudo em administração de banco de dados, com foco em SQL. O banco foi criado do zero e inclui a implementação de funções, views, stored procedures, triggers, índices e roles para realizar operações de gestão de dados de uma loja fictícia. O objetivo principal deste projeto é fornecer um ambiente de estudo prático para o gerenciamento e otimização de bancos de dados relacionais.

## Estrutura do Banco de Dados

O banco de dados simula uma loja que gerencia **produtos**, **clientes** e **vendas**, além de registrar os itens de cada venda. As tabelas principais são:

- **Produtos**: Contém informações sobre os produtos disponíveis na loja (idProduto, nome, preço de compra, preço de venda, quantidade).
- **Clientes**: Armazena dados dos clientes (idCliente, nome, idade, categoria, estado).
- **Vendas**: Registra as vendas realizadas, associando cada venda a um cliente (idVenda, dataVenda, totalVenda, statusPagamento).
- **Itens_Venda**: Registra os itens vendidos em cada venda (idItemVenda, fk_idVenda, fk_idProduto, quantidade, preco_unitario, preco_total).

## Funcionalidades Implementadas

### Funções SQL
Foram criadas várias funções para realizar operações no banco de dados, como:

- **fn_categoria_cliente**: Retorna a categoria de um cliente (bronze, prata, ouro).
- **fn_total_vendas_data**: Retorna o total de vendas realizadas em uma data específica.
- **fn_produtos_estoque_baixo**: Retorna a quantidade de produtos com estoque abaixo de 40 unidades.
- **fn_vendas_por_estado**: Retorna o valor total de vendas realizadas por clientes de um estado específico.
- **fn_produto_mais_vendido**: Retorna o nome do produto mais vendido.

### Procedures
Procedures foram criadas para realizar operações mais complexas, como:

- **sp_residentesDeEstado**: Exibe os clientes de um determinado estado.
- **sp_totalVendas**: Retorna o total de vendas realizadas até o momento.
- **sp_totalVendasPorCliente**: Retorna o total de vendas realizadas por um cliente específico.

### Índices
Índices foram criados para melhorar a performance de consultas:

- **clientes_estado**: Índice na tabela `Clientes` para otimizar buscas por estado.
- **itens_fks**: Índice composto na tabela `Itens_Venda` para otimizar buscas por venda e produto.
- **nome_preco_unico**: Índice único na tabela `Produtos` para garantir que combinações de nome e preço de compra sejam únicas.

### Roles e Permissões
Foram criadas **roles** para controlar o acesso e as permissões dos usuários no banco de dados:

- **GerenteVendas**: Permite que o usuário insira, atualize e visualize registros nas tabelas de vendas e itens de venda.
- **AnalistaEstoque**: Permite que o usuário visualize e atualize os produtos e registre itens de venda.
- **Auditor**: Permite que o usuário visualize todos os registros em todas as tabelas do banco.

### Triggers
Três triggers foram criadas para automatizar algumas ações no banco:

- **atualizaEstoque**: Atualiza o estoque automaticamente após uma venda.
- **estoqueInsuficiente**: Impede a venda de um produto se a quantidade solicitada for maior do que a disponível no estoque.
- **historicoPagamento**: Registra as alterações no status de pagamento das vendas em uma tabela de histórico.

## Exemplo de Uso

### Funções
Exemplo de como utilizar as funções criadas:

```sql
SELECT fn_categoria_cliente(2);  -- Retorna a categoria do cliente com ID 2
SELECT fn_total_vendas_data('2024-11-01');  -- Retorna o total de vendas realizadas em 01/11/2024
SELECT fn_produtos_estoque_baixo();  -- Retorna a quantidade de produtos com estoque abaixo de 40
SELECT fn_vendas_por_estado('São Paulo');  -- Retorna o total de vendas realizadas no estado de São Paulo
SELECT fn_produto_mais_vendido();  -- Retorna o produto mais vendido
```

### Stored Procedures
Exemplo de como utilizar as procedures criadas:

```sql
CALL sp_residentesDeEstado('Rio de Janeiro');  -- Exibe os clientes do estado Rio de Janeiro
CALL sp_totalVendas(@totalVendasAtualmente);  -- Retorna o total de vendas realizadas até o momento
CALL sp_totalVendasPorCliente(5, @totalVendasCliente);  -- Retorna o total de vendas realizadas pelo cliente com ID 5
```

### Índices
Exemplo de como visualizar os índices criados:

```sql
SHOW INDEX FROM ITENS_VENDA;
```

### Triggers
As triggers são automaticamente acionadas durante as operações de inserção ou atualização nas tabelas. Exemplos:

- **atualizaEstoque**: Acionado após a inserção de um item na tabela `Itens_Venda`, atualizando o estoque do produto.
- **estoqueInsuficiente**: Impede a inserção de um item em `Itens_Venda` se a quantidade solicitada for maior do que a disponível no estoque.
- **historicoPagamento**: Registra alterações no status de pagamento das vendas.


