CREATE DATABASE Faculdade
go 
USE Faculdade

CREATE TABLE aluno(

RA      INT            NOT NULL,
nome    VARCHAR(30)    NOT NULL,
sobrenome VARCHAR(30)  NOT NULL,
rua       VARCHAR(50)  NOT NULL,
numero    INT          NOT NULL,
bairro    VARCHAR(20)  NOT NULL,
cep       CHAR(8)   NOT NULL,
telefone  CHAR(8)    NULL,

PRIMARY KEY (RA)

)

GO

CREATE TABLE curso (

codigo_cur INT       NOT NULL,
nome_cur      VARCHAR(50)    NOT NULL,
ch_cur        INT             NOT NULL,
turno_cur     VARCHAR(10)     NOT NULL
PRIMARY KEY (codigo_cur)

)

GO

CREATE TABLE disciplina(

codigo_dis INT       NOT NULL,
nome_dis     VARCHAR(50)    NOT NULL,
ch_dis       INT             NOT NULL,
turno_dis     VARCHAR(10)     NOT NULL,
semestre      INT             NOT NULL,
PRIMARY KEY (codigo_dis)





)

GO

CREATE TABLE aluno_disciplina(
alunoCodigo INT      NOT NULL,
disciplinaCodigo INT NOT NULL
FOREIGN KEY (alunoCodigo) REFERENCES aluno(RA),
FOREIGN KEY (disciplinaCodigo) REFERENCES disciplina(codigo_dis)
)


SELECT * FROM aluno


--1 ) Nome e sobrenome, como nome completo dos Alunos Matriculados

SELECT nome + ' ' + sobrenome AS nome_completo
FROM aluno


-- 2) Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone

SELECT 
rua + ' , '+ CAST(numero AS VARCHAR(5)) +' , ' + SUBSTRING(cep, 1,4)+ '-' +SUBSTRING(cep, 5, 3) AS endereço_Aluno_que_não_tem_telefone
FROM aluno 
WHERE telefone = ' '


-- 3) Telefone do aluno com RA 12348

SELECT telefone
FROM aluno
WHERE RA = 12348


--4) Nome e Turno dos cursos com 2800 horas

SELECT nome_cur, turno_cur
FROM curso
WHERE ch_cur = 2800

--5) O semestre do curso de Banco de Dados I noite

SELECT semestre
FROM disciplina
WHERE turno_dis = 'noite'
       AND nome_dis 