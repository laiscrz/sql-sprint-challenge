/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM AS PROCEDURES e SEUS TESTES => JOIN + JSON e Relatorio (SPRINT 3) ---------------------------
*/


SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- ------------------------- PROCEDURES (30 PONTOS) -------------------------
/* 
------------------------- PRIMEIRA PROCEDURE -------------------------
obter_dados_cliente_produto: Este procedimento é responsável por recuperar dados de 
clientes e produtos a partir de tabelas relacionadas (JOIN), converter esses dados em uma string JSON.
Ele precisa retornar no minimo 5 registros solicitado pela disciplina (usado como parametro)
*/
CREATE OR REPLACE PROCEDURE obter_dados_cliente_produto (p_min_registros IN NUMBER) IS
    v_cursor SYS_REFCURSOR;
    v_json VARCHAR2(32767);
    v_contagem NUMBER;
    
    e_registros_insuficientes EXCEPTION;
    v_mensagem_registros_insuficientes VARCHAR2(100) := 'Número de registros insuficiente.';

BEGIN
    OPEN v_cursor FOR
        SELECT c.idCliente, c.nome, c.telefone, c.email, c.idade,
               p.idProduto, p.nomeProduto, p.categoriaProduto, p.valorProduto
        FROM Cliente c
        JOIN Cliente_Produto cp ON c.idCliente = cp.idCliente
        JOIN Produto p ON cp.idProduto = p.idProduto;

    SELECT COUNT(*)
    INTO v_contagem
    FROM (
        SELECT 1
        FROM Cliente c
        JOIN Cliente_Produto cp ON c.idCliente = cp.idCliente
        JOIN Produto p ON cp.idProduto = p.idProduto
    );

    --  mínimo requerido (solicitado pela disciplina)
    IF v_contagem < p_min_registros THEN
        RAISE e_registros_insuficientes;
    ELSE
        v_json := converte_json_func(v_cursor);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_json);

EXCEPTION
    WHEN e_registros_insuficientes THEN
        DBMS_OUTPUT.PUT_LINE(v_mensagem_registros_insuficientes);
        v_json := '{"Erro": "Número de registros insuficiente."}'; -- Exception personalizada
        DBMS_OUTPUT.PUT_LINE(v_json);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Muitos registros retornados.');
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Cursor inválido ou não inicializado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;

------------------------- TESTES DA PROCEDURE : obter_dados_cliente -------------------------
-- Executa a procedure OBTER_DADOS_CLIENTE_PRODUTO (COM SUCESSO)
EXEC OBTER_DADOS_CLIENTE_PRODUTO(5); -- como solicitado pela disciplina precisa retornar no minimo 5 valores


-- TESTE: a procedure OBTER_DADOS_CLIENTE_PRODUTO -> Simular erro (passagem de paremetros 
-- com numero maior de registros que existem na tabela)
EXEC OBTER_DADOS_CLIENTE_PRODUTO(10);

/* ---------------------------------------------------------------------------------------------------- */

/*
------------------------- SEGUNDA PROCEDURE -------------------------
Historico_Cliente_Detalhado: Este procedimento mostra um relatório detalhado sobre o histórico de compras dos clientes, 
exibindo a data da compra atual,  a data da compra anterior e a data da próxima compra. 
Se não houver dados para a compra anterior ou a próxima, ele exibe "Vazio".
*/
CREATE OR REPLACE PROCEDURE Historico_Cliente_Detalhado AS
    CURSOR c_historico IS
        SELECT idHistCompra, idCliente, idProduto, dataCompraProduto
        FROM Historico_Cliente
        ORDER BY idHistCompra;
        
    v_idHistCompra NUMBER;
    v_idCliente NUMBER;
    v_idProduto NUMBER;
    v_dataCompraProduto DATE;

    v_idHistCompra_prev NUMBER := NULL;
    v_dataCompraProduto_prev DATE := NULL;
    v_dataCompraProduto_next DATE := NULL;
    
BEGIN
    OPEN c_historico;
    FETCH c_historico INTO v_idHistCompra, v_idCliente, v_idProduto, v_dataCompraProduto;
    IF c_historico%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado no histórico de compras.');
        CLOSE c_historico;
        RETURN;
    END IF;

    FETCH c_historico INTO v_idHistCompra_prev, v_idCliente, v_idProduto, v_dataCompraProduto_next;

    LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_idHistCompra ||
                             ' | Anterior: ' || NVL(TO_CHAR(v_dataCompraProduto_prev, 'YYYY-MM-DD'), 'Vazio') ||
                             ' | Atual: ' || TO_CHAR(v_dataCompraProduto, 'YYYY-MM-DD') ||
                             ' | Próximo: ' || NVL(TO_CHAR(v_dataCompraProduto_next, 'YYYY-MM-DD'), 'Vazio'));

        v_dataCompraProduto_prev := v_dataCompraProduto;
        v_idHistCompra := v_idHistCompra_prev;
        v_dataCompraProduto := v_dataCompraProduto_next;
        
        FETCH c_historico INTO v_idHistCompra_prev, v_idCliente, v_idProduto, v_dataCompraProduto_next;
        
        EXIT WHEN c_historico%NOTFOUND;

        IF c_historico%NOTFOUND THEN
            v_dataCompraProduto_next := NULL;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('ID: ' || v_idHistCompra ||
                         ' | Anterior: ' || NVL(TO_CHAR(v_dataCompraProduto_prev, 'YYYY-MM-DD'), 'Vazio') ||
                         ' | Atual: ' || TO_CHAR(v_dataCompraProduto, 'YYYY-MM-DD') ||
                         ' | Próximo: Vazio');

    CLOSE c_historico;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado no histórico de compras.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor inesperado encontrado ao processar os dados.');
    WHEN ACCESS_INTO_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tentativa de acessar um valor nulo em um objeto.');
    WHEN CURSOR_ALREADY_OPEN THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O cursor já está aberto.');
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ORA-01722: número inválido');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao processar o histórico de compras: ' || SQLERRM);
END;

------------------------- TESTES DA PROCEDURE: historico_cliente_detalhado -------------------------
-- Execução do procedimento Historico_Cliente_Detalhado (COM SUCESSO)
EXEC Historico_Cliente_Detalhado;

-- TESTE: procedimento Historico_Cliente_Detalhado que caia na EXCEPTION (INVALID NUMBER)
BEGIN
    INSERT INTO Historico_Cliente (idHistCompra, idCliente, idProduto, dataCompraProduto)
        VALUES (999, 'texto_invalido', 1, TO_DATE('2024-02-20', 'YYYY-MM-DD')); -- Valor não numérico em idCliente

    Historico_Cliente_Detalhado;
    
    DELETE FROM Historico_Cliente WHERE idHistCompra = 999;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;