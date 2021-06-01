CREATE DATABASE exaula2
GO
USE exaula2
GO
CREATE TABLE fornecedor (
ID				INT				NOT NULL	PRIMARY KEY,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(70)		NOT NULL
)
GO
CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL		PRIMARY KEY,
nome		VARCHAR(50)		NOT NULL,	
telefone	VARCHAR(9)		NOT NULL,
)
GO
CREATE TABLE produto (
codigo		INT				NOT NULL	PRIMARY KEY,
descricao	VARCHAR(50)		NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)
GO
CREATE TABLE venda (
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(11)		NOT NULL,
quantidade		INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente, data)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)


--1) Quantos produtos não foram vendidos (nome da coluna qtd_prd_nao_vend) ?

SELECT COUNT(pr.codigo) AS qtd_prd_nao_ven
FROM produto pr
WHERE pr.codigo NOT IN 
(
SELECT ve.produto
FROM venda ve
)


--2) Descrição do produto, Nome do fornecedor, count() do produto nas vendas
SELECT pr.descricao, fo.nome, COUNT(ve.quantidade) AS QUANTIDADE_VENDIDA
FROM produto pr, fornecedor fo, venda ve
WHERE pr.codigo = ve.produto
AND pr.fornecedor = fo.ID
GROUP BY pr.descricao, fo.nome


--3) --Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade
SELECT cl.nome, SUM(ve.quantidade) AS prod_comprados
FROM cliente cl,venda ve
WHERE cl.cpf = ve.cliente
GROUP BY cl.nome



--4) Descrição do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos
SELECT TOP 1 pr.descricao, ve.quantidade 
FROM produto pr, venda ve
WHERE pr.codigo = ve.produto
GROUP BY pr.descricao, ve.quantidade, pr.preco
ORDER BY pr.preco asc

--5) Nome do Fornecedor e Quantos produtos cada um fornece

SELECT fo.nome, COUNT(pr.fornecedor) AS Quant_prod_forne
FROM fornecedor fo, produto pr
WHERE fo.ID = pr.fornecedor
GROUP BY fo.nome



--6) Considerando que hoje é 20/10/2019, consultar, sem repetições, o código da compra, nome do cliente, 
--telefone do cliente (Mascarado XXXX-XXXX ou XXXXX-XXXX) e quantos dias da data da compra
SELECT ve.codigo, cl.nome, 
CASE
	WHEN LEN(cl.telefone)=9 THEN
		SUBSTRING(cl.telefone, 1,5)+'-'+SUBSTRING(cl.telefone, 6,4)
     ELSE
		SUBSTRING(cl.telefone, 1,4)+'-'+SUBSTRING(cl.telefone, 5,4)
		END AS telefone_mascarado,
DATEDIFF(DAY, ve.data, '2019-10-20') AS data_da_venda
FROM venda ve, cliente cl
WHERE ve.cliente = cl.cpf
GROUP BY ve.codigo, cl.nome, cl.telefone, ve.data


--7) CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade comprada dos clientes que compraram mais de 2 produtos

SELECT SUBSTRING(cl.cpf, 1,3)+'.'+SUBSTRING(cl.cpf, 4,3)+'.'+SUBSTRING(cl.cpf, 7,3)+'-'+SUBSTRING(cl.cpf, 10,2) AS cpf_mascarado,
cl.nome, SUM(ve.quantidade) AS quantidade_comprada
FROM cliente cl, venda ve
WHERE cl.cpf = ve.cliente
GROUP BY cl.cpf, cl.nome
HAVING SUM(ve.quantidade) > 2

--8) Sem repetições, Código da venda, CPF do cliente, mascarado (XXX.XXX.XXX-XX), 
--Nome do Cliente e Soma do valor_total gasto(valor_total_gasto = preco do produto * quantidade de venda).Ordenar por nome do cliente

SELECT ve.codigo, SUBSTRING(cl.cpf, 1,3)+'.'+SUBSTRING(cl.cpf, 4,3)+'.'+SUBSTRING(cl.cpf, 7,3)+'-'+SUBSTRING(cl.cpf, 10,2) AS cpf_mascarado,
cl.nome, SUM(ve.quantidade*pr.preco) AS valor_total_gasto
FROM venda ve, cliente cl, produto pr 
WHERE cl.cpf = ve.cliente
AND ve.produto = pr.codigo
GROUP BY ve.codigo,cl.cpf, cl.nome 


--9) Código da venda, data da venda em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado

SET LANGUAGE 'Brazilian'
SELECT ve.codigo, CONVERT(CHAR(10), ve.data, 103) AS data_venda, DATENAME(WEEKDAY, ve.data) AS dia_da_semana
FROM venda ve
