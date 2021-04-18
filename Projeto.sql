CREATE DATABASE PROJETO
GO
USE PROJETO

CREATE TABLE PROJECTS(

id				INT			  NOT NULL			IDENTITY(10001,1),
nome			VARCHAR(50)   NOT NULL,
descrição		VARCHAR(45)	  NULL,
data_projeto 	DATE		  NOT NULL			CHECK(data_projeto > '2014-09-01')
PRIMARY KEY(id)
)

CREATE TABLE USERS(
id				INT				      NOT NULL	IDENTITY(1,1),
nome			VARCHAR(45)			  NOT NULL,
username		VARCHAR(10)			  NOT NULL  UNIQUE,
senha		    VARCHAR(8)			  NOT NULL	DEFAULT( '123mudar'),
email		    VARCHAR(45)			  NOT NULL
PRIMARY KEY(id)

)

CREATE TABLE USERS_HAS_PROJECT(

users_id		INT			NOT NULL,
projects_id		INT			NOT NULL
FOREIGN KEY (users_id) REFERENCES USERS(id),
FOREIGN KEY (projects_id) REFERENCES PROJECTS(id)

)

EXEC sp_help USERS
EXEC sp_help PROJECTS

ALTER TABLE USERS
ALTER COLUMN username  VARCHAR(10)  NOT NULL

ALTER TABLE USERS
ALTER COLUMN senha  VARCHAR(8)  NOT NULL


INSERT INTO USERS(nome, username, senha, email) VALUES

('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
 ('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
(' Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')


INSERT INTO PROJECTS(nome, descrição, data_projeto) VALUES

('Re-folha', 'Refatoração das Folhas', '2014-09-05'),
(' Manutenção PC','Manutenção PC´s', '2014-09-06'),
('Auditoria', NULL, '2014-09-07')


INSERT INTO USERS_HAS_PROJECT(users_id,projects_id)VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

SELECT * FROM USERS
SELECT * FROM PROJECTS


UPDATE PROJECTS
SET data_projeto = '2014-09-12'
WHERE id = 10002

UPDATE USERS
SET username = 'Rh_cido'
WHERE nome = 'Aparecido'

UPDATE USERS
SET senha = '888@*'
WHERE id = 1

DELETE USERS_HAS_PROJECT
WHERE users_id = 2

DELETE USERS
WHERE nome = 'Paulo'

