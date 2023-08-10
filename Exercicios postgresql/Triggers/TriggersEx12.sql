-- Questão 3

CREATE OR REPLACE FUNCTION trg_atualizar_produto()
RETURNS TRIGGER AS $$
DECLARE
    v_data TIMESTAMP := NOW();
    v_descricao VARCHAR(255);
BEGIN
    -- Montar a descrição do log com os detalhes da atualização
    v_descricao := 'Produto atualizado - Código: ' || VELH.codproduto || ', Descrição Antiga: ' || VELH.descricao ||
                   ', NOV Descrição: ' || NOV.descricao || ', Quantidade Antiga: ' || VELH.quantidade ||
                   ', NOV Quantidade: ' || NOV.quantidade;

    -- Inserir o registro de log na tabela EX2_LOG com o valor da sequência EX2_LOG_SEQ
    INSERT INTO EX2_LOG (codlog, data, descricao)
    VALUES (NEXTVAL('EX2_LOG_SEQ'), v_data, v_descricao);

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_produto
AFTER UPDATE ON EX2_PRODUTO
FOR EACH ROW
EXECUTE FUNCTION trg_atualizar_produto();

-- Questão 4

CREATE OR REPLACE FUNCTION trg_estoque_insuficiente()
RETURNS TRIGGER AS $$
DECLARE
    v_codlog INTEGER;
    v_descricao TEXT;
BEGIN
    -- Verifica se a quantidade do item de pedido é maior que a quantidade em estoque
    IF NOV.quantidade > (
        SELECT quantidade FROM EX2_PRODUTO WHERE codproduto = NOV.codproduto
    ) THEN
        -- Gera o código do log
        SELECT nextval('EX2_LOG_SEQ') INTO v_codlog;
        -- Define a descrição do log
        v_descricao := 'Item do pedido sem estoque - Código do Pedido: ' || NOV.codpedido || ', Número do Item: ' || NOV.numeroitem;
        -- Insere o registro na tabela de logs
        INSERT INTO EX2_LOG (codlog, data, descricao)
        VALUES (v_codlog, CURRENT_DATE, v_descricao);
    END IF;
    -- Retorna o registro do item de pedido
    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger na tabela EX2_ITEMPEDIDO
CREATE TRIGGER trg_estoque_insuficiente
AFTER INSERT ON EX2_ITEMPEDIDO
FOR EACH ROW
EXECUTE FUNCTION trg_estoque_insuficiente();

-- Questão 5 

-- Criação do TRIGGER
CREATE OR REPLACE FUNCTION trg_estoque_requisicao_compra()
RETURNS TRIGGER AS $$
DECLARE
    v_codrequisicaocompra INTEGER;
    v_codproduto INTEGER;
    v_data DATE;
    v_quantidade INTEGER;
BEGIN
    -- Verifica se o estoque atingiu 50% da venda mensal
    SELECT codproduto, CURRENT_DATE - INTERVAL '1 month', COUNT(*)
    INTO v_codproduto, v_data, v_quantidade
    FROM EX2_ITEMPEDIDO
    JOIN EX2_PEDIDO ON EX2_PEDIDO.codpedido = EX2_ITEMPEDIDO.codpedido
    WHERE EX2_ITEMPEDIDO.codproduto = NOV.codproduto
        AND EX2_PEDIDO.datapedido >= CURRENT_DATE - INTERVAL '1 month'
    GROUP BY codproduto, v_data;

    IF v_quantidade >= 0.5 * (
        SELECT SUM(quantidade)
        FROM EX2_ITEMPEDIDO
        JOIN EX2_PEDIDO ON EX2_PEDIDO.codpedido = EX2_ITEMPEDIDO.codpedido
        WHERE EX2_ITEMPEDIDO.codproduto = v_codproduto
            AND EX2_PEDIDO.datapedido >= v_data
    ) THEN
        -- Gera o código da requisição de compra
        SELECT nextval('EX2_REQUISICAO_COMPRA_SEQ') INTO v_codrequisicaocompra;
        -- Insere a requisição de compra
        INSERT INTO EX2_REQUISICAO_COMPRA (codrequisicaocompra, codproduto, data, quantidade)
        VALUES (v_codrequisicaocompra, v_codproduto, CURRENT_DATE, v_quantidade);
    END IF;

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

-- Cria o TRIGGER na tabela EX2_PRODUTO
CREATE TRIGGER trg_estoque_requisicao_compra
AFTER UPDATE ON EX2_PRODUTO
FOR EACH ROW
EXECUTE FUNCTION trg_estoque_requisicao_compra();

-- Teste do TRIGGER
-- Atualize a quantidade de estoque de um produto existente na tabela EX2_PRODUTO
UPDATE EX2_PRODUTO
SET quantidade = (
    SELECT quantidade * 0.5 -- Defina a nov quantidade de estoque como 50% da quantidade atual
    FROM EX2_PRODUTO
    WHERE codproduto = 1 -- Defina o código do produto aqui
)
WHERE codproduto = 1; -- Defina o código do produto aqui

-- Verifique as requisições de compra geradas
SELECT *
FROM EX2_REQUISICAO_COMPRA;

-- Questão 6

-- Criação do TRIGGER
CREATE OR REPLACE FUNCTION trg_itempedido_removido()
RETURNS TRIGGER AS $$
BEGIN
    -- Insere um registro de log para o item pedido removido
    INSERT INTO EX2_LOG (data, descricao)
    VALUES (CURRENT_DATE, 'Item pedido removido. CodPedido: ' || VELH.codpedido || ', NumeroItem: ' || VELH.numeroitem);
    
    RETURN VELH;
END;
$$ LANGUAGE plpgsql;

-- Cria o TRIGGER na tabela EX2_ITEMPEDIDO
CREATE TRIGGER trg_itempedido_removido
AFTER DELETE ON EX2_ITEMPEDIDO
FOR EACH ROW
EXECUTE FUNCTION trg_itempedido_removido();

-- Questão 8

-- Criação do TRIGGER
CREATE OR REPLACE FUNCTION verifi_itempedido_valorunitario()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOV.valorunitario < 0 THEN
        RAISE EXCEPTION 'O valor unitário não pode ser negativo. Valor mínimo: 0';
    END IF;

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_verific_itempedido_valorunitario
    BEFORE INSERT ON EX2_ITEMPEDIDO
    FOR EACH ROW
    EXECUTE FUNCTION verifi_itempedido_valorunitario();

-- Questão 10

-- Criação do TRIGGER
CREATE OR REPLACE FUNCTION auto_numero_itempedido()
    RETURNS TRIGGER AS $$
DECLARE
    max_numeroitem INTEGER;
BEGIN
    SELECT COALESCE(MAX(numeroitem), 0)
    INTO max_numeroitem
    FROM EX2_ITEMPEDIDO
    WHERE codpedido = NOV.codpedido;

    NOV.numeroitem := max_numeroitem + 1;

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_auto_numero_itempedido
    BEFORE INSERT ON EX2_ITEMPEDIDO
    FOR EACH ROW
    EXECUTE FUNCTION auto_numero_itempedido();

-- Questão 11

CREATE OR REPLACE FUNCTION verific_quantidade_itempedido()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOV.quantidade < 0 THEN
        RAISE EXCEPTION 'A quantidade do item de pedido não pode ser negativa.';
    END IF;

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_verific_quantidade_itempedido
    BEFORE INSERT OR UPDATE ON EX2_ITEMPEDIDO
    FOR EACH ROW
    EXECUTE FUNCTION verific_quantidade_itempedido();

-- Questão 12 

CREATE OR REPLACE FUNCTION add_sra_nome()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOV.datanascimento <= (current_date - INTERVAL '30 years') THEN
        NOV.nome := 'Sr(a). ' || NOV.nome;
    END IF;

    RETURN NOV;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_add_sra_nome
    BEFORE INSERT OR UPDATE ON EX2_CLIENTE
    FOR EACH ROW
    EXECUTE FUNCTION add_sra_nome();

-- Questão 13

CREATE OR REPLACE FUNCTION retorna_quantidade_estoque_do_itempedido_removido()
    RETURNS TRIGGER AS $$
DECLARE
    quantidade_removida INTEGER;
BEGIN
    SELECT quantidade
    INTO quantidade_removida
    FROM EX2_ITEMPEDIDO
    WHERE codpedido = VELH.codpedido
      AND numeroitem = VELH.numeroitem;

    UPDATE EX2_PRODUTO
    SET quantidade = quantidade + quantidade_removida
    WHERE codproduto = VELH.codproduto;

    INSERT INTO EX2_LOG (codlog, data, descricao)
    VALUES (nextval('EX2_LOG_SEQ'), current_date, 'Item pedido removido. CodPedido: ' || VELH.codpedido || ', NumeroItem: ' || VELH.numeroitem || ', Quantidade: ' || quantidade_removida);

    RETURN VELH;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_retorna_quantidade_estoque_do_itempedido_removido
    AFTER DELETE ON EX2_ITEMPEDIDO
    FOR EACH ROW
    EXECUTE FUNCTION retorna_quantidade_estoque_do_itempedido_removido();


-- Questão 14

-- TRIGGER para excluir registros em EX2_ITEMPEDIDO antes de remover um produto
CREATE OR REPLACE FUNCTION remove_itempedido_de_requisicoes()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM EX2_ITEMPEDIDO
    WHERE codproduto = VELH.codproduto;

    RETURN VELH;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_remove_itempedido_de_requisicoes
    BEFORE DELETE ON EX2_PRODUTO
    FOR EACH ROW
    EXECUTE FUNCTION remove_itempedido_de_requisicoes();

-- TRIGGER para remover as REQUISICOESCOMPRA de um produto que é removido
CREATE OR REPLACE FUNCTION remove_requisicoescompra_produto_removido()
    RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM EX2_REQUISICAO_COMPRA
    WHERE codproduto = VELH.codproduto;

    RETURN VELH;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_remove_requisicoescompra_produto_removido_produto_removido
    AFTER DELETE ON EX2_PRODUTO
    FOR EACH ROW
    EXECUTE FUNCTION remove_requisicoescompra_produto_removido();


