
-- Запрос на вывод номеров свободных в данный промежуток времени
SELECT Room.Room_number AS "Свободные номера",
	   Build.Prestige AS "Класс номера",
	   Room.Room_cost AS "Цена номера"
FROM Booking
JOIN Room ON Booking.id_room = Room.id_room
JOIN Build ON Build.id_Build = Room.id_Build
WHERE (Booking.Settlement_time BETWEEN '15.05.2020' AND '11.06.2020'
	  AND
	  Booking.Departure_time BETWEEN '15.05.2020' AND '11.06.2020')
	  OR (Booking.Settlement_time IS NULL AND Booking.Departure_time IS NULL)
UNION ALL
SELECT Room.Room_number AS "Свободные номера",
	   Build.Prestige AS "Класс номера",
	   Room.Room_cost AS "Цена номера"
FROM Room
JOIN Build ON Build.id_Build = Room.id_Build
LEFT JOIN Booking ON Booking.id_room = Room.id_room
WHERE Booking.id_booking is NULL
group BY Room.Room_number, Build.Prestige, Room.Room_cost



--Разбиение клиентов на возрастные группы
SELECT
COUNT(CASE WHEN  Age(birth_date) < interval '18 years' THEN 1 END) AS "<18",
COUNT(CASE WHEN  Age(birth_date) > interval '19 years' AND Age(birth_date) < interval '25 years'  THEN 1 END) AS "19-25",
COUNT(CASE WHEN  Age(birth_date) > interval '26 years' AND Age(birth_date) < interval '39 years'  THEN 1 END) AS "26-39",
COUNT(CASE WHEN  Age(birth_date) > interval '40 years' AND Age(birth_date) < interval '65 years'  THEN 1 END) AS "40-65",
COUNT(CASE WHEN  Age(birth_date) > interval '65 years' THEN 1 END) ">65"
FROM Fiz_person





--Вывод данных о сотруднике и клиенте, которые заключали договор
SELECT Fiz_person.Surname || ' ' || Fiz_person.forename AS "Клиент(Физ)",
	   UR_Person.Name_organization AS "Клиент(Юр)",
	   Worker.Surname || ' ' || Worker.sorename AS "Сотрудник"
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
ORDER BY Worker.Surname

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
JOIN type_booking ON Booking.Id_status = type_booking.id_type_booking
WHERE Booking.Id_status = 3
group by fiz_person.surname,Fiz_person.id_client, fiz_person.forename, 
		 UR_Person.Name_organization, Worker.Surname,Worker.sorename 
order by "Количество" desc;





