-------------------1
SELECT sobrenome, nome, dept, datanas, dinadim, salario 
FROM empr 
WHERE salario > 30000
-------------------2
SELECT * FROM dept WHERE gerente is NULL
-------------------3
SELECT sobrenome, nome, dept, datanas, dinadim, salario 
FROM empr 
WHERE salario < 20000 ORDER BY sobrenome, nome
-------------------4
SELECT * FROM dept 
WHERE dsuper = 'A00'
-------------------5
SELECT dcodigo, dnome
FROM dept
WHERE dnome LIKE '%SERVIÇO%'
-------------------6
SELECT matr, sobrenome, nome, dept, fone
FROM empr
WHERE dept = 'D11' OR dept = 'D21'
-------------------7
SELECT sobrenome, dept, salario+comis AS rendimento
FROM empr
WHERE dept = 'B01' OR dept = 'C01' OR dept = 'D01' ORDER BY rendimento DESC
-------------------8
SELECT sobrenome, dept, salario
FROM empr
WHERE salario/12 > 3000 ORDER BY sobrenome
-------------------9
SELECT nome, sobrenome, matr
FROM empr
WHERE dept LIKE'E%' ORDER BY sobrenome
-------------------10
SELECT matr, sobrenome, salario/12
FROM empr
WHERE sexo = 'M' AND salario/12 < 1600 ORDER BY salario/12 DESC
-------------------11
SELECT sobrenome, comis*100/(salario+comis+bonus) as rendimento
FROM empr
WHERE cargo = 'REPVENDA'
-------------------12
SELECT * FROM dept
WHERE dcodigo = 'E01' OR dsuper = 'E01'	
-------------------13
SELECT sobrenome, salario, cargo, niveled
FROM empr
WHERE salario > 40000 OR cargo = 'GERENTE' AND niveled < 16








