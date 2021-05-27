CREATE DATABASE exec02
GO

USE exec02
GO

CREATE TABLE carro(
    placa VARCHAR(20) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    cor VARCHAR(20) NOT NULL,
    ano INT NOT NULL
    PRIMARY KEY(placa)
)
GO

CREATE TABLE cliente(
    carro VARCHAR(20) NOT NULL,
    nome VARCHAR(20) NOT NULL,
    logradouro VARCHAR(20),
    num VARCHAR(4),
    bairro VARCHAR(20),
    telefone VARCHAR(10)
    PRIMARY KEY(carro)
    FOREIGN KEY(carro) REFERENCES carro(placa)
)
GO

CREATE TABLE pecas(
    codigo INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    valor INT NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE servico(
    carro VARCHAR(20) NOT NULL,
    peca INT NOT NULL,
    quantidade INT NOT NULL,
    valor INT NOT NULL,
    data DATE NOT NULL
    PRIMARY KEY(carro, peca, data)
    FOREIGN KEY(carro) REFERENCES carro(placa),
    FOREIGN KEY(peca) REFERENCES pecas(codigo)
)
GO

--1)
SELECT cliente.telefone
FROM cliente
WHERE cliente.carro IN (
    SELECT carro.placa
    FROM carro
    WHERE carro.modelo LIKE 'Ka' AND carro.cor LIKE 'Azul'
)

--2)
SELECT cliente.logradouro + ' ' + cliente.num + ' ' + cliente.bairro AS endereco_cliente
FROM cliente
WHERE cliente.carro IN (
    SELECT carro.placa
    FROM carro
    WHERE carro.placa IN (
        SELECT servico.carro
        FROM servico
        WHERE servico.data = '2020-08-02'
    )
)

--3)
SELECT carro.placa
FROM carro
WHERE carro.ano < 2001

--4)
SELECT carro.marca + ' ' + carro.modelo + ' ' + carro.cor AS detalhes_carro
FROM carro
WHERE carro.ano > 2005

--5)
SELECT pecas.codigo, pecas.nome
FROM pecas
WHERE pecas.valor < 80