-- 1 Atualiza Status de Amizade com NPCs =======================================================

CREATE OR REPLACE FUNCTION atualizar_pontos_amizade()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_relacao = 'conversar' THEN
        UPDATE npc
        SET coracoes = coracoes + 1
        WHERE id_npc = NEW.id_npc;
    ELSIF NEW.tipo_relacao = 'presentear' THEN
        UPDATE npc
        SET coracoes = coracoes + 3
        WHERE id_npc = NEW.id_npc;
    ELSIF NEW.tipo_relacao = 'casar' THEN
        -- Verifica se o NPC é casável
        IF (SELECT casavel FROM npc WHERE id_npc = NEW.id_npc) = TRUE THEN
            UPDATE npc
            SET coracoes = coracoes + 5
            WHERE id_npc = NEW.id_npc;
        ELSE
            -- Lança uma exceção com uma mensagem de erro
            RAISE EXCEPTION 'Não é possível casar com esse NPC.';
        END IF;
    END IF;
    
    -- Verifica se já existe uma relação de casamento com o jogador
    IF EXISTS (
        SELECT 1
        FROM relaciona
        WHERE tipo_relacao = 'casar'
            AND id_jogador = NEW.id_jogador
            AND id_npc != NEW.id_npc
    ) THEN
        -- Caso já exista um casamento, remove a relação atual
        DELETE FROM relaciona
        WHERE id_relacao = NEW.id_relacao;
        
        -- Lança uma exceção com uma mensagem de erro
        RAISE EXCEPTION 'Você já está casado com outro NPC.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_pontos_amizade
AFTER INSERT ON relaciona
FOR EACH ROW
WHEN (NEW.tipo_relacao IN ('conversar', 'presentear', 'casar'))
EXECUTE FUNCTION atualizar_pontos_amizade();

-- 2 Doação Para Conjuntos =======================================================

CREATE OR REPLACE FUNCTION doacao()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se o item está na tabela "guarda"
    IF EXISTS (
        SELECT 1
        FROM guarda
        WHERE id_item = NEW.id_item
          AND id_inventario = NEW.id_jogador
    ) THEN
        -- Remover o item da tabela "guarda"
        DELETE FROM guarda
        WHERE id_item = NEW.id_item
          AND id_inventario = NEW.id_jogador;
    ELSE
        -- Emitir mensagem informando que o item não está na tabela "guarda"
        RAISE EXCEPTION 'O item não está na tabela "guarda".';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_doacao
BEFORE INSERT ON doacao
FOR EACH ROW
EXECUTE FUNCTION doacao();

-- 3 Compra de Animais =======================================================

CREATE OR REPLACE FUNCTION compra_animais()
RETURNS TRIGGER AS $$
DECLARE
    quantidade_animais INTEGER;
    limite INTEGER;
BEGIN
    -- Obtém a quantidade de animais na estrutura
    SELECT COUNT(*) INTO quantidade_animais
    FROM animal
    WHERE id_estrutura = NEW.id_estrutura;

    -- Obtém o limite de animais suportado pela estrutura
    SELECT capacidade INTO limite
    FROM abriga_animais
    WHERE id_estrutura = NEW.id_estrutura;

    -- Verifica se a quantidade de animais ultrapassa o limite
    IF quantidade_animais > limite THEN
        RAISE EXCEPTION 'Limite de animais excedido para a estrutura';
    END IF;

    -- Verifica se o nome do animal já existe
    IF EXISTS (
        SELECT 1
        FROM animal
        WHERE nome = NEW.nome
    ) THEN
        RAISE EXCEPTION 'Já existe um animal com esse nome';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_compra_animais
BEFORE INSERT ON animal
FOR EACH ROW
EXECUTE FUNCTION compra_animais();

-- 4 Atualiza Quantidade de Ouro do Save =======================================================

CREATE OR REPLACE FUNCTION atualizar_ouro_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE save
    SET ouro_total = (
        SELECT SUM(ouro)
        FROM jogador
        WHERE jogador.id_save = NEW.id_save
    )
    WHERE save.id_save = NEW.id_save;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_ouro_total
AFTER INSERT OR UPDATE OF ouro ON jogador
FOR EACH ROW
EXECUTE FUNCTION atualizar_ouro_total();

-- 5 Comprar Item =======================================================

CREATE OR REPLACE FUNCTION comprar_item() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o jogador já possui o item
    IF EXISTS (
        SELECT 1
        FROM guarda
        WHERE id_item = NEW.id_item
          AND id_inventario = NEW.id_jogador
    ) THEN
        RAISE EXCEPTION 'O jogador já possui o item.';
    END IF;

    -- Verifica se o item é comprável
    IF NOT EXISTS (
        SELECT 1
        FROM compravel
        WHERE id_item = NEW.id_item
    ) THEN
        RAISE EXCEPTION 'Este item não é comprável.';
    END IF;

    -- Verifica se o jogador possui ouro suficiente para a compra
    IF (
        SELECT ouro
        FROM jogador
        WHERE id_jogador = NEW.id_jogador
    ) < (
        SELECT ouro_compra
        FROM compravel
        WHERE id_item = NEW.id_item
    ) THEN
        RAISE EXCEPTION 'O jogador não possui ouro suficiente para comprar o item.';
    END IF;

    -- Subtrai o valor em ouro do item do valor de ouro do jogador
    UPDATE jogador
    SET ouro = ouro - (
        SELECT ouro_compra
        FROM compravel
        WHERE id_item = NEW.id_item
    )
    WHERE id_jogador = NEW.id_jogador;

    -- Adiciona o item à tabela guarda
    INSERT INTO guarda (id_inventario, id_item)
    VALUES (NEW.id_jogador, NEW.id_item);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_compra_item
AFTER INSERT ON compra
FOR EACH ROW
EXECUTE FUNCTION comprar_item();

-- 6 Impedir Exclusão da Estrutura com Animais =======================================================

CREATE OR REPLACE FUNCTION impedir_exclusao_estrutura()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM animal
        WHERE animal.id_estrutura = OLD.id_estrutura
    ) THEN
        RAISE EXCEPTION 'A estrutura não pode ser excluída porque está associada a animais.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_impedir_exclusao_estrutura
BEFORE DELETE ON estrutura
FOR EACH ROW
EXECUTE FUNCTION impedir_exclusao_estrutura();

-- 7 Realizar Missão =======================================================

CREATE OR REPLACE FUNCTION realizar_missao() RETURNS TRIGGER AS $$
BEGIN
    -- Adiciona o ouro ao jogador caso ouro_receber não seja nulo
    IF NEW.ouro_receber IS NOT NULL THEN
        UPDATE jogador SET ouro = ouro + NEW.ouro_receber WHERE id_jogador = NEW.id_jogador;
    END IF;

    -- Adiciona o item à tabela guarda caso o item não seja nulo
    IF NEW.id_item IS NOT NULL THEN
        INSERT INTO guarda (id_inventario, id_item) VALUES (NEW.id_jogador, NEW.id_item);
    END IF;

    -- Exibe uma mensagem caso o jogador receba uma receita
    IF NEW.nome_receita IS NOT NULL THEN
        RAISE EXCEPTION 'Nova receita: %', NEW.nome_receita;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_realiza BEFORE INSERT ON realiza
    FOR EACH ROW EXECUTE FUNCTION realizar_missao();

-- 8 Vender Item =======================================================

CREATE OR REPLACE FUNCTION vender_item() RETURNS TRIGGER AS $$
BEGIN
    -- Remove o item da tabela "guarda"
    DELETE FROM guarda WHERE id_inventario = OLD.id_inventario AND id_item = OLD.id_item;

    -- Adiciona a quantidade de ouro do item Ã  quantidade atual de ouro do jogador
    UPDATE jogador SET ouro = ouro + (SELECT ouro_venda FROM item WHERE id_item = OLD.id_item LIMIT 1) WHERE id_jogador = (SELECT id_jogador FROM inventario WHERE id_inventario = OLD.id_inventario LIMIT 1);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vender
AFTER DELETE ON guarda
FOR EACH ROW
EXECUTE FUNCTION vender_item();

-- 9 Aumento de Energia =======================================================

CREATE OR REPLACE FUNCTION aumento_energia()
RETURNS TRIGGER AS $$
DECLARE
    energia_atual INTEGER;
BEGIN
    SELECT energia INTO energia_atual FROM jogador WHERE id_jogador = (SELECT id_jogador FROM guarda WHERE id_inventario = NEW.id_inventario LIMIT 1);
    
    IF energia_atual >= 508 THEN
        RAISE EXCEPTION 'A energia do jogador já está no máximo (508)';
    ELSE
        UPDATE jogador SET energia = LEAST(508, energia_atual + 34) WHERE id_jogador = (SELECT id_jogador FROM guarda WHERE id_inventario = NEW.id_inventario LIMIT 1);
    END IF;

    DELETE FROM guarda WHERE id_inventario = NEW.id_inventario AND id_item = 100;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_aumento_energia
AFTER INSERT ON guarda
FOR EACH ROW
WHEN (NEW.id_item = 100)
EXECUTE FUNCTION aumento_energia();

-- 10 Aumentar Saúde =======================================================

CREATE OR REPLACE FUNCTION aumentar_saude()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE jogador SET saude = saude + 25 WHERE id_jogador = (SELECT id_jogador FROM guarda WHERE id_inventario = NEW.id_inventario LIMIT 1);
    
    IF (SELECT saude FROM jogador WHERE id_jogador = (SELECT id_jogador FROM guarda WHERE id_inventario = NEW.id_inventario LIMIT 1)) > 175 THEN
        RAISE EXCEPTION 'O jogador já tem a saúde máxima';
    END IF;
    
    DELETE FROM guarda WHERE id_item = 130;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_aumentar_saude
AFTER INSERT ON guarda
FOR EACH ROW
WHEN (NEW.id_item = 130)
EXECUTE FUNCTION aumentar_saude();



