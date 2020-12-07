/*Пример запроса*/
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



