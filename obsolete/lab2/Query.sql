 --1) Запрос на выборку самый популярных доп. услуг, с количеством принесенной прибыли.
 GO
SELECT Bilt_position.id_option_service as 'ID', option_service_name as 'Название услуги',
 COUNT(*) * Option_cost  AS 'Прибыль'
FROM Bilt_position 
join Optional_service on Optional_service.id_option_service=Bilt_position.id_option_service
GROUP BY Bilt_position.id_option_service,option_service_name,Option_cost
ORDER BY COUNT(*) * Option_cost DESC

--2) Запрос на полученную с номеров прибыль, сгруппированное по классам номеров 

GO
select Prestige as 'Класс', Sum(Room.Room_cost) as 'Цена' from Build
	join Room on Room.id_Build = Build.id_Build
	join Booking on Booking.id_room = Room.id_room
	join Contract on Contract.Id_contract = Booking.Id_contract
	join Bill on Bill.id_bill = Contract.id_bill
		GROUP BY Prestige


GO

--Чистая прибыль полученная за заданный промежуток времени.
--3) (Сумма полученная за номера + доп. услуги - зарплата рабочих - стоимость доп. услуг)

GO
select sum(Ammount) - sum(Include_service.Cost)
- sum(Worker.Sallary) - SUM(Optional_service.Option_cost_for_hotel) as 'Чистая прибыль'
  from Bill
join Contract on Contract.id_bill = Bill.id_bill
join Bilt_position on Bilt_position.id_bill = Bill.id_bill
join Optional_service on Optional_service.id_option_service = Bilt_position.Id_bilt_position
join Booking on Booking.Id_contract = Contract.Id_contract
join Room on Room.id_room = Booking.id_room
join Include_service_number on Include_service_number.id_room = Room.id_room
join Include_service on Include_service.id_service = Include_service_number.id_service
join Worker  on Worker.id_worker = Contract.id_worker
where 
     Contract.Start_date>='2019-11-30T00:00:00' 
	  AND Contract.End_date<='2020-01-05T00:00:00'

--4)Выборка самых прибыльных  месяцев в данных промежуток времени с выводом полученной прибыли за месяц.

select YEAR(Contract.End_date) as 'Год',
	   MONTH(Contract.End_date) as 'Номер месяца',
       SUM(Bill.Ammount) as 'Прибыль' from Contract
	join Bill on Bill.id_bill = Contract.id_bill
		where Contract.Start_date>='2019-11-30T00:00:00' 
	  AND Contract.End_date<='2020-01-05T00:00:00'
	  group by MONTH(Contract.End_date),YEAR(Contract.End_date)

-- 5) Выборка среднего и медианного числа дней  на которое был забронирован номер
GO
DECLARE @c BIGINT = (SELECT COUNT(*) FROM Booking);

SELECT AVG(1.0 * val) as 'Медиана', 
(select AVG(DATEDIFF(dayofyear,  Booking.Settlement_time,Booking.Departure_time)) from Booking) as 'Среднее'
FROM (
    SELECT DATEDIFF(dayofyear,  Booking.Settlement_time,Booking.Departure_time) as val FROM Booking
     ORDER BY val
     OFFSET (@c - 1) / 2 ROWS
     FETCH NEXT 1 + (1 - @c % 2) ROWS ONLY
) AS x;
Go



--6)Выборка юр лиц с наибольшим количеством забронированных
-- номеров в заданный промежуток времени  с выводом суммы
GO
select UR_Person.Name_organization as 'название организации',Sum(Room.Room_cost) as 'Сумма' from UR_Person 
	join Client on Client.id_client = UR_Person.id_client
	join Contract on Contract.id_client = Client.id_client
	join Booking on Booking.Id_contract = Contract.Id_contract
	join Room on Room.id_room = Booking.id_room
		where 
		 Contract.Start_date>='2018-11-30T00:00:00' 
		 AND Contract.End_date<='2021-01-05T00:00:00'
			Group by UR_Person.Name_organization 
				Order By Sum(Room.Room_cost) DESC
Go


--7) Выборка прибыли полученной от юр. лиц и от физ. лиц в заданный промежуток времени

GO
 select Fiz_person.Name as 'Имя',Fiz_person.Surname as 'Фамилия',UR_Person.Name_organization as 'Название организации',SUM(Room.Room_cost) as 'Сумма'  from Contract
	join Client on Client.id_client = Contract.id_client
	 left join Fiz_person on Fiz_person.id_client = Client.id_client
	 left join UR_Person on UR_Person.id_client = Client.id_client
	join Booking on Booking.Id_contract = Contract.Id_contract
	join Room on Room.id_room = Booking.id_room
	where 
		 Contract.Start_date>='2018-11-30T00:00:00' 
		 AND Contract.End_date<='2021-01-05T00:00:00'			
		GROUP BY Client.id_client,Fiz_person.Name,UR_Person.Name_organization,Fiz_person.Surname
			ORDER BY SUM(Room.Room_cost)	
		
GO

select * from Booking
select * from Bill
select * from Build
select * from Room
select * from Contract

--8)Вывод количества купленных номеров в каждом договоре с ценой, которая была уплачена
SELECT COUNT(Booking.id_booking) AS 'Кол-во номеров', 
		Contract.Contract_number AS 'Номер договора' , 
		Bill.Ammount AS 'Итог'
FROM Contract
JOIN Booking ON Contract.Id_contract = Booking.Id_contract
JOIN Bill  ON Contract.Id_bill = Bill.Id_bill
GROUP BY Contract.Contract_number, Bill.Ammount;

--################################################################--
--################################################################--
--################################################################--
--Количество проживающих постояльцев в данный момент времени/ в определенный промежуток времени
SELECT COUNT(id_booking) AS 'Количество проживающих'
FROM Booking
--WHERE Booking.Settlement_time > GETDATE() 
--	  AND
--	  Booking.Departure_time < GETDATE()
WHERE Booking.Settlement_time BETWEEN '25.12.2019' AND '10.01.2020'
	  AND
	  Booking.Departure_time BETWEEN '25.12.2019' AND '10.01.2020'

--Вывод списка цен забронированных номеров со скидками для физ лиц и юр. лиц
SELECT Room.Room_number AS 'Номер', 
		Build.Prestige AS 'Класс номера', 
		Disscount.Disscount_name AS 'Наименование скидки',
		Room_cost - (Room_cost * 0.01 * Disscount.Diss_person) AS 'Цена со скидкой (Физ)',
		Disscount.Diss_person AS 'Процент скидки (Физ)',
		Room_cost - (Room_cost * 0.01 * Disscount.Diss_legal) AS 'Цена со скидкой (Юр)',
		Disscount.Diss_legal AS 'Процент скидки (Юр)',
		Room.Room_cost AS 'Цена номера'
FROM Room
JOIN Build ON Room.id_build = Build.id_build
JOIN Bilt_position on Room.id_room = Bilt_position.id_room
JOIN Disscount on Bilt_position.id_disscount = Disscount.id_disscount;

-- Частота посещений клиентов гостинницы
SELECT COUNT(Contract.Id_contract) AS 'Количество посещений',UR_Person.Name_organization AS 'Юр.лицо', Fiz_person.Surname + ' ' + Fiz_person.Name AS 'Физ.лицо'
FROM Client
JOIN Contract ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
GROUP BY Fiz_person.Surname, Fiz_person.Name, UR_Person.Name_organization

--Узнать, какие отзывы чаще всего оставляют постояльцы
SELECT COUNT(Mark) AS 'Количество отзывов', Mark AS 'Оценка'
FROM Feedback
GROUP BY Mark
ORDER BY Mark DESC

--#############################################################################--

-- Запрос на вывод номеров свободныхв данный промежуток времени
SELECT Room.Room_number AS 'Свободные номера',
	   Build.Prestige AS 'Класс номера', 
	   Room.Room_cost AS 'Цена номера'
FROM Booking
JOIN Room ON Booking.id_room = Room.id_room
JOIN Build ON Build.id_Build = Room.id_Build
WHERE (Booking.Settlement_time BETWEEN '25.12.2019' AND '10.01.2020' 
	  AND
	  Booking.Departure_time BETWEEN '25.12.2019' AND '10.01.2020')
	  OR (Booking.Settlement_time IS NULL AND Booking.Departure_time IS NULL)
UNION ALL
SELECT Room.Room_number AS 'Свободные номера',
	   Build.Prestige AS 'Класс номера', 
	   Room.Room_cost AS 'Цена номера'
FROM Room
JOIN Build ON Build.id_Build = Room.id_Build
LEFT JOIN Booking ON Booking.id_room = Room.id_room
WHERE Booking.id_booking is NULL
ORDER BY Room.Room_number, Build.Prestige

--Вывод клиента и всех забронированных им номеров
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS 'Клиент(Физ)', 
       UR_Person.Name_organization AS 'Клиент(Юр)',
	   Room.Room_number AS 'Номер комнаты',
	   Booking.Settlement_time AS 'Время заселения',
	   Booking.Departure_time AS 'Время выселения'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Booking ON Booking.Id_contract = Contract.Id_contract
JOIN Room ON Booking.id_room = Room.id_room
--добавить where  если надо для конкретного клиента

--Разбиение клиентов на возрастные группы
SELECT 
COUNT(CASE WHEN  Age < 18 THEN 1 END) AS '<18', 
COUNT(CASE WHEN  Age > 19 AND Age < 25  THEN 1 END) AS '19-25', 
COUNT(CASE WHEN  Age > 26 AND Age < 39  THEN 1 END) AS '26-39', 
COUNT(CASE WHEN  Age > 40 AND Age < 65  THEN 1 END) AS '40-65', 
COUNT(CASE WHEN  Age > 65 THEN 1 END) '>65'
FROM Fiz_person


--Вывод данных о сотруднике и клиенте, которые заключали договор
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS 'Клиент(Физ)', 
	   UR_Person.Name_organization AS 'Клиент(Юр)',
	   Worker.Surname + ' ' + Worker.Name AS 'Сотрудник'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
ORDER BY Worker.Surname

--Вывод клиентов, которые отменяли бронирование и сотрудника, который заключал договор с клиентом
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS 'Клиент(Физ)', 
	   UR_Person.Name_organization AS 'Клиент(Юр)',
	   Worker.Surname + ' ' + Worker.Name AS 'Сотрудник'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
JOIN Booking ON Booking.Id_contract = Contract.Id_contract
JOIN Status_booking ON Booking.Id_status = Status_booking.Id_status
WHERE Status_booking.Name_status = 'Отмена заказа'
ORDER BY Worker.Surname