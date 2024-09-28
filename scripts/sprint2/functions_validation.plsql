/*
Empresa LeadTech

Banco de dados relacionado ao projeto "Conversao Inteligente"


Bianca Leticia Román Caldeira - RM552267 - Turma : 2TDSPH
Charlene Aparecida Estevam Mendes Fialho - RM552252 - Turma : 2TDSPH
Lais Alves Da Silva Cruz - RM:552258 - Turma : 2TDSPH
Fabrico Torres Antonio - RM:97916 - Turma : 2TDSPH
Lucca Raphael Pereira dos Santos - RM 99675 - Turma : 2TDSPZ -> PROFESSOR: Milton Goya

 --------------------------- ESSE SCRIPT CONTEM OS CODIGOS DAS FUNCOES DE VALIDACAO (SPRINT 2) ---------------------------
*/


SET SERVEROUTPUT ON;
SET VERIFY OFF;

- FUNÇÕES DE VALIDAÇÃO DE DADOS

-- Primeira função para validar entrada de dados: tabela 

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