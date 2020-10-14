/*utf-8
  Выборка количества
  */

select DISTINCT  name as "Наименование", beds_count as "Кол-во спальных мест", count(room.id_category_room)
    as "Количество" from category_room
    inner join room  on category_room.id_category_room = room.id_category_room
    group by cube(name, beds_count)
    order by count(room.id_category_room) desc;


