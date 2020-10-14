/*
Кол-во всего людей от организаций + сумма по каждой организации
utf-8
*/

select name_organization as "Наименование организации", count(client.id_ur_person)  as "Кол-во людей" from ur_person
    inner join client  on ur_person.id_ur_person = client.id_ur_person
    where ur_person.id_ur_person <> 1 /*т.к 1 - это не юр лицо*/
    GROUP BY cube (name_organization)

