/*utf-8*/
select * from bill;
select * from build;
select * from client;
select * from service;
select * from bilt_position_service;
select * from build;
select * from type_booking;
select * from disscount;
select * from bilt_position;
select * from contract;
select * from type_booking;




 --1) Запрос на выборку самый популярных доп. услуг, с количеством принесенной прибыли.
select distinct service_name as "Услуга", (count(id_bilt_position) * service_cost) + (count(service_for_room.id_room) * service_cost)
    as "Доход" from service
    inner join bilt_position_service  on service.id_service = bilt_position_service.id_service
    inner join service_for_room  on service.id_service = service_for_room.id_service
    GROUP BY bilt_position_service.id_bilt_position, service_name, service_cost
    ORDER BY (count(id_bilt_position) * service_cost) + (count(service_for_room.id_room) * service_cost) desc;


--2) Запрос на сравнение потраченных на скидки денег к полной стоимости.
-- Сгруппированное по скидке и отфидтрованная в данный промежуток времени

SELECT disscount_name,sum(with_diss) as "Сумма издержек по процентам",sum(with_out_diss - with_diss) as "Сумма за вычетом процентов",
       sum(with_out_diss) as "Полная стоимость"
from
    (
        SELECT  disscount_name, sum((without_disscount / 100) * diss_person) * count(bp.id_disscount) as with_diss,
                sum(without_disscount) as with_out_diss
                from disscount
                inner join bilt_position bp on disscount.id_disscount = bp.id_disscount
                inner join bill bill on bp.id_bill = bill.id_bill
                inner join contract  on bill.id_bill = contract.id_bill
                where contract.end_date between '2001-01-05 00:00:00.000000' and '2011-06-24 00:00:00.000000'
                GROUP BY disscount_name,without_disscount, diss_person, disscount_name
    )  as merged
    GROUP BY merged.disscount_name
    ORDER BY sum(with_diss) desc;

CREATE VIEW MOST_VALUABLE AS
SELECT Prestig as "Престиж", sum(Summer) as "Сумма" from (
                                     SELECT prestige  as Prestig,
                                            sum(room_cost * EXTRACT(EPOCH FROM b.departure_time - b.settlement_time) /
                                                3600) as Summer
                                     from build
                                              inner join room on build.id_build = room.id_build
                                              inner join booking b on room.id_room = b.id_room
                                              inner join status_booking sb on b.id_status = sb.id_status
                                              inner join type_booking tb on sb.id_type_booking = tb.id_type_booking

                                     WHERE sb.id_type_booking = 1
                                     GROUP BY prestige
                                 ) as PS
    GROUP BY Prestig
    ORDER BY sum(Summer) desc ;
