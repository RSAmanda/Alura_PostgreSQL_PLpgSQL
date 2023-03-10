# Alura_PostgreSQL_PLpgSQL
Repositório dedicado as notas de estudos e projeto do curso da Alura PostegreSQL: PL/pgSQL. O curso faz parte da trilha de dados do programa DESENVOLVE 2023 do Grupo Boticário.
# PostgreSQL: Desenvolva com PL/pgSQL

# Link do Curso

[Curso Online PostgreSQL: desenvolva com PL/pgSQL | Alura](https://cursos.alura.com.br/course/postgresql-procedures)

# Notas de Aula

[Notas de Aula - PostgreSQL: Desenvolva com PL/pgSQL](https://github.com/RSAmanda/Alura_PostgreSQL_PLpgSQL/blob/bd2860946b6c05e7f1f06c9d0b1f1f9f98151af6/Notas_de_Aula.md)

[Arquivo SQL - Aulas](https://github.com/RSAmanda/Alura_PostgreSQL_PLpgSQL/blob/bd2860946b6c05e7f1f06c9d0b1f1f9f98151af6/postgresql_plpgsql_Aulas.sql
)

[Arquivo SQL - Projeto](https://github.com/RSAmanda/Alura_PostgreSQL_PLpgSQL/blob/bd2860946b6c05e7f1f06c9d0b1f1f9f98151af6/postgresql_plpgsql_Projeto.sql
)

# Conteúdo por Aula

## Criando funções

- Começamos falando sobre o propósito de programar diretamente no banco de dados;
- Conhecemos o conceito de funções no PostgreSQL;
- Entendemos sobre tipos em
    - Parâmetros
    - Retornos de funções
- Falamos sobre como retornar valores em funções escritas em SQL.

## Tipos de Funções

- Entendemos que podemos trabalhar com tipos "compostos";
- Vimos que podemos representar tipos compostos de diversas formas
    - Definindo seu valor como o registro de uma tabela
    - Como um tipo personalizado do PostgreSQL
    - Com variáveis de saída
- Entendemos como retornar mais de um dado por vez em nossas funções através do `SETOF`
- Conhecemos um dos possíveis usos para o tipo `RECORD`.

## Linguagem Procedural

- Entendemos as limitações do SQL quando se trata de programação;
- Conhecemos a linguagem PLpgSQL, que é uma linguagem de Programação Procedural criada pelo PostgreSQL como uma extensão ao SQL;
- Aprendemos sobre a estrutura básica de criação de uma função usando PLpgSQL;
- Aprendemos a definir variáveis;
- Entendemos o conceito de blocos e escopos usando PLpgSQL.

## Estruturas de Controle

- Vimos como retornar valores utilizando PLpgSQL;
- Aprendemos a tomar decisões em nossos códigos usando `IF`;
- Conseguimos controlar o fluxo de nossa aplicação com `ELSEIF` e `ELSE`;
- Aprendemos a deixar nosso código um pouco mais legível com `CASE`.

## Estruturas de Repetição

- Vimos mais uma forma de retornar valores através do `RETURN NEXT`;
- Entendemos a necessidade de realizar operações "repetidas" em determinadas funções;
- Aprendemos a usar a estrutura `LOOP` para repetir instruções;
- Usamos `EXIT` para não cairmos em um "loop infinito";
- Conhecemos a estrutura `WHILE` para facilitar a leitura do `LOOP` sem precisar do `EXIT`;
- Aprendemos a usar (e quando usar) o famoso `FOR`;
- Vimos como percorrer o resultado de uma query usando `FOR IN`.

## Mão na Massa

- Criamos funções mais próximas da vida real;
- Aprendemos sobre a variável automaticamente criada em funções com PLpgSQL chamada `FOUND`;
- Conseguimos realizar logs de operações feitas no banco de dados;
- Aprendemos a realizar cálculos com conversões de tipos usando PLpgSQL.
