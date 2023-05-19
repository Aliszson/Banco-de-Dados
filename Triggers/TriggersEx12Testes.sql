-- Questão 3

-- Realiza uma operação de atualização na tabela EX2_PRODUTO
UPDATE EX2_PRODUTO SET quantidade = 20 WHERE codproduto = 1;

-- Verifique se o registro de log correspondente foi inserido na tabela EX2_LOG
SELECT * FROM EX2_LOG;

-- Questão 4

-- Atualiza a quantidade de um produto para uma quantidade disponível em estoque
UPDATE EX2_PRODUTO SET quantidade = 5 WHERE codproduto = 1;

-- Insere um item de pedido com quantidade disponível em estoque
INSERT INTO EX2_ITEMPEDIDO (codpedido, numeroitem, valorunitario, quantidade, codproduto)
VALUES (1, 3, 25.50, 1, 1);

-- Atualiza a quantidade de um produto para uma quantidade indisponível em estoque
UPDATE EX2_PRODUTO SET quantidade = 0 WHERE codproduto = 1;

-- Insere um item de pedido com quantidade indisponível em estoque
INSERT INTO EX2_ITEMPEDIDO (codpedido, numeroitem, valorunitario, quantidade, codproduto)
VALUES (4, 5, 10.90, 5, 1);

-- Verifica os registros na tabela EX2_LOG
SELECT * FROM EX2_LOG;

-- Questão 5

-- Teste do TRIGGER
-- Atualize a quantidade de estoque de um produto existente na tabela EX2_PRODUTO
UPDATE EX2_PRODUTO
SET quantidade = (
    SELECT quantidade * 0.5 -- Defina a nova quantidade de estoque como 50% da quantidade atual
    FROM EX2_PRODUTO
    WHERE codproduto = 1 -- Defina o código do produto aqui
)
WHERE codproduto = 1; -- Defina o código do produto aqui

-- Verifique as requisições de compra geradas
SELECT *
FROM EX2_REQUISICAO_COMPRA;

-- Questão 6

-- Remover a tabela EX2_LOG se já existir
DROP TABLE IF EXISTS EX2_LOG;

-- Corrigir a sequência EX2_LOG_SEQ
ALTER SEQUENCE EX2_LOG_SEQ RESTART WITH 1;

-- Criar a tabela EX2_LOG com o valor padrão da sequência para o campo codlog
CREATE TABLE EX2_LOG(
    codlog int DEFAULT NEXTVAL('EX2_LOG_SEQ') NOT NULL,
    data date,
    descricao varchar(255),
    CONSTRAINT pk2_ex2_log PRIMARY KEY (codlog)
);

-- Teste do TRIGGER
-- Remova um item pedido existente na tabela EX2_ITEMPEDIDO
DELETE FROM EX2_ITEMPEDIDO
WHERE codpedido = 4 -- Defina o código do pedido
    AND numeroitem = 1; -- Defina o número do item

-- Verifique os registros de log gerados
SELECT *
FROM EX2_LOG;

-- Questão 8

-- Tente inserir um valor unitário negativo
INSERT INTO EX2_ITEMPEDIDO (codpedido, numeroitem, valorunitario, quantidade, codproduto)
VALUES (4, 5, -10.50, 2, 3);

-- Questão 10

SELECT *
FROM EX2_ITEMPEDIDO
ORDER BY codpedido, numeroitem;

-- Inserir itens de pedido
INSERT INTO EX2_ITEMPEDIDO (codpedido, valorunitario, quantidade, codproduto)
VALUES (1, 10.00, 2, 1);

INSERT INTO EX2_ITEMPEDIDO (codpedido, valorunitario, quantidade, codproduto)
VALUES (1, 15.00, 3, 2);

INSERT INTO EX2_ITEMPEDIDO (codpedido, valorunitario, quantidade, codproduto)
VALUES (2, 20.00, 1, 1);

SELECT *
FROM EX2_ITEMPEDIDO
ORDER BY codpedido, numeroitem;

-- Questão 11

INSERT INTO EX2_ITEMPEDIDO (codpedido, numeroitem, valorunitario, quantidade, codproduto)
VALUES (1, 3, 10.00, -2, 1);

-- Questão 12

INSERT INTO EX2_CLIENTE (codcliente, nome, datanascimento, cpf)
VALUES (8, 'Maria Silva', '1990-01-01', '12345678901');

SELECT codcliente, nome, datanascimento, cpf
FROM EX2_CLIENTE;

