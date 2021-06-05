CREATE DATABASE plano
GO

USE plano
GO

CREATE TABLE planos_de_saude(
    codigo INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    telefone VARCHAR(10) NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE paciente(
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    telefone VARCHAR(10) NOT NULL,
    rua VARCHAR(30) NOT NULL,
    num INT NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    plano_de_saude INT NOT NULL
    PRIMARY KEY(cpf)
    FOREIGN KEY(plano_de_saude) REFERENCES planos_de_saude(codigo)
)
GO

CREATE TABLE medico(
    codigo INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    especialidade VARCHAR(30) NOT NULL,
    plano_de_saude INT NOT NULL
    PRIMARY KEY(codigo)
    FOREIGN KEY(plano_de_saude) REFERENCES planos_de_saude(codigo)
)
GO

CREATE TABLE consultas(
    medico INT NOT NULL,
    paciente VARCHAR(11) NOT NULL,
    dataHora DATE NOT NULL,
    diagnostico VARCHAR(30) NOT NULL
    PRIMARY KEY(medico, paciente, dataHora)
    FOREIGN KEY(medico) REFERENCES medico(codigo),
    FOREIGN KEY(paciente) REFERENCES paciente(cpf)
)
GO



SELECT * FROM consultas
SELECT * FROM paciente



--1)Nome e especialidade dos médicos da Amil

SELECT me.nome, me.especialidade
FROM medico me, planos_de_saude pl
WHERE me.plano_de_saude = pl.codigo
AND pl.nome LIKE '%Amil%'


--2) Nome, Endereço concatenado, Telefone e Nome do Plano de Saúde de todos os pacientes


SELECT pa.nome, pa.rua+',' + CAST(pa.num AS VARCHAR(10))+'-'+ pa.bairro AS endereco_completo, pa.telefone, pa.plano_de_saude
FROM paciente pa


--3)Telefone do Plano de  Saúde de Ana Júlia

SELECT pl.telefone
FROM paciente pa, planos_de_saude pl
WHERE pa.plano_de_saude = pl.codigo
AND pa.nome LIKE '%Ana Julia%'

--4) Plano de Saúde que não tem pacientes cadastrados

SELECT pl.nome
FROM planos_de_saude pl LEFT OUTER JOIN paciente pa
ON pl.codigo = pa.plano_de_saude
WHERE pa.plano_de_saude IS NULL


--5) Planos de Saúde que não tem médicos cadastrados


SELECT pl.nome
FROM planos_de_saude pl LEFT OUTER JOIN medico me
ON pl.codigo = me.plano_de_saude
WHERE me.plano_de_saude IS NULL


--6) Data da consulta, Hora da consulta, nome do médico, nome do paciente e diagnóstico de todas as consultas

SELECT co.dataHora, me.nome, pa.nome, co.diagnostico
FROM consultas co, medico me, paciente pa
WHERE co.paciente = pa.cpf
AND co.medico = me.codigo


--7) Nome do médico, data e hora de consulta e diagnóstico de José Lima

SELECT me.nome, co.dataHora, co.diagnostico
FROM medico me, consultas co, paciente pa
WHERE co.paciente = pa.cpf
AND co.medico = me.codigo
AND pa.nome LIKE '%José Lima%'


--8) Alterar o nome de João Carlos para João Carlos da Silva
UPDATE paciente
SET nome = 'João Carlos da Silva'
WHERE nome = 'João Carlos'

--9) Deletar o plano de Saúde Unimed
DELETE FROM planos_de_saude
WHERE nome LIKE 'Unimed'

--10) Renomear a coluna Rua da tabela Paciente para Logradouro
EXEC sp_rename 'paciente.rua' , 'paciente.Logradouro', 'COLUMN'


--11) Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os 
--valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente
ALTER TABLE  paciente
ADD data_nasc    DATE      NULL

UPDATE paciente
SET data_nasc = '1990-04-18'
WHERE CPF = '85987458920'

UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE CPF = '87452136900'


UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE CPF = '23659874100'


UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE CPF = '63259874100'