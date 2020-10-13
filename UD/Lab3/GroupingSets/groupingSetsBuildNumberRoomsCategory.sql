SELECT category_room.name as "Нименование комната", build.prestige  as "Престиж", count(booking.id_room) as "Количество"  from build
    join room  on build.id_build = room.id_build
    join category_room  on room.id_category_room = category_room.id_category_room
    join booking on room.id_room = booking.id_room
    join status_booking  on booking.id_status = status_booking.id_status
        where id_type_booking = 1
        group by  GROUPING SETS (build.prestige, category_room.name);

