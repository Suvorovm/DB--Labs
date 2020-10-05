
    --Вывод клиентов, которые отменяли бронирование и сотрудника, который заключал договор с клиентом

SELECT Fiz_person.Surname || ' ' || Fiz_person.forename AS "Клиент(Физ)",
	   UR_Person.Name_organization AS "Клиент(Юр)",
	   Worker.Surname || ' ' ||  Worker.sorename AS "Сотрудник",
	   COUNT(*) as "Количество",
	   Fiz_person.id_client
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
JOIN Booking ON Booking.Id_contract = Contract.Id_contract
JOIN
JOIN type_booking ON Booking.Id_status = type_booking.id_type_booking
WHERE type_booking.id_type_booking = 3
group by fiz_person.surname,Fiz_person.id_client, fiz_person.forename,
		 UR_Person.Name_organization, Worker.Surname,Worker.sorename
order by "Количество" desc;




-- вывод количества расторгнутых и успешно завершенных договоров
Select COUNT(case when type_booking.name_type = 'Оплачено'then 1 end) as "Succes",
        COUNT(case when type_booking.name_type = 'Отмена заказа'then 1 end) as "Расторгнутые",
        COUNT(case when type_booking.name_type = 'Забронированно'then 1 end) as "Забронированно"

from contract
inner join booking on booking.id_contract = contract.id_contract
inner join status_booking on booking.id_status = status_booking.id_status
inner join type_booking on status_booking.id_type_booking = type_booking.id_type_booking;


