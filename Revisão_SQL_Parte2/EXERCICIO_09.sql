CREATE DATABASE editora
GO
USE editora

CREATE TABLE estoque
(
codigo       INT          NOT NULL,
nome         VARCHAR(50)  NOT NULL          UNIQUE,
qtd                INT    NOT NULL,
valor        DECIMAL(7,2) NOT NULL          CHECK(valor>0),
cod_ed       INT          NOT NULL,
cod_aut      INT          NOT NULL

PRIMARY KEY(codigo)
FOREIGN KEY (cod_ed) REFERENCES editora(codigo),
FOREIGN KEY (cod_aut) REFERENCES autor(codigo)
)

CREATE TABLE editora 

(
codigo        INT      NOT NULL,
nome_ed       VARCHAR(50)  NOT NULL,
site          VARCHAR(50)  NOT NULL
PRIMARY KEY (codigo)
)


CREATE TABLE autor

(
codigo          INT      NOT NULL,
nome_aut        VARCHAR(80) NOT NULL,
biografia       VARCHAR(100) NOT NULL
PRIMARY KEY (codigo)

)


CREATE TABLE compras
(
codigo       INT       NOT NULL,
cod_est      INT       NOT NULL,
qtd_com      INT       NOT NULL             CHECK(qtd_com > 0),
valor        DECIMAL(7,2)  NOT NULL             CHECK(valor > 0),
data_com     DATE          NOT NULL

PRIMARY KEY(codigo, cod_est)
FOREIGN KEY(cod_est) REFERENCES estoque(codigo)

)

SELECT * FROM compras
SELECT * FROM estoque
SELECT * FROM autor
SELECT * FROM editora

--1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.


SELECT es.nome, es.valor, ed.nome_ed, au.nome_aut
FROM estoque es, compras co, editora ed, autor au
WHERE co.cod_est = es.codigo
	AND es.cod_aut = au.codigo
	AND es.cod_ed = ed.codigo
GROUP BY es.nome, es.valor, ed.nome_ed, au.nome_aut



--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051

SELECT es.nome, co.qtd_com, co.valor
FROM estoque es, compras co
WHERE es.codigo = co.cod_est
AND co.codigo = 15051
GROUP BY es.nome, co.qtd_com, co.valor



--3)Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).

SELECT es.nome, ed.site
FROM estoque es, editora ed 
WHERE es.cod_ed = ed.codigo
AND ed.nome_ed LIKE 'Makron books'
GROUP BY es.nome, ed.site


--4)Consultar nome do livro e Breve Biografia do David Halliday
SELECT es.nome, au.biografia
FROM estoque es, autor au
WHERE es.cod_aut = au.codigo
GROUP BY es.nome, au.biografia



--5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos

SELECT co.codigo, co.qtd_com
FROM estoque es, compras co
WHERE co.cod_est = es.codigo
AND es.nome LIKE 'Sistemas Operacionais Modernos'
GROUP BY co.codigo, co.qtd_com



--6)Consultar quais livros não foram vendidos
 
 SELECT es.nome
 FROM estoque es
 WHERE es.codigo NOT IN 
(
SELECT co.cod_est
FROM compras co
)


--7) Consultar quais livros foram vendidos e não estão cadastrados




--8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)

SELECT ed.nome_ed, 
CASE
	WHEN LEN(ed.site)> 10 THEN
		REPLACE(ed.site, 'www.', '')
	ELSE
		ed.site
    END AS SITE
FROM editora ed
WHERE ed.codigo NOT IN

(
SELECT es.cod_ed
FROM estoque es

)


--9)Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)

SELECT au.nome_aut,
CASE
	WHEN au.biografia LIKE 'Doutorado%'THEN
		REPLACE (au.biografia, 'Doutorado', 'Ph.d.')
	ELSE
		au.biografia
	END AS biografia
FROM autor au
WHERE au.codigo NOT IN

(
SELECT es.cod_aut
FROM estoque es

)

--10)Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente


SELECT TOP 1 au.nome_aut, es.valor
FROM autor au, estoque es
WHERE au.codigo= es.cod_aut
GROUP BY au.nome_aut, es.valor
ORDER BY es.valor desc


--11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.

SELECT co.codigo, SUM(co.valor) AS soma_valor, SUM(co.qtd_com) AS qtd_total
FROM compras co
GROUP BY co.codigo
ORDER BY co.codigo asc

--12) Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.

SELECT ed.nome_ed, CAST(AVG(es.valor) AS DECIMAL(7,2)) AS media
FROM editora ed, estoque es
WHERE ed.codigo = es.cod_ed
GROUP BY ed.nome_ed


--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora
--(Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:
--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
-- A Ordenação deve ser por Quantidade ascendente


SELECT es.nome, 
  CASE WHEN es.qtd < 5 THEN
		'Produto em Ponto de Pedido'
	 ELSE 
	 CASE WHEN es.qtd >= 5 AND es.qtd<=10 THEN
		'Produto Acabando'
		ELSE
		'Estoque Suficiente'
		END 
		END AS STATUS,
		
		es.qtd,

		ed.nome_ed,

		CASE
	WHEN LEN(ed.site)> 10 THEN
		REPLACE(ed.site, 'www.', '')
	ELSE
		ed.site
    END AS SITE


FROM estoque es, editora ed
WHERE es.cod_ed = ed.codigo
GROUP BY es.nome, es.qtd, ed.nome_ed, ed.site
ORDER BY es.qtd asc


--14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: 
--Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros
--Só pode concatenar sites que não são nulos


SELECT es.codigo, es.nome, au.nome_aut,
CASE 
	WHEN ed.site = NULL THEN
		ed.nome_ed
	ELSE
		ed.nome_ed +' '+ ed.site
	END AS Info_Editora
FROM estoque es, autor au, editora ed
WHERE es.cod_aut = au.codigo
AND es.cod_ed = ed.codigo
GROUP BY es.codigo, es.nome, au.nome_aut, ed.nome_ed, ed.site

--15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje

SELECT co.codigo, DATEDIFF(DAY, co.data_com, GETDATE()) AS dias_de_compras, DATEDIFF(MONTH, co.data_com, GETDATE()) AS meses_da_compra
FROM compras co



--16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00

SELECT co.codigo, SUM(co.valor) AS compras_acima_de_200 , SUM(co.qtd_com) AS qtd_total
FROM compras co
GROUP BY co.codigo
HAVING SUM(co.valor)>200