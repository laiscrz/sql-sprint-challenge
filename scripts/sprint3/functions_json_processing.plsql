/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM AS FUNCTIONS e SEUS TESTES => JSON e Substituição de Processo (SPRINT 3) ---------------------------
*/


SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- ------------------------- FUNCTIONS (30 PONTOS) -------------------------

/* 
------------------------- PRIMEIRA FUNCAO -------------------------
converte_json_func:  Esta função tem como objetivo converter um conjunto de dados 
retornado por um cursor (SYS_REFCURSOR) em uma string JSON.
OBS. será chamada e TESTADA na procedure que será implementada posteriormente.
*/
CREATE OR REPLACE FUNCTION converte_json_func(p_cursor IN SYS_REFCURSOR) RETURN VARCHAR2 IS
    v_json VARCHAR2(32767) := '[';
    v_separator VARCHAR2(10) := '';
    v_idCliente Cliente.idCliente%TYPE;
    v_nome Cliente.nome%TYPE;
    v_telefone Cliente.telefone%TYPE;
    v_email Cliente.email%TYPE;
    v_idade Cliente.idade%TYPE;
    v_idProduto Produto.idProduto%TYPE;
    v_nomeProduto Produto.nomeProduto%TYPE;
    v_categoriaProduto Produto.categoriaProduto%TYPE;
    v_valorProduto Produto.valorProduto%TYPE;
BEGIN
    LOOP
        FETCH p_cursor INTO v_idCliente, v_nome, v_telefone, v_email, v_idade, v_idProduto, v_nomeProduto, v_categoriaProduto, v_valorProduto;
        EXIT WHEN p_cursor%NOTFOUND;

        v_json := v_json || v_separator ||
                  '{"idCliente": "' || v_idCliente || '", ' ||
                  '"nomeCliente": "' || v_nome || '", ' || 
                  '"telefoneCliente": "' || v_telefone || '", ' ||
                  '"emailCliente": "' || v_email || '", ' || 
                  '"idadeCliente": ' || v_idade || ', ' || 
                  '"idProduto": "' || v_idProduto || '", ' ||
                  '"nomeProduto": "' || v_nomeProduto || '", ' || 
                  '"categoriaProduto": "' || v_categoriaProduto || '", ' ||
                  '"valorProduto": ' || v_valorProduto || '}';
        v_separator := ',' || CHR(10);
    END LOOP;
    v_json := v_json || ']';
    RETURN v_json;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado no cursor.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro de conversão de tipo de dado ao processar dados do cursor.');
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O cursor está inválido ou fechado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao converter dados para JSON: ' || SQLERRM);
END;

------------------------- TESTES DA FUNTION : converte_json_func -------------------------
-- TESTE: da funcao converte_json_func similar a nossa procedure (com sucesso)
DECLARE
    c_cliente_produto SYS_REFCURSOR;
    v_json_resultado VARCHAR2(32767);
BEGIN
    OPEN c_cliente_produto FOR
        SELECT c.idCliente, c.nome, c.telefone, c.email, c.idade,
               p.idProduto, p.nomeProduto, p.categoriaProduto, p.valorProduto
        FROM Cliente c
        JOIN Cliente_Produto cp ON c.idCliente = cp.idCliente
        JOIN Produto p ON cp.idProduto = p.idProduto;

    v_json_resultado := converte_json_func(c_cliente_produto);

    DBMS_OUTPUT.PUT_LINE('Resultado em JSON:');
    DBMS_OUTPUT.PUT_LINE(v_json_resultado);

    CLOSE c_cliente_produto;
END;

-- TESTE: da funcao converte_json_fun (CAI NA EXCEPTION VALUE_ERROR)
DECLARE
    -- Cursor para simular um erro ao converter dados (neste caso, idade será um VARCHAR)
    c_cliente_produto SYS_REFCURSOR;
    v_json_resultado VARCHAR2(32767);
BEGIN
    -- Abrir o cursor -> intencionalmente retorna um erro (idade sendo passada como VARCHAR)
    OPEN c_cliente_produto FOR
        SELECT c.idCliente, c.nome, c.telefone, c.email, TO_CHAR(c.idade, 'A999') AS idade, 
               p.idProduto, p.nomeProduto, p.categoriaProduto, p.valorProduto
        FROM Cliente c
        JOIN Cliente_Produto cp ON c.idCliente = cp.idCliente
        JOIN Produto p ON cp.idProduto = p.idProduto;
        
    -- Chamar a função e capturar o resultado JSON (deve gerar um erro de VALUE_ERROR)
    v_json_resultado := converte_json_func(c_cliente_produto);

    -- Exibir o resultado JSON no DBMS_OUTPUT 
    DBMS_OUTPUT.PUT_LINE('Resultado em JSON:');
    DBMS_OUTPUT.PUT_LINE(v_json_resultado);

    CLOSE c_cliente_produto;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro durante o teste: ' || SQLERRM);
END;

/*----------------------------------------------------------------------------------------------------*/


/*
------------------------- SEGUNDA FUNCAO -------------------------
calcular_compras_por_categoria : calcula manualmente as compras por categoria e retorna um cursor com os resultados. 
Ela substitui o bloco anônimo presente no script, separando a logica de contagem da execucao e teste, 
o que melhora a modularidade e a manutenção do codigo.
*/
CREATE OR REPLACE FUNCTION calcular_compras_por_categoria RETURN VARCHAR2 IS
    v_categoriaProduto Produto.categoriaProduto%TYPE;
    v_total_compras NUMBER;
    v_resultado VARCHAR2(4000); 
BEGIN
    v_resultado := '';

    FOR r IN (
        SELECT p.categoriaProduto,
               (SELECT COUNT(*)
                FROM Historico_Cliente h
                JOIN Produto p2 ON h.idProduto = p2.idProduto
                WHERE p2.categoriaProduto = p.categoriaProduto) AS total_compras
        FROM Produto p
        GROUP BY p.categoriaProduto
    ) LOOP
        v_resultado := v_resultado || 'Categoria: ' || r.categoriaProduto || ' | '|| ' Total de Compras: ' || r.total_compras || CHR(10);
    END LOOP;

    IF v_resultado IS NULL OR v_resultado = '' THEN
        v_resultado := 'Nenhuma categoria encontrada.';
    END IF;

    RETURN v_resultado;
EXCEPTION
    WHEN ACCESS_INTO_NULL THEN
    RETURN 'Erro: Tentativa de acessar um valor nulo em um objeto.';
    WHEN VALUE_ERROR THEN
        RETURN 'Erro: Valor inesperado encontrado ao processar as compras.';
    WHEN INVALID_NUMBER THEN
        RETURN 'Erro: Tentativa de conversão de string para número inválido.';
    WHEN INVALID_CURSOR THEN
        RETURN 'Erro: ORA-01001: cursor inválido.';
    WHEN OTHERS THEN
        RETURN 'Erro ao processar as compras: ' || SQLERRM;
END calcular_compras_por_categoria;

------------------------- TESTES DA FUNTION: calcular_compras por_categoria -------------------------
-- TESTE: da funcao calcular_compras_por_categoria (com sucesso)
DECLARE
    v_resultado VARCHAR2(4000);
BEGIN
    v_resultado := calcular_compras_por_categoria;

    DBMS_OUTPUT.PUT_LINE(v_resultado);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao testar a função: ' || SQLERRM);
END;

-- TESTE: da função calcular_compras_por_categoria (CAI NA EXCEPTION INVALID_CURSOR)
DECLARE
    v_cursor SYS_REFCURSOR;
    v_categoriaProduto Produto.categoriaProduto%TYPE;
    v_total_compras NUMBER;
    v_resultado VARCHAR2(4000);
BEGIN
    OPEN v_cursor FOR SELECT categoriaProduto FROM Produto;
    CLOSE v_cursor; -- Fechar o cursor antes de utilizá-lo

    -- Agora tentar usar o cursor fechado (isso deve gerar INVALID_CURSOR)
    LOOP
        FETCH v_cursor INTO v_categoriaProduto;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_categoriaProduto);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Deveria ter dado erro aqui.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;