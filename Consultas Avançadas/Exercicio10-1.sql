--1================
SELECT e.dept, e.sobrenome
FROM empr e
WHERE e.dept = (
    SELECT e2.dept
    FROM empr e2
    WHERE e2.sobrenome = 'BROWN'
);
  
--2================
SELECT empr.sobrenome, empr.cargo
FROM empr
JOIN dept ON empr.dept = dept.dcodigo
WHERE dept.dnome LIKE '%CENTRO%'

--3================
SELECT dept.dcodigo, AVG(empr.salario) 
FROM empr
JOIN dept ON empr.dept = dept.dcodigo
GROUP BY dept.dcodigo
HAVING AVG(empr.salario) < (SELECT AVG(salario) FROM empr)
ORDER by AVG(empr.salario)

--4================
SELECT empr.matr, empr.nome, empr.sobrenome
FROM empr
JOIN dept ON empr.dept = dept.dcodigo
WHERE empr.sexo = 'F' AND empr.salario > (
  SELECT AVG(salario)
  FROM empr
  WHERE sexo = 'M' AND dept LIKE 'E%'
)
AND dept.dcodigo LIKE 'E%'

--5================
SELECT empr.nome, empr.sobrenome, empr.salario
FROM empr
JOIN dept ON empr.dept = dept.dcodigo
WHERE empr.sexo = 'F' AND empr.salario < (
  SELECT AVG(salario)
  FROM empr empr_homem
  WHERE empr_homem.sexo = 'M' AND empr_homem.dept = empr.dept
)

--6================
SELECT empr.nome, empr.sobrenome, empr.salario
FROM empr
JOIN dept ON empr.dept = dept.dcodigo
WHERE dept.dcodigo = 'E11' AND empr.salario < all(
  SELECT AVG(salario)
  FROM empr 
  GROUP by dept
)

--7================
SELECT empr.nome, empr.sobrenome, empr.fone, empr.dinadim, empr.cargo
FROM empr
JOIN (
  SELECT MIN(dinadim) as min_admissao
  FROM empr
) empr_antigo
ON empr.dinadim = empr_antigo.min_admissao

--8================
SELECT DISTINCT dept.dcodigo
FROM dept
JOIN empr ON dept.dcodigo = empr.dept
WHERE empr.cargo IN (
  SELECT cargo
  FROM empr
  WHERE dept = 'A00'
)

--9================
SELECT dept.dcodigo AS departamento,
       empr.sobrenome AS sobrenome,
       empr.cargo AS funcao,
       empr.comis AS comissao,
       empr.bonus AS bonus
FROM empr
INNER JOIN dept ON empr.dept = dept.dcodigo
WHERE empr.cargo NOT IN ('PRES', 'GERENTE')
AND (
  empr.comis = (
    SELECT MAX(empr2.comis)
    FROM empr AS empr2
    WHERE empr2.cargo NOT IN ('PRES', 'GERENTE') AND empr2.dept = empr.dept
  ) OR
  empr.bonus = (
    SELECT MAX(empr3.bonus)
    FROM empr AS empr3
    WHERE empr3.cargo NOT IN ('PRES', 'GERENTE') AND empr3.dept = empr.dept
  )
)
ORDER BY dept.dcodigo, empr.sobrenome;

--10================
SELECT cargo
FROM empr
GROUP BY cargo
ORDER BY cargo
LIMIT 2;

--11================
SELECT d.dnome, e.nome, e.sobrenome, e.cargo, e.salario
FROM dept d JOIN empr e ON d.dcodigo = e.dept
WHERE d.dcodigo IN (
    SELECT e.dept
    FROM empr e
    WHERE e.sexo = 'F'
    GROUP BY e.dept
    HAVING COUNT(*) = COUNT(CASE WHEN e.sexo = 'F' THEN 1 END)
) AND e.sexo = 'F' AND e.salario > (
    SELECT MAX(e2.salario)
    FROM empr e2
    WHERE e2.sexo = 'M' AND e2.dept = e.dept
)
ORDER BY d.dnome
LIMIT 1;
