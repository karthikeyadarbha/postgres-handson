
SELECT id, doc FROM docs03 WHERE '{complicated}' <@ string_to_array(lower(doc), ' ');
EXPLAIN SELECT id, doc FROM docs03 WHERE '{complicated}' <@ string_to_array(lower(doc), ' ');


drop table docs03;
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE INDEX array03 ON docs03 USING gin(to_tsvector('english', lower(doc)));
CREATE INDEX array03 ON docs03 USING gin(string_to_array(lower(doc), ' ')  array_ops);

INSERT INTO docs03 (doc) VALUES
('Taking a break helps with the thinking So does talking If you explain'),
('the problem to someone else or even to yourself you will sometimes'),
('find the answer before you finish asking the question'),
('But even the best debugging techniques will fail if there are too many'),
('errors or if the code you are trying to fix is too big and complicated'),
('Sometimes the best option is to retreat simplifying the program until'),
('you get to something that works and that you understand'),
('Beginning programmers are often reluctant to retreat because they cant'),
('stand to delete a line of code even if its wrong If it makes you'),
('feel better copy your program into another file before you start');

INSERT INTO docs03 (doc) SELECT 'Neon ' || generate_series(10000,20000);

TRUNCATE table DOCS03;


select count(*)
from docs03;

SELECT id, doc FROM docs03 WHERE '{complicated}' <@ string_to_array(lower(doc), ' ');

analyze docs03;

EXPLAIN SELECT id, doc FROM docs03 WHERE '{complicated}' <@ string_to_array(lower(doc), ' ');
   
   select *
   from pg4e_debug
   order by created_at desc;
  
  
  SELECT
    t.schemaname,
    t.tablename,
    c.reltuples::bigint                            AS num_rows,
    pg_size_pretty(pg_relation_size(c.oid))        AS table_size,
    psai.indexrelname                              AS index_name,
    pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size,
    CASE WHEN i.indisunique THEN 'Y' ELSE 'N' END  AS "unique",
    psai.idx_scan                                  AS number_of_scans,
    psai.idx_tup_read                              AS tuples_read,
    psai.idx_tup_fetch                             AS tuples_fetched
FROM
    pg_tables t
    LEFT JOIN pg_class c ON t.tablename = c.relname
    LEFT JOIN pg_index i ON c.oid = i.indrelid
    LEFT JOIN pg_stat_all_indexes psai ON i.indexrelid = psai.indexrelid
WHERE
    t.schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY 1, 2;

SELECT
    pg_class.relname,
    pg_size_pretty(pg_class.reltuples::bigint)            AS rows_in_bytes,
    pg_class.reltuples                                    AS num_rows,
    COUNT(*)                                              AS total_indexes,
    COUNT(*) FILTER ( WHERE indisunique)                  AS unique_indexes,
    COUNT(*) FILTER ( WHERE indnatts = 1 )                AS single_column_indexes,
    COUNT(*) FILTER ( WHERE indnatts IS DISTINCT FROM 1 ) AS multi_column_indexes
FROM
    pg_namespace
    LEFT JOIN pg_class ON pg_namespace.oid = pg_class.relnamespace
    LEFT JOIN pg_index ON pg_class.oid = pg_index.indrelid
WHERE
    pg_namespace.nspname = 'public' AND
    pg_class.relkind = 'r'
GROUP BY pg_class.relname, pg_class.reltuples
ORDER BY pg_class.reltuples DESC;
