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
