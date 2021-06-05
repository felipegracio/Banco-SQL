USE planoSaude
GO


CREATE TABLE planos(
    codPlano INT NOT NULL,
    nomePlano VARCHAR(40) NOT NULL,
    valorPlano INT NOT NULL
    PRIMARY KEY(codPlano)
)
GO

CREATE TABLE servicos(
    codServico INT NOT NULL,
    nomeServico VARCHAR(40) NOT NULL,
    valorServico INT NOT NULL
    PRIMARY KEY(codServico)
)
GO

CREATE TABLE clientes(
    codCliente INT NOT NULL,
    nomeCliente VARCHAR(40) NOT NULL,
    dataInicio DATE NOT NULL,
    PRIMARY KEY(codCliente)
)
GO

CREATE TABLE contratos(
    codCliente INT NOT NULL,
    codPlano INT NOT NULL,
    codServico INT NOT NULL,
    status CHAR(1) NOT NULL,
    data DATE NOT NULL
    PRIMARY KEY(codCliente, codPlano, codServico, data)
    FOREIGN KEY(codCliente) REFERENCES clientes(codCliente),
    FOREIGN KEY(codPlano) REFERENCES planos(codPlano),
    FOREIGN KEY(codServico) REFERENCES servicos(codServico)
)
GO

--1) Consultar o nome do cliente, o nome do plano, a quantidade de estados
-- de contrato (sem repetições) por contrato, dos planos cancelados,
-- ordenados pelo nome do cliente
SELECT cl.nomeCliente, pl.nomePlano, COUNT(co.status) AS contratos_inativos
FROM clientes cl, planos pl, contratos co
WHERE cl.codCliente = co.codCliente
AND co.codPlano = pl.codPlano
AND co.status = 'D'

GROUP BY cl.nomeCliente, pl.nomePlano
ORDER BY cl.nomeCliente


-- 2)Consultar o nome do cliente, o nome do plano, a quantidade de estados
-- de contrato (sem repetições) por contrato, dos planos não cancelados,
-- ordenados pelo nome do cliente

SELECT cl.nomeCliente, pl.nomePlano, COUNT(co.status) AS contratos_Ativos
FROM clientes cl, planos pl, contratos co
WHERE cl.codCliente = co.codCliente
AND co.codPlano = pl.codPlano
AND co.status <> 'D'
GROUP BY cl.nomeCliente, pl.nomePlano
ORDER BY cl.nomeCliente


-- 3)Consultar o nome do cliente, o nome do plano, e o valor da conta de cada
-- contrato que está ou esteve ativo, sob as seguintes condições:
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%
	-- Contas com valor inferiores a R$200,00 não tem desconto


SELECT cl.nomeCliente, pl.nomePlano, SUM(pl.valorPlano + se.valorServico) AS valor_contrato,
CASE 
WHEN SUM(pl.valorPlano + se.valorServico)>400 THEN
	SUM((pl.valorPlano + se.valorServico)*0.92)
	
	WHEN SUM(pl.valorPlano + se.valorServico)>300 AND SUM(pl.valorPlano + se.valorServico)<400 THEN
			SUM((pl.valorPlano + se.valorServico)*0.95)
					
		WHEN SUM(pl.valorPlano + se.valorServico)>200 AND SUM(pl.valorPlano + se.valorServico)<300 THEN
				SUM((pl.valorPlano + se.valorServico)*0.97)
				ELSE
					SUM(pl.valorPlano + se.valorServico)
					END  AS VALOR_PLANO_DESCONTO

FROM clientes cl, planos pl, servicos se, contratos co
WHERE cl.codCliente = co.codCliente
AND pl.codPlano = co.codPlano
AND se.codServico = co.codServico
AND co.status = 'A'
GROUP BY cl.nomeCliente, pl.nomePlano

-- 4)Consultar o nome do cliente, o nome do serviço, e a duração, em meses
-- (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano


SELECT DISTINCT cl.nomeCliente, se.nomeServico, DATEDIFF(MONTH, co.data, GETDATE()) AS meses_do_contrato
FROM clientes cl, servicos se, contratos co
WHERE co.codCliente = cl.codCliente
AND co.codServico = se.codServico
AND co.status = 'A'
GROUP BY cl.nomeCliente, se.nomeServico, co.data