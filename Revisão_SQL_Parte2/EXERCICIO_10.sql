CREATE DATABASE farmacia
GO
USE farmacia
GO

CREATE TABLE medicamentos(

codigo     INT       NOT NULL,
nome       VARCHAR(70) NOT NULL,
apresentacao VARCHAR(60) NOT NULL,
unidade      VARCHAR(20) NOT NULL,
preco        DECIMAL(7,3) NOT NULL

PRIMARY KEY (codigo)

)
GO

CREATE TABLE cliente(

CPF          VARCHAR(11)     NOT NULL,
nome		 VARCHAR(60)     NOT NULL,
rua          VARCHAR(70)     NOT NULL,
num          INT			 NOT NULL,
bairro       VARCHAR(50)     NOT NULL,
telefone     VARCHAR(11)     NOT NULL

PRIMARY KEY(CPF)

)
GO

CREATE TABLE venda(

nota         INT        NOT NULL,
CPF_cliente  VARCHAR(11) NOT NULL,
codigo_med   INT         NOT NULL,
quant        INT         NOT NULL,
valor		 DECIMAL(7,2) NOT NULL,
data         DATE        NOT NULL

PRIMARY KEY(nota,CPF_cliente ,codigo_med )
FOREIGN KEY (CPF_cliente) REFERENCES cliente(CPF),
FOREIGN KEY (codigo_med ) REFERENCES medicamentos(codigo)


)





--1) Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. 
--Caso a unidade de cadastro seja comprimido, mostrar Comp.

SELECT me.nome, me.apresentacao, me.unidade, me.preco
FROM  medicamentos me LEFT OUTER JOIN venda ve
ON me.codigo = ve.codigo_med
WHERE ve.codigo_med IS NULL



--2)Nome dos clientes que compraram Amiodarona
SELECT cl.nome
FROM cliente cl, medicamentos me, venda ve
WHERE cl.CPF = ve.CPF_cliente
AND ve.codigo_med = me.codigo
AND me.nome LIKE '%Amiodarona%'



--3) CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  
--apresentação do remédio, unidade, preço proposto, quantidade vendida e valor total dos remédios vendidos a Maria Zélia


SELECT cl.CPF, cl.rua+','+ CAST(cl.num AS VARCHAR(4)) + '-' + cl.bairro AS end_completo, me.nome AS nome_medicamento, me.apresentacao,
me.unidade, me.preco, ve.quant, ve.valor
FROM cliente cl, medicamentos me, venda ve
WHERE cl.CPF = ve.CPF_cliente
AND ve.codigo_med = me.codigo
AND cl.nome LIKE 'Maria Zélia'




--4) Data de compra, convertida, de Carlos Campos

SELECT CONVERT(VARCHAR(10), ve.data, 103) AS data_carlos
FROM venda ve, cliente cl
WHERE ve.CPF_cliente = cl.CPF
AND cl.nome LIKE 'Carlos Campos'


--5) Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
UPDATE medicamentos
SET nome = 'Cloridrato de Amitriptilina'
WHERE nome LIKE '%Amitriptilina(Cloridrato)%'