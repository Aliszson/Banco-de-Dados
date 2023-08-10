CREATE TABLE seccao (
  numsec INTEGER PRIMARY KEY,
  nome VARCHAR(50),
  cidade VARCHAR(50)
);

CREATE TABLE empregado (
  numemp INTEGER PRIMARY KEY,
  nome VARCHAR(50),
  seccao INTEGER,
  posto VARCHAR(50),
  chefe INTEGER REFERENCES empregado(numemp),
  salario FLOAT,
  comissao FLOAT,
  FOREIGN KEY (seccao) REFERENCES seccao(numsec),
  CONSTRAINT FK_EMPREGADO_X_EMPREGADO
    FOREIGN KEY (chefe) REFERENCES empregado(numemp)
);

INSERT INTO seccao (numsec, nome, cidade) VALUES 
(10, 'Fabrica', 'Porto'),
(20, 'Comercial', 'Porto'),
(30, 'Marketing', 'Braga'),
(40, 'Planeamento', 'Guimarães'),
(50, 'Administração', 'Porto'),
(60, 'Informática', 'Braga'),
(70, 'Recursos Humanos', 'Guimarães');

INSERT INTO empregado (numemp, nome, seccao, posto, chefe, salario, comissao) VALUES 
(1, 'Ana', 10, 'Programador', 3, 3000, 10),
(2, 'Nuno', 70, 'Engenheiro', 1, 1500, 40),
(3, 'Álvaro', 50, 'Administrador', NULL, 2500, 0),
(4, 'António', 10, 'Engenheiro', 3, 1450, 20),
(5, 'Susana', 20, 'Administrador', NULL, 2750, 30),
(6, 'Cláudio', 60, 'Comercial', 4, 1000, 50);


