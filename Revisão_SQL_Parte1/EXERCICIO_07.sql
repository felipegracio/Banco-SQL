CREATE DATABASE pedidos
GO
USE pedidos
GO

CREATE TABLE clientes
(
RG              VARCHAR(9)   NOT NULL,
CPF             VARCHAR(11)  NOT NULL         UNIQUE,
nome            VARCHAR(60)  NOT NULL,
endereco_cli    VARCHAR(70)  NOT NULL


PRIMARY KEY (RG)
)
GO

CREATE TABLE pedido
(
nota_fiscal       INT     NOT NULL,
valor             DECIMAL(7,2)    NOT NULL,
data              DATE            NOT NULL,
rg_cliente        VARCHAR(9)      NOT NULL

PRIMARY KEY(nota_fiscal)
FOREIGN KEY(rg_cliente) REFERENCES clientes(RG)

)
GO

CREATE TABLE fornecedor

(
codigo     INT     NOT NULL,
nome_for   VARCHAR(30) NOT NULL,
end_for    VARCHAR(60) NOT NULL,
telefone   VARCHAR(13) NULL,
CGC        VARCHAR(14) NULL,
cidade     VARCHAR(20) NULL,
transporte VARCHAR(15) NULL,
pais       VARCHAR(4)  NULL,
moeda      VARCHAR(4)  NULL

PRIMARY KEY (codigo)



)
GO

CREATE TABLE mercadoria
(
cod_merc     INT    NOT NULL,
descricao    VARCHAR(30) NOT NULL,
preco        DECIMAL(7,2) NOT NULL,
qtd          INT          NOT NULL,
cod_forne    INT          NOT NULL

PRIMARY KEY (cod_merc)
FOREIGN KEY (cod_forne) REFERENCES fornecedor (codigo)

)

SELECT * FROM fornecedor
SELECT * FROM clientes
SELECT * FROM mercadoria
SELECT * FROM pedido


--1) Consultar 10% de desconto no pedido 1003

SELECT CAST(valor*0.9 AS DECIMAL(7,2)) AS valor_com_desconto
FROM pedido
WHERE nota_fiscal = 1003

--2) Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT CAST(valor*0.95 AS DECIMAL(7,2)) AS valor_com_desconto
FROM pedido
WHERE valor > 700.00


--3) Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10

SELECT CAST (mer.preco * 1.2 AS DECIMAL(7,2)) AS preco_acrescimo
FROM mercadoria mer
WHERE mer.qtd > 10



--4) Data e valor dos pedidos do Luiz

SELECT CONVERT(CHAR(10),ped.data, 103), ped.valor
FROM pedido ped
WHERE ped.rg_cliente IN
(
SELECT cl.RG
FROM clientes cl
WHERE cl.nome LIKE 'Luiz%'
)


-- 5) CPF, Nome e endereço do cliente de nota 1004
SELECT cl.CPF, cl.nome
FROM   clientes cl
WHERE cl.RG IN

(
SELECT ped.rg_cliente
FROM pedido ped
WHERE ped.nota_fiscal = 1004
)


--6) País e meio de transporte da Cx. De som
SELECT forn.pais, forn.transporte
FROM fornecedor forn
WHERE forn.codigo IN

(
SELECT mer.cod_forne
FROM mercadoria mer
WHERE mer.descricao LIKE 'Cx. De som'
)


--7) Nome e Quantidade em estoque dos produtos fornecidos pela Clone

SELECT mer.descricao, mer.qtd
FROM mercadoria mer
WHERE mer.cod_forne IN
(
SELECT forn.codigo
FROM fornecedor forn
WHERE forn.nome_for LIKE 'Clone'

)

--8) Endereço e telefone dos fornecedores do monitor

SELECT forn.end_for, forn.telefone
FROM fornecedor forn
WHERE forn.codigo IN

(
SELECT mer.cod_forne
FROM mercadoria mer
WHERE mer.descricao LIKE 'Monitor%'

)


--9) Tipo de moeda que se compra o notebook

SELECT forn.moeda
FROM fornecedor forn
WHERE forn.codigo IN

(
SELECT mer.cod_forne
FROM mercadoria mer
WHERE mer.descricao LIKE 'Notebook%'

)

--10) Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses

SELECT CASE
       WHEN DATEDIFF(MONTH, ped.data, GETDATE())> 6 THEN
	   'Pedido Antigo'
	   ELSE
	   CONVERT(VARCHAR(10), ped.data, 103)
	   END AS Pedido
FROM pedido ped






--11) Nome e Quantos pedidos foram feitos por cada cliente


SELECT cl.nome, COUNT(ped.rg_cliente) AS Pedidos_por_cliente
FROM pedido ped, clientes cl
WHERE cl.RG = ped.rg_cliente
GROUP BY cl.nome, ped.rg_cliente






--12) RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT cl.RG, cl.CPF, cl.endereco_cli
FROM clientes cl LEFT JOIN  pedido ped 
ON cl.RG = ped.rg_cliente
WHERE ped.rg_cliente IS NULL