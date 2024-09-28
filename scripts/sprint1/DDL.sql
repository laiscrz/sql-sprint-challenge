/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM OS CODIGOS DOS BLOCOS ANONIMOS DE CONSULTA 1 (SPRINT 1) ---------------------------
*/

/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM OS CODIGOS DAS SPRINTS 1,2 E 3  ---------------------------
*/

/* -------------------------------------------- SPRINT 1 --------------------------------------------*/

-- Esses comandos exclui se a tabela ja existir, e tambem exclui
-- juntos com as restricoes que ela obter (chave estrangeira).
drop table lead cascade constraints;
drop table cliente cascade constraints;
drop table Cliente_Produto cascade constraints;
drop table Pesquisa cascade constraints;
drop table Pesquisa_Cliente cascade constraints;
drop table Historico_Cliente cascade constraints;
drop table Historico_Produto cascade constraints;
drop table Produto cascade constraints;
drop table Produto_Fornecedor cascade constraints;
drop table Fornecedor cascade constraints;
drop table LocalizacaoGeografica cascade constraints;

-- Tabela que armazena dados sobre leads potenciais, 
-- como fonte de origem e categoria de produtos de interesse.
CREATE TABLE Lead (
    idLead NUMBER(10) PRIMARY KEY,
    idCliente NUMBER(10),
    canalOrigem VARCHAR2(100),
    categoriaProdutoInteresse VARCHAR2(100)
);

-- Tabela que armazena 
-- informações detalhadas sobre os clientes.
CREATE TABLE Cliente (
    idCliente NUMBER(10) PRIMARY KEY,
    nome VARCHAR2(100),
    telefone VARCHAR2(20),
    email VARCHAR2(255),
    idade NUMBER(3),
    genero VARCHAR2(10),
    estadoCivil VARCHAR2(20),
    idLocalizacao NUMBER(10),
    nivelRenda NUMBER(12, 2),
    nivelEducacao VARCHAR2(100),
    formaPagamentoPref VARCHAR2(50)
);

-- Tabela que estabelece a relação entre clientes e produtos adquiridos.
CREATE TABLE Cliente_Produto (
    idCliente NUMBER(10),
    idProduto NUMBER(10)
);

-- Tabela que armazena dados sobre as pesquisas realizadas pelos clientes.
CREATE TABLE Pesquisa (
    idPesquisa NUMBER(10) PRIMARY KEY,
    palavraChave VARCHAR2(255)
);


-- Tabela que estabelece a relação entre as pesquisas e os clientes que as realizaram.
CREATE TABLE Pesquisa_Cliente (
    idCliente NUMBER(10),
    idPesquisa NUMBER(10)
);


-- Tabela que registra o histórico de compras dos clientes.
CREATE TABLE Historico_Cliente (
    idHistCompra NUMBER(10) PRIMARY KEY,
    idCliente NUMBER(10),
    idProduto NUMBER(10),
    dataCompraProduto DATE
);

-- Tabela que estabelece a relação entre o histórico de compras e os produtos adquiridos.
CREATE TABLE Historico_Produto (
    idHistCompra NUMBER(10),
    idProduto NUMBER(10)
);

-- Tabela que armazena dados sobre os produtos disponíveis para compra.
CREATE TABLE Produto (
    idProduto NUMBER(10) PRIMARY KEY,
    nomeProduto VARCHAR2(255),
    estrelas NUMBER(5),
    categoriaProduto VARCHAR2(100),
    qtdEstoque NUMBER(10),
    dataCompraProduto DATE,
    valorProduto NUMBER(12, 2)
);

-- Tabela que relaciona produtos a seus fornecedores.
CREATE TABLE Produto_Fornecedor (
    idProduto NUMBER(10),
    idFornecedor NUMBER(10)
);

-- Tabela que armazena informações sobre fornecedores.
CREATE TABLE Fornecedor (
    idFornecedor NUMBER(10) PRIMARY KEY,
    nomeFornecedor VARCHAR2(255),
    tipoFornecedor VARCHAR2(100)
);

-- Tabela que armazena dados sobre as localizações geográficas dos clientes.
CREATE TABLE LocalizacaoGeografica (
    idLocalizacao NUMBER(10) PRIMARY KEY,
    pais VARCHAR2(100),
    estado VARCHAR2(100),
    cidade VARCHAR2(100),
    cep VARCHAR2(20)
);

-- Adicionando restrições de chave estrangeira usando ALTER TABLE

-- Cada restrição está sendo adicionada usando o comando ALTER TABLE, 
-- que permite modificar a estrutura de uma tabela já existente.

/*OBS. A ação ON DELETE CASCADE define o que acontece com os registros dependentes quando um registro principal é excluído.
Nesse caso, CASCADE significa que a exclusão de um registro na tabela pai (referenciada) 
resultará na exclusão automática dos registros dependentes na tabela filha (referenciadora).
*/
ALTER TABLE Lead ADD CONSTRAINT fk_lead_cliente 
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE;

ALTER TABLE Cliente ADD CONSTRAINT fk_cliente_localizacao 
FOREIGN KEY (idLocalizacao) REFERENCES LocalizacaoGeografica(idLocalizacao) ON DELETE CASCADE;

ALTER TABLE Cliente_Produto ADD CONSTRAINT fk_cliente_produto_cliente 
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE;

ALTER TABLE Cliente_Produto ADD CONSTRAINT fk_cliente_produto_produto 
FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE;

ALTER TABLE Pesquisa_Cliente ADD CONSTRAINT fk_pesquisa_cliente 
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE;

ALTER TABLE Pesquisa_Cliente ADD CONSTRAINT fk_pesquisa_pesquisa 
FOREIGN KEY (idPesquisa) REFERENCES Pesquisa(idPesquisa) ON DELETE CASCADE;

ALTER TABLE Historico_Cliente ADD CONSTRAINT fk_historico_cliente 
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE;

ALTER TABLE Historico_Cliente ADD CONSTRAINT fk_historico_cliente_produto 
FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE;

ALTER TABLE Historico_Produto ADD CONSTRAINT fk_historico_produto 
FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE;

ALTER TABLE Produto_Fornecedor ADD CONSTRAINT fk_produto_fornecedor_produto 
FOREIGN KEY (idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE;

ALTER TABLE Produto_Fornecedor ADD CONSTRAINT fk_produto_fornecedor_fornecedor 
FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor) ON DELETE CASCADE;

-- ADD 5 RESGISTROS EM CADA TABELA

-- Inserções na tabela Pesquisa
INSERT INTO Pesquisa (idPesquisa, palavraChave) VALUES (101, 'Tecnologia');
INSERT INTO Pesquisa (idPesquisa, palavraChave) VALUES (102, 'Moda');
INSERT INTO Pesquisa (idPesquisa, palavraChave) VALUES (103, 'Decoração');
INSERT INTO Pesquisa (idPesquisa, palavraChave) VALUES (104, 'Esportes');
INSERT INTO Pesquisa (idPesquisa, palavraChave) VALUES (105, 'Literatura');

-- Inserções na tabela LocalizacaoGeografica
INSERT INTO LocalizacaoGeografica (idLocalizacao, pais, estado, cidade, cep)
VALUES (201, 'Brasil', 'São Paulo', 'São Paulo', '01000-000');
INSERT INTO LocalizacaoGeografica (idLocalizacao, pais, estado, cidade, cep)
VALUES (202, 'Brasil', 'Rio de Janeiro', 'Rio de Janeiro', '20000-000');
INSERT INTO LocalizacaoGeografica (idLocalizacao, pais, estado, cidade, cep)
VALUES (203, 'Brasil', 'Minas Gerais', 'Belo Horizonte', '30000-000');
INSERT INTO LocalizacaoGeografica (idLocalizacao, pais, estado, cidade, cep)
VALUES (204, 'Brasil', 'Rio Grande do Sul', 'Porto Alegre', '90000-000');
INSERT INTO LocalizacaoGeografica (idLocalizacao, pais, estado, cidade, cep)
VALUES (205, 'Brasil', 'Bahia', 'Salvador', '40000-000');

-- Inserções na tabela Cliente
INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref)
VALUES (101, 'Ana', '123456789', 'ana@example.com', 30, 'Feminino', 'Solteiro(a)', 201, 5000.00, 'Graduação', 'Cartão de Crédito');
INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref)
VALUES (102, 'João', '987654321', 'joao@example.com', 35, 'Masculino', 'Casado(a)', 202, 6000.00, 'Pós-Graduação', 'Boleto Bancário');
INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref)
VALUES (103, 'Maria', '111222333', 'maria@example.com', 25, 'Feminino', 'Solteiro(a)', 203, 4000.00, 'Graduação', 'Cartão de Débito');
INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref)
VALUES (104, 'Pedro', '444555666', 'pedro@example.com', 40, 'Masculino', 'Casado(a)', 204, 7000.00, 'Pós-Graduação', 'Dinheiro');
INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref)
VALUES (105, 'Carla', '777888999', 'carla@example.com', 28, 'Feminino', 'Solteiro(a)', 205, 4500.00, 'Graduação', 'Cartão de Crédito');

-- Inserções na tabela Produto
INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
VALUES (301, 'Smartphone', 4, 'Tecnologia', 100, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 1500.00);
INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
VALUES (302, 'Camisa Polo', 5, 'Moda', 200, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 100.00);
INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
VALUES (303, 'Vaso Decorativo', 4, 'Decoração', 50, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 80.00);
INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
VALUES (304, 'Bola de Futebol', 4, 'Esportes', 80, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 50.00);
INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
VALUES (305, 'Livro de Ficção', 5, 'Literatura', 120, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 30.00);

-- Inserções na tabela Fornecedor
INSERT INTO Fornecedor (idFornecedor, nomeFornecedor, tipoFornecedor)
VALUES (401, 'TecnoCorp', 'Tecnologia');
INSERT INTO Fornecedor (idFornecedor, nomeFornecedor, tipoFornecedor)
VALUES (402, 'ModaStyle', 'Moda');
INSERT INTO Fornecedor (idFornecedor, nomeFornecedor, tipoFornecedor)
VALUES (403, 'DecorArte', 'Decoração');
INSERT INTO Fornecedor (idFornecedor, nomeFornecedor, tipoFornecedor)
VALUES (404, 'EsporteMais', 'Esportes');
INSERT INTO Fornecedor (idFornecedor, nomeFornecedor, tipoFornecedor)
VALUES (405, 'Livrotopia', 'Livros');

-- Tabela Cliente_Produto
INSERT INTO Cliente_Produto (idCliente, idProduto) VALUES (101, 301);
INSERT INTO Cliente_Produto (idCliente, idProduto) VALUES (102, 302);
INSERT INTO Cliente_Produto (idCliente, idProduto) VALUES (103, 303);
INSERT INTO Cliente_Produto (idCliente, idProduto) VALUES (104, 304);
INSERT INTO Cliente_Produto (idCliente, idProduto) VALUES (105, 305);

-- Tabela Historico_Cliente
INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
VALUES (1, 101, 301, TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
VALUES (2, 102, 302, TO_DATE('2023-02-20', 'YYYY-MM-DD'));
INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
VALUES (3, 103, 303, TO_DATE('2023-03-25', 'YYYY-MM-DD'));
INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
VALUES (4, 104, 304, TO_DATE('2023-04-30', 'YYYY-MM-DD'));
INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
VALUES (5, 105, 305, TO_DATE('2023-05-05', 'YYYY-MM-DD'));

-- Tabela Pesquisa_Cliente
INSERT INTO Pesquisa_Cliente (idCliente, idPesquisa) VALUES (101, 101);
INSERT INTO Pesquisa_Cliente (idCliente, idPesquisa) VALUES (102, 102);  
INSERT INTO Pesquisa_Cliente (idCliente, idPesquisa) VALUES (103, 103);  
INSERT INTO Pesquisa_Cliente (idCliente, idPesquisa) VALUES (104, 104);  
INSERT INTO Pesquisa_Cliente (idCliente, idPesquisa) VALUES (105, 105);  

-- Tabela Historico_Produto
INSERT INTO Historico_Produto (idHistCompra, idProduto) VALUES (401, 301);
INSERT INTO Historico_Produto (idHistCompra, idProduto) VALUES (402, 302);
INSERT INTO Historico_Produto (idHistCompra, idProduto) VALUES (403, 303);
INSERT INTO Historico_Produto (idHistCompra, idProduto) VALUES (404, 304);
INSERT INTO Historico_Produto (idHistCompra, idProduto) VALUES (405, 305);

-- Tabela Produto_Fornecedor
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor) VALUES (301, 401);
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor) VALUES (302, 402);
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor) VALUES (303, 403);
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor) VALUES (304, 404);
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor) VALUES (305, 405);

-- Tabela lead
INSERT INTO Lead (idLead, idCliente, canalOrigem, categoriaProdutoInteresse)
VALUES (1, 101, 'Site', 'Eletrônicos');
INSERT INTO Lead (idLead, idCliente, canalOrigem, categoriaProdutoInteresse)
VALUES (2, 102, 'Redes Sociais', 'Moda');
INSERT INTO Lead (idLead, idCliente, canalOrigem, categoriaProdutoInteresse)
VALUES (3, 103, 'E-mail', 'Decoração');
INSERT INTO Lead (idLead, idCliente, canalOrigem, categoriaProdutoInteresse)
VALUES (4, 104, 'Site', 'Esportes');
INSERT INTO Lead (idLead, idCliente, canalOrigem, categoriaProdutoInteresse)
VALUES (5, 105, 'Redes Sociais', 'Livros');

-- Confirmando Alteracoes feitas
COMMIT;