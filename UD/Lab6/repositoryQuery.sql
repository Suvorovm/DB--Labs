/*Пример запроса выборка цены принесенной тем или иным сервисом за год*/
/*pivote запросы*/
select
        name_service,
        year_name,
        sum(sum_cost)

 from service_fact
     inner join quarter q on q.quarter_id = service_fact.quarter_id
     inner join halfyear h on h.half_year_id = q.half_year_id
     inner join year y on y.year_id = h.year_id
     inner join type_service ts on ts.type_service_id = service_fact.type_service_id
    /* WHERE year_name = '2021'*/
        GROUP BY name_service, year_name
        ORDER BY 1,2 DESC;

/*первый результрующий*/
select * from crosstab(
    $$ select
        name_service,
        year_name,
        sum(sum_cost)

 from service_fact
     inner join quarter q on q.quarter_id = service_fact.quarter_id
     inner join halfyear h on h.half_year_id = q.half_year_id
     inner join year y on y.year_id = h.year_id
     inner join type_service ts on ts.type_service_id = service_fact.type_service_id
        GROUP BY name_service, year_name
         ORDER BY 1,2 DESC $$
    )
    AS ct("name_service" varchar(255), "2020" float8, "2021" float8);


/*Количестов Бронированием по типу комнат */


select * from repo_hotel.booking
    inner join repo_hotel.room r on booking.room_id = r.room_id
    inner join repo_hotel.category cr on cr.category_id = r.category_id
    inner join repo_hotel.quarter q on q.quarter_id = booking.quarter_id
    inner join repo_hotel.halfyear h on h.half_year_id = q.half_year_id
    inner join repo_hotel.year y on y.year_id = h.year_id;

/*второй результруюзий*/
select * from crosstab(
    $$
      select r.name_room, year_name, sum(cost) from repo_hotel.booking
    inner join repo_hotel.room r on booking.room_id = r.room_id
    inner join repo_hotel.category cr on cr.category_id = r.category_id
    inner join repo_hotel.quarter q on q.quarter_id = booking.quarter_id
    inner join repo_hotel.halfyear h on h.half_year_id = q.half_year_id
    inner join repo_hotel.year y on y.year_id = h.year_id
        GROUP BY r.name_room,y.year_name;
        $$
    )
as ct("name_room" varchar(255),"2020" bigint, "2021" bigint);



/*Выборка суммы счета по категориям */

select c.name,year_name,sum(sale_fact.sum) from sale_fact
    inner join repo_hotel.room r on r.room_id = sale_fact.room_id
    inner join quarter q on sale_fact.quarter_id = q.quarter_id
    inner join halfyear h on h.half_year_id = q.half_year_id
    inner join year y on y.year_id = h.year_id
    inner join repo_hotel.category c on c.category_id = r.category_id
    group by c.name, year_name;


/*Запрос pivote*/

select * from crosstab(
    $$
    select c.name,year_name,sum(sale_fact.sum) from sale_fact
    inner join repo_hotel.room r on r.room_id = sale_fact.room_id
    inner join quarter q on sale_fact.quarter_id = q.quarter_id
    inner join halfyear h on h.half_year_id = q.half_year_id
    inner join year y on y.year_id = h.year_id
    inner join repo_hotel.category c on c.category_id = r.category_id
        group by c.name, year_name;
        $$
    )
as ct("name_room" varchar(255),"2020" float8, "2021" float8);
