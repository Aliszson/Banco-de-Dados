 --Exercício 09-1

--1================

--A)---------------
SELECT id_nf, id_item, cod_prod, valor_unit
FROM vendas
WHERE desconto is NULL 

--B)---------------
SELECT id_nf, id_item, cod_prod, valor_unit, valor_unit - (valor_unit*(desconto/100)) as valorvendido
FROM vendas
WHERE desconto > 0

--C)---------------
UPDATE vendas 
SEt desconto = 0 
WHERE desconto is NULL

--D)---------------
SELECT id_nf, id_item, cod_prod, valor_unit, valor_unit, quantidade*valor_unit as valor_total, 
valor_unit - (valor_unit*(desconto/100)) as valor_vendido
FROM vendas

--E)---------------
SELECT id_nf, SUM(quantidade*valor_unit) as valor_total
FROM vendas
GROUP by id_nf ORDEr by valor_total desc

--F)---------------
SELECT id_nf, SUM(quantidade*valor_unit) as valor_total, SUM(valor_unit - 
                 (valor_unit*(desconto/100))) As valor_vendido
FROM vendas
GROUP by id_nf 

--G)---------------
SELECT cod_prod, sum(quantidade) as quantidade
FROM vendas
GROUP by cod_prod

--H)---------------
SELECT id_nf, cod_prod, sum(quantidade) as quantidade
FROM vendas
GROUP by id_nf, cod_prod
HAVING sum(quantidade) > 10

--I)---------------
SELECT id_nf, sum(quantidade * valor_unit) as valor_total
FROM vendas
GROUP by id_nf
HAVING sum(quantidade * valor_unit) > 500
ORDER by valor_total desc

--J)---------------
SELECT cod_prod, AVG(desconto) as media
FROM vendas
GROUP by cod_prod

--K)---------------
SELECT cod_prod, min(desconto) as menor, max(desconto) as maior, avg(desconto) as media
FROM vendas
GROUP by cod_prod 

--L)---------------
SELECT id_nf, COUNT(*) as qtd_itens
FROM vendas
GROUP by id_nf 
HAVING COUNT(*) > 3

--2================

--A)---------------
SELECT DISTINCT mat
FROM historico
WHERE cod_disc = 'BD' and ano = 2015 ANd nota < 5

--B)---------------

SELECT mat, 
       (SELECT nota
        FROM historico 
        WHERE cod_disc = 'POO' AND ANO = 2015 AND historico.MAT = alunos.MAT) AS nota_POO
FROM Alunos

--C)---------------
SELECT mat, 
       (SELECT nota
        FROM historico 
        WHERE cod_disc = 'POO' AND ANO = 2015 AND historico.MAT = alunos.MAT and historico.nota > 6) AS nota_POO
FROM Alunos

--D)---------------
SELECT COUNT(*) AS total_alunos
FROM Alunos
WHERE cidade <> 'NATAL'






