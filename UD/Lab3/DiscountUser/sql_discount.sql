
/*Кол-во посещений, кому можно дать скидку*/
    SELECT discount.name as Name, discount.surname as Surname, discount.lastname as lastName , count(discount.id_client) as CountIn from (
                 SELECT name, surname, lastname, client.id_client  from client
                    inner join contract c on client.id_client = c.id_client
                    inner join booking b on c.id_contract = b.id_contract
                    inner join status_booking sb on sb.id_status = b.id_status
                    where sb.id_type_booking = 1) as discount
        group by Name, Surname, lastName
        having  count(discount.id_client) >= 3;



/*Скидка  за неделю до день рождения

   The difference between two DATES is always an INTEGER, representing the number of DAYS difference


  I don't know how does it works 0_0
https://stackoverrun.com/ru/q/1749666
*/
select * from
     (select *, client.birth_date + date_trunc('year', age(client.birth_date)) + interval '1 year' as anniversary from client) bd
where
     (current_date, current_date + interval '1 week') overlaps (anniversary, anniversary);

/*тетс*/
select * from type_booking;
