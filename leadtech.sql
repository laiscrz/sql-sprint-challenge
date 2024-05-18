/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPW
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
*/

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

-- BLOCOS ANONIMOS COM JOINS, GROUP BY, ORDER BY
SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Primeiro bloco anônimo com consultas de junções, agrupamento e ordenação
DECLARE
    -- declaracao de variaveis
    v_nome_cliente Cliente.nome%TYPE;
    v_nome_produto Produto.nomeProduto%TYPE;
    v_nome_fornecedor Fornecedor.nomeFornecedor%TYPE;
    
    v_categoria_produto Produto.categoriaProduto%TYPE;
    v_total_compras NUMBER(3);
    
    -- Declaração do cursor para obter os dados de cliente, produto e fornecedor
    CURSOR c_cliente_produto_fornecedor IS
        SELECT c.nome AS nome_cliente, p.nomeProduto AS produto_comprado, f.nomeFornecedor AS fornecedor
        INTO v_nome_cliente, v_nome_produto, v_nome_fornecedor
        FROM Cliente c
        JOIN Historico_Cliente hc ON c.idCliente = hc.idCliente
        JOIN Produto p ON hc.idProduto = p.idProduto
        JOIN Produto_Fornecedor pf ON p.idProduto = pf.idProduto
        JOIN Fornecedor f ON pf.idFornecedor = f.idFornecedor
        ORDER BY c.nome;
    
    -- Declaração do cursor para obter a contagem de compras por categoria de produto    
    CURSOR c_total_compras_categoria IS
        SELECT p.categoriaProduto, COUNT(h.idHistCompra) AS total_compras
        INTO v_categoria_produto, v_total_compras
        FROM Historico_Cliente h
        JOIN Produto p ON h.idProduto = p.idProduto
        GROUP BY p.categoriaProduto;
BEGIN
    -- Loop para percorrer o cursor c_cliente_produto_fornecedor e exibir os resultados
    FOR rec IN c_cliente_produto_fornecedor LOOP
         -- Atribuição dos valores às variáveis do cursor
        v_nome_cliente := rec.nome_cliente;
        v_nome_produto := rec.produto_comprado;
        v_nome_fornecedor := rec.fornecedor;
        
         -- Exibição dos resultados
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_nome_cliente || ', Produto: ' || rec.produto_comprado || ', Fornecedor: ' || rec.fornecedor);
    END LOOP;
    
    -- Loop para percorrer o cursor c_total_compras_categoria e exibir os resultados
    FOR cat_prod IN c_total_compras_categoria LOOP
        -- Atribuição dos valores às variáveis do cursor
        v_categoria_produto := cat_prod.categoriaProduto ;
        v_total_compras := cat_prod.total_compras ;
        
         -- Exibição dos resultados
        DBMS_OUTPUT.PUT_LINE('Categoria de Produto: ' || v_categoria_produto || ', Total de Compras: ' || v_total_compras);
    END LOOP;
END;

-- Segundo bloco anônimo com consultas de junções, agrupamento e ordenação
DECLARE
    -- declaracao de variaveis
    v_nome_cliente Cliente.nome%TYPE;
    v_id_pesquisa Pesquisa_Cliente.idPesquisa%TYPE;
    v_cidade LocalizacaoGeografica.cidade%TYPE;
    
    -- Declaração do cursor para obter os dados de cliente, pesquisa e localização
    CURSOR c_cliente_pesquisa_localizacao IS
        SELECT c.nome AS nome_cliente, pc.idPesquisa AS idPesquisa, l.cidade AS cidade
        INTO v_nome_cliente, v_id_pesquisa, v_cidade
        FROM Cliente c
        JOIN Pesquisa_Cliente pc ON c.idCliente = pc.idCliente
        JOIN Pesquisa p ON pc.idPesquisa = p.idPesquisa
        JOIN LocalizacaoGeografica l ON c.idLocalizacao = l.idLocalizacao
        ORDER BY c.nome;
BEGIN
    -- Loop para percorrer o cursor c_cliente_pesquisa_localizacao e exibir os resultados
    FOR rec IN c_cliente_pesquisa_localizacao LOOP
         -- Atribuição dos valores às variáveis do cursor
        v_nome_cliente := rec.nome_cliente;
        v_id_pesquisa := rec.idPesquisa;
        v_cidade := rec.cidade;
        
        -- Exibição dos resultados
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_nome_cliente || ', Pesquisa: ' || v_id_pesquisa || ', Localização: ' || v_cidade);
    END LOOP;
END;

-- FUNÇÕES DE VALIDAÇÃO DE DADOS

-- Primeira função para validar entrada de dados: tabela cliente
/* Esta função valida os dados do cliente referente a colunas :
    - idade: se é maior que 18 anos
    - email : se contem o @
    - genero : se é do tipo 'Feminino' ou 'Masculino'
como requisito para cadastro, conforme estabelecido pela regra de negócio.*/
-- Drop a function se existir
DROP FUNCTION validar_cliente;
-- criando function para validar dados
CREATE OR REPLACE FUNCTION validar_cliente(
    idade_cliente NUMBER,
    email_cliente VARCHAR2,
    genero_cliente VARCHAR2
) RETURN BOOLEAN IS
    idade_valida BOOLEAN := TRUE;
    email_valido BOOLEAN := TRUE;
    genero_valido BOOLEAN := TRUE;
BEGIN
    -- Validando idade
    IF idade_cliente < 18 THEN
        idade_valida := FALSE;
    END IF;

    -- Validando Email
    IF INSTR(email_cliente, '@') = 0 THEN
        email_valido := FALSE;
    END IF;

    -- Validando genero
    IF genero_cliente NOT IN ('Feminino', 'Masculino') THEN
        genero_valido := FALSE;
    END IF;

    RETURN idade_valida AND email_valido AND genero_valido;
END;
-- Bloco PL/SQL com exemplo de chamada validar_cliente
DECLARE
    idade_cliente NUMBER := 25;
    email_cliente VARCHAR2(255) := 'cliente@example.com';
    genero_cliente VARCHAR2(10) := 'Masculino';
    resultado_validacao BOOLEAN;
BEGIN
    resultado_validacao := validar_cliente(idade_cliente, email_cliente, genero_cliente);
    
    IF resultado_validacao THEN
        DBMS_OUTPUT.PUT_LINE('Os detalhes do cliente são válidos.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Os detalhes do cliente são inválidos.');
    END IF;
END;

-- Segunda funcao para validar entrada de dados: tabela produto
/* Esta função valida os dados do produto referente a colunas :
    - estrelas:  estar entre 1 ate 5
    - estoque : se é um numero positivo
    - valor do produto : se é numero positivo
garantindo que apenas valores válidos sejam inseridos no banco de dados.*/
DROP FUNCTION validar_produto;
CREATE OR REPLACE FUNCTION validar_produto(
    estrelas NUMBER,
    qtd_estoque NUMBER,
    valor_produto NUMBER
) RETURN BOOLEAN IS
    estrelas_validas BOOLEAN := TRUE;
    estoque_valido BOOLEAN := TRUE;
    valor_valido BOOLEAN := TRUE;
BEGIN
    -- Validar se o número de estrelas está entre 1 e 5
    IF estrelas IS NULL OR estrelas < 1 OR estrelas > 5 THEN
        estrelas_validas := FALSE;
    END IF;

    -- Validar se a quantidade em estoque é um número positivo
    IF qtd_estoque IS NULL OR qtd_estoque < 0 THEN
        estoque_valido := FALSE;
    END IF;

    -- Validar se o valor do produto é um número positivo
    IF valor_produto IS NULL OR valor_produto < 0 THEN
        valor_valido := FALSE;
    END IF;

    -- Retornar verdadeiro se todos os critérios forem atendidos, falso caso contrário
    RETURN estrelas_validas AND estoque_valido AND valor_valido;
END;
-- Bloco PL/SQL com exemplo de chamada validar_produto
DECLARE
    estrelas_produto NUMBER := 10;
    qtd_estoque NUMBER := 100;
    valor_produto NUMBER := 1500.00;
    resultado_validacao BOOLEAN;
BEGIN
    resultado_validacao := validar_produto(estrelas_produto, qtd_estoque, valor_produto);
    
    IF resultado_validacao THEN
        DBMS_OUTPUT.PUT_LINE('Os detalhes do produto são válidos.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Os detalhes do produto são inválidos.');
    END IF;
END;


-- CRIAÇÃO DE PROCEDURES DAS TABELAS => INSERT, DELETE E UPDATE

/*CLIENTE*/
-- DROP das procedures relacionadas à tabela cliente
DROP PROCEDURE inserir_cliente;
DROP PROCEDURE atualizar_cliente;
DROP PROCEDURE excluir_cliente;
-- Procedure para inserir um novo cliente na tabela cliente
CREATE OR REPLACE PROCEDURE inserir_cliente(
    p_idcliente IN NUMBER,
    p_nome IN VARCHAR2,
    p_telefone IN VARCHAR2,
    p_email IN VARCHAR2,
    p_idade IN NUMBER,
    p_genero IN VARCHAR2,
    p_estadocivil IN VARCHAR2,
    p_idlocalizacao IN NUMBER,
    p_nivelrenda IN NUMBER,
    p_niveleducacao IN VARCHAR2,
    p_formapagamentopref IN VARCHAR2
)
AS BEGIN
    -- Verificando se os dados do cliente são válidos usando a função validar_cliente
    IF validar_cliente(p_idade, p_email, p_genero) THEN
        BEGIN
            INSERT INTO cliente (idcliente, nome, telefone, email, idade, genero, estadocivil, idlocalizacao, nivelrenda, niveleducacao, formapagamentopref) 
            VALUES (p_idcliente, p_nome, p_telefone, p_email, p_idade, p_genero, p_estadocivil, p_idlocalizacao, p_nivelrenda, p_niveleducacao, p_formapagamentopref);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Cliente inserido com sucesso.');
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dados do cliente inválidos. Verifique a idade, o e-mail e o gênero.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente: Já existe um cliente com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente: Verifique se os tipos de dados estão corretos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente: ' || SQLERRM);
        ROLLBACK;
END;

-- Exemplo de chamada na procedure inserir_cliente
DECLARE
    v_idcliente NUMBER := 222;
    v_nome VARCHAR2(100) := 'João Silva';
    v_telefone VARCHAR2(20) := '123456789';
    v_email VARCHAR2(100) := 'joao.silva@example.com';
    v_idade NUMBER := 30;
    v_genero VARCHAR2(10) := 'Masculino';
    v_estadocivil VARCHAR2(20) := 'Solteiro';
    v_idlocalizacao NUMBER := 201;
    v_nivelrenda NUMBER := 5000;
    v_niveleducacao VARCHAR2(50) := 'Graduação';
    v_formapagamentopref VARCHAR2(30) := 'Cartão de Crédito';
BEGIN
    inserir_cliente(p_idcliente => v_idcliente,p_nome => v_nome,p_telefone => v_telefone,p_email => v_email,p_idade => v_idade,p_genero => v_genero,p_estadocivil => v_estadocivil,
        p_idlocalizacao => v_idlocalizacao,p_nivelrenda => v_nivelrenda,p_niveleducacao => v_niveleducacao,p_formapagamentopref => v_formapagamentopref);
END;

-- Procedure para atualizar os dados de um cliente na tabela cliente
CREATE OR REPLACE PROCEDURE atualizar_cliente(
    p_idcliente IN NUMBER,
    p_nome IN VARCHAR2,
    p_telefone IN VARCHAR2,
    p_email IN VARCHAR2,
    p_idade IN NUMBER,
    p_genero IN VARCHAR2,
    p_estadocivil IN VARCHAR2,
    p_idlocalizacao IN NUMBER,
    p_nivelrenda IN NUMBER,
    p_niveleducacao IN VARCHAR2,
    p_formapagamentopref IN VARCHAR2
)
AS BEGIN
    UPDATE cliente SET 
        nome = p_nome, telefone = p_telefone, email = p_email, idade = p_idade, genero = p_genero, estadocivil = p_estadocivil, idlocalizacao = p_idlocalizacao, 
        nivelrenda = p_nivelrenda, niveleducacao = p_niveleducacao, formapagamentopref = p_formapagamentopref 
    WHERE idcliente = p_idcliente;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar cliente: ' || SQLERRM);
        ROLLBACK;
END;

-- Exemplo de chamada na procedure atualizar_cliente
DECLARE
    v_idcliente_atualizar NUMBER := 222;  
    v_nome_atualizado VARCHAR2(100) := 'João Novo Silva';  
    v_telefone_atualizado VARCHAR2(20) := '987654321';  
    v_email_atualizado VARCHAR2(100) := 'joao.novo.silva@example.com'; 
    v_idade_atualizada NUMBER := 31; 
    v_genero_atualizado VARCHAR2(10) := 'Masculino'; 
    v_estadocivil_atualizado VARCHAR2(20) := 'Casado';  
    v_idlocalizacao_atualizada NUMBER := 202;
    v_nivelrenda_atualizado NUMBER := 6000; 
    v_niveleducacao_atualizado VARCHAR2(50) := 'Pós-Graduação';
    v_formapagamentopref_atualizada VARCHAR2(30) := 'Boleto';
BEGIN
    atualizar_cliente(p_idcliente => v_idcliente_atualizar,p_nome => v_nome_atualizado,p_telefone => v_telefone_atualizado,p_email => v_email_atualizado,
        p_idade => v_idade_atualizada,p_genero => v_genero_atualizado,p_estadocivil => v_estadocivil_atualizado,p_idlocalizacao => v_idlocalizacao_atualizada,
        p_nivelrenda => v_nivelrenda_atualizado,p_niveleducacao => v_niveleducacao_atualizado,p_formapagamentopref => v_formapagamentopref_atualizada);
END;

-- Procedure para excluir um cliente da tabela cliente
CREATE OR REPLACE PROCEDURE excluir_cliente(p_idcliente IN NUMBER)
AS BEGIN
    DELETE FROM cliente WHERE idcliente = p_idcliente;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir cliente: ' || SQLERRM);
        ROLLBACK; 
END;
-- Exemplo de chamada na procedure excluir_cliente
DECLARE
    v_idcliente_excluir NUMBER := 222;  -- ID do cliente a ser excluído
BEGIN
    excluir_cliente(p_idcliente => v_idcliente_excluir);
END;


/*PRODUTO*/
-- DROP das procedures relacionadas à tabela produto
DROP PROCEDURE inserir_produto;
DROP PROCEDURE atualizar_produto;
DROP PROCEDURE excluir_produto;
-- Procedure para inserir um novo produto na tabela produto
CREATE OR REPLACE PROCEDURE inserir_produto(
    p_idproduto IN NUMBER,
    p_nomeproduto IN VARCHAR2,
    p_estrelas IN NUMBER,
    p_categoriaproduto IN VARCHAR2,
    p_qtdestoque IN NUMBER,
    p_datacompraproduto IN DATE,
    p_valorproduto IN NUMBER
)
AS BEGIN
    -- Verificar se os dados do produto são válidos usando a função validar_produto
    IF validar_produto(p_estrelas, p_qtdestoque, p_valorproduto) THEN
        BEGIN
            INSERT INTO produto (idproduto, nomeproduto, estrelas, categoriaproduto, qtdestoque, datacompraproduto, valorproduto) 
            VALUES (p_idproduto, p_nomeproduto, p_estrelas, p_categoriaproduto, p_qtdestoque, TO_DATE(p_datacompraproduto, 'YYYY-MM-DD'), p_valorproduto);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Produto inserido com sucesso.');
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Dados do produto inválidos. Verifique as estrelas, a quantidade em estoque e o valor do produto.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir produto: Já existe um produto com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir produto: Verifique se os tipos de dados estão corretos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir produto: ' || SQLERRM);
        ROLLBACK;
END;
-- Exemplo de chamada na procedure inserir_produto
DECLARE
    v_idproduto NUMBER := 555;
    v_nomeproduto VARCHAR2(100) := 'Camiseta';
    v_estrelas NUMBER := 4;
    v_categoriaproduto VARCHAR2(50) := 'Moda';
    v_qtdestoque NUMBER := 150;
    v_datacompraproduto DATE := SYSDATE;
    v_valorproduto NUMBER := 199;
BEGIN
    inserir_produto(p_idproduto => v_idproduto,p_nomeproduto => v_nomeproduto, p_estrelas => v_estrelas,p_categoriaproduto => v_categoriaproduto,
        p_qtdestoque => v_qtdestoque,p_datacompraproduto => v_datacompraproduto,p_valorproduto => v_valorproduto);
END;

-- Procedure para atualizar os dados de um produto na tabela produto
CREATE OR REPLACE PROCEDURE atualizar_produto(
    p_idproduto IN NUMBER,
    p_nomeproduto IN VARCHAR2,
    p_estrelas IN NUMBER,
    p_categoriaproduto IN VARCHAR2,
    p_qtdestoque IN NUMBER,
    p_datacompraproduto IN DATE,
    p_valorproduto IN NUMBER
)
AS BEGIN
    UPDATE produto SET 
        nomeproduto = p_nomeproduto, estrelas = p_estrelas, categoriaproduto = p_categoriaproduto, qtdestoque = p_qtdestoque, datacompraproduto = p_datacompraproduto, 
        valorproduto = p_valorproduto
    WHERE idproduto = p_idproduto;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum produto encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar produto: ' || SQLERRM);
        ROLLBACK;
END;
-- Exemplo de chamada na procedure atualizar_produto
DECLARE
    v_idproduto_atualizar NUMBER := 555;  
    v_nomeproduto_atualizado VARCHAR2(100) := 'Camiseta Nova'; 
    v_estrelas_atualizado NUMBER := 5;  
    v_categoriaproduto_atualizado VARCHAR2(50) := 'Moda Masculina';  
    v_qtdestoque_atualizado NUMBER := 200; 
    v_datacompraproduto_atualizado DATE := SYSDATE; 
    v_valorproduto_atualizado NUMBER := 299; 
BEGIN
    atualizar_produto(p_idproduto => v_idproduto_atualizar,p_nomeproduto => v_nomeproduto_atualizado,p_estrelas => v_estrelas_atualizado,
        p_categoriaproduto => v_categoriaproduto_atualizado,p_qtdestoque => v_qtdestoque_atualizado,p_datacompraproduto => v_datacompraproduto_atualizado,
        p_valorproduto => v_valorproduto_atualizado);
END;

-- Procedure para excluir um produto da tabela produto
CREATE OR REPLACE PROCEDURE excluir_produto(p_idproduto IN NUMBER)
AS BEGIN
    DELETE FROM produto WHERE idproduto = p_idproduto;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum produto encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir produto: ' || SQLERRM);
        ROLLBACK; 
END;
-- Exemplo de chamada na procedure excluir_produto
DECLARE
    v_idproduto_excluir NUMBER := 555; 
BEGIN
    excluir_produto(p_idproduto => v_idproduto_excluir);
END;

/*LEAD*/
-- DROP das procedures relacionadas à tabela lead
DROP PROCEDURE inserir_lead;
DROP PROCEDURE atualizar_lead;
DROP PROCEDURE excluir_lead;
-- Procedure para inserir um novo lead na tabela lead
CREATE OR REPLACE PROCEDURE inserir_lead(
    p_idlead IN NUMBER,
    p_idcliente IN NUMBER,
    p_canalorigem IN VARCHAR2,
    p_categoriaprodutointeresse IN VARCHAR2
)
AS BEGIN
    INSERT INTO lead (idlead, idcliente, canalorigem, categoriaprodutointeresse) 
    VALUES (p_idlead, p_idcliente, p_canalorigem, p_categoriaprodutointeresse);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir lead: Já existe um produto com este ID.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir lead: Verifique se os tipos de dados estão corretos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir lead: ' || SQLERRM);
        ROLLBACK; 
END;
-- Exemplo de chamada na procedure inserir_lead
DECLARE
    v_idlead NUMBER := 444;
    v_idcliente NUMBER := 101; 
    v_canalorigem VARCHAR2(50) := 'E-mail'; 
    v_categoriaprodutointeresse VARCHAR2(50) := 'Decoração';  
BEGIN
    inserir_lead(p_idlead => v_idlead,p_idcliente => v_idcliente,p_canalorigem => v_canalorigem, p_categoriaprodutointeresse => v_categoriaprodutointeresse);
END;

-- Procedure para atualizar os dados de um lead na tabela lead
CREATE OR REPLACE PROCEDURE atualizar_lead(
    p_idlead IN NUMBER,
    p_idcliente IN NUMBER,
    p_canalorigem IN VARCHAR2,
    p_categoriaprodutointeresse IN VARCHAR2
)
AS BEGIN
    UPDATE lead SET 
        idcliente = p_idcliente, canalorigem = p_canalorigem, categoriaprodutointeresse = p_categoriaprodutointeresse
    WHERE idlead = p_idlead;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum lead encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar lead: ' || SQLERRM);
        ROLLBACK;
END;
-- Exemplo de chamada na procedure atualizar_lead
DECLARE
    v_idlead_atualizar NUMBER := 444;
    v_idcliente_atualizado NUMBER := 101;
    v_canalorigem_atualizado VARCHAR2(50) := 'Redes Sociais';  -- Novo canal de origem do lead
    v_categoriaprodutointeresse_atualizada VARCHAR2(50) := 'Higiene';  -- Nova categoria de produto de interesse do lead
BEGIN
    atualizar_lead(p_idlead => v_idlead_atualizar,p_idcliente => v_idcliente_atualizado,p_canalorigem => v_canalorigem_atualizado,
    p_categoriaprodutointeresse => v_categoriaprodutointeresse_atualizada);
END;

-- Procedure para excluir um lead da tabela lead
CREATE OR REPLACE PROCEDURE excluir_lead(p_idlead IN NUMBER)
AS BEGIN
    DELETE FROM lead WHERE idlead = p_idlead;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum lead encontrado com o ID especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir lead: ' || SQLERRM);
        ROLLBACK; 
END;
-- Exemplo de chamada na procedure excluir_lead
DECLARE
    v_idlead_excluir NUMBER := 444;  -- ID do lead a ser excluído
BEGIN
    excluir_lead(p_idlead => v_idlead_excluir);
END;

-- CRIAÇÃO DE PROCEDURE COM USO DE JOIN E CURSOR
DROP PROCEDURE relatorio_compras;
CREATE OR REPLACE PROCEDURE relatorio_compras IS
  -- Declaração do cursor para obter informações sobre as compras
  CURSOR c_compras IS
    SELECT hc.idHistCompra, c.nome AS nome_cliente, p.nomeProduto, f.nomeFornecedor
    FROM Historico_Cliente hc
    JOIN Cliente c ON hc.idCliente = c.idCliente
    JOIN Produto p ON hc.idProduto = p.idProduto
    JOIN Produto_Fornecedor pf ON p.idProduto = pf.idProduto
    JOIN Fornecedor f ON pf.idFornecedor = f.idFornecedor;
BEGIN
  -- Imprime cabeçalho do relatório
  DBMS_OUTPUT.PUT_LINE('ID Compra | Cliente | Produto | Fornecedor');
  DBMS_OUTPUT.PUT_LINE('----------------------------------------');
  
  -- Utiliza um FOR loop para iterar sobre os resultados do cursor
  FOR compra IN c_compras LOOP
    -- Imprime informações da compra
    DBMS_OUTPUT.PUT_LINE(compra.idHistCompra || ' | ' || compra.nome_cliente || ' | ' || compra.nomeProduto || ' | ' || compra.nomeFornecedor);
  END LOOP;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nenhum relatorio de compra encontrado.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

-- Chamando a Procedure que utiliza JOIN e CURSOR
EXEC relatorio_compras;

-- CRIAÇÃO PROCEDURE QUE UTILIZE ( funções, inner Join, order by, sum ou count.) 
-- com Regra de negocio
/*
Regra de Negócio da Solução: Gerar um relatório que liste todas as localizações geográficas, 
ordenadas pela cidade, e mostre o número total de clientes associados a cada localização. 
Este relatório deve incluir as informações de cidade, estado e país, junto com o total de clientes para 
cada localização para a análise de distribuição geográfica de clientes.
*/
DROP PROCEDURE Relatorio_Clientes_Por_Localizacao;
CREATE OR REPLACE PROCEDURE Relatorio_Clientes_Por_Localizacao AS
    FUNCTION Contar_Clientes_Por_Localizacao(id_localizacao IN NUMBER) RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM Cliente c
        INNER JOIN LocalizacaoGeografica lg ON c.idLocalizacao = lg.idLocalizacao
        WHERE lg.idLocalizacao = id_localizacao;

        RETURN v_count;
    END Contar_Clientes_Por_Localizacao;
BEGIN
    FOR cur_localizacao IN (
        SELECT lg.idLocalizacao, lg.cidade, lg.estado, lg.pais
        FROM LocalizacaoGeografica lg
        ORDER BY lg.cidade
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Cidade: ' || cur_localizacao.cidade);
        DBMS_OUTPUT.PUT_LINE('Estado: ' || cur_localizacao.estado);
        DBMS_OUTPUT.PUT_LINE('País: ' || cur_localizacao.pais);
        DBMS_OUTPUT.PUT_LINE('Total de Clientes: ' || Contar_Clientes_Por_Localizacao(cur_localizacao.idLocalizacao));
        DBMS_OUTPUT.PUT_LINE('---------------------');
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma localização encontrada.');
    WHEN OTHERS THEN
        -- Registra o erro ou lida com ele conforme necessário
        DBMS_OUTPUT.PUT_LINE('Erro em Relatorio_Clientes_Por_Localizacao: ' || SQLERRM);
END Relatorio_Clientes_Por_Localizacao;
-- Chamando procedure que utiliza ( funções, inner Join, order by, sum ou count.)
EXEC Relatorio_Clientes_Por_Localizacao;
