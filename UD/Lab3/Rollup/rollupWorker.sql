/*UTF-8*

  Группировка по работнику и подсчет  количества контрактов заключенных работником в данным промежуок времени
  /
 */
select * from (select  (worker.id_worker) as "id_worker",  name as "Имя",
                                          surname as "Фамилия",
                                          count(contract.id_worker) as "Количество заключенных контрактов"

        from worker
        join contract  on worker.id_worker = contract.id_worker
        where (start_date >= '2020-08-01' and start_date <= '2020-10-01')
        group by rollup(worker.id_worker, name, surname)
        order by count(contract.id_worker) DESC) as tb
    where "Имя" is not null and "Фамилия" is not null and  id_worker is not null
        or id_worker is null;

