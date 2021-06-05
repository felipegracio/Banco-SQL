CREATE DATABASE mercado
GO
USE mercado
GO

CREATE TABLE cliente 

(
codigo     INT             NOT NULL,
nome       VARCHAR(60)     NOT NULL,
endereco   VARCHAR(60)     NOT NULL,
telefone   VARCHAR(8)      NOT NULL,
comercial  VARCHAR(8)      NULL

PRIMARY KEY (codigo)

) 
GO


CREATE TABLE mercadoria
(
codigo_mer   INT             NOT NULL,
nome_mer     VARCHAR(60)     NOT NULL,
corredor     INT             NOT NULL,
tipo         INT             NOT NULL,
valor        DECIMAL(7,2)    NOT NULL

PRIMARY KEY(codigo_mer)
FOREIGN KEY (corredor) REFERENCES corredores(codigo_cor),
FOREIGN KEY (tipo) REFERENCES tipo_merc(codigo),
)
GO


CREATE TABLE corredores
(
codigo_cor        INT       NOT NULL,
tipo_cor          INT           NULL,
nome_cor          VARCHAR(40)   NULL
PRIMARY KEY(codigo_cor)
FOREIGN KEY (tipo_cor) REFERENCES tipo_merc(codigo)
)
GO

CREATE TABLE tipo_merc
(
codigo      INT      NOT NULL,
nome_tipo_merc      VARCHAR(60)   NOT NULL,
PRIMARY KEY (codigo)
)
GO


CREATE TABLE compra

(
nota            INT        NOT NULL,
codigo_cli      INT        NOT NULL,
valor           DECIMAL(7,2)    NOT NULL

PRIMARY KEY(nota)
FOREIGN KEY (codigo_cli) REFERENCES cliente(codigo)
)



SELECT * FROM cliente
SELECT * FROM compra
SELECT * FROM tipo_merc
SELECT * FROM corredores
SELECT * FROM mercadoria



--1)Valor da Compra de Luis Paulo

SELECT com.valor
FROM compra com, cliente cl
WHERE com.codigo_cli = cl.codigo
AND  cl.nome LIKE 'Luis Paulo%'
GROUP BY com.valor


--2)Valor da Compra de Marcos Henrique

SELECT com.valor
FROM compra com, cliente cl
WHERE com.codigo_cli = cl.codigo
AND  cl.nome LIKE 'Marcos%'
GROUP BY com.valor


--3)Endereço e telefone do comprador de Nota Fiscal = 4567

SELECT cl.endereco, cl.telefone
FROM compra com, cliente cl
WHERE com.codigo_cli = cl.codigo
AND  com.nota=4567
GROUP BY cl.endereco, cl.telefone



--4)Valor da mercadoria cadastrada do tipo " Pães"

SELECT mer.valor
FROM mercadoria mer
WHERE mer.tipo IN

(
SELECT ti.codigo
FROM tipo_merc ti
WHERE ti.nome_tipo_merc LIKE 'Pães'


)



--5)Nome do corredor onde está a Lasanha
SELECT cor.nome_cor
FROM mercadoria mer, corredores cor
WHERE mer.corredor = cor.codigo_cor
AND mer.nome_mer LIKE 'Lasanha'
GROUP BY cor.nome_cor




--6)Nome do corredor onde estão os clorados

SELECT cor.nome_cor
FROM mercadoria mer, corredores cor, tipo_merc ti
WHERE mer.corredor = cor.codigo_cor
AND cor.tipo_cor = ti.codigo
AND ti.nome_tipo_merc LIKE 'Clorados'
GROUP BY cor.nome_cor
