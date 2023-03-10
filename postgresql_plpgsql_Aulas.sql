/* Curso Alura: PostgreSQL: Desenvolva com PL/pgSQL*/

-- Aula 01: Criando funções

-- Uma função que retorna um valor
CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS '
	SELECT (5 -3)*2
' LANGUAGE SQL;

SELECT primeira_funcao() AS "Número";

-- Uma função que recebe dois números e retorna um valor
CREATE FUNCTION soma_dois_numeros(numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS '
	SELECT numero_1 + numero_2
' LANGUAGE SQL;

SELECT soma_dois_numeros(2,2) AS "Soma de dois Números";

-- Uma função que recebe dois números e retorna um valor
	-- sem declarar nomes as variáveis de entrada
CREATE FUNCTION soma_dois_numeros_v2(INTEGER, INTEGER) RETURNS INTEGER AS '
	SELECT $1 + $2
' LANGUAGE SQL;

SELECT soma_dois_numeros_v2(4,2) AS "Soma de dois Números";

-- usando outro delimitador
DROP TABLE a;
CREATE TABLE a (nome VARCHAR(255) NOT NULL);
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS void AS $$

	INSERT INTO a(nome) VALUES(cria_a.nome);

$$ LANGUAGE SQL;

SELECT cria_a('Amanda r.')

-- Aula 02: Tipos E Funções

CREATE TABLE instrutor(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	salario DECIMAL (10, 2)
);

-- INSERINDO UMA LINHA NA TABELA
INSERT INTO instrutor(nome, salario) VALUES ('Vinicius Dias', 100);
INSERT INTO instrutor(nome, salario) VALUES ('Patricia Dias', 150);

-- criando uma função que dobre o salário de um instrutor
CREATE FUNCTION dobro_do_salario(instrutor) RETURNS DECIMAL AS $$
	SELECT $1.salario * 2 AS Dobro;
$$ LANGUAGE SQL;

SELECT nome, dobro_do_salario(instrutor.*) FROM instrutor;

-- criando uma função que retorna um registro na tabela
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
--	SELECT 22 AS id, 'Nome Falso' AS nome, 200.00 AS salario;
--	SELECT 22 AS id, 'Nome Falso' AS nome, 200::DECIMAL AS salario;
  	SELECT 22, 'Nome Falso', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT * FROM cria_instrutor_falso();

-- retornando conjuntos
-- inserindo novos instrutores
INSERT INTO instrutor(nome, salario) VALUES ('Diogo Mascarenhas', 200);
INSERT INTO instrutor(nome, salario) VALUES ('Nico Steppat', 300);
INSERT INTO instrutor(nome, salario) VALUES ('Juliana', 400);

-- criando uma função que retorna o nome dos instrutores que ganham mais que um determinado valor de salário
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$
	SELECT * FROM instrutor WHERE salario >= valor_salario;
$$ LANGUAGE SQL;

SELECT * FROM instrutores_bem_pagos(200);

-- criando uma função que retorna mais de um valor
CREATE FUNCTION soma_e_produto (IN numero_1 INTEGER, IN numero_2 INTEGER, OUT soma INTEGER, OUT produto INTEGER) AS $$
	SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM soma_e_produto(3,3);

-- Aula 03: linguagem procedural
CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
-- para criar uma pl é necessário criar um bloco para inserir os comandos
	BEGIN
		RETURN 1; -- pare retornar um valor
	END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

-- DECLARANDO VARIÁVEIS COM PL
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
-- Bloco de declaração de variáveis
	DECLARE
	primeira_variavel INTEGER DEFAULT 3;
-- para criar uma pl é necessário criar um bloco para inserir os comandos
	BEGIN
		primeira_variavel := primeira_variavel*2; -- Atribuição :=
		RETURN primeira_variavel; -- pare retornar um valor
	END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

-- Aula 04
-- exercícios
-- reescrevendo funções com pl
CREATE OR REPLACE FUNCTION primeira_funcao() RETURNS INTEGER AS $$
	BEGIN
		RETURN (5-3)*2;
	END
$$ LANGUAGE plpgsql;

SELECT primeira_funcao();

CREATE OR REPLACE FUNCTION soma_dois_numeros(numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS $$
	BEGIN
		RETURN (numero_1+numero_2);
	END
$$ LANGUAGE plpgsql;

SELECT soma_dois_numeros(1,1);

CREATE OR REPLACE FUNCTION cria_a (nome VARCHAR) RETURNS void AS $$
	BEGIN
		INSERT INTO a (nome) VALUES(cria_a.nome);
	END;
$$ LANGUAGE plpgsql;

SELECT cria_a('nome');

CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
	BEGIN
  		RETURN ROW (22, 'Nome Falso', 220::DECIMAL)::instrutor;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM cria_instrutor_falso();
-- ou também...
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
	DECLARE 
		retorno instrutor; -- declarando uma variável do tipo instrutor
	BEGIN
  		SELECT 22, 'sr. Nome Falso', 220::DECIMAL INTO retorno;
		RETURN retorno;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM cria_instrutor_falso();
-- retorando uma tabela
-- criando uma função que retorna o nome dos instrutores que ganham mais que um determinado valor de salário
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$
	BEGIN
		RETURN QUERY SELECT * FROM instrutor WHERE salario >= valor_salario;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutores_bem_pagos(200);

-- Aula 04: estruturas de controle
-- IF ELSE
CREATE FUNCTION salario_ok (instrutor instrutor) RETURNS VARCHAR(255) AS $$
	BEGIN
		IF instrutor.salario > 200 THEN
			RETURN 'Salário está ok';
		ELSE
			RETURN 'Salário pode aumentar';
		END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor.*) FROM instrutor;

-- ELSEIF
CREATE FUNCTION salario_ok_V2 (instrutor instrutor) RETURNS VARCHAR(255) AS $$
	BEGIN
		IF instrutor.salario > 300 THEN
			RETURN 'Salário está ok';
		ELSEIF instrutor.salario = 300 THEN
			RETURN 'Salário pode aumentar';
		ELSE
			RETURN 'Salário está defasado';
		END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok_V2(instrutor.*) FROM instrutor;

-- WHEN
CREATE FUNCTION salario_ok_V3 (instrutor instrutor) RETURNS VARCHAR(255) AS $$
	BEGIN
		CASE instrutor.salario
			WHEN 100 THEN
				RETURN 'salario muito baixo';
			WHEN 200 THEN
				RETURN 'salario baixo';
			WHEN 300 THEN
				RETURN 'salario ok';
			ELSE
				RETURN 'Salario ótimo';
		END CASE;
	END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok_V3(instrutor.*) FROM instrutor;

-- AULA 05: Estruturas de repetição
DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
		LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
			EXIT WHEN multiplicador = 10;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;


SELECT tabuada(9);
-- while
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
		WHILE multiplicador < 10 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
			multiplicador := multiplicador + 1;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;


SELECT tabuada(9);

-- for
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
	BEGIN
		FOR multiplicador IN 1..9 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;


SELECT tabuada(5);

-- Outra forma de sar o for
DROP FUNCTION instrutor_com_salario;
CREATE OR REPLACE FUNCTION instrutor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$
	DECLARE
		instrutor instrutor;
	BEGIN
		FOR instrutor IN SELECT * FROM instrutor LOOP
			nome := instrutor.nome;
			salario_ok = salario_ok(instrutor.id);
			
			RETURN NEXT;
		END LOOP;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor_com_salario();
