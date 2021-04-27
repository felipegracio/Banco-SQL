CREATE DATABASE Locadora
GO
USE Locadora

CREATE TABLE FILME(
id		INT				NOT NULL        IDENTITY(1001,1),
titulo	VARCHAR(40)		NOT NULL,
ano		INT				    NULL		CHECK (ano <= 2021)
PRIMARY KEY (id)
)

CREATE TABLE DVD (
num		INT				NOT NULL        IDENTITY(10001,1),
data_fabricação	DATE	NOT NULL		CHECK(data_fabricação <= GETDATE()),
FilmeId		INT			NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(FilmeId) REFERENCES FILME(id)

)

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

 

CREATE TABLE CLIENTE(
num_Cadastro  INT	        NOT NULL          IDENTITY(5501,1),
nome          VARCHAR(70)   NOT NULL,
logradouro    VARCHAR(150)  NOT NULL,
num	          INT           NOT NULL          CHECK (num >=0),
cep	          VARCHAR(8)    NULL              CHECK (LEN(cep)=8)
PRIMARY KEY (num_Cadastro)

)

CREATE TABLE ESTRELA(
id    INT    NOT NULL		IDENTITY(9901, 1),
nome  VARCHAR(50) NOT NULL
PRIMARY KEY(id)

)

CREATE TABLE FILME_ESTRELA(

FilmeId    INT       NOT NULL,
EstrelaId  INT       NOT NULL
FOREIGN KEY (FilmeId) REFERENCES FILME(id),
FOREIGN KEY (EstrelaId) REFERENCES ESTRELA(id)

)


ALTER TABLE FILME
ALTER COLUMN titulo VARCHAR(80)  NOT NULL

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
(10001,5502, '2021-04-17', '2021-04-19', 3.50),
(10009,5502, '2021-04-18', '2021-04-19', 3.50),
(10002,5503, '2021-04-19', '2021-04-20', 3.50),
(10002,5505, '2021-04-20', '2021-04-21', 3.00),
(10004,5505, '2021-04-21', '2021-04-22', 3.00),
(10005,5505, '2021-04-22', '2021-04-23', 3.00),
(10001,5501, '2021-04-23', '2021-04-24', 3.50),
(10008,5501, '2021-04-24', '2021-04-24', 3.50)


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



