/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"

Turma : 2TDSPH

Bianca Leticia Román Caldeira - RM552267
Charlene Aparecida Estevam Mendes Fialho - RM552252
Lucca Raphael Pereira dos Santos - RM 99675
Lais Alves Da Silva Cruz - RM:552258
Fabrico Torres Antonio - RM:97916
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

-- Primeira função para validar entrada de dados: idade do cliente
/* Esta função valida se a idade do cliente é maior ou igual a 18 anos, 
como requisito para cadastro, conforme estabelecido pela regra de negócio.*/
DROP FUNCTION validar_idade_cliente;
CREATE OR REPLACE FUNCTION validar_idade_cliente(idade_cliente NUMBER) RETURN BOOLEAN IS
BEGIN
    IF idade_cliente >= 18 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- Segunda funcao para validar entrada de dados 
/* Esta função valida se o valor do produto é maior que zero, 
garantindo que apenas valores válidos sejam inseridos no banco de dados.*/
DROP FUNCTION validar_valor_produto;
CREATE OR REPLACE FUNCTION validar_valor_produto(valor_produto NUMBER) RETURN BOOLEAN IS
BEGIN
    IF valor_produto > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- Bloco PL/SQL com exemplo de uso das funções de validação
DECLARE
    v_idade_cliente cliente.idade%TYPE := &idadeCliente;
    v_valor_produto produto.valorproduto%TYPE := &valorProduto;
BEGIN
    IF v_idade_cliente < 18 THEN
        DBMS_OUTPUT.PUT_LINE('A idade do cliente não é válida.');
    ELSE
        BEGIN
            INSERT INTO Cliente (idCliente, nome, telefone, email, idade, genero, estadoCivil, idLocalizacao, nivelRenda, nivelEducacao, formaPagamentoPref) 
            VALUES (1, 'Maria', '123456789', 'maria@maria.com', v_idade_cliente, 'Feminino', 'Casado(a)', 201, 1000.00, 'Fundamental', 'Boleto');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao inserir dados do cliente.');
        END;
    END IF;

    IF v_valor_produto <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('O valor do produto não é válido.');
    ELSE
        BEGIN
            INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto) 
            VALUES (1, 'Maquiagem', 5, 'Cosméticos', 10, SYSDATE, v_valor_produto);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao inserir dados do produto.');
        END;
    END IF;
    COMMIT;
END;


-- CRIAÇÃO DE PROCEDURES DAS TABELAS => INSERT, DELETE E UPDATE
/* PESQUISA*/
-- Procedure para inserir uma nova pesquisa na tabela pesquisa
CREATE OR REPLACE PROCEDURE inserir_pesquisa(p_idpesquisa IN NUMBER,p_palavrachave IN VARCHAR2)
AS BEGIN
    INSERT INTO pesquisa (idpesquisa, palavrachave) 
    VALUES (p_idpesquisa, p_palavrachave);
    COMMIT;
END;

-- Procedure para atualizar os dados de uma pesquisa na tabela pesquisa
CREATE OR REPLACE PROCEDURE atualizar_pesquisa(
    p_idpesquisa IN NUMBER,
    p_palavrachave IN VARCHAR2
)
AS BEGIN
    UPDATE pesquisa SET 
        palavrachave = p_palavrachave
    WHERE idpesquisa = p_idpesquisa;
    COMMIT;
END;

-- Procedure para excluir uma pesquisa da tabela pesquisa
CREATE OR REPLACE PROCEDURE excluir_pesquisa(p_idpesquisa IN NUMBER)
AS BEGIN
    DELETE FROM pesquisa WHERE idpesquisa = p_idpesquisa;
    COMMIT;
END;


/*LOCALIZACAOGEOGRAFICA*/
-- Procedure para inserir uma nova localização geográfica na tabela localizacaogeografica
CREATE OR REPLACE PROCEDURE inserir_localizacao_geografica(
    p_idlocalizacao IN NUMBER,
    p_pais IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_cidade IN VARCHAR2,
    p_cep IN VARCHAR2
)
AS BEGIN
    INSERT INTO localizacaogeografica (idlocalizacao, pais, estado, cidade, cep) 
    VALUES (p_idlocalizacao, p_pais, p_estado, p_cidade, p_cep);
    COMMIT;
END;

-- Procedure para atualizar os dados de uma localização geográfica na tabela localizacaogeografica
CREATE OR REPLACE PROCEDURE atualizar_localizacao_geografica(
    p_idlocalizacao IN NUMBER,
    p_pais IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_cidade IN VARCHAR2,
    p_cep IN VARCHAR2
)
AS BEGIN
    UPDATE localizacaogeografica SET 
        pais = p_pais, 
        estado = p_estado, 
        cidade = p_cidade, 
        cep = p_cep
    WHERE idlocalizacao = p_idlocalizacao;
    COMMIT;
END;

-- Procedure para excluir uma localização geográfica da tabela localizacaogeografica
CREATE OR REPLACE PROCEDURE excluir_localizacao_geografica(p_idlocalizacao IN NUMBER)
AS BEGIN
    DELETE FROM localizacaogeografica WHERE idlocalizacao = p_idlocalizacao;
    COMMIT;
END;


/*CLIENTE*/
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
    INSERT INTO cliente (idcliente, nome, telefone, email, idade, genero, estadocivil, idlocalizacao, nivelrenda, niveleducacao, formapagamentopref) 
    VALUES (p_idcliente, p_nome, p_telefone, p_email, p_idade, p_genero, p_estadocivil, p_idlocalizacao, p_nivelrenda, p_niveleducacao, p_formapagamentopref);
    COMMIT;
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
        nome = p_nome, 
        telefone = p_telefone, 
        email = p_email, 
        idade = p_idade, 
        genero = p_genero, 
        estadocivil = p_estadocivil, 
        idlocalizacao = p_idlocalizacao, 
        nivelrenda = p_nivelrenda, 
        niveleducacao = p_niveleducacao, 
        formapagamentopref = p_formapagamentopref 
    WHERE idcliente = p_idcliente;
    COMMIT;
END;

-- Procedure para excluir um cliente da tabela cliente
CREATE OR REPLACE PROCEDURE excluir_cliente(p_idcliente IN NUMBER)
AS BEGIN
    DELETE FROM cliente WHERE idcliente = p_idcliente;
    COMMIT;
END;

/*PRODUTO*/
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
    INSERT INTO produto (idproduto, nomeproduto, estrelas, categoriaproduto, qtdestoque, datacompraproduto, valorproduto) 
    VALUES (p_idproduto, p_nomeproduto, p_estrelas, p_categoriaproduto, p_qtdestoque, p_datacompraproduto, p_valorproduto);
    COMMIT;
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
        nomeproduto = p_nomeproduto, 
        estrelas = p_estrelas, 
        categoriaproduto = p_categoriaproduto, 
        qtdestoque = p_qtdestoque, 
        datacompraproduto = p_datacompraproduto, 
        valorproduto = p_valorproduto
    WHERE idproduto = p_idproduto;
    COMMIT;
END;

-- Procedure para excluir um produto da tabela produto
CREATE OR REPLACE PROCEDURE excluir_produto(p_idproduto IN NUMBER)
AS BEGIN
    DELETE FROM produto WHERE idproduto = p_idproduto;
    COMMIT;
END;


/*FORNECEDOR*/
-- Procedure para inserir um novo fornecedor na tabela fornecedor
CREATE OR REPLACE PROCEDURE inserir_fornecedor(
    p_idfornecedor IN NUMBER,
    p_nomefornecedor IN VARCHAR2,
    p_tipofornecedor IN VARCHAR2
)
AS BEGIN
    INSERT INTO fornecedor (idfornecedor, nomefornecedor, tipofornecedor) 
    VALUES (p_idfornecedor, p_nomefornecedor, p_tipofornecedor);
    COMMIT;
END;

-- Procedure para atualizar os dados de um fornecedor na tabela fornecedor
CREATE OR REPLACE PROCEDURE atualizar_fornecedor(
    p_idfornecedor IN NUMBER,
    p_nomefornecedor IN VARCHAR2,
    p_tipofornecedor IN VARCHAR2
)
AS BEGIN
    UPDATE fornecedor SET 
        nomefornecedor = p_nomefornecedor, 
        tipofornecedor = p_tipofornecedor
    WHERE idfornecedor = p_idfornecedor;
    COMMIT;
END;

-- Procedure para excluir um fornecedor da tabela fornecedor
CREATE OR REPLACE PROCEDURE excluir_fornecedor(p_idfornecedor IN NUMBER)
AS BEGIN
    DELETE FROM fornecedor WHERE idfornecedor = p_idfornecedor;
    COMMIT;
END;

/*CLIENTE_PRODUTO*/
-- Procedure para inserir uma nova entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE inserir_pesquisa_cliente(
    p_idcliente IN NUMBER,
    p_idpesquisa IN NUMBER
)
AS BEGIN
    INSERT INTO pesquisa_cliente (idcliente, idpesquisa) 
    VALUES (p_idcliente, p_idpesquisa);
    COMMIT;
END;

-- Procedure para atualizar uma entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE atualizar_pesquisa_cliente(
    p_idcliente IN NUMBER,
    p_idpesquisa IN NUMBER
)
AS BEGIN
    UPDATE pesquisa_cliente SET 
        idcliente = p_idcliente
    WHERE idpesquisa = p_idpesquisa;
    COMMIT;
END;

-- Procedure para excluir uma entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE excluir_pesquisa_cliente(p_idpesquisa IN NUMBER)
AS BEGIN
    DELETE FROM pesquisa_cliente WHERE idpesquisa = p_idpesquisa;
    COMMIT;
END;


/*HISTORICO_CLIENTE*/
-- Procedure para inserir um novo registro no histórico do cliente na tabela historico_cliente
CREATE OR REPLACE PROCEDURE inserir_historico_cliente(
    p_idhistcompra IN NUMBER,
    p_idcliente IN NUMBER,
    p_idproduto IN NUMBER,
    p_datacompraproduto IN DATE
)
AS BEGIN
    INSERT INTO historico_cliente (idhistcompra, idcliente, idproduto, datacompraproduto) 
    VALUES (p_idhistcompra, p_idcliente, p_idproduto, p_datacompraproduto);
    COMMIT;
END;

-- Procedure para atualizar os dados de um registro no histórico do cliente na tabela historico_cliente
CREATE OR REPLACE PROCEDURE atualizar_historico_cliente(
    p_idhistcompra IN NUMBER,
    p_idcliente IN NUMBER,
    p_idproduto IN NUMBER,
    p_datacompraproduto IN DATE
)
AS BEGIN
    UPDATE historico_cliente SET 
        idcliente = p_idcliente, 
        idproduto = p_idproduto, 
        datacompraproduto = p_datacompraproduto
    WHERE idhistcompra = p_idhistcompra;
    COMMIT;
END;

-- Procedure para excluir um registro do histórico do cliente da tabela historico_cliente
CREATE OR REPLACE PROCEDURE excluir_historico_cliente(p_idhistcompra IN NUMBER)
AS BEGIN
    DELETE FROM historico_cliente WHERE idhistcompra = p_idhistcompra;
    COMMIT;
END;

/*PESQUISA_CLIENTE*/
-- Procedure para inserir uma nova entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE inserir_pesquisa_cliente(
    p_idcliente IN NUMBER,
    p_idpesquisa IN NUMBER
)
AS BEGIN
    INSERT INTO pesquisa_cliente (idcliente, idpesquisa) 
    VALUES (p_idcliente, p_idpesquisa);
    COMMIT;
END;

-- Procedure para atualizar uma entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE atualizar_pesquisa_cliente(
    p_idcliente IN NUMBER,
    p_idpesquisa IN NUMBER,
    p_novoidcliente IN NUMBER
)
AS BEGIN
    UPDATE pesquisa_cliente SET 
        idcliente = p_novoidcliente
    WHERE idcliente = p_idcliente AND idpesquisa = p_idpesquisa;
    COMMIT;
END;

-- Procedure para excluir uma entrada na tabela pesquisa_cliente
CREATE OR REPLACE PROCEDURE excluir_pesquisa_cliente(
    p_idcliente IN NUMBER,
    p_idpesquisa IN NUMBER
)
AS BEGIN
    DELETE FROM pesquisa_cliente WHERE idcliente = p_idcliente AND idpesquisa = p_idpesquisa;
    COMMIT;
END;

/*HISTORICO_PRODUTO*/
-- Procedure para inserir um novo registro na tabela historico_produto
CREATE OR REPLACE PROCEDURE inserir_historico_produto(
    p_idhistcompra IN NUMBER,
    p_idproduto IN NUMBER
)
AS BEGIN
    INSERT INTO historico_produto (idhistcompra, idproduto) 
    VALUES (p_idhistcompra, p_idproduto);
    COMMIT;
END;

-- Procedure para atualizar um registro na tabela historico_produto
CREATE OR REPLACE PROCEDURE atualizar_historico_produto(
    p_idhistcompra IN NUMBER,
    p_novoidproduto IN NUMBER
)
AS BEGIN
    UPDATE historico_produto SET 
        idproduto = p_novoidproduto
    WHERE idhistcompra = p_idhistcompra;
    COMMIT;
END;

-- Procedure para excluir um registro na tabela historico_produto
CREATE OR REPLACE PROCEDURE excluir_historico_produto(p_idhistcompra IN NUMBER)
AS BEGIN
    DELETE FROM historico_produto WHERE idhistcompra = p_idhistcompra;
    COMMIT;
END;


/*PRODUTO_FORNECEDOR*/
-- Procedure para inserir um novo relacionamento na tabela produto_fornecedor
CREATE OR REPLACE PROCEDURE inserir_produto_fornecedor(
    p_idproduto IN NUMBER,
    p_idfornecedor IN NUMBER
)
AS BEGIN
    INSERT INTO produto_fornecedor (idproduto, idfornecedor) 
    VALUES (p_idproduto, p_idfornecedor);
    COMMIT;
END;

-- Procedure para atualizar um relacionamento na tabela produto_fornecedor
CREATE OR REPLACE PROCEDURE atualizar_produto_fornecedor(
    p_idproduto IN NUMBER,
    p_idfornecedor IN NUMBER,
    p_novoidfornecedor IN NUMBER
)
AS BEGIN
    UPDATE produto_fornecedor SET 
        idfornecedor = p_novoidfornecedor
    WHERE idproduto = p_idproduto AND idfornecedor = p_idfornecedor;
    COMMIT;
END;

-- Procedure para excluir um relacionamento na tabela produto_fornecedor
CREATE OR REPLACE PROCEDURE excluir_produto_fornecedor(
    p_idproduto IN NUMBER,
    p_idfornecedor IN NUMBER
)
AS BEGIN
    DELETE FROM produto_fornecedor WHERE idproduto = p_idproduto AND idfornecedor = p_idfornecedor;
    COMMIT;
END;

/*LEAD*/
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
        idcliente = p_idcliente, 
        canalorigem = p_canalorigem, 
        categoriaprodutointeresse = p_categoriaprodutointeresse
    WHERE idlead = p_idlead;
    COMMIT;
END;

-- Procedure para excluir um lead da tabela lead
CREATE OR REPLACE PROCEDURE excluir_lead(p_idlead IN NUMBER)
AS BEGIN
    DELETE FROM lead WHERE idlead = p_idlead;
    COMMIT;
END;

