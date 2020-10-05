 --1) ������ �� ������� ����� ���������� ���. �����, � ����������� ����������� �������.
 GO
SELECT Bilt_position.id_option_service,option_service_name as '�������� ������',
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

select YEAR(Contract.End_date) as '���',MONTH(Contract.End_date) as '����� ������', SUM(Bill.Ammount) as '�������' from Contract
	join Bill on Bill.id_bill = Contract.id_bill
		where Contract.Start_date>='2019-11-30T00:00:00' 
	  AND Contract.End_date<='2020-01-05T00:00:00'
	  group by MONTH(Contract.End_date),YEAR(Contract.End_date)

-- 5) ������� �������� � ���������� ����� ����  �� ������� ��� ������������ �����
GO
DECLARE @c BIGINT = (SELECT COUNT(*) FROM Booking);

SELECT AVG(1.0 * val) as '�������', (select AVG(DATEDIFF(dayofyear,  Booking.Settlement_time,Booking.Departure_time)) from Booking) as '�������'
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
 select Fiz_person.Name,Fiz_person.Surname,UR_Person.Name_organization,SUM(Room.Room_cost)  from Contract
	join Client on Client.id_client = Contract.id_client
	 left join Fiz_person on Fiz_person.id_client = Client.id_client
	 left join UR_Person on UR_Person.id_client = Client.id_client
	join Booking on Booking.Id_contract = Contract.Id_contract
	join Room on Room.id_room = Booking.id_room
		GROUP BY Client.id_client,Fiz_person.Name,UR_Person.Name_organization,Fiz_person.Surname
			ORDER BY SUM(Room.Room_cost)	
		
GO


select * from Booking
select * from Bill
select * from Build
select * from Room
select * from Contract