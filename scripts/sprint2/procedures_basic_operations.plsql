/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM OS CODIGOS DAS PROCEDURES DAS TABELAS => INSERT, DELETE E UPDATE (SPRINT 2) ---------------------------
*/


SET SERVEROUTPUT ON;
SET VERIFY OFF;

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