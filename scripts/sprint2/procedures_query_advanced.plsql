/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- Este script contém as PROCEDURES para CONSULTAS utilizando JOIN, CURSOR, FUNÇÕES, INNER JOIN, ORDER BY e AGREGAÇÃO (SUM/COUNT) - (SPRINT 2) ---------------------------
*/


SET SERVEROUTPUT ON;
SET VERIFY OFF;

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