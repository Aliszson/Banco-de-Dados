CREATE TABLE usuario (id_usuario INTEGER PRIMARY KEY NOT NULL);

CREATE TABLE save (
    id_save INTEGER PRIMARY KEY NOT NULL,
    id_usuario INTEGER NOT NULL,
    nome_fazenda VARCHAR(100),
    nome_jogador VARCHAR(100),
    tempo_jogo TIME(10),
    estacao VARCHAR(50),
    dia_atual INTEGER,
    ouro_total INTEGER,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE fazenda (
    id_fazenda INTEGER PRIMARY KEY NOT NULL,
    nome_fazenda varchar(20),
    modelo varchar(20)
);

CREATE TABLE jogador (
    id_jogador INTEGER PRIMARY KEY NOT NULL,
    id_fazenda INTEGER not NULL,
    id_save INTEGER NOT NULL,
    nome VARCHAR(20),
    genero varchar(20),
    ouro INTEGER,
    energia INTEGER,
    saude INTEGER,
    FOREIGN KEY (id_save) REFERENCES save(id_save) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_fazenda) REFERENCES fazenda(id_fazenda) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inventario (
    id_inventario INTEGER PRIMARY KEY NOT NULL,
    id_jogador INTEGER NOT NULL,
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE carteira (
    id_carteira INTEGER PRIMARY KEY not NULL,
    id_jogador INTEGER,
  	item_especial varchar(20) unique,
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE item (
    id_item SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE,
    raridade VARCHAR(20),
    ouro_venda INTEGER
);

CREATE TABLE compravel (
    id_item INTEGER PRIMARY KEY,
    ouro_compra INTEGER,
    vendedor VARCHAR(20),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE fabricavel (
    id_item INTEGER PRIMARY KEY,
    material VARCHAR(20),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE coletavel (
    id_item INTEGER PRIMARY KEY,
    area VARCHAR(40),
    estacao VARCHAR(20),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE consumivel (
    id_item INTEGER PRIMARY KEY,
    bonus VARCHAR(20),
    saude INTEGER,
    energia INTEGER,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE cultivavel (
    id_item INTEGER PRIMARY KEY,
    estacao VARCHAR(20),
    tempo_cultivo DATE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE peixe (
    id_item INTEGER PRIMARY KEY,
    peso FLOAT,
    estacao VARCHAR(20),
    localizacao VARCHAR(20),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE vestivel (
    id_item INTEGER PRIMARY KEY,
    tipo VARCHAR(20),
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITS (item);

CREATE TABLE interaje (
    id_jogador INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    tipo_interacao VARCHAR,
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

CREATE TABLE conjunto (nome VARCHAR PRIMARY KEY);

CREATE TABLE doacao (
    id_jogador INTEGER NOT NULL,
    id_item INTEGER NOT NULL,
    nome_conjunto VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_jogador, id_item, nome_conjunto),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nome_conjunto) REFERENCES conjunto(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE missao (
    nome VARCHAR(20) UNIQUE PRIMARY key not NULL,
    origem VARCHAR(20),
    tempo INTERVAL
);

CREATE TABLE receita (
    nome VARCHAR(20) UNIQUE PRIMARY key NOT NULL,
    material_necess VARCHAR(20)
);

CREATE TABLE estrutura (
    id_estrutura INTEGER PRIMARY KEY not NULL,
    id_fazenda INTEGER not NULL,
    nome VARCHAR(20),
    tipo VARCHAR(20),
    preco INTEGER,
    nivel INTEGER,
    tamanho VARCHAR(10),
    FOREIGN KEY (id_fazenda) REFERENCES fazenda(id_fazenda) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (
        tipo IN ('abriga_animais', 'fabrica_item', 'armazena')
    )
);

-- TIPOS DE ESTRUTURAS
CREATE TABLE fabrica_item (
    id_estrutura INTEGER PRIMARY KEY not NULL,
    tipo_item VARCHAR(20),
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
    material VARCHAR(20),
    PRIMARY KEY (id_estrutura, id_item),
    FOREIGN key (id_estrutura) REFERENCES estrutura(id_estrutura) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_item) REFERENCES item(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE abriga_animais (
    id_estrutura INTEGER PRIMARY KEY not NULL,
    capacidade INTEGER,
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) ON DELETE CASCADE ON UPDATE CASCADE
) INHERITs (estrutura);

CREATe TABLE animal (
    id_animal INTEGER PRIMARY key not NULL,
    id_estrutura INTEGER,
    nome varchar(20) UNIQUE not NULL,
    tipo VARCHAR(20),
    FOREIGN KEY (id_estrutura) REFERENCES abriga_animais(id_estrutura) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE solicita (
    id_jogador INTEGER NOT NULL,
    id_estrutura INTEGER NOT NULL,
    tempo_construcao TIME(10),
    material_necess VARCHAR(30),
    PRIMARY KEY (id_jogador, id_estrutura),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador),
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura)
);

CREATE TABLE ferramenta (
    id_ferramenta INTEGER PRIMARY key not NULL,
    tipo VARCHAR(20),
    nivel INTEGER
);

CREATE TABLE aprimora (
    id_jogador INTEGER not NULL,
    id_ferramenta INTEGER,
    id_estrutura INTEGER,
    material_necess VARCHAR(20),
    ouro_necess INTEGER,
    PRIMARY KEY (id_jogador, id_ferramenta, id_estrutura),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_ferramenta) REFERENCES ferramenta(id_ferramenta) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN KEY (id_estrutura) REFERENCES estrutura(id_estrutura) on DELETE CASCADE on UPDATE CASCADE
);

CREATE table possui (
    id_jogador INTEGER not NULL,
    id_ferramenta INTEGER not NULL,
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
    nome_receita VARCHAR(20),
    nome_missao VARCHAR(20),
    PRIMARY KEY (id_jogador, id_item, nome_receita, nome_missao),
    FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (id_item) REFERENCES item(id_item) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (nome_missao) REFERENCES missao(nome) on DELETE CASCADE on UPDATE CASCADE,
    FOREIGN key (nome_receita) REFERENCES receita(nome) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE npc (
    id_npc INTEGER PRIMARY KEY,
    nome_npc VARCHAR(30) UNIQUE not NULL,
    genero VARCHAR(30) CHECK(genero in ('masculino', 'feminino')),
    comerciante BOOLEAN,
    pontos_de_amizade FLOAT,
    casavel BOOLEAN,
    presenteavel BOOLEAN
);

CREATE TABLE localizacao (
    id_local INTEGER PRIMARY KEY NOT NULL,
    area VARCHAR(50) CHECK (area IN ('floresta cinzaseiva', 'montanha',
                                     'deserto', 'vila pelicanos',
                                     'ilha gengibre', 'praia', 'esgoto')),
    nome_local VARCHAR(30) UNIQUE not NULL
);

CREATE TABLE relaciona (
    id_jogador INTEGER NOT NULL,
    id_npc INTEGER NOT NULL,
    tipo_relacao VARCHAR(20),
    PRIMARY KEY (id_jogador, id_npc),
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
