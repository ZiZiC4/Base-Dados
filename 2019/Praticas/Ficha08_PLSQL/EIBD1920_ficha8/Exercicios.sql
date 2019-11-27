-- Exercicios
-- consta sys
@Z:\Base-Dados\2019\Praticas\Ficha08_PLSQL\EIBD1920_ficha8\scripts\Ficha8_users.sql

-- consta aulas
@Z:\Base-Dados\2019\Praticas\Ficha08_PLSQL\EIBD1920_ficha8\scripts\Ficha8_bd.sql


-- 1
CREATE OR REPLACE VIEW v_total_doutorados
AS
	SELECT p.id_inst AS instituicao, COUNT(*) AS total_doutorados 
	FROM pessoa p JOIN docente d
		ON p.id = d.id
	WHERE d.grau = 'D'
	GROUP BY p.id_inst
;

-- OU 

CREATE OR REPLACE VIEW v_total_doutorados
(instituicao, total_doutorados)
AS
	SELECT p.id_inst, COUNT(*)
	FROM pessoa p JOIN docente d
		ON p.id = d.id
	WHERE d.grau = 'D'
	GROUP BY p.id_inst
;

GRANT SELECT ON v_total_doutorados TO presidente;


-- 2
CREATE OR REPLACE VIEW v_docentes
AS
	SELECT p.id, p.prim_nome, p.ult_nome, NVL(t.num_telefone, ' ') AS contato
	FROM pessoa p LEFT JOIN telefone t
		ON p.id = t.id_pessoa
;

GRANT SELECT ON v_docentes TO presidente;


-- 3
CREATE OR REPLACE FUNCTION f_nomeCompleto
(p_idP pessoa.id%TYPE,p_formato CHAR)
RETURN VARCHAR2
IS 
	primeiroNome pessoa.prim_nome%TYPE;
	ultimoNome pessoa.ult_nome%TYPE;
	
BEGIN 
	SELECT prim_nome,ULT_NOME INTO primeiroNome,ultimoNome
	FROM pessoa
  WHERE id = p_idP;
  
  IF p_formato = 'A' THEN
    RETURN primeiroNome || ' ' || ultimoNome;
  ELSIF p_formato = 'B' THEN 
    RETURN ultimoNome || ' ' || primeiroNome;
  ELSE
    RETURN NULL;
  END IF;
END f_nomeCompleto;
/

-- executar a funcao
	-- SQL
	SELECT f_nomeCompleto(id, 'A')
	FROM PESSOA;
	
	--PLSQL
	set serveroutput on
	DECLARE 
		v_nome VARCHAR2(100);
	BEGIN
		v_nome := f_nomeCompleto(1, 'B');
		DBMS_OUTPUT.PUT_LINE(v_nome);
	END;
	/
	