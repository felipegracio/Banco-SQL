CREATE DATABASE loja
GO
USE loja

CREATE TABLE cliente(

CPF      VARCHAR(11)       NOT NULL,
nome     VARCHAR(60)       NOT NULL,
telefone VARCHAR (8)       NOT NULL

PRIMARY KEY (CPF)
)

GO

CREATE TABLE fornecedor(
ID     INT    NOT NULL,
nome_for  VARCHAR(40)   NOT NULL,
logradouro VARCHAR (40) NOT NULL,
numero INT   NOT NULL,
complemento VARCHAR (40) NOT NULL,
cidade VARCHAR(30)  NOT NULL
PRIMARY KEY (ID)



)
GO



CREATE TABLE produto(

codigo    INT      NOT NULL,
descricao VARCHAR(100)  NOT NULL,
fornec INT      NOT NULL,
preco     DECIMAL(7,2)   NOT NULL

PRIMARY KEY (codigo)
FOREIGN KEY (fornec) REFERENCES fornecedor(ID)


)
GO

CREATE TABLE venda (

codigo_ven     INT    NOT NULL,
prod           INT    NOT NULL,
client         VARCHAR(11) NOT NULL,
quant          INT       NOT NULL,
valo_tot       DECIMAL(7,2) NOT NULL,
data           DATE        NOT NULL,

PRIMARY KEY(codigo_ven, prod, client),
FOREIGN KEY (prod) REFERENCES produto(codigo),
FOREIGN KEY (client) REFERENCES cliente (CPF)

)

SELECT * FROM cliente
SELECT * FROM fornecedor
SELECT * FROM venda
SELECT * FROM produto


--1)
-- Consultar no formato dd/mm/aaaa:
-- Data da Venda 4

SELECT CONVERT(CHAR(10), data, 103) AS data 
FROM venda
WHERE codigo_ven = 4


--2) Inserir na tabela Fornecedor, a coluna Telefone	
--e os seguintes dados:	
--1 7216-5371
--2	8715-3738
--4	3654-6289

ALTER TABLE fornecedor
ADD telefone   CHAR(8)    NULL

UPDATE fornecedor
SET telefone = '72165371'
WHERE ID = 1

UPDATE fornecedor
SET telefone = '87153738'
WHERE ID = 2

UPDATE fornecedor
SET telefone = '36546289'
WHERE ID = 4

--3) Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores

SELECT nome_for, logradouro +','+ CAST(numero AS VARCHAR(5) ) +','+complemento+'-'+cidade AS Endereco_completo, 
SUBSTRING(telefone, 1,4)+'-'+SUBSTRING(telefone,5,8) AS Telefone
FROM fornecedor
ORDER BY nome_for ASC

--4) Produto, quantidade e valor total do comprado por Julio Cesar

SELECT prod, quant, valo_tot
FROM venda
WHERE client IN

(
SELECT CPF
FROM cliente
WHERE nome LIKE 'Julio Cesar'
)

--5) Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar
SELECT CONVERT(CHAR(10), data, 103) AS data, valo_tot
FROM venda
WHERE client IN

(
SELECT CPF
FROM cliente
WHERE nome LIKE 'Paulo Cesar'

)


--6) Consultar, em ordem decrescente, o nome e o preço de todos os produtos 
SELECT descricao, preco
FROM produto
ORDER BY preco, descricao desc 