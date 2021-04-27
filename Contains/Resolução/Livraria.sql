CREATE DATABASE LIVRARIA
GO
USE LIVRARIA

CREATE TABLE Livro(
Codigo_Livro        INT         NOT NULL,
Nome				VARCHAR(50) NULL,
Lingua				VARCHAR(50) NULL,
Ano					INT        NULL		CHECK(Ano >1990)
PRIMARY KEY(Codigo_Livro)
)

CREATE TABLE Autor(

Codigo_Autor		INT			NOT NULL,
Nome				VARCHAR(60) NULL		UNIQUE,
Nascimento			DATE        NULL,
Pais				VARCHAR(20) NULL		CHECK(Pais = 'Brasil' AND Pais = 'Alemanha'),
Biografia			VARCHAR(120) NULL
PRIMARY KEY (Codigo_Autor)

)

CREATE TABLE Livro_Autor(
LivroCodigo_Livro		INT		NOT NULL,
AutorCodigo_Autor		INT     NOT NULL,
FOREIGN KEY  (LivroCodigo_Livro) REFERENCES Livro(Codigo_Livro),
FOREIGN KEY  (AutorCodigo_Autor) REFERENCES Autor(Codigo_Autor)
)

CREATE TABLE Edições(
ISBN				INT				NOT NULL,
Preço				DECIMAL(7,2)	NULL			CHECK(Preço >=0),
Ano					INT			NULL			CHECK(Ano >1993),
Num_Paginas			INT				NULL			CHECK(Num_Paginas >=0),
Qtd_Estoque			INT				NULL,
LivroCodigo_Livro	INT				NOT NULL,
PRIMARY KEY(ISBN),
FOREIGN KEY  (LivroCodigo_Livro) REFERENCES Livro(Codigo_Livro)

)


CREATE TABLE Editora(

Codigo_Editora			INT				NOT NULL,
Nome					VARCHAR(60)		NULL		UNIQUE,
Logradouro				VARCHAR(60)		NULL,
Numero					INT				NULL		CHECK(Numero>=0),
CEP						VARCHAR(8)		NULL,
Telefone				VARCHAR(11)		NULL,
PRIMARY KEY(Codigo_Editora)
)


CREATE TABLE Edições_Editora(

EdicoesISBN		INT			NOT NULL,
EditoraCodigo_Editora		INT		NOT NULL,
FOREIGN KEY (EdicoesISBN) REFERENCES Edições(ISBN),
FOREIGN KEY (EditoraCodigo_Editora) REFERENCES Editora(Codigo_Editora)


)


SELECT * FROM Edições
SELECT * FROM Editora
SELECT * FROM Livro
SELECT * FROM Livro_Autor
SELECT * FROM Edições_Editora
SELECT * FROM Autor