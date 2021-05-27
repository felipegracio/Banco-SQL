CREATE DATABASE clinica

use clinica



CREATE TABLE pacientes(

CPF     VARCHAR(11)           NOT NULL,
nome    VARCHAR(70)    NOT NULL,
rua       VARCHAR(50)  NOT NULL,
numero    INT          NOT NULL,
bairro    VARCHAR(20)  NOT NULL,
telefone  CHAR(8)    NULL

PRIMARY KEY (CPF)


)
GO


CREATE TABLE medico (

codigo     INT            NOT NULL,
nome    VARCHAR(70)    NOT NULL,
especialidade VARCHAR(30)

PRIMARY KEY (codigo)

) 


CREATE TABLE prontuario (

data     DATETIME        NOT NULL,
CPF_paci VARCHAR(11)            NOT NULL,
cod_med  INT            NOT NULL,
diagnos  VARCHAR(200)   NOT NULL,
medicame VARCHAR(100)   NOT NULL

PRIMARY KEY (data)
FOREIGN KEY (CPF_paci) REFERENCES pacientes(CPF),
FOREIGN KEY (cod_med) REFERENCES medico(codigo),


)

-- 1) Nome e Endereço (concatenado) dos pacientes com mais de 50 anos

SELECT * FROM pacientes

SELECT * FROM medico

SELECT * FROM prontuario

SELECT nome, rua+' , ' + CAST(numero AS VARCHAR(5)) + ', ' + bairro AS eendereco_completo
FROM pacientes


-- 2) Qual a especialidade de Carolina Oliveira
SELECT especialidade
FROM medico
WHERE nome LIKE 'Carolina%'


--3) Qual medicamento receitado para reumatismo
SELECT medicame
FROM prontuario
WHERE diagnos LIKE 'reumatismo'



-- Consultar em subqueries:

-- 1) Diagnóstico e Medicamento do paciente José Rubens em suas consultas
SELECT  diagnos, medicame
FROM prontuario
WHERE CPF_paci IN
(
SELECT CPF
FROM pacientes
WHERE nome LIKE 'José Rubens'
)



--2 Nome e especialidade do(s) Médico(s) que atenderam José Rubens. 
--Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)

SELECT nome, especialidade
FROM medico 
WHERE codigo IN
(
SELECT cod_med
FROM prontuario
WHERE CPF_paci IN

(
SELECT CPF
FROM pacientes
WHERE nome LIKE 'José Rubens'

)

)


--3) CPF (Com a máscara XXX.XXX.XXX-XX)
--, Nome, Endereço completo (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius

SELECT SUBSTRING(CPF, 1,3)+'.'+SUBSTRING(CPF, 4, 3)+'.'+SUBSTRING(CPF,7,3)+'-'+SUBSTRING(CPF, 10, 11) AS CPF,nome,
rua+' , ' + CAST(numero AS VARCHAR(5)) + ', ' + bairro AS endereco_completo,
CASE WHEN telefone > LEN(0) THEN
		telefone
		ELSE
		'-'
		END AS Telefone

FROM pacientes
WHERE CPF IN

(
SELECT CPF_paci
FROM prontuario
WHERE cod_med IN
(
SELECT codigo
FROM medico
WHERE nome LIKE 'Vinicius%'
)

)


--4) Quantos dias fazem da consulta de Maria Rita até hoje

SELECT DISTINCT DATEDIFF(DAY, data, GETDATE()) AS dias_ate_hoje 
FROM prontuario
WHERE CPF_paci IN

(
SELECT CPF
FROM pacientes
WHERE nome LIKE '%Maria Rita%'

)

--Alterações

--1) Alterar o telefone da paciente Maria Rita, para 98345621

UPDATE pacientes
SET telefone = '98345621'
WHERE nome LIKE 'Maria Rita'

--2) Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto
UPDATE pacientes
SET rua = 'Voluntários da Pátria', numero = 1980, bairro = 'Jd. Aeroporto'
WHERE nome LIKE 'Joana de Souza'