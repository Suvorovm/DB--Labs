/*
UTF-8
Количестов услуг взятых для разных номеров.
*/

SELECT service_name AS "Название услуги" , category_room.name as "Категория" ,count(bilt_position.id_service) as "Количество" from service
    inner join bilt_position  on service.id_service = bilt_position.id_service
    inner join room  on room.id_room = bilt_position.id_room
    inner join category_room ON room.id_category_room = category_room.id_category_room
    GROUP BY GROUPING SETS (service_name, category_room.name)