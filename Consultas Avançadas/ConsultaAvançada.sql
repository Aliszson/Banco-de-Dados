--Criar Tabela
CREATE TABLE Alunos (
  MAT INTEGER PRIMARY KEY,
  nome VARCHAR(50),
  endereco VARCHAR(50),
  cidade VARCHAR(50)
);

CREATE TABLE Disciplinas (
  COD_DISC VARCHAR(50) PRIMARY KEY,
  nome_disc VARCHAR(50),
  carga_hor INTEGER
);

CREATE TABLE Professores (
  COD_PROF VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(50),
  endereco VARCHAR(50),
  cidade VARCHAR(50)
);

CREATE TABLE Turma (
  COD_DISC VARCHAR(50),
  COD_TURMA VARCHAR(50),
  COD_PROF VARCHAR(50),
  ANO INTEGER,
  horario VARCHAR(50),
  PRIMARY KEY (COD_DISC, COD_TURMA),
  UNIQUE(COD_DISC, COD_TURMA, COD_PROF, ANO),
  FOREIGN KEY (COD_DISC) REFERENCES Disciplinas(COD_DISC),
  FOREIGN KEY (COD_PROF) REFERENCES Professores(COD_PROF)
);


CREATE TABLE Historico (
  MAT INTEGER,
  COD_DISC VARCHAR(50),
  COD_TURMA VARCHAR(50),
  COD_PROF VARCHAR(50),
  ANO INTEGER,
  frequencia INTEGER,
  nota FLOAT,
  PRIMARY KEY (MAT, COD_DISC, COD_TURMA, COD_PROF, ANO),
  FOREIGN KEY (MAT) REFERENCES Alunos (MAT),
  FOREIGN KEY (COD_DISC, COD_TURMA, COD_PROF, ANO) REFERENCES Turma (COD_DISC, COD_TURMA, COD_PROF, ANO)
);

------------------------------------------------------------------------

--Inserir

INSERT INTO Alunos (MAT, nome, endereco, cidade)
VALUES
(2015010101, 'JOSE DE ALENCAR', 'RUA DAS ALMAS', 'NATAL'),
(2015010102, 'JOÃO JOSÉ', 'AVENIDA RUY CARNEIRO', 'JOÃO PESSOA'),
(2015010103, 'MARIA JOAQUINA', 'RUA CARROSSEL', 'RECIFE'),
(2015010104, 'MARIA DAS DORES', 'RUA DAS LADEIRAS', 'FORTALEZA'),
(2015010105, 'JOSUÉ CLAUDINO DOS SANTOS', 'CENTRO', 'NATAL'),
(2015010106, 'JOSUÉLISSON CLAUDINO DOS SANTOS', 'CENTRO', 'NATAL');

INSERT INTO Disciplinas (COD_DISC, nome_disc, carga_hor)
VALUES
('BD', 'BANCO DE DADOS', 100),
('POO', 'PROGRAMAÇÃO COM ACESSO A BANCO DE DADOS', 100),
('WEB', 'AUTORIA WEB', 50),
('ENG', 'ENGENHARIA DE SOFTWARE', 80);

INSERT INTO Professores (COD_PROF, nome, endereco, cidade)
VALUES
(212131, 'NICKERSON FERREIRA', 'RUA MANAÍRA', 'JOÃO PESSOA'),
(122135, 'ADORILSON BEZERRA', 'AVENIDA SALGADO FILHO', 'NATAL'),
(192011, 'DIEGO OLIVEIRA', 'AVENIDA ROBERTO FREIRE', 'NATAL');

INSERT INTO Turma (COD_DISC, COD_TURMA, COD_PROF, ANO, horario)
VALUES
('BD', 1, 212131, 2015, '11:00-12:00'),
('BD', 2, 212131, 2015, '13:00-14:00'),
('POO', 1, 192011, 2015, '08:00-09:00'),
('WEB', 1, 192011, 2015, '07:00-08:00'),
('ENG', 1, 122135, 2015, '10:00-11:00');

INSERT INTO Historico VALUES
(2015010101, 'BD', 1, 212131, 2015, 80, 8.5),
(2015010101, 'POO', 1, 192011, 2015, 75, 7.0),
(2015010101, 'WEB', 1, 192011, 2015, 85, 9.0),
(2015010101, 'ENG', 1, 122135, 2015, 90, 8.0),
(2015010102, 'BD', 1, 212131, 2015, 70, 7.0),
(2015010102, 'POO', 1, 192011, 2015, 80, 8.0),
(2015010102, 'WEB', 1, 192011, 2015, 65, 6.5),
(2015010102, 'ENG', 1, 122135, 2015, 95, 9.5),
(2015010103, 'BD', 2, 212131, 2015, 75, 8.0),
(2015010103, 'POO', 1, 192011, 2015, 85, 9.0),
(2015010103, 'WEB', 1, 192011, 2015, 90, 9.5),
(2015010103, 'ENG', 1, 122135, 2015, 70, 7.5),
(2015010104, 'BD', 1, 212131, 2015, 65, 6.5),
(2015010104, 'POO', 1, 192011, 2015, 70, 7.0),
(2015010104, 'WEB', 1, 192011, 2015, 75, 8.0),
(2015010104, 'ENG', 1, 122135, 2015, 80, 8.5),
(2015010105, 'BD', 2, 212131, 2015, 85, 9.0),
(2015010105, 'POO', 1, 192011, 2015, 90, 9.5),
(2015010105, 'WEB', 1, 192011, 2015, 80, 8.0),
(2015010105, 'ENG', 1, 122135, 2015, 85, 8.5),
(2015010106, 'BD', 2, 212131, 2015, 80, 8.0),
(2015010106, 'POO', 1, 192011, 2015, 75, 7.5),
(2015010106, 'WEB', 1, 192011, 2015, 85, 8.5),
(2015010106, 'ENG', 1, 122135, 2015, 90, 9.0);

