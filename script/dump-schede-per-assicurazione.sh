


mysql -E filo_development > lista-monografie-per-secolo-e-anno.txt <<EOF
select title as titolo, authors.name as autore, year as anno, century as secolo, collocation as collocazione
from documents 
left join authors on (documents.author_id = authors.id) 
where (century is not null or year is not null)
  and document_type = 'monograph'
order by century, year
EOF

mysql -E filo_development > lista-monografie-senza-anno-o-secolo.txt <<EOF
select title as titolo, authors.name as autore, collocation as collocazione
  from documents 
  join authors on (documents.author_id = authors.id) 
 where century is null 
   and year is null
   and document_type = 'monograph'
   and parent_id is null
 order by title
EOF
