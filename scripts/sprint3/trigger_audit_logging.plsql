/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM O GATILHO (INSERT, UPDATE, DELETE) e SEUS TESTES => Com criar a tabela auditoria (SPRINT 3) ---------------------------
*/

-- -------------------------TRIGGER (30 PONTOS)-------------------------
/* 
------------------------- CREATE TABELA AUDITORIA -------------------------
*/
DROP TABLE auditoria CASCADE CONSTRAINTS;
CREATE TABLE Auditoria (
    id_auditoria NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome_tabela VARCHAR2(50),
    operacao VARCHAR2(10),
    usuario VARCHAR2(50),
    data_operacao DATE,
    dados_antigos VARCHAR2(4000),
    dados_novos VARCHAR2(4000)
);

/*
Trigger: trig_auditoria_produto
    Objetivo: Registrar todas as operações de INSERT, UPDATE e DELETE na tabela Produto.
    A cada operação, o trigger insere um registro na tabela Auditoria com os dados antigos e novos, nome do usuário que fez a operação,
    tipo da operação (INSERT, UPDATE, DELETE) e a data da operação.
*/
CREATE OR REPLACE TRIGGER trig_auditoria_produto
AFTER INSERT OR UPDATE OR DELETE ON Produto
FOR EACH ROW
DECLARE
    v_usuario VARCHAR2(50) := USER;
    v_dados_antigos VARCHAR2(4000);
    v_dados_novos VARCHAR2(4000);
BEGIN
    -- Concatena os dados antigos, se disponíveis
    IF INSERTING THEN
        v_dados_antigos := NULL; -- Inserindo novos valores, por isso NAO TEM DADOS ANTIGOS
        v_dados_novos := 'ID: ' || :NEW.idProduto || ', Nome: ' || :NEW.nomeProduto || 
                         ', Estrelas: ' || :NEW.estrelas || ', Categoria: ' || :NEW.categoriaProduto || 
                         ', Quantidade em Estoque: ' || :NEW.qtdEstoque || 
                         ', Data Compra: ' || TO_CHAR(:NEW.dataCompraProduto, 'DD/MM/YYYY') ||
                         ', Valor: ' || :NEW.valorProduto;
        INSERT INTO Auditoria (nome_tabela, operacao, usuario, data_operacao, dados_antigos, dados_novos)
        VALUES ('Produto', 'INSERT', v_usuario, SYSDATE, v_dados_antigos, v_dados_novos);
        
    ELSIF DELETING THEN
        v_dados_antigos := 'ID: ' || :OLD.idProduto || ', Nome: ' || :OLD.nomeProduto || 
                           ', Estrelas: ' || :OLD.estrelas || ', Categoria: ' || :OLD.categoriaProduto || 
                           ', Quantidade em Estoque: ' || :OLD.qtdEstoque || 
                           ', Data Compra: ' || TO_CHAR(:OLD.dataCompraProduto, 'DD/MM/YYYY') ||
                           ', Valor: ' || :OLD.valorProduto;
        v_dados_novos := NULL; -- os dados sao DELETADOS, por isso NAO TEM novos valores
        INSERT INTO Auditoria (nome_tabela, operacao, usuario, data_operacao, dados_antigos, dados_novos)
        VALUES ('Produto', 'DELETE', v_usuario, SYSDATE, v_dados_antigos, v_dados_novos);
        
    ELSIF UPDATING THEN
        v_dados_antigos := 'ID: ' || :OLD.idProduto || ', Nome: ' || :OLD.nomeProduto || 
                           ', Estrelas: ' || :OLD.estrelas || ', Categoria: ' || :OLD.categoriaProduto || 
                           ', Quantidade em Estoque: ' || :OLD.qtdEstoque || 
                           ', Data Compra: ' || TO_CHAR(:OLD.dataCompraProduto, 'DD/MM/YYYY') ||
                           ', Valor: ' || :OLD.valorProduto;
        v_dados_novos := 'ID: ' || :NEW.idProduto || ', Nome: ' || :NEW.nomeProduto || 
                         ', Estrelas: ' || :NEW.estrelas || ', Categoria: ' || :NEW.categoriaProduto || 
                         ', Quantidade em Estoque: ' || :NEW.qtdEstoque || 
                         ', Data Compra: ' || TO_CHAR(:NEW.dataCompraProduto, 'DD/MM/YYYY') ||
                         ', Valor: ' || :NEW.valorProduto;
        INSERT INTO Auditoria (nome_tabela, operacao, usuario, data_operacao, dados_antigos, dados_novos)
        VALUES ('Produto', 'UPDATE', v_usuario, SYSDATE, v_dados_antigos, v_dados_novos);
    END IF;
END;

/*
    ------------------------- Blocos para testar o trigger -------------------------
*/

-- TESTE TRIGGER -> INSERT
BEGIN
    INSERT INTO Produto (idProduto, nomeProduto, estrelas, categoriaProduto, qtdEstoque, dataCompraProduto, valorProduto)
    VALUES (2, 'Batom', 5, 'Maquiagem', 50, TO_DATE('2024-09-10', 'YYYY-MM-DD'), 29.99);
    
    DBMS_OUTPUT.PUT_LINE('Registros na tabela Auditoria após INSERT:');
    
    FOR r IN (
        SELECT * 
        FROM Auditoria 
        WHERE nome_tabela = 'Produto' 
          AND operacao = 'INSERT'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Nome da Tabela   : ' || r.nome_tabela);
        DBMS_OUTPUT.PUT_LINE('Operação          : ' || r.operacao);
        DBMS_OUTPUT.PUT_LINE('Usuário           : ' || r.usuario);
        DBMS_OUTPUT.PUT_LINE('Data da Operação  : ' || TO_CHAR(r.data_operacao, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Dados Antigos     : ' || NVL(r.dados_antigos, 'NENHUM DADO ANTERIOR'));
        DBMS_OUTPUT.PUT_LINE('Dados Novos       : ' || NVL(r.dados_novos, 'Nenhum dado novo'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;

-- TESTE TRIGGER -> UPDATE
BEGIN
    UPDATE Produto
    SET nomeProduto = 'Batom Colorido', estrelas = 4
    WHERE idProduto = 2;
    
    DBMS_OUTPUT.PUT_LINE('Registros na tabela Auditoria após UPDATE:');
    
    FOR r IN (
        SELECT * 
        FROM Auditoria 
        WHERE nome_tabela = 'Produto' 
          AND operacao = 'UPDATE'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Nome da Tabela   : ' || r.nome_tabela);
        DBMS_OUTPUT.PUT_LINE('Operação          : ' || r.operacao);
        DBMS_OUTPUT.PUT_LINE('Usuário           : ' || r.usuario);
        DBMS_OUTPUT.PUT_LINE('Data da Operação  : ' || TO_CHAR(r.data_operacao, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Dados Antigos     : ' || r.dados_antigos);
        DBMS_OUTPUT.PUT_LINE('Dados Novos       : ' || r.dados_novos);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;


-- TESTE TRIGGER -> DELETE
BEGIN
    DELETE FROM Produto WHERE idProduto = 2;
    
    DBMS_OUTPUT.PUT_LINE('Registros na tabela Auditoria após DELETE:');
    
    FOR r IN (
        SELECT * 
        FROM Auditoria 
        WHERE nome_tabela = 'Produto' 
          AND operacao = 'DELETE'
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Nome da Tabela   : ' || r.nome_tabela);
        DBMS_OUTPUT.PUT_LINE('Operação          : ' || r.operacao);
        DBMS_OUTPUT.PUT_LINE('Usuário           : ' || r.usuario);
        DBMS_OUTPUT.PUT_LINE('Data da Operação  : ' || TO_CHAR(r.data_operacao, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Dados Antigos     : ' || r.dados_antigos);
        DBMS_OUTPUT.PUT_LINE('Dados Novos       : ' || r.dados_novos || 'NAO CONTEM (DADOS DELETADOS)');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;

-- TESTE TRIGGER -> VISUALIZANDO A TABELA AUDITORIA
BEGIN
    DBMS_OUTPUT.PUT_LINE('Registros da tabela Auditoria:');
    
    FOR r IN (
        SELECT nome_tabela,operacao,usuario,
               data_operacao,dados_antigos,dados_novos
        FROM Auditoria
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Nome da Tabela   : ' || r.nome_tabela);
        DBMS_OUTPUT.PUT_LINE('Operação          : ' || r.operacao);
        DBMS_OUTPUT.PUT_LINE('Usuário           : ' || r.usuario);
        DBMS_OUTPUT.PUT_LINE('Data da Operação  : ' || TO_CHAR(r.data_operacao, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Dados Antigos     : ' || NVL(r.dados_antigos, 'Nenhum dado anterior'));
        DBMS_OUTPUT.PUT_LINE('Dados Novos       : ' || NVL(r.dados_novos, 'Nenhum dado novo'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
END;


