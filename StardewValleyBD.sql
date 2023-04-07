CREATE TABLE usuario (id_usuario INTEGER PRIMARY KEY);

CREATE TABLE save (
    id_save INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    nome_fazenda VARCHAR(100) not NULL,
    nome_jogador VARCHAR(100) not NULL,
    tempo_jogo TIME(10),
    estacao VARCHAR(50) CHECK(estacao in('primavera', 'verao', 'outono', 'inverno')),
    dia_atual INTEGER CHECK(dia_atual BETWEEN 1 and 28),
    ano INTEGER,
    ouro_total INTEGER CHECK(ouro_total BETWEEN 0 AND 99999999),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE fazenda (
    id_fazenda INTEGER PRIMARY KEY,
    nome_fazenda varchar(20) not NULL,
    modelo varchar(20) CHECK(modelo IN('padrao', 'entre riachos', 'na floresta', 'na colina',
                                       'remota', 'quatro cantos', 'praia'))
);

CREATE TABLE jogador (
    id_jogador INTEGER PRIMARY KEY,
    id_fazenda INTEGER not NULL,
    id_save INTEGER NOT NULL,
    nome VARCHAR(20) not NULL,
    genero varchar(20) CHECK(genero in('masculino', 'feminino')),
    ouro INTEGER CHECK(ouro BETWEEN 0 AND 99999999),
    energia INTEGER not NULL,
    saude INTEGER not NULL,
    FOREIGN KEY (id_save) REFERENCES save(id_save) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_fazenda) REFERENCES fazenda(id_fazenda) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inventario (
    id_inventario INTEGER PRIMARY KEY,
    id_jogador INTEGER NOT NULL,
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE carteira (
    id_carteira INTEGER PRIMARY KEY not NULL,
    id_jogador INTEGER not NULL,
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE item_especial (
    id_item_especial INTEGER PRIMARY KEY NOT NULL,
    nome VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE porta (
    id_carteira INTEGER NOT NULL,
    id_item_especial INTEGER NOT NULL,
    PRIMARY KEY (id_carteira, id_item_especial),
    FOREIGN KEY (id_carteira) REFERENCES carteira(id_carteira) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item_especial) REFERENCES item_especial(id_item_especial) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE receita (
    nome VARCHAR(100) UNIQUE PRIMARY key NOT NULL,
    material_necess VARCHAR(200) not NULL
);

CREATE TABLE item (
    id_item INTEGER PRIMARY KEY not NULL,
    nome VARCHAR(50) UNIQUE not NULL,
    nome_receita VARCHAR(50),
    raridade VARCHAR(20) CHECK(raridade in('padrao', 'prata', 'ouro', 'iridio')),
    ouro_venda INTEGER,
    FOREIGN KEY (nome_receita) REFERENCES receita(nome) ON DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE compravel (
    id_item INTEGER PRIMARY KEY,
    ouro_compra INTEGER not NULL,
    vendedor VARCHAR(20) not NULL,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE fabricavel (
    id_item INTEGER PRIMARY KEY,
    material VARCHAR(100) not NULL,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE coletavel (
    id_item INTEGER PRIMARY KEY not NULL,
    area VARCHAR(40) CHECK(area in('qualquer', 'floresta cinzaseiva', 'montanha','deserto', 
                                   'vila pelicanos', 'ilha gengibre', 'praia', 'esgoto',
                                   'bosque secreto', 'minas', 'fazenda')),
    estacao VARCHAR(20) CHECK(estacao in('todas', 'primavera', 'verao', 'outono', 'inverno')),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE consumivel (
    id_item INTEGER PRIMARY KEY not NULL,
    bonus VARCHAR(20) CHECK(bonus in('N/A', 'bebado', 'amaldicoado', 'coberto de gosma', 'fluxo de adrenalina',
                                     'energia de guerreiro', 'bencao de loba', 'oleo de alho', 'velocidade',
                                     'mineracao', 'pesca', 'cultivo', 'coleta', 'ataque', 'defesa', 'magnetismo',
                                     'energia maxima', 'sorte', 'congelado', 'escuridao', 'queimado', 'fraqueza',
                                     'enjoado', 'ravioli de tinta de lula')),
    saude INTEGER,
    energia INTEGER,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE cultivavel (
    id_item INTEGER PRIMARY KEY not NULL,
    estacao VARCHAR(20) CHECK(estacao in('primavera', 'verao', 'outono', 'inverno')),
    tempo_cultivo INTEGER not NULL, -- QUANTIDADDE DE DIAS
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE peixe (
    id_item INTEGER PRIMARY KEY not NULL,
    tamanho FLOAT not NULL,
    clima VARCHAR(20) CHECK(clima in('qualquer', 'sol', 'chuva', 'vento')),
    estacao VARCHAR(20) CHECK(estacao in('todas','primavera', 'verao', 'outono', 'inverno')),
    localizacao VARCHAR(100) CHECK(localizacao in('oceano', 'rio', 'lago da floresta', 'lago da montanha', 'lago da ilha gengibre',
                                                 'lago do bosque', 'esgotos', 'pantano da bruxa', 'oceano da ilha gengibre', 'mina', 'deserto',
                                                'forja', 'caverna dos piratas', 'covil dos insetos mutantes')),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE vestivel (
    id_item INTEGER PRIMARY KEY,
    tipo VARCHAR(20) CHECK(tipo in('calca', 'blusa', 'calcado', 'chapeu', 'anel')),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE interaje (
    id_jogador INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    tipo_interacao VARCHAR(20) not NULL,
    PRIMARY KEY (id_jogador, id_item),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE guarda (
    id_inventario INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    PRIMARY KEY (id_inventario, id_item),
    FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE conjunto (nome VARCHAR(50) UNIQUE PRIMARY KEY);

CREATE TABLE doacao (
    id_jogador INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    nome_conjunto VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_jogador, id_item, nome_conjunto),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nome_conjunto) REFERENCES conjunto(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE missao (
    nome VARCHAR(50) UNIQUE PRIMARY key,
    origem VARCHAR(50) CHECK(origem in ('precisa-se de ajuda', 'historia', 'pedido especial',
                                        'pedido especial do sr.qi')),
    tempo INTEGER,
    ouro_receber INTEGER
);

CREATE TABLE estrutura (
    id_estrutura INTEGER PRIMARY KEY,
    id_fazenda INTEGER not NULL,
    nome VARCHAR(20) CHECK(nome in('celeiro', 'galinheiro', 'moinho', 'cabana', 'silo',
                                   'lago de peixes', 'casa de gosmas', 'estabulo', 'poço',
                                   'casa', 'caixa de remessas')),
    tipo VARCHAR(20) not NULL CHECK (tipo IN ('abriga_animais', 'fabrica_item', 'armazena')),
    preco INTEGER not NULL,
    nivel VARCHAR(20) CHECK(nivel IN('inicial', 'grande', 'de luxo')),
    tamanho VARCHAR(10) not NULL,
    FOREIGN KEY (id_fazenda) REFERENCES fazenda(id_fazenda) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TIPOS DE ESTRUTURAS
CREATE TABLE fabrica_item (
    id_estrutura INTEGER PRIMARY KEY,
    tipo_item VARCHAR(40) not NULL,
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) on DELETE CASCADe on UPDATE CASCADE
) INHERITS (estrutura);

CREATE TABLE armazena (
    id_estrutura INTEGER PRIMARY key not NULL,
    tipo_armazenamento varchar(20),
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) on DELETE CASCADe on UPDATE CASCADE
) INHERITS (estrutura);

CREATE TABLE cria (
    id_estrutura INTEGER not NULL,
    id_item INTEGER not NULL,
    material VARCHAR(20) not NULL,
    PRIMARY KEY (id_estrutura, id_item),
    FOREIGN key (id_estrutura) REFERENCES estrutura(id_estrutura) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE abriga_animais (
    id_estrutura INTEGER PRIMARY KEY,
    capacidade INTEGER not NULL,
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITs (estrutura);

CREATe TABLE animal (
    id_animal INTEGER PRIMARY key,
    id_estrutura INTEGER not NULL,
    nome varchar(20) UNIQUE not NULL,
    tipo VARCHAR(20) CHECK (tipo in('galinha branca', 'galinha marrom', 'galinha azul', 'galinha nula',
                                    'galinha dourada', 'pato', 'coelho', 'dinossauro', 'vaca', 'vaca marrom',
                                    'cabra', 'ovelha', 'porco', 'avestruz', 'gosma', 'cavalo', 'peixe')),
                                    
    FOREIGN KEY (id_estrutura) REFERENCES abriga_animais(id_estrutura) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE solicita (
    id_jogador INTEGER NOT NULL,
    id_estrutura INTEGER NOT NULL,
    tempo_construcao TIME(10) not NULL,
    material_necess VARCHAR(30) not NULL,
    PRIMARY KEY (id_jogador, id_estrutura),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador),
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura)
);

CREATE TABLE ferramenta (
    id_ferramenta INTEGER PRIMARY key,
    tipo VARCHAR(20) CHECK(tipo in('enxada', 'picareta', 'machado', 'regador', 'lixeira',
                                  'foice', 'foice de ouro', 'balde de leite', 'tesoura',
                                  'mochila grande', 'mochila de luxo', 'vara de pescar',
                                  'peneira de cobre', 'auto-recolhedora', 'aquecedor')),
  
    nivel VARCHAR(20) CHECK(nivel in('inicial', 'cobre', 'aco', 'ouro', 'iridio'))
);

CREATE TABLE aprimora (
    id_jogador INTEGER not NULL,
    id_ferramenta INTEGER,
    id_estrutura INTEGER,
    material_necess VARCHAR(100),
    ouro_necess INTEGER not NULL,
    UNIQUE (id_jogador, id_ferramenta, id_estrutura),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_ferramenta) REFERENCES ferramenta(id_ferramenta) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) on DELETE CASCADE on UPDATE CASCADE
);

CREATE table possui (
    id_jogador INTEGER not NULL,
    id_ferramenta INTEGER,
    PRIMARY key (id_jogador, id_ferramenta),
    FOREIGN key (id_jogador) REFERENCES jogador(id_jogador),
    FOREIGN key (id_ferramenta) REFERENCES ferramenta(id_ferramenta)
);

CREATE TABLE gera (
    id_animal INTEGER not NULL,
    id_item INTEGER not NULL,
    PRIMARY KEY (id_animal, id_item),
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE realiza (
    id_jogador INTEGER NOT NULL,
    id_item INTEGER,
    nome_receita VARCHAR(100),
    nome_missao VARCHAR(100) not NULL,
    UNIQUE (id_jogador, id_item, nome_receita, nome_missao),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (id_item) REFERENCES item(id_item) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (nome_missao) REFERENCES missao(nome) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (nome_receita) REFERENCES receita(nome) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE npc (
    id_npc INTEGER PRIMARY KEY,
    nome_npc VARCHAR(30) UNIQUE not NULL,
    genero VARCHAR(30) CHECK(genero in ('masculino', 'feminino') or genero is NULL),
    comerciante BOOLEAN not NULL,
    coracoes INTEGER,
    casavel BOOLEAN not NULL,
    presenteavel BOOLEAN not NULL
);

CREATE TABLE localizacao (
    id_local INTEGER PRIMARY KEY,
    area VARCHAR(50) CHECK (area IN ('floresta cinzaseiva', 'montanha',
                                     'deserto', 'vila pelicanos',
                                     'ilha gengibre', 'praia', 'esgoto')),
    nome_local VARCHAR(30) UNIQUE not NULL
);

CREATE TABLE relaciona (
    id_relacao INTEGER PRIMARY KEY,
    id_jogador INTEGER NOT NULL,
    id_npc INTEGER NOT NULL,
    tipo_relacao VARCHAR(20),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_npc) REFERENCES npc(id_npc) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE venda (
    id_npc INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    PRIMARY KEY (id_npc, id_item),
    FOREIGN KEY (id_npc) REFERENCES npc(id_npc) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ocupa (
    id_npc INTEGER NOT NULL,
    id_local INTEGER NOT NULL,
    PRIMARY KEY (id_npc, id_local),
    FOREIGN KEY (id_npc) REFERENCES npc(id_npc) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_local) REFERENCES localizacao(id_local) ON DELETE CASCADE ON UPDATE CASCADE
);

===================================================================================================

INSERT INTO usuario (id_usuario) 
VALUES
  (1);

insert INTO save (id_save, id_usuario, nome_fazenda, nome_jogador, tempo_jogo,
                  estacao, dia_atual, ano, ouro_total) 
VALUES
  (1, 1, 'Pidão Farm', 'Lobo', '02:50:58', 'primavera', 8, 1, 5000);
                  
INSERT into fazenda (id_fazenda, nome_fazenda, modelo) 
VALUES
  (1, 'Pidão Farm', 'padrao');

insert into jogador (id_jogador, id_fazenda, id_save, nome, genero, ouro, energia, saude) 
VALUES
  (1, 1, 1, 'Lobo', 'masculino', 500, 270, 200);

INSERT into inventario (id_inventario, id_jogador) 
VALUES
  (1, 1);
							
insert INTO carteira (id_carteira, id_jogador) 
VALUES
  (1, 1);
                        
INSERT INTO item_especial (id_item_especial, nome) 
VALUES
  (1, 'Guia de Pigmeu'),
  (2, 'Chave Enferrujada'),
  (3, 'Cartão do Clube'),
  (4, 'Amuleto Especial'),
  (5, 'Chave de Caveira'),
  (6, 'Lupa'),
  (7, 'Talismã das Trevas'),
  (8, 'Tinta Mágica'),
  (9, 'Conhecimento do Urso'),
  (10, 'Dominio das Cebolinhas'),
  (11, 'Chave da Vila');
                        						
INSERT into porta (id_carteira, id_item_especial) 
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (1, 5),
  (1, 6),
  (1, 7),
  (1, 8),
  (1, 9),
  (1, 10),
  (1, 11);

INSERT INTO receita (nome, material_necess) 
VALUES
  ('Painel Solar', 'Quartzo Refinado(10), Barra de Ferro(5), Barra de Ouro(5)'),
  ('Esmagador de Geodos', 'Barra de Ouro(2), Pedra (50), Diamante(1)'),
  ('Computador da Fazenda', 'Dispositivo de Anão(1), Conjunto de Pilhas(1), Quartzo Refinado(10)');
						

INSERT INTO item (id_item, nome, nome_receita, raridade, ouro_venda)
VALUES
  (1, 'Mudas de Grama', NULL, 'padrao', NULL),
  (2, 'Açúcar', NULL, 'padrao', NULL),
  (3, 'Farinha de Trigo', NULL, 'padrao', NULL),
  (4, 'Arroz', NULL, 'padrao', NULL),
  (5, 'Óleo', NULL, 'padrao', NULL),
  (6, 'Vinagre', NULL, 'padrao', NULL),
  (7, 'Fertilizante Básico', NULL, 'padrao', NULL),
  (8, 'Painel Solar', 'Painel Solar', 'padrao', NULL),
  (9, 'Esmagador de Geodos', 'Esmagador de Geodos', 'padrao', NULL),
  (10, 'Computador da Fazenda', 'Computador da Fazenda', 'padrao', NULL),
  (11, 'Raiz-forte', NULL, 'prata', 62),
  (12, 'Narciso', NULL, 'ouro', 45),
  (13, 'Alho-Poró', NULL, 'padrao', 60),
  (14, 'Cebolinha', NULL, 'iridio', 16),
  (15, 'Café de jardim', NULL, 'padrao', 80),
  (16, 'Uva', NULL, 'padrao', 80),
  (17, 'Cogumelo vermelho', NULL, 'padrao', 75),
  (18, 'Amora', NULL, 'prata', 25),
  (19, 'Cantarelo', NULL, 'padrao', 160),
  (20, 'Raiz de inverno', NULL, 'iridio', 140),
  (21, 'Omelete', NULL, 'padrao', 125),
  (22, 'Ovo Frito', NULL, 'padrao', 110),
  (23, 'Salada', NULL, 'padrao', 300),
  (24, 'Couve-Flor com Queijo', NULL, 'padrao', 100),  
  (25, 'Peixe Cozido', NULL, 'padrao', 100),
  (26, 'Sopa de Chirivia', NULL, 'padrao', 120),
  (27, 'Mexido de Legumes', NULL, 'padrao', 120), 
  (28, 'Café da Manhã Completo', NULL, 'padrao', 350), 
  (29, 'Lula Frita', NULL, 'padrao', 150),
  (30, 'Pão Estranho', NULL, 'padrao', 225),
  (31, 'Alho', NULL, 'prata', 75),
  (32, 'Batata', NULL, 'ouro', 120),
  (33, 'Chirivia', NULL, 'padrao', 35), 
  (34, 'Carambola', NULL, 'iridio', 1500), 
  (35, 'Flor-Miçanga', NULL, 'ouro', 135),
  (36, 'Lúpulo', NULL, 'prata', 31),
  (37, 'Pimenta Quente', NULL, 'iridio', 80),
  (38, 'Abóbora', NULL, 'ouro', 480),
  (39, 'Berinjela', NULL, 'iridio', 120),
  (40, 'Couve Chinesa', NULL, 'padrao', 80),
  (41, 'Baiacu', NULL, 'prata', 250),
  (42, 'Anchova', NULL, 'padrao', 30),
  (43, 'Atum', NULL, 'padrao', 100),
  (44, 'Sardinha', NULL, 'ouro', 60),
  (45, 'Achigã', NULL, 'iridio', 200),
  (46, 'Truta arco-iris', NULL, 'padrao', 65),
  (47, 'Picão-verde', NULL, 'prata', 131),
  (48, 'Peixe-pedra', NULL, 'padrao', 300),
  (49, 'Areinha', NULL, 'iridio', 150),
  (50, 'Albacora', NULL, 'prata', 93),
  (51, 'Ófis', NULL, 'ouro', 180),
  (52, 'Salmão Mutante', NULL, 'padrao', 100),
  (53, 'Achigã-pequeno', NULL, 'prata', 62),
  (54, 'Bagre', NULL, 'iridio', 400),
  (55, 'Lúcio', NULL, 'padrao', 100),
  (56, 'Chapéu de Caubói', NULL, 'padrao', NULL),
  (57, 'Manto Real', NULL, 'padrao', NULL),
  (58, 'Calças de Dinossauro', NULL, 'padrao', NULL),
  (59, 'Botas de Palhaço da Brasa', NULL, 'padrao', NULL),
  (60, 'Anel Quente de Java', NULL, 'padrao', NULL),
  (61, 'Madeira', NULL, 'padrao', 2),
  (62, 'Madeira de Lei', NULL, 'padrao', 15),
  (63, 'Pedra', NULL, 'padrao', 2),
  (64, 'ovo', NULL, 'padrao', 50),
  (65, 'ovo grande', NULL, 'padrao', 95),
  (66, 'ovo marrom', NULL, 'padrao', 50),
  (67, 'ovo marrom grande', NULL, 'padrao', 95),
  (68, 'ovo nulo', NULL, 'padrao', 65),
  (69, 'ovo dourado', NULL, 'padrao', 500),
  (70, 'ovo de pata', NULL, 'padrao', 95),
  (71, 'pena de pato', NULL, 'padrao', 250),
  (72, 'lã', NULL, 'padrao', 340),
  (73, 'pé de coelho', NULL, 'padrao', 565),
  (74, 'ovo de dinossauro', NULL, 'padrao', 350),
  (75, 'leite', NULL, 'padrao', 125),
  (76, 'leite grande', NULL, 'padrao', 190),
  (77, 'leite de cabra', NULL, 'padrao', 225),
  (78, 'leite grande de cabra', NULL, 'padrao', 345),
  (79, 'trufa', NULL, 'padrao', 625),
  (80, 'ovo de avestruz', NULL, 'padrao', 600),
  (81, 'ovo de gosma', NULL, 'padrao', 1000),
  (82, 'minerio de ouro', NULL, 'padrao', 25),
  (83, 'cerveja', NULL, 'padrao', 200),
  (84, 'muda de cerejeira', NULL, 'padrao', 3400),
  (85, 'isca artificial', NULL, 'padrao', 1000);

INSERT INTO compravel (id_item, nome, nome_receita, raridade, ouro_venda, ouro_compra, vendedor)
VALUES

  (1, 'Mudas de Grama', NULL, 'padrao', NULL, 100, 'Pierre' ),
  (2, 'Açúcar', NULL, 'padrao', NULL, 100, 'Pierre'),
  (3, 'Farinha de Trigo', NULL, 'padrao', NULL, 100, 'Pierre'),
  (4, 'Arroz', NULL, 'padrao', NULL, 200, 'Pierre'),
  (5, 'Óleo', NULL, 'padrao', NULL, 200, 'Pierre'),
  (6, 'Vinagre', NULL, 'padrao', NULL, 200, 'Pierre'),
  (7, 'Fertilizante Básico', NULL, 'padrao', NULL, 150, 'Pierre');

INSERT INTO fabricavel (id_item, nome, nome_receita, raridade, ouro_venda, material) 
VALUES
  (8, 'Painel Solar', 'Painel Solar', 'padrao', NULL, 'Quartzo Refinado(10), Barra de Ferro(5), Barra de Ouro(5)'),
  (9, 'Esmagador de Geodos', 'Esmagador de Geodos', 'padrao', NULL, 'Barra de Ouro(2), Pedra (50), Diamante(1)'),
  (10, 'Computador da Fazenda', 'Computador da Fazenda', 'padrao', NULL, 'Dispositivo de Anão(1), Conjunto de Pilhas(1), Quartzo Refinado(10)');

INSERT into coletavel (id_item, nome, nome_receita, raridade, ouro_venda, area, estacao) 
VALUES 
  (11, 'Raiz-forte', NULL, 'prata', 62, 'vila pelicanos', 'primavera'),
  (12, 'Narciso', NULL, 'ouro', 45, 'vila pelicanos', 'primavera'),
  (13, 'Alho-Poró', NULL, 'padrao', 60, 'vila pelicanos', 'primavera'),
  (14, 'Cebolinha', NULL, 'iridio', 16, 'floresta cinzaseiva', 'primavera'),
  (15, 'Café de jardim', NULL, 'padrao', 80, 'vila pelicanos', 'verao'),
  (16, 'Uva', NULL, 'padrao', 80, 'vila pelicanos', 'verao'),
  (17, 'Cogumelo vermelho', NULL, 'padrao', 75, 'minas', 'verao'),
  (18, 'Amora', NULL, 'prata', 25, 'vila pelicanos', 'outono'),
  (19, 'Cantarelo', NULL, 'padrao', 160, 'bosque secreto', 'outono'),
  (20, 'Raiz de inverno', NULL, 'iridio', 140, 'vila pelicanos', 'inverno'),
  (61, 'Madeira', NULL, 'padrao', 2, 'qualquer', 'todas'),
  (62, 'Madeira de Lei', NULL, 'padrao', 15, 'bosque secreto', 'todas'),
  (63, 'Pedra', NULL, 'padrao', 2, 'qualquer', 'todas'),
  (64, 'ovo', NULL, 'padrao', 50, 'fazenda', 'todas'),
  (65, 'ovo grande', NULL, 'padrao', 95, 'fazenda', 'todas'),
  (66, 'ovo marrom', NULL, 'padrao', 50, 'fazenda', 'todas'),
  (67, 'ovo marrom grande', NULL, 'padrao', 95, 'fazenda', 'todas'),
  (68, 'ovo nulo', NULL, 'padrao', 65, 'fazenda', 'todas'),
  (69, 'ovo dourado', NULL, 'padrao', 500, 'fazenda', 'todas'),
  (70, 'ovo de pata', NULL, 'padrao', 95, 'fazenda', 'todas'),
  (71, 'pena de pato', NULL, 'padrao', 250, 'fazenda', 'todas'),
  (72, 'lã', NULL, 'padrao', 340 , 'fazenda', 'todas'),
  (73, 'pé de coelho', NULL, 'padrao', 565, 'fazenda', 'todas'),
  (74, 'ovo de dinossauro', NULL, 'padrao', 350, 'fazenda', 'todas'),
  (75, 'leite', NULL, 'padrao', 125, 'fazenda', 'todas'),
  (76, 'leite grande', NULL, 'padrao', 190, 'fazenda', 'todas'),
  (77, 'leite de cabra', NULL, 'padrao', 225, 'fazenda', 'todas'),
  (78, 'leite grande de cabra', NULL, 'padrao', 345, 'fazenda', 'todas'),
  (79, 'trufa', NULL, 'padrao', 625, 'fazenda', 'todas'),
  (80, 'ovo de avestruz', NULL, 'padrao', 600, 'fazenda', 'todas'),
  (81, 'ovo de gosma', NULL, 'padrao', 1000, 'fazenda', 'todas');
  

INSERT into consumivel (id_item, nome, nome_receita, raridade, ouro_venda, bonus, saude, energia) 
VALUES 
  (21, 'Ovo Frito', NULL, 'padrao', 110, 'N/A', 22, 50),
  (22, 'Omelete', NULL, 'padrao', 125, 'N/A', 45, 100),
  (23, 'Salada', NULL, 'padrao', 300, 'N/A', 50, 113),
  (24, 'Couve-Flor com Queijo', NULL, 'padrao', 100, 'N/A', 62, 138),  
  (25, 'Peixe Cozido', NULL, 'padrao', 100, 'N/A', 33, 75),
  (26, 'Sopa de Chirivia', NULL, 'padrao', 120, 'N/A', 38, 85), 
  (27, 'Mexido de Legumes', NULL, 'padrao', 120, 'N/A', 74, 165), 
  (28, 'Café da Manhã Completo', NULL, 'padrao', 350, 'N/A', 90, 200), 
  (29, 'Lula Frita', NULL, 'padrao', 150, 'N/A', 36, 80),
  (30, 'Pão Estranho', NULL, 'padrao', 225, 'N/A', 45, 100);

INSERT into cultivavel (id_item, nome, nome_receita, raridade, ouro_venda, estacao, tempo_cultivo) 
VALUES
  (31, 'Alho', NULL, 'prata', 75, 'primavera', 4),
  (32, 'Batata', NULL, 'ouro', 120, 'primavera', 6),
  (33, 'Chirivia', NULL, 'padrao', 35, 'primavera', 4), 
  (34, 'Carambola', NULL, 'iridio', 1500, 'verao', 13), 
  (35, 'Flor-Miçanga', NULL, 'ouro', 135, 'verao', 8),
  (36, 'Lúpulo', NULL, 'prata', 31, 'verao', 11),
  (37, 'Pimenta Quente', NULL, 'iridio', 80, 'verao', 5),
  (38, 'Abóbora', NULL, 'ouro', 480, 'outono', 13),
  (39, 'Berinjela', NULL, 'iridio', 120, 'outono', 5),
  (40, 'Couve Chinesa', NULL, 'padrao', 80, 'outono', 4);

INSERT INTO peixe (id_item, nome, nome_receita, raridade, ouro_venda, tamanho, clima, estacao, localizacao)
VALUES 
  (41, 'Baiacu', NULL, 'prata', 250, 40, 'sol', 'verao', 'oceano'),
  (42, 'Anchova', NULL, 'padrao', 30, 20, 'qualquer', 'primavera', 'oceano'),
  (43, 'Atum', NULL, 'padrao', 100, 70, 'qualquer', 'verao', 'oceano'),
  (44, 'Sardinha', NULL, 'ouro', 60, 20, 'qualquer', 'outono', 'oceano'),
  (45, 'Achigã', NULL, 'iridio', 200, 45, 'qualquer', 'todas', 'lago da montanha'),
  (46, 'Truta arco-iris', NULL, 'padrao', 65, 35, 'sol', 'verao', 'rio'),
  (47, 'Picão-verde', NULL, 'prata', 131, 50, 'chuva', 'outono', 'rio'),
  (48, 'Peixe-pedra', NULL, 'padrao', 300, 45, 'qualquer', 'todas', 'mina'),
  (49, 'Areinha', NULL, 'iridio', 150, 20, 'qualquer', 'todas', 'deserto'),
  (50, 'Albacora', NULL, 'prata', 93, 60, 'qualquer', 'inverno', 'oceano'),
  (51, 'Ófis', NULL, 'ouro', 180, 76, 'qualquer', 'inverno', 'rio'),
  (52, 'Salmão Mutante', NULL, 'padrao', 100, 75, 'qualquer', 'todas', 'covil dos insetos mutantes'),
  (53, 'Achigã-pequeno', NULL, 'prata', 62, 30, 'qualquer', 'outono', 'rio'),
  (54, 'Bagre', NULL, 'iridio', 400, 80, 'chuva', 'primavera', 'lago do bosque'),
  (55, 'Lúcio', NULL, 'padrao', 100, 50, 'qualquer', 'primavera', 'rio');

INSERT into vestivel (id_item, nome, nome_receita, raridade, ouro_venda, tipo) 
VALUES
  (56, 'Chapéu de Caubói', NULL, 'padrao', NULL, 'chapeu'),
  (57, 'Manto Real', NULL, 'padrao', NULL, 'blusa'),
  (58, 'Calças de Dinossauro', NULL, 'padrao', NULL, 'calca'),
  (59, 'Botas de Palhaço da Brasa', NULL, 'padrao', NULL, 'calcado'),
  (60, 'Anel Quente de Java', NULL, 'padrao', NULL, 'anel');
  

INSERT INTO interaje (id_jogador, id_item, tipo_interacao) 
VALUES
  (1, 39, 'cultiva'),
  (1, 60, 'veste'),
  (1, 29, 'consome'),
  (1, 16, 'coleta'),
  (1, 10, 'fábrica'),
  (1, 54, 'pesca'),
  (1, 5, 'compra');

INSERT into guarda (id_inventario, id_item) 
VALUES
  (1, 3),
  (1, 11),
  (1, 12),
  (1, 15),
  (1, 16),
  (1, 17),
  (1, 18),
  (1, 20),
  (1, 22),
  (1, 28),
  (1, 31),
  (1, 33),
  (1, 35),
  (1, 37),
  (1, 38),
  (1, 39),
  (1, 41),
  (1, 42),
  (1, 44),
  (1, 45),
  (1, 46),
  (1, 47),
  (1, 50),
  (1, 54),
  (1, 60);
  

INSERT INTO conjunto (nome) 
VALUES
  ('recursos de primavera'),
  ('recursos de verão'),
  ('recursos de outono'),
  ('recursos de inverno'),
  ('recursos de construção'),
  ('recusos exóticos'),
  ('plantações de primavera'),
  ('plantações de verão'),
  ('plantações de outono'),
  ('plantações de qualidade'),
  ('animal'),
  ('artesão'),
  ('peixes do rio'),
  ('peixes de lago'),
  ('peixes de oceano'),
  ('pesca nortuna'),
  ('covo'),
  ('peixes especializados'),
  ('ferreiro'),
  ('geólogo'),
  ('aventureiro'),
  ('cozinheiro'),
  ('tinta'),
  ('pesquisa de campo'),
  ('forragem'),
  ('encantador'),
  ('a desaparecida');

INSERT INTO doacao (id_jogador, id_item, nome_conjunto) 
VALUES
  (1, 11, 'recursos de primavera'),
  (1, 12, 'recursos de primavera'),
  (1, 16, 'recursos de verão'),
  (1, 15, 'recursos de verão'),
  (1, 18, 'recursos de outono'),
  (1, 20, 'recursos de inverno'),
  (1, 60, 'recursos de construção'),
  (1, 17, 'recusos exóticos'),
  (1, 33, 'plantações de primavera'),
  (1, 37, 'plantações de verão'),
  (1, 38, 'plantações de outono'),
  (1, 54, 'peixes do rio'),
  (1, 45, 'peixes de lago'),
  (1, 44, 'peixes de oceano'),
  (1, 47, 'pesca nortuna'),
  (1, 41, 'peixes especializados'),
  (1, 22, 'cozinheiro'),
  (1, 17, 'tinta');
  
INSERT INTO missao (nome, origem, tempo, ouro_receber)
VALUES
  ('Coletando', 'precisa-se de ajuda', NULL, NULL),
  ('Como ganhar amigos', 'historia', NULL, NULL),
  ('Patrulha da Caverna', 'pedido especial', 7, 6000),
  ('Vamos Jogar um Jogo', 'pedido especial do sr.qi', 7, NULL),
  ('Plantas Qi', 'pedido especial do sr.qi', 28, NULL),
  ('Ingredientes da Ilha', 'pedido especial', 28, 300),
  ('Superpopulação Aquática', 'pedido especial', 7, 240);

INSERT INTO estrutura (id_estrutura, id_fazenda, nome, tipo, preco, nivel, tamanho) 
VALUES
  (1, 1, 'celeiro', 'abriga_animais', 6000, 'inicial', '7x4'), 
  (2, 1, 'celeiro', 'abriga_animais', 12000, 'grande', '7x4'), 
  (3, 1, 'celeiro', 'abriga_animais', 25000 , 'de luxo', '7x4'), 
  (4, 1, 'galinheiro', 'abriga_animais', 4000, 'inicial', '6x3'), 
  (5, 1, 'galinheiro', 'abriga_animais', 10000, 'grande', '6x3'), 
  (6, 1, 'galinheiro', 'abriga_animais', 20000, 'de luxo', '6x3'), 
  (7, 1, 'lago de peixes', 'abriga_animais', 5000, 'inicial', '5x5'), 
  (8, 1, 'casa de gosmas', 'abriga_animais', 10000, 'inicial', '11x6'), 
  (9, 1, 'estabulo', 'abriga_animais', 10000, 'inicial', '4x2'), 
  (10, 1, 'moinho', 'fabrica_item', 2500, 'inicial', '4x2'),
  (11, 1, 'cabana', 'armazena', 15000, 'inicial', '7x3'), 
  (12, 1, 'cabana', 'armazena', 20000, 'grande', '7x3'), 
  (13, 1, 'silo', 'armazena', 100, 'inicial', 'pequeno'), 
  (14, 1, 'poço', 'armazena', 1000, 'inicial', '3x3'), 
  (15, 1, 'casa', 'armazena', 10000, 'inicial', '5x3'), 
  (16, 1, 'casa', 'armazena', 10000, 'grande', '5x3'), 
  (17, 1, 'casa', 'armazena', 10000, 'de luxo', '5x3'), 
  (18, 1, 'caixa de remessas', 'armazena', 2500, 'inicial', '2x1'); 

INSERT INTO fabrica_item (id_estrutura, id_fazenda, nome, tipo, preco, nivel, tamanho, tipo_item) 
VALUES
  (10, 1, 'moinho', 'fabrica_item', 2500, 'inicial', '4x2', 'Açucar e farinha');

INSERT INTO armazena (id_estrutura, id_fazenda, nome, tipo, preco, nivel, tamanho, tipo_armazenamento) 
VALUES
  (11, 1, 'cabana', 'armazena', 15000, 'inicial', '7x3', 'qualquer'), 
  (12 , 1, 'cabana', 'armazena', 20000, 'grande', '7x3', 'qualquer'), 
  (13, 1, 'silo', 'armazena', 100, 'inicial', 'pequeno', 'feno'),
  (14, 1, 'poço', 'armazena', 1000, 'inicial', '3x3', 'água'), 
  (15, 1, 'casa', 'armazena', 10000, 'inicial', '5x3', 'qualquer'), 
  (16, 1, 'casa', 'armazena', 10000, 'grande', '5x3', 'qualquer'),
  (17, 1, 'casa', 'armazena', 10000, 'de luxo', '5x3', 'qualquer'), 
  (18, 1, 'caixa de remessas', 'armazena', 2500, 'inicial', '2x1', 'item');

INSERT INTO abriga_animais (id_estrutura, id_fazenda, nome, tipo, preco, nivel, tamanho, capacidade) 
VALUES
  (1, 1, 'celeiro', 'abriga_animais', 6000, 'inicial', '7x4', 4), 
  (2, 1, 'celeiro', 'abriga_animais', 12000, 'grande', '7x4', 8), 
  (3, 1, 'celeiro', 'abriga_animais', 25000 , 'de luxo', '7x4', 12),
  (4, 1, 'galinheiro', 'abriga_animais', 4000, 'inicial', '6x3', 4),
  (5, 1, 'galinheiro', 'abriga_animais', 10000, 'grande', '6x3', 8),
  (6, 1, 'galinheiro', 'abriga_animais', 20000, 'de luxo', '6x3', 12),
  (7, 1, 'lago de peixes', 'abriga_animais', 5000, 'inicial', '5x5', 3),
  (8, 1, 'casa de gosmas', 'abriga_animais', 10000, 'inicial', '11x6',20),
  (9, 1, 'estabulo', 'abriga_animais', 10000, 'inicial', '4x2', 1);

insert into animal (id_animal, id_estrutura, nome, tipo) 
VALUES
  (1, 4, 'Lila', 'galinha branca'),
  (2, 4, 'Bento', 'galinha marrom'),
  (3, 4, 'Luz', 'galinha azul'),
  (4, 5, 'Bia', 'galinha nula'),
  (5, 5, 'Apolo', 'galinha dourada'),
  (6, 5, 'Duck', 'pato'),
  (7, 6, 'Bugs', 'coelho'),
  (8, 5, 'Rex', 'dinossauro'),
  (9, 1, 'Mimosa', 'vaca'),
  (10, 1, 'Mancha', 'vaca marrom'),
  (11, 2, 'Borrego', 'cabra'),
  (12, 3, 'Baa', 'ovelha'),
  (13, 3, 'Wilbur', 'porco'),
  (14, 1, 'Emu', 'avestruz'),
  (15, 8, 'Slime', 'gosma'),
  (16, 9, 'Pé de Pano', 'cavalo'),
  (17, 7, 'Nemo', 'peixe');
  
INSERT INTO ferramenta (id_ferramenta, tipo, nivel) 
VALUES
  (1, 'auto-recolhedora', 'inicial'),
  (2, 'balde de leite', 'inicial'),
  (3, 'enxada', 'inicial'),
  (4, 'enxada', 'aco'),
  (5, 'enxada', 'ouro'),
  (6, 'enxada', 'iridio'),
  (8, 'foice', 'inicial'),
  (9, 'foice de ouro', 'ouro'),
  (10, 'lixeira', 'inicial'),
  (11, 'lixeira', 'aco'),
  (12, 'lixeira', 'ouro'),
  (13, 'lixeira', 'iridio'),
  (14, 'machado', 'inicial'),
  (15, 'machado', 'aco'),
  (16, 'machado', 'ouro'),
  (17, 'machado', 'iridio'),
  (18, 'mochila de luxo', 'inicial'),
  (19, 'mochila grande', 'inicial'),
  (20, 'peneira de cobre', 'inicial'),
  (21, 'picareta', 'inicial'),
  (22, 'picareta', 'aco'),
  (23, 'picareta', 'ouro'),
  (24, 'picareta', 'iridio'),
  (25, 'regador', 'inicial'),
  (26, 'regador', 'aco'),
  (27, 'regador', 'ouro'),
  (28, 'regador', 'iridio'),
  (29, 'tesoura', 'inicial'),
  (30, 'vara de pescar', 'inicial'),
  (31, 'enxada', 'cobre'),
  (32, 'lixeira', 'cobre'),
  (33, 'machado', 'cobre'),
  (34, 'regador', 'cobre');


INSERT into aprimora (id_jogador, id_ferramenta, id_estrutura, material_necess, ouro_necess) 
VALUES
  (1, 3, 1, 'Barra de Cobre(5), Madeira(350), Pedra(150)', 2000+6000),
  (1, NULL, 5, 'Madeira(550), Pedra(300)', 25000), 
  (1, 27, NULL, 'Barra de Irídio(5)', 25000);
  
INSERT into possui (id_jogador, id_ferramenta) 
VALUES
  (1, 10),
  (1, 18), 
  (1, 24), 
  (1, 31), 
  (1, 27), 
  (1, 5), 
  (1, 14);

INSERT into gera (id_animal, id_item)
VALUES
  (1, 64),
  (2, 66),
  (3, 65),
  (4, 68),
  (5, 69),
  (6, 71),
  (7, 73),
  (8, 74),
  (9, 75),
  (10, 76),
  (11, 77),
  (12, 72),
  (13, 79),
  (14, 80),
  (15, 81);

INSERT INTO realiza (id_jogador, id_item, nome_receita, nome_missao)
VALUES
  (1, NULL, 'Painel Solar', 'Ingredientes da Ilha'),
  (1, NULL, 'Esmagador de Geodos', 'Patrulha da Caverna'),
  (1, NULL, 'Computador da Fazenda', 'Superpopulação Aquática'),
  (1, NULL, NULL, 'Plantas Qi'),
  (1, NULL, NULL, 'Coletando');

insert into npc (id_npc, nome_npc, genero, comerciante, coracoes, casavel, presenteavel)
VALUES
  (1, 'Alex', 'masculino', FALSE, 4, TRUE, TRUE),
  (2, 'Elliot', 'masculino', FALSE, 4, TRUE, TRUE),
  (3, 'Harvey', 'masculino', FALSE, 4, TRUE, TRUE),
  (4, 'Sam', 'masculino', FALSE, 4, TRUE, TRUE),
  (5, 'Sebastian', 'masculino', FALSE, 4, TRUE, TRUE),
  (6, 'Shane', 'masculino', FALSE, 4, TRUE, TRUE),
  (7, 'Abigail', 'feminino', FALSE, 4, TRUE, TRUE),
  (8, 'Emily', 'feminino', FALSE, 4, TRUE, TRUE),
  (9, 'Haley', 'feminino', FALSE, 4, TRUE, TRUE),
  (10, 'Leah', 'masculino', FALSE, 4, TRUE, TRUE),
  (11, 'Maru', 'feminino', FALSE, 4, TRUE, TRUE),
  (12, 'Penny', 'feminino', FALSE, 4, TRUE, TRUE),
  (13, 'Anão', NULL, TRUE, 4, FALSE, TRUE),
  (14, 'Caroline', 'feminino', FALSE, 4, FALSE, TRUE),
  (15, 'Clint', 'masculino', TRUE, 4, FALSE, TRUE),
  (16, 'Demetrius', 'masculino', FALSE, 4, FALSE, TRUE),
  (17, 'Evelyn', 'feminino', FALSE, 4, FALSE, TRUE),
  (18, 'Feiticeiro', 'masculino', TRUE, 4, FALSE, TRUE),
  (19, 'George', 'masculino', FALSE, 4, FALSE, TRUE),
  (20, 'Gus', 'masculino', TRUE, 4, FALSE, TRUE),
  (21, 'Jas', 'feminino', FALSE, 4, FALSE, TRUE),
  (22, 'Jodi', 'feminino', FALSE, 4, FALSE, TRUE),
  (23, 'Kent', 'masculino', FALSE, 4, FALSE, TRUE),
  (24, 'Krobus', NULL, TRUE, 4, FALSE, TRUE),
  (25, 'Leo', 'masculino', FALSE, 4, FALSE, TRUE),
  (26, 'Lewis', 'masculino', FALSE, 4, FALSE, TRUE),
  (27, 'Linus', 'masculino', FALSE, 4, FALSE, TRUE),
  (28, 'Marnie', 'feminino', TRUE, 4, FALSE, TRUE),
  (29, 'Pam', 'feminino', FALSE, 4, FALSE, TRUE),
  (30, 'Pierre', 'masculino', TRUE, 4, FALSE, TRUE),
  (31, 'Robin', 'feminino', TRUE, 4, FALSE, TRUE),
  (32, 'Sandy', 'feminino', TRUE, 4, FALSE, TRUE),
  (33, 'Vincent', 'masculino', FALSE, 4, FALSE, TRUE),
  (34, 'Ajudante', 'masculino', FALSE, NULL, FALSE, FALSE),
  (35, 'Avô', 'masculino', FALSE, 4, FALSE, TRUE),
  (36, 'Passarinha', 'feminino', FALSE, NULL, FALSE, FALSE),
  (37, 'Gil', 'masculino', FALSE, NULL, FALSE, FALSE),
  (38, 'Governador', 'masculino', FALSE, NULL, FALSE, FALSE),
  (39, 'Gunther', 'masculino', FALSE, NULL, FALSE, FALSE),
  (40, 'Marlon', 'masculino', TRUE, NULL, FALSE, FALSE),
  (41, 'Morris', 'masculino', TRUE, NULL, FALSE, FALSE),
  (42, 'Professor Caracol', 'masculino', TRUE, NULL, FALSE, FALSE),
  (43, 'Segurança', 'masculino', FALSE, NULL, FALSE, FALSE),
  (44, 'Sr. Qi', 'masculino', TRUE, NULL, FALSE, FALSE),
  (45, 'Willy', 'masculino', TRUE, 4, FALSE, TRUE);
  
insert into localizacao (id_local, area, nome_local) 
VALUES
  (1, 'montanha', 'Carpintaria'),
  (2, 'vila pelicanos', 'Armazém do Pierre'),
  (3, 'vila pelicanos', 'Clínica do Harvey'),
  (4, 'vila pelicanos', 'Centro Comunitário'),
  (5, 'vila pelicanos', 'Museu'),
  (6, 'vila pelicanos', 'Ferreiro'),
  (7, 'vila pelicanos', 'Saloon Fruta Estrelar'),
  (8, 'vila pelicanos', 'Estrada do Rio, n° 1'),
  (9, 'vila pelicanos', 'Trailer'),
  (10, 'vila pelicanos', 'Mansão do Prefeito'),
  (11, 'vila pelicanos', 'Rua do Salgueiro, n° 1'),
  (12, 'vila pelicanos', 'Rua do Salgueiro, n° 2'),
  (13, 'montanha', 'Casa do Anão'),
  (14, 'esgoto', 'Casa do Krobus'),
  (15, 'montanha', 'Guilda dos Aventureiros'),
  (16, 'ilha gengibre', 'Árvore do Leo'),
  (17, 'ilha gengibre', 'Barraca da Passarinha'),
  (18, 'praia', 'Peixaria'),
  (19, 'ilha gengibre', 'Sala de Nozes'),
  (20, 'deserto', 'Oásis'),
  (21, 'floresta cinzaseiva', 'Rancho da Marnie'),
  (22, 'vila pelicanos', 'Mercado Joja'),
  (23, 'montanha', 'Barraca do Linus');


insert into relaciona (id_relacao, id_jogador, id_npc, tipo_relacao)
VALUES
  (1, 1, 1, 'presentear'),
  (2, 1, 11, 'conversar'),
  (3, 1, 11, 'presentear'),
  (4, 1, 8, 'conversar'),
  (5, 1, 2, 'presentear'),
  (6, 1, 44, 'conversar'),
  (7, 1, 25, 'presentear'),
  (8, 1, 24, 'presentear'),
  (9, 1, 34, 'conversar'),
  (10, 1, 16, 'presentear'),
  (11, 1, 4, 'casar');

insert into venda (id_npc, id_item) 
VALUES
  (15, 85),
  (20, 83),
  (30, 84),
  (31, 61),
  (31, 62),
  (31, 63),
  (45, 85);
  
insert into ocupa (id_npc, id_local) 
VALUES
  (30, 2),
  (14, 2),
  (7, 2),
  (39, 5),
  (15, 6),
  (41, 22),
  (20, 7),
  (1, 8),
  (17, 8),
  (19, 8),
  (29, 9),
  (12, 9),
  (26, 10),
  (22, 11),
  (23, 11),
  (4, 11),
  (33, 11),
  (8, 12),
  (9, 12),
  (31, 1),
  (16, 1),
  (5, 1),
  (11, 1),
  (45, 18),
  (28, 21),
  (21, 21),
  (6, 21),
  (44, 19),
  (40, 15),
  (37, 15),
  (3, 3),
  (13,13),
  (24, 14),
  (26, 16),
  (36, 17),
  (32, 20);
