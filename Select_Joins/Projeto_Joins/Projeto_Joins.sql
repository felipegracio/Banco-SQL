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
SELECT * FROM USERS_HAS_PROJECT

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


--1
SELECT id, nome, email, username,
	CASE
		WHEN senha <> '123mudar' THEN
			'********'
		ELSE
			'123mudar'
		END AS formatted_password
FROM users


-- 2
SELECT nome, descrição, data_projeto AS data_inicial,
	DATEADD(DAY, 15, data_projeto) AS data_final
FROM PROJECTS
WHERE id IN
(
	SELECT projects_id
	FROM USERS_HAS_PROJECT
	WHERE users_id IN
	(
		SELECT id
		FROM users
		WHERE email = 'aparecido@empresa.com'
	)
)


-- 3
SELECT nome, email
FROM users
WHERE id IN
(
	SELECT users_id
	FROM USERS_HAS_PROJECT
	WHERE projects_id IN
	(
		SELECT id
		FROM projects
		WHERE nome = 'Auditoria'
	)
)


-- 4
SELECT nome, descrição, CONVERT(CHAR(10), data_projeto, 103) AS data_inicial,
	'16/09/2014' AS data_final,
	79.85 * DATEDIFF(DAY, data_projeto, '2014-09-16') AS custo_total
FROM projects
WHERE nome LIKE '%Manutenção%'



-- JOINS


--INSERTS NOVOS 


INSERT INTO users(nome, username, senha, email) VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')
GO

INSERT INTO projects(nome, descrição, data_projeto) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '12/09/2014')
GO


-- 1) Id, Name e Email de Users, Id, Name, Description e Data de
-- Projects, dos usuários que participaram do projeto Name Re-folha
SELECT us.id AS usuario_id, us.nome, us.email, 
proj.id AS projeto_id, 
proj.nome AS projeto_name, 
proj.descrição, 
proj.data_projeto AS data
FROM USERS us, PROJECTS proj, USERS_HAS_PROJECT us_has_pro
WHERE us.id = us_has_pro.users_id
	AND proj.id = us_has_pro.projects_id
	AND proj.nome LIKE 'Re-folha'

-- 2) Name dos Projects que não tem Users
SELECT proj.nome
FROM PROJECTS proj LEFT JOIN USERS_HAS_PROJECT us_has_proj
ON proj.id = us_has_proj.projects_id
WHERE us_has_proj.users_id IS NULL


-- 3) Name dos Users que não tem Projects
SELECT us.nome
FROM USERS us LEFT JOIN USERS_HAS_PROJECT us_has_proj
ON us.id =  us_has_proj.users_id
WHERE  us_has_proj.users_id IS NULL


