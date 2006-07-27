
delete from graduates;

insert into graduates (first_name, last_name, image_url, born_on, address, graduation_year, home_page_url, notes, curriculum)
  select nome, cognome, img, datanascita, concat(indirizzo, ', ', citta), annodiploma, web, 
    altridati, concat(caratteristiche, '\n', altricorsi, '\n', curr)
  from diplomati;

update graduates set curriculum = replace(curriculum, '&lt;', '<')  ;
update graduates set curriculum = replace(curriculum, '&gt;', '>')  ;
update graduates set notes = replace(notes, '&lt;', '<')  ;
update graduates set notes = replace(notes, '&gt;', '>')  ;
