--1================
SELECT seccao.nome, seccao.cidade 
FROM seccao 
WHERE seccao.numsec = 70

--2================
SELECT posto, salario, comissao 
FROM empregado 
WHERE comissao > salario

--3================
SELECT nome
FROM seccao
WHERE cidade = 'Porto'

--4================
SELECT DISTINCT posto
FROM empregado

--5================
SELECT e.nome, e.posto, e.seccao
FROM empregado e
WHERE e.seccao IN (20, 30, 40)

--6================
SELECT SUM(salario) AS total_gasto, posto
FROM empregado
WHERE posto IN ('Engenheiro', 'Programador')
GROUP BY posto

--7================
SELECT numemp, nome, posto
FROM empregado
ORDER BY numemp

--8================
SELECT seccao.numsec, seccao.nome, COUNT(empregado.numemp) AS total_empregados, SUM(empregado.salario) AS total_salarios
FROM seccao
LEFT JOIN empregado ON empregado.seccao = seccao.numsec
GROUP BY seccao.numsec, seccao.nome

--9================
SELECT s.numsec AS "Número da Seção", e.posto AS "Posto",
  COUNT(e.numemp) AS "Número de Empregados", AVG(e.salario) AS "Salário Médio"
FROM seccao s
INNER JOIN empregado e ON s.numsec = e.seccao
WHERE s.numsec IN (10, 20, 30)
GROUP BY s.numsec, e.posto

--10================
SELECT s.numsec, COUNT(*) as total_vendedores, SUM(e.salario * 12) as gastos_anuais
FROM empregado e
INNER JOIN seccao s ON e.seccao = s.numsec
WHERE e.posto = 'Comercial'
GROUP BY s.numsec

--11================
SELECT seccao, AVG(num_empregados) as media_empregados
FROM (
  SELECT seccao, COUNT(*) as num_empregados
  FROM empregado
  GROUP BY seccao
) t
GROUP BY seccao

--12================
SELECT posto, AVG(salario) AS salario_medio
FROM empregado
WHERE posto != 'Presidente'
GROUP BY posto

--13================
SELECT nome, posto
FROM empregado
WHERE salario + coalesce(comissao,0) = (
   SELECT MAX(salario + coalesce(comissao,0))
   FROM empregado
   WHERE posto <> 'Presidente'
);

--14================
SELECT e1.nome, e1.posto, e1.salario 
FROM empregado e1 
INNER JOIN empregado e2 ON e1.posto = e2.posto AND e1.salario = e2.salario AND e2.seccao = 10
WHERE e1.seccao <> 10;

--15================
SELECT e.seccao AS numsec, 
       e.nome, 
       e.posto, 
       e.salario*12 AS salario_total
FROM empregado e 
WHERE e.salario*12 = (SELECT MAX(e2.salario*12) 
                      FROM empregado e2 
                      WHERE e2.salario*12 < (SELECT MAX(e3.salario*12) 
                                             FROM empregado e3))

--16================
SELECT e.seccao , e.nome , e.posto , SUM(e.salario) + SUM(e.comissao) AS salario_total, SUM(e.comissao) AS comissao
FROM empregado e
WHERE e.seccao = 20 OR (e.posto = 'Comercial' AND e.salario + e.comissao = (
    SELECT MAX(e2.salario + e2.comissao)
    FROM empregado e2
    WHERE e2.posto = 'Comercial'
))
GROUP BY e.seccao, e.nome, e.posto
ORDER BY salario_total DESC;

--17================
SELECT seccao.numsec, AVG(empregado.salario) as media_salario
FROM empregado
INNER JOIN seccao ON empregado.seccao = seccao.numsec
GROUP BY seccao.numsec
HAVING AVG(empregado.salario) > 200000

--18================
SELECT seccao.numsec, COUNT(empregado.numemp) AS num_vendedores
FROM empregado
JOIN seccao ON empregado.seccao = seccao.numsec
WHERE empregado.posto = 'Vendedor'
GROUP BY seccao.numsec
HAVING COUNT(empregado.numemp) > 2

--19================
SELECT seccao.numsec, AVG(empregado.salario) AS salario_medio
FROM empregado
JOIN seccao ON empregado.seccao = seccao.numsec
GROUP BY seccao.numsec
HAVING AVG(empregado.salario) >= ALL (
    SELECT AVG(empregado.salario)
    FROM empregado
    JOIN seccao ON empregado.seccao = seccao.numsec
    GROUP BY seccao.numsec
)

--20================
SELECT empregado.nome, empregado.posto, empregado.salario
FROM empregado
JOIN (
  SELECT seccao.numsec, AVG(empregado.salario) AS media_salario
  FROM empregado
  JOIN seccao ON empregado.seccao = seccao.numsec
  GROUP BY seccao.numsec
  ORDER BY media_salario DESC
  LIMIT 1
) AS subquery ON empregado.seccao = subquery.numsec

--21================
SELECT empregado.nome, seccao.*
FROM empregado
JOIN seccao ON empregado.seccao = seccao.numsec

--22================
SELECT e.nome, e.salario, c.nome as chefe, c.salario as salario_chefe
FROM empregado e
JOIN empregado c ON e.chefe = c.numemp
WHERE e.salario > c.salario

--23================
SELECT emp.nome AS empregado_nome, emp_cidade.nome AS empregado_cidade, 
       chefe.nome AS chefe_nome, chefe_cidade.nome AS chefe_cidade
FROM empregado AS emp
INNER JOIN seccao AS emp_cidade ON emp_cidade.numsec = emp.seccao
INNER JOIN empregado AS chefe ON chefe.numemp = emp.chefe
INNER JOIN seccao AS chefe_cidade ON chefe_cidade.numsec = chefe.seccao
WHERE emp_cidade.cidade <> chefe_cidade.cidade

--24================
SELECT e1.nome, e1.posto, e1.salario+e1.comissao
FROM empregado e1
WHERE e1.salario+e1.comissao > 0.25 * (
  SELECT SUM(e2.salario+e2.comissao)
  FROM empregado e2
  WHERE e2.posto = e1.posto
  GROUP BY e2.posto
  HAVING COUNT(*) >= 3
) AND e1.posto IN (
  SELECT e3.posto
  FROM empregado e3
  GROUP BY e3.posto
  HAVING COUNT(*) >= 3
)
ORDER BY e1.posto, e1.nome;
