# Notas de Aula - PostgreSQL: Desenvolva com PL/pgSQL

# Link do Curso

[Curso Online PostgreSQL: desenvolva com PL/pgSQL | Alura](https://cursos.alura.com.br/course/postgresql-procedures)

# Materiais de Apoio

[38.4. User-Defined Procedures](https://www.postgresql.org/docs/current/xproc.html)

[6.4. Returning Data from Modified Rows](https://www.postgresql.org/docs/current/dml-returning.html)

[43.5. Basic Statements](https://www.postgresql.org/docs/current/plpgsql-statements.html#PLPGSQL-STATEMENTS-SQL-ONEROW)

# Aulas

## Criando funções

Um exemplo de função, precisamos informar o nome da função, o que ela retorna (se não retorna nada, colocamos VOID) e a linguagem utilizada (no caso, SQL).

```sql
CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS '
	SELECT (5 -3)*2
' LANGUAGE SQL;

SELECT primeira_funcao() AS "Número";
```

Função que recebe valores

```sql
CREATE FUNCTION soma_dois_numeros(numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS '
	SELECT numero_1 + numero_2
' LANGUAGE SQL;

SELECT soma_dois_numeros(2,2) AS "Soma de dois Números";
```

Podemos não definir nomes para os parâmetros de entrada, com isso a função fica da seguinte forma:

```sql
CREATE FUNCTION soma_dois_numeros_v2(INTEGER, INTEGER) RETURNS INTEGER AS '
	SELECT $1 + $2
' LANGUAGE SQL;

SELECT soma_dois_numeros_v2(4,2) AS "Soma de dois Números";
```

Porém é uma boa prática definir nomes para as variáveis.

Podemos delimitar a função usando $$

```sql
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS void AS $$

	INSERT INTO a(nome) VALUES(cria_a.nome);

$$ LANGUAGE SQL;
```

> Existe um outro conceito, muito similar às funções, chamado de `PROCEDURE`s.
> 
> 
> Uma Procedure no PostgreSQL é exatamente igual a uma função tendo como diferença o fato de que não retorna nenhum valor.
> 
> Como não há retorno em *Procedures*, não podemos chamá-lo como parte de um comando SQL (como temos feito com funções, chamando-as como parte do `SELECT`). No lugar disso, utilizamos `CALL nome_do_procedure` para executar uma Procedure.
> 

## Tipos e Funções

Uma função pode usar um tipo composto como parâmetro, como uma tabela em que a função recebeu um registro da tabela ‘instrutor’:

```sql
-- criando uma função que dobre o salário de um instrutor
CREATE FUNCTION dobro_do_salario(instrutor) RETURNS DECIMAL AS $$
	SELECT $1.salario * 2 AS Dobro;
$$ LANGUAGE SQL;

-- chamando a função:
SELECT nome, dobro_do_salario(instrutor.*) FROM instrutor;
```

> Nós fizemos com que o PostgreSQL passasse todos os valores para a função através da sintaxe `instrutor.*`, mas se eu fizesse simplesmente `instrutor`, sem o `.*`, também funcionaria.
> 

Criando uma função que retorna um item de uma tabela (respeitando os nomes dos atributos, como se fosse um), ou seja, um tipo composto:

```sql
-- criando uma função que retorna um registro na tabela
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
--	SELECT 22 AS id, 'Nome Falso' AS nome, 200.00 AS salario;
--	SELECT 22 AS id, 'Nome Falso' AS nome, 200::DECIMAL AS salario;
  	SELECT 22, 'Nome Falso', 200::DECIMAL;
$$ LANGUAGE SQL;

SELECT * FROM cria_instrutor_falso();
```

Retorno do SELECT:

![Untitled](Notas%20de%20Aula%20-%20PostgreSQL%20Desenvolva%20com%20PL%20pgSQL%20e737230aea9a486ebc59fb765d7d4fe2/Untitled.png)

Criando uma função que retorna uma tabela:

```sql
-- criando uma função que retorna o nome dos instrutores que ganham mais que um determinado valor de salário
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$
	SELECT * FROM instrutor WHERE salario >= valor_salario;
$$ LANGUAGE SQL;
```

Podemos, também, utilizar o RECORD ao invés do SETOF, porém o RECORD retorna uma tabela genérica e é necessário informar os campos (nome e tipos).

Criando uma função que retorna mais de um parâmetro:

```sql
-- criando uma função que retorna mais de um valor
-- RETORNA A SOMA E O PRODUTO DE DUAS FUNÇÕES
CREATE FUNCTION soma_e_produto (IN numero_1 INTEGER, IN numero_2 INTEGER, OUT soma INTEGER, OUT produto INTEGER) AS $$
	SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$ LANGUAGE SQL;
```

É uma boa prática criar o tipo antes e fazer o *returns* com o tipo definido.

## Linguagem Procedural

- plpgsql ⇒ Procedural Language do SQL feita pelo postgre
- é uma linguagem de programação formada por procedimentos
- Essa linguagem é semelhante ao SQL.
- É um módulo externo ao SQL (tem como habilitar e desabilitar por segurança)

```sql
CREATE FUNCTION primeira_pl() RETURNS INTEGER AS $$
-- para criar uma pl é necessário criar um bloco para inserir os comandos
	BEGIN
		RETURN 1; -- pare retornar um valor
	END
$$ LANGUAGE plpgsql; -- definindo a linguagem
```

- DECLARANDO E MANIPULANDO VARIÁVEIS:
    
    ```sql
    CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    -- Bloco de declaração de variáveis
    	DECLARE
    	primeira_variavel INTEGER DEFAULT 3;
      -- primeira_variavel INTEGER := 3; -- outro modo
    -- para criar uma pl é necessário criar um bloco para inserir os comandos
    	BEGIN
    		primeira_variavel := primeira_variavel*2; -- Atribuição := ou =
    		RETURN primeira_variavel; -- pare retornar um valor
    	END;
    $$ LANGUAGE plpgsql;
    
    SELECT primeira_pl();
    ```
    

<aside>
❗ - É usual usar a atribuição como := para deixar claro que não é uma comparação.
- Quando está declarando e atribuindo uma variável é comum usar o DEFAULT ao invés do = ou :=

</aside>

## Estruturas de Controle

- Como retornar uma linha de uma tabela usando plpgsql
    
    ```sql
    CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
    	BEGIN
      		RETURN ROW (22, 'Nome Falso', 220::DECIMAL)::instrutor;
    	END;
    $$ LANGUAGE plpgsql;
    
    SELECT * FROM cria_instrutor_falso();
    /*                    ou                       */
    CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
    	DECLARE 
    		retorno instrutor; -- declarando uma variável do tipo instrutor
    	BEGIN
      		SELECT 22, 'sr. Nome Falso', 220::DECIMAL INTO retorno;
    		RETURN retorno;
    	END;
    $$ LANGUAGE plpgsql;
    
    SELECT * FROM cria_instrutor_falso();
    ```
    
- retornando uma tabela usando plpgsql
    
    ```sql
    CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$
    	BEGIN
    		RETURN QUERY SELECT * FROM instrutor WHERE salario >= valor_salario;
    	END;
    $$ LANGUAGE plpgsql;
    
    SELECT * FROM instrutores_bem_pagos(200);
    ```
    
- IF ELSE
    
    ```sql
    CREATE FUNCTION salario_ok (instrutor instrutor) RETURNS VARCHAR(255) AS $$
    	BEGIN
    		IF instrutor.salario > 200 THEN
    			RETURN 'Salário está ok';
    		ELSE
    			RETURN 'Salário pode aumentar';
    		END IF;
    	END;
    $$ LANGUAGE plpgsql;
    ```
    
    - Utilização e saída da função
    
    ![Untitled](Notas%20de%20Aula%20-%20PostgreSQL%20Desenvolva%20com%20PL%20pgSQL%20e737230aea9a486ebc59fb765d7d4fe2/Untitled%201.png)
    
- ELSEIF
    
    ```sql
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
    ```
    
- WHEN
    
    ```sql
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
    ```
    

## Estruturas de Repetição

> `RETURN NEXT`: Essa instrução é utilizada quando precisamos retornar múltiplas linhas de uma função PLpgSQL mas não temos uma query para isso (senão poderíamos utilizar o `RETURN QUERY`).
> 
- loop:
    
    ```sql
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
    ```
    
- while
    
    ```sql
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
    ```
    
- for
    
    ```sql
    CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
    	BEGIN
    		FOR multiplicador IN 1..9 LOOP
    			RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
    		END LOOP;
    	END;
    $$ LANGUAGE plpgsql;
    
    SELECT tabuada(5);
    ```
    
    - Outra forma:
        
        ```sql
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
        ```
        

## Mão na Massa

Projeto:

```sql
-- projeto última aula PL/pgSQL

CREATE TABLE aluno (
	id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso(
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);
-- cria curso
CREATE FUNCTION cria_curso(nome_curso VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$
	DECLARE
		id_categoria INTEGER;
	BEGIN
		SELECT id INTO id_categoria FROM categoria WHERE nome=nome_categoria;
		IF NOT FOUND THEN
			INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
		END IF;
		INSERT INTO curso (nome, categoria_id) VALUES (nome_curso, id_categoria);
	END;
$$ LANGUAGE plpgsql;

-- inserindo cursos
-- a função cria o curso e a categoria (caso ela não exista)
SELECT cria_curso('PHP', 'Programação');
SELECT cria_curso('Java', 'Programação');

SELECT * FROM curso;
SELECT * FROM categoria;

/*
	inserindo instrutores (com salários).
	se o salário for maior do que a média, salvar um log
	salvar outro log dizendo que fulano recebe mais do que x% da grade de instrutores
*/

CREATE TABLE log_instrutores(
	id SERIAL PRIMARY KEY,
	informacao VARCHAR(255),
	momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP	
);

CREATE OR REPLACE FUNCTION cria_instrutor (nome_instrutor VARCHAR, salario_instrutor DECIMAL) RETURNS void AS $$
	DECLARE
		id_instrutor_inserido INTEGER;
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL;
	BEGIN
		INSERT INTO instrutor (nome, salario) VALUES (nome_instrutor, salario_instrutor) RETURNING id INTO id_instrutor_inserido;
		SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> id_instrutor_inserido;
		IF salario_instrutor > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (nome_instrutor || 'recebe acima da média');
		END IF;
		
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> id_instrutor_inserido LOOP
			total_instrutores := total_instrutores +1;
			IF salario_instrutor > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		percentual = instrutores_recebem_menos::DECIMAL / total_instrutores:: DECIMAL * 100;
		INSERT INTO log_instrutores (informacao)
			VALUES(nome_instrutor || ' recebe mais do que ' || percentual || '% da grade de instrutores.');
	END;
$$ LANGUAGE plpgsql;
```
