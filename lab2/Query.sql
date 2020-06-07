 --1) ������ �� ������� ����� ���������� ���. �����, � ����������� ����������� �������.
 GO
SELECT Bilt_position.id_option_service as 'ID', option_service_name as '�������� ������',
 COUNT(*) * Option_cost  AS '�������'
FROM Bilt_position 
join Optional_service on Optional_service.id_option_service=Bilt_position.id_option_service
GROUP BY Bilt_position.id_option_service,option_service_name,Option_cost
ORDER BY COUNT(*) * Option_cost DESC

--2) ������ �� ���������� � ������� �������, ��������������� �� ������� ������� 

GO
select Prestige as '�����', Sum(Room.Room_cost) as '����' from Build
	join Room on Room.id_Build = Build.id_Build
	join Booking on Booking.id_room = Room.id_room
	join Contract on Contract.Id_contract = Booking.Id_contract
	join Bill on Bill.id_bill = Contract.id_bill
		GROUP BY Prestige


GO

--������ ������� ���������� �� �������� ���������� �������.
--3) (����� ���������� �� ������ + ���. ������ - �������� ������� - ��������� ���. �����)

GO
select sum(Ammount) - sum(Include_service.Cost)
- sum(Worker.Sallary) - SUM(Optional_service.Option_cost_for_hotel) as '������ �������'
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

--4)������� ����� ����������  ������� � ������ ���������� ������� � ������� ���������� ������� �� �����.

select YEAR(Contract.End_date) as '���',
	   MONTH(Contract.End_date) as '����� ������',
       SUM(Bill.Ammount) as '�������' from Contract
	join Bill on Bill.id_bill = Contract.id_bill
		where Contract.Start_date>='2019-11-30T00:00:00' 
	  AND Contract.End_date<='2020-01-05T00:00:00'
	  group by MONTH(Contract.End_date),YEAR(Contract.End_date)

-- 5) ������� �������� � ���������� ����� ����  �� ������� ��� ������������ �����
GO
DECLARE @c BIGINT = (SELECT COUNT(*) FROM Booking);

SELECT AVG(1.0 * val) as '�������', 
(select AVG(DATEDIFF(dayofyear,  Booking.Settlement_time,Booking.Departure_time)) from Booking) as '�������'
FROM (
    SELECT DATEDIFF(dayofyear,  Booking.Settlement_time,Booking.Departure_time) as val FROM Booking
     ORDER BY val
     OFFSET (@c - 1) / 2 ROWS
     FETCH NEXT 1 + (1 - @c % 2) ROWS ONLY
) AS x;
Go



--6)������� �� ��� � ���������� ����������� ���������������
-- ������� � �������� ���������� �������  � ������� �����
GO
select UR_Person.Name_organization as '�������� �����������',Sum(Room.Room_cost) as '�����' from UR_Person 
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


--7) ������� ������� ���������� �� ��. ��� � �� ���. ��� � �������� ���������� �������

GO
 select Fiz_person.Name as '���',Fiz_person.Surname as '�������',UR_Person.Name_organization as '�������� �����������',SUM(Room.Room_cost) as '�����'  from Contract
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

--8)����� ���������� ��������� ������� � ������ �������� � �����, ������� ���� ��������
SELECT COUNT(Booking.id_booking) AS '���-�� �������', 
		Contract.Contract_number AS '����� ��������' , 
		Bill.Ammount AS '����'
FROM Contract
JOIN Booking ON Contract.Id_contract = Booking.Id_contract
JOIN Bill  ON Contract.Id_bill = Bill.Id_bill
GROUP BY Contract.Contract_number, Bill.Ammount;

--################################################################--
--################################################################--
--################################################################--
--���������� ����������� ����������� � ������ ������ �������/ � ������������ ���������� �������
SELECT COUNT(id_booking) AS '���������� �����������'
FROM Booking
--WHERE Booking.Settlement_time > GETDATE() 
--	  AND
--	  Booking.Departure_time < GETDATE()
WHERE Booking.Settlement_time BETWEEN '25.12.2019' AND '10.01.2020'
	  AND
	  Booking.Departure_time BETWEEN '25.12.2019' AND '10.01.2020'

--����� ������ ��� ��������������� ������� �� �������� ��� ��� ��� � ��. ���
SELECT Room.Room_number AS '�����', 
		Build.Prestige AS '����� ������', 
		Disscount.Disscount_name AS '������������ ������',
		Room_cost - (Room_cost * 0.01 * Disscount.Diss_person) AS '���� �� ������� (���)',
		Disscount.Diss_person AS '������� ������ (���)',
		Room_cost - (Room_cost * 0.01 * Disscount.Diss_legal) AS '���� �� ������� (��)',
		Disscount.Diss_legal AS '������� ������ (��)',
		Room.Room_cost AS '���� ������'
FROM Room
JOIN Build ON Room.id_build = Build.id_build
JOIN Bilt_position on Room.id_room = Bilt_position.id_room
JOIN Disscount on Bilt_position.id_disscount = Disscount.id_disscount;

-- ������� ��������� �������� ����������
SELECT COUNT(Contract.Id_contract) AS '���������� ���������',UR_Person.Name_organization AS '��.����', Fiz_person.Surname + ' ' + Fiz_person.Name AS '���.����'
FROM Client
JOIN Contract ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
GROUP BY Fiz_person.Surname, Fiz_person.Name, UR_Person.Name_organization

--������, ����� ������ ���� ����� ��������� ����������
SELECT COUNT(Mark) AS '���������� �������', Mark AS '������'
FROM Feedback
GROUP BY Mark
ORDER BY Mark DESC

--#############################################################################--

-- ������ �� ����� ������� ���������� ������ ���������� �������
SELECT Room.Room_number AS '��������� ������',
	   Build.Prestige AS '����� ������', 
	   Room.Room_cost AS '���� ������'
FROM Booking
JOIN Room ON Booking.id_room = Room.id_room
JOIN Build ON Build.id_Build = Room.id_Build
WHERE (Booking.Settlement_time BETWEEN '25.12.2019' AND '10.01.2020' 
	  AND
	  Booking.Departure_time BETWEEN '25.12.2019' AND '10.01.2020')
	  OR (Booking.Settlement_time IS NULL AND Booking.Departure_time IS NULL)
UNION ALL
SELECT Room.Room_number AS '��������� ������',
	   Build.Prestige AS '����� ������', 
	   Room.Room_cost AS '���� ������'
FROM Room
JOIN Build ON Build.id_Build = Room.id_Build
LEFT JOIN Booking ON Booking.id_room = Room.id_room
WHERE Booking.id_booking is NULL
ORDER BY Room.Room_number, Build.Prestige

--����� ������� � ���� ��������������� �� �������
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS '������(���)', 
       UR_Person.Name_organization AS '������(��)',
	   Room.Room_number AS '����� �������',
	   Booking.Settlement_time AS '����� ���������',
	   Booking.Departure_time AS '����� ���������'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Booking ON Booking.Id_contract = Contract.Id_contract
JOIN Room ON Booking.id_room = Room.id_room
--�������� where  ���� ���� ��� ����������� �������

--��������� �������� �� ���������� ������
SELECT 
COUNT(CASE WHEN  Age < 18 THEN 1 END) AS '<18', 
COUNT(CASE WHEN  Age > 19 AND Age < 25  THEN 1 END) AS '19-25', 
COUNT(CASE WHEN  Age > 26 AND Age < 39  THEN 1 END) AS '26-39', 
COUNT(CASE WHEN  Age > 40 AND Age < 65  THEN 1 END) AS '40-65', 
COUNT(CASE WHEN  Age > 65 THEN 1 END) '>65'
FROM Fiz_person


--����� ������ � ���������� � �������, ������� ��������� �������
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS '������(���)', 
	   UR_Person.Name_organization AS '������(��)',
	   Worker.Surname + ' ' + Worker.Name AS '���������'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
ORDER BY Worker.Surname

--����� ��������, ������� �������� ������������ � ����������, ������� �������� ������� � ��������
SELECT Fiz_person.Surname + ' ' + Fiz_person.Name AS '������(���)', 
	   UR_Person.Name_organization AS '������(��)',
	   Worker.Surname + ' ' + Worker.Name AS '���������'
FROM Contract
JOIN Client ON  Contract.Id_client = Client.id_client
LEFT JOIN Fiz_person ON  Fiz_person.id_client = Client.id_client
LEFT JOIN UR_person ON  UR_Person.id_client = Client.id_client
JOIN Worker ON Worker.id_worker = Contract.id_worker
JOIN Booking ON Booking.Id_contract = Contract.Id_contract
JOIN Status_booking ON Booking.Id_status = Status_booking.Id_status
WHERE Status_booking.Name_status = '������ ������'
ORDER BY Worker.Surname