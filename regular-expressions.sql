create table bigtext(content VARCHAR);

drop table bigtext;

insert into bigtext 
select *
from Generate_series(100000,199999);

select *
from bigtext
WHERE content LIKE '%178006%';


SELECT purpose FROM taxdata WHERE purpose ~ '^[A-Z]' ORDER BY purpose DESC LIMIT 3;
