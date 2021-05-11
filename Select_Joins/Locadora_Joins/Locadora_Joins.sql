DROP DATABASE Locadora
USE master
CREATE DATABASE Locadora
GO
USE Locadora

CREATE TABLE FILME(
id		INT				NOT NULL        IDENTITY(1001,1),
titulo	VARCHAR(40)		NOT NULL,
ano		INT				    NULL		CHECK (ano <= 2021)
PRIMARY KEY (id)
)
GO
CREATE TABLE DVD (
num		INT				NOT NULL        IDENTITY(10001,1),
data_fabricação	DATE	NOT NULL		CHECK(data_fabricação <= GETDATE()),
FilmeId		INT			NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(FilmeId) REFERENCES FILME(id)

)
GO

CREATE TABLE LOCACAO(
DVDnum			INT		NOT NULL,		
data_locação	DATE	NOT NULL		DEFAULT(GETDATE()),
Clientenum_Cadastro INT NOT NULL,
data_devolução  DATE    NOT NULL      CHECK(data_devolução >= GETDATE()),
valor           DECIMAL(7,2) NOT NULL   CHECK(valor>=0)
PRIMARY KEY(data_locação),
FOREIGN KEY (DVDnum) REFERENCES DVD (num),
FOREIGN KEY (Clientenum_Cadastro) REFERENCES CLIENTE (num_Cadastro)

)

GO 

CREATE TABLE CLIENTE(
num_Cadastro  INT	        NOT NULL          IDENTITY(5501,1),
nome          VARCHAR(70)   NOT NULL,
logradouro    VARCHAR(150)  NOT NULL,
num	          INT           NOT NULL          CHECK (num >=0),
cep	          VARCHAR(8)    NULL              CHECK (LEN(cep)=8)
PRIMARY KEY (num_Cadastro)

)
GO

CREATE TABLE ESTRELA(
id    INT    NOT NULL		IDENTITY(9901, 1),
nome  VARCHAR(50) NOT NULL
PRIMARY KEY(id)

)
GO

CREATE TABLE FILME_ESTRELA(

FilmeId    INT       NOT NULL,
EstrelaId  INT       NOT NULL
FOREIGN KEY (FilmeId) REFERENCES FILME(id),
FOREIGN KEY (EstrelaId) REFERENCES ESTRELA(id)

)

GO

ALTER TABLE FILME
ALTER COLUMN titulo VARCHAR(80)  NOT NULL
GO

ALTER TABLE ESTRELA
ADD nome_real VARCHAR(50)  NULL  


EXEC sp_help ESTRELA
EXEC SP_help FILME
EXEC sp_help LOCACAO
EXEC Sp_help DVD
EXEC sp_help CLIENTE
EXEC sp_help FILME_ESTRELA


INSERT INTO ESTRELA(nome, nome_real)VALUES
( 'Michael Keaton', 'Michael John Douglas'),
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', NULL),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')

SELECT * FROM ESTRELA
SELECT * FROM FILME_ESTRELA
SELECT * FROM FILME
SELECT * FROM DVD
SELECT * FROM CLIENTE
SELECT * FROM LOCACAO

INSERT INTO FILME (titulo, ano) VALUES
('Whiplash', 2015),
('Birdman', 2015),
('Interestelar', 2014),
('A Culpa é das estrelas', 2014),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso',2014),
('Sing', 2016)

INSERT INTO FILME_ESTRELA (FilmeId, EstrelaId) VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)


INSERT INTO DVD( data_fabricação, FilmeId) VALUES
('2020-12-02', 1001),
('2019-10-18', 1002),
('2020-04-03', 1003),
('2020-12-02', 1001),
('2019-10-18', 1004),
('2020-04-03', 1002),
('2020-12-02', 1005),
('2019-10-18', 1002),
('2020-04-03', 1003)

INSERT INTO CLIENTE(nome, logradouro, num, cep) VALUES

('Matilde Luz', 'Rua Síria', 150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO LOCACAO (DVDnum,Clientenum_Cadastro, data_locação, data_devolução, valor) VALUES
(10001,5502, '2021-05-17', '2021-05-19', 3.50),
(10009,5502, '2021-05-18', '2021-05-19', 3.50),
(10002,5503, '2021-05-19', '2021-05-20', 3.50),
(10002,5505, '2021-05-20', '2021-05-21', 3.00),
(10004,5505, '2021-05-21', '2021-05-22', 3.00),
(10005,5505, '2021-05-22', '2021-05-23', 3.00),
(10001,5501, '2021-05-23', '2021-05-24', 3.50),
(10008,5501, '2021-05-24', '2021-05-24', 3.50)


UPDATE CLIENTE 
SET cep =  '08411150'
WHERE num_Cadastro = 5503

UPDATE CLIENTE 
SET cep =  '02918190'
WHERE num_Cadastro = 5504

UPDATE LOCACAO
SET valor = 3.25
WHERE Clientenum_Cadastro = 5502

UPDATE LOCACAO
SET valor = 3.10
WHERE Clientenum_Cadastro = 5501

UPDATE DVD
SET data_fabricação = '2019-07-14'
WHERE num = 10005

UPDATE ESTRELA
SET nome_real = 'Miles Alexander Teller'
WHERE id = 9903

DELETE FILME
WHERE titulo = 'Sing'

SELECT titulo, ano FROM FILME
WHERE ano = 2014
GO
SELECT id,titulo, ano FROM FILME
WHERE titulo = 'Birdman'

GO
SELECT id,titulo, ano FROM FILME
WHERE titulo LIKE '%plash'

GO
SELECT id, nome, nome_real FROM ESTRELA
WHERE nome LIKE 'Steve%'

GO
SELECT FilmeId, CONVERT(CHAR(10), data_fabricação, 103) AS fab 
FROM DVD
WHERE  data_fabricação > '01/01/2020'

GO
SELECT DVDnum, data_locação, data_devolução, valor, CAST(valor*1.02 AS DECIMAL(7,2))AS Multa 
FROM LOCACAO
WHERE Clientenum_Cadastro = 5505 

GO
SELECT logradouro + ' ' + CAST(num AS VARCHAR(5)) + ' , ' + cep AS Endereço_Completo 
FROM CLIENTE
WHERE nome = 'Matilde Luz'

GO
SELECT nome, nome_real 
FROM ESTRELA
WHERE nome LIKE '%Michael Keato%'

GO
SELECT num_Cadastro, nome, logradouro + ' ' + CAST(num AS VARCHAR(5)) + ' , ' + cep AS End_Completo    
FROM CLIENTE
WHERE num_Cadastro >=5503


-- SELECT CASE E SUBQUERY

--1
SELECT id, ano,
 CASE
	WHEN LEN(titulo) >10  THEN
	SUBSTRING (titulo, 1, 10 )+'...'
		ELSE
	titulo
	END AS Titulo
FROM FILME


--2
SELECT num, data_fabricação,
	DATEDIFF(MONTH, data_fabricação, GETDATE()) AS qtd_meses_desde_fabricacao
FROM DVD
WHERE FilmeId IN
(
	SELECT id
	FROM FILME
	WHERE titulo = 'Interestelar'

)


--3
SELECT DVDnum, data_locação, data_devolução,
	DATEDIFF(DAY, data_locação, data_devolução) AS dias_alugados
FROM LOCACAO
WHERE Clientenum_Cadastro IN
(
SELECT num_Cadastro
FROM CLIENTE
WHERE nome LIKE '%Rosa%'
)

--4
SELECT nome, num_Cadastro, 
		logradouro + ' ' + CAST(num AS VARCHAR(5)) + ' , ' + SUBSTRING(cep, 1, 5) +'-'+SUBSTRING(cep,6,3)  AS Endereço_Completo
FROM CLIENTE
WHERE num_Cadastro IN
(
SELECT Clientenum_Cadastro
FROM LOCACAO
WHERE DVDnum IN
(
SELECT num
FROM DVD
WHERE num = 10002
)
)

-- JOINS 

--1) Consultar num_cadastro do cliente, nome do cliente, data_locacao (Formato 
--dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado), titulo do 
--filme, ano do filme da locação do cliente cujo nome inicia com Matilde


SELECT cl.num_Cadastro, cl.nome, CONVERT(CHAR(10), loc.data_locação, 103) AS data_locação,
DATEDIFF(DAY, loc.data_locação, loc.data_devolução) AS dias_alugados, fil.ano, fil.titulo
FROM CLIENTE cl, LOCACAO loc, FILME fil, DVD dvd
WHERE cl.num_Cadastro = loc.Clientenum_Cadastro
AND  loc.DVDnum = dvd.num
AND  dvd.FilmeId = fil.id
AND  cl.nome LIKE 'Matilde%'

--2) Consultar nome da estrela, nome_real da estrela, título do filme dos filmes 
--cadastrados do ano de 2015

SELECT st.nome, st.nome_real, fil.titulo, fil.ano
FROM ESTRELA st, FILME fil, FILME_ESTRELA fil_st
WHERE  st.id = fil_st.EstrelaId
AND fil.id = fil_st.FilmeId
AND ano = 2015

--3) ) Consultar título do filme, data_fabricação do dvd (formato dd/mm/aaaa), caso a 
--diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a diferença 
--do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso 
--contrário só a diferença (Exemplo: 4).

SELECT fil.titulo, CONVERT(CHAR(10), dvd.data_fabricação, 103) AS data_fabricacao,
	CASE
		WHEN (YEAR(GETDATE()) - fil.ano > 6) THEN
			CAST((YEAR(GETDATE()) - fil.ano) AS VARCHAR(1)) + ' anos'
		ELSE
			CAST((YEAR(GETDATE()) - fil.ano) AS VARCHAR(1))
	END AS diferenca_ano_atual
FROM filme fil, dvd dvd
WHERE dvd.FilmeId = fil.id
