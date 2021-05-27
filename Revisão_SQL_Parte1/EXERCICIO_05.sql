create database ex05 

go 

use ex05 

create table fornecedores(

codigo int not null,
nome varchar(15) not null,
atividade varchar(30) not null,
telefone varchar(9) not null

primary key(codigo)

)

go 

create table cliente(

codigo int not null, 
nome varchar (35) not null,
endereco varchar(100) not null,
telefone varchar(9) not null,
idade int not null

primary key(codigo)

)

go 

create table produto(

codigo int not null, 
nome varchar(35) not null,
valor_unitario float not null,
qtde_estoque int not null,
descricao varchar(40) not null,
codigo_fornecedor int not null

primary key (codigo)
foreign key(codigo_fornecedor) references fornecedores(codigo)

)

go 

create table pedido(

codigo int not null, 
codigo_cliente int not null,
codigo_produto int not null, 
qtde int not null, 
valor_total float not null, 
previsao_entrega date not null

primary key(codigo, codigo_cliente, codigo_produto)
foreign key(codigo_cliente) references cliente(codigo),
foreign key(codigo_produto)  references produto(codigo)

)

-- Consultar a quantidade, valor total e valor total com desconto (25%) dos itens comprados par Maria Clara.

select qtde, valor_total,  (valor_total*0.25)+ valor_total as valor_com_desconto
from pedido
where codigo_cliente in
(
	select codigo
	from cliente 
	where nome like 'Maria Clara'
)

-- Verificar quais brinquedos não tem itens em estoque.
select codigo, nome, descricao
from produto
where qtde_estoque = 0 and codigo_fornecedor in
(
	select codigo 
	from fornecedores
	where atividade like 'Brinquedo%'
)

-- Alterar para reduzir em 10% o valor das barras de chocolate.
UPDATE produto
SET valor_unitario = valor_unitario-(valor_unitario*0.1)
WHERE descricao like 'Barra'

-- Alterar a quantidade em estoque do faqueiro para 10 peças.
UPDATE produto
SET qtde_estoque = 10
WHERE nome like 'Faqueiro'

-- Consultar quantos clientes tem mais de 40 anos.
select count(codigo) as qtde_mais_que_40
from cliente 
where idade> 40

-- Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.
select nome, telefone 
from fornecedores
where  atividade like 'Brinquedo%' or atividade like 'Chocolate'

-- Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
select nome, valor_unitario-(valor_unitario*0.25) as desconto
from produto
where valor_unitario < 5000

-- Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
select nome, valor_unitario, valor_unitario+(valor_unitario*0.10) as aumento
from produto
where valor_unitario > 10000

-- Consultar desconto de 15% no valor total de cada produto da venda 99001.

select pro.nome, pro.valor_unitario- (pro.valor_unitario*0.15) as desconto
from pedido pe, produto pro
where pe.codigo_produto = pro.codigo
	and pe.codigo = 99001