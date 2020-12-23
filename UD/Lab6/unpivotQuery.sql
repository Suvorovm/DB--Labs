/*unpivot-разворот по покупок по дате*/
select name, prestige, sum(sale_fact.sum) as amount,

    unnest(array['Квартал', 'Полугодие', 'Год']) AS quarter,

    unnest(array[quarter_name, half_year, year_name]) AS amount
from sale_fact
    inner join repo_hotel.room r on r.room_id = sale_fact.room_id
    inner join build b on r.build_id = b.build_id
    inner join category on category.category_id = r.category_id
    inner join quarter q on q.quarter_id = sale_fact.quarter_id
    inner join halfyear h on h.half_year_id = q.half_year_id
    inner join year y on h.year_id = y.year_id
        group by name, prestige, quarter_name, half_year, year_name;



/*unpivot-разворот бронирования*/
select name, sum(booking.count_booking) as amount,

    unnest(array['Квартал', 'Полугодие', 'Год']) AS quarter,

    unnest(array[quarter_name, half_year, year_name]) AS amount
from repo_hotel.booking
    inner join repo_hotel.room r on r.room_id = booking.room_id
    inner join build b on r.build_id = b.build_id
    inner join category on category.category_id = r.category_id
    inner join quarter q on q.quarter_id = booking.quarter_id
    inner join halfyear h on h.half_year_id = q.half_year_id
    inner join year y on h.year_id = y.year_id
        group by name,quarter_name, half_year, year_name;




/*unpivot-разворот доп. услгу */
select ts.name_service, sum(service_fact.sum_cost) as amount,

    unnest(array['Квартал', 'Полугодие', 'Год']) AS quarter,

    unnest(array[quarter_name, half_year, year_name]) AS amount
from repo_hotel.service_fact
    inner join type_service ts on service_fact.type_service_id = ts.type_service_id
    inner join quarter q on q.quarter_id = service_fact.quarter_id
    inner join halfyear h on h.half_year_id = q.half_year_id
    inner join year y on h.year_id = y.year_id
        group by ts.name_service,quarter_name, half_year, year_name;

