import random
import time
import psycopg2
import datetime
conn = psycopg2.connect(dbname='hotelaaa', user='admin',
                        password='samihad228', host='localhost')
cursor = conn.cursor()



def str_time_prop(start, end, format, prop):
    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))
    ptime = stime + prop * (etime - stime)
    return time.strftime(format, time.localtime(ptime))

def random_date(start, end, prop):
    return str_time_prop(start, end, '%d.%m.%Y', prop)

first_name_man = ('Халим','Максим','Ильяс','Андрей','Святослав','Никита','Петр','Георгий','Руслан','Денис','Михаил','Рустам','Дмитрий','Егор','Кирилл','Валерий','Александр','Сергей','Иван','Виктор','Юрий','Игорь')
second_name_man=('Лысенко','Гаврилов','Данилов','Красовский','Дюжев','Макаров','Сидоров','Сенченко','Попов','Земнухов','Иванов','Петров','Орлушин','Чистяков','Русин','Хамзин','Суворов','Хусаинов','Пантелеев','Данилов','Назаров','Назаркин','Мельников','Макаров','Якомазов','Луба','Кулишов','Беляков')
last_name_man = ('Халимович','Максимович','Ильясович','Андреевич','Святославович','Никитич','Георгиевич','Русланович','Денисович','Михайлович','Рустамович','Дмитриевич','Егорович','Кириллович','Валерьевич','Александрович','Сергеевич','Иванович','Викторович','Юрьевич','Игоревич')

count_id = 1

street = ('ул.Московская ','ул.Дмитриевская','пр.Победы ','пр.Строителей','ул.Ладожская','ул.Циолковского','ул.Водонаева ','ул.Октябрьская','ул.Ленина','ул.Сталинская','площадь Рефолюции','ул.Дачная','ул.Радужная','ул.Сиреневая','ул.Хорошая','ул.Виражная','ул.Гагарина')
city=('г.Москва','г.Пенза','г.Воронеж','г.Санкт-Петербург','г.Витебск','г.Казань','г.Сочи','г.Иваново','г.Мурманск','г.Волгоград','г.Ростов','г.Кузнецк','г.Сургут','г.Анадырь')
ur_name=['Не юр.лицо','Тинькофф','Microsoft','Apple','YouTube','Mailru','Газпром','Лукойл','Роснефть','ИнтерЭйр','Tortuga','Codeinside','Vigrom','OpenSolutions','Bitgames','Лейхтрум','Молескинес','Пож-центр','Intel','AMD','Foxconn','Qualcomm','Finmax','PickPoint','Ponyexpress','Почта России','Aliexpress']

#Заполнение клиента
for i in range(800):

    addres = f'{random.choice(city)}, {random.choice(street)} {random.randint(1,100)}, кв.{random.randint(1,500)}'

    number = str(random.randint(11111111111,99999999999))
    query = f'INSERT INTO Client(Adress, Phone_number) values(\'{addres}\',\'{number}\')'
    cursor.execute(query)
    conn.commit()

#Заполнение юр лица
for i in range(len(ur_name)):
    query = f'INSERT INTO UR_Person(id_client,ITN,Name_organization) values ({count_id},\'{random.randint(1000000000,9999999999)}\',\'{ur_name[i]}\')'
    cursor.execute(query)
    conn.commit()
    count_id += 1

#заполение физ_лица от юрлица
for i in range(320):
    query = f'INSERT INTO fiz_person(id_client,id_ur_person, Surname, forename, Lastname, Birth_date, Passport) VALUES({count_id},{random.randint(1,16)},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',\'{str(random.randint(1000000000, 9999999999))}\')'
    cursor.execute(query)
    conn.commit()
    count_id+=1
#заполение физ_лица
for i in range(180):
    query = f'INSERT INTO fiz_person(id_client,id_ur_person, Surname, forename, Lastname, Birth_date, Passport) VALUES({count_id},{1},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',\'{str(random.randint(1000000000, 9999999999))}\')'
    cursor.execute(query)
    conn.commit()
    count_id+=1

employment_number = 1000
#заполение сотрудника
for i in range(100):
    addres = f'{random.choice(city)}, {random.choice(street)} {random.randint(1, 100)}, кв.{random.randint(1, 500)}'
    query=f'INSERT INTO Worker(Employment_number, Surname, sorename, Lastname, Birth_date, Sallary, Passport, Address, ITN) values({employment_number},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',{random.randint(15,150)*1000},\'{str(random.randint(1000000000, 9999999999))}\',\'{addres}\',\'{str(random.randint(100000000000, 999999999999))}\')'
    employment_number=+1
    cursor.execute(query)
    conn.commit()
    count_id += 1


cursor.execute("SELECT COUNT(*) FROM Worker;")
ver = cursor.fetchall()
for row in ver:
    worker_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM client;")
ver = cursor.fetchall()
for row in ver:
    client_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM ur_person;")
ver = cursor.fetchall()
for row in ver:
    ur_person_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM fiz_person;")
ver = cursor.fetchall()
for row in ver:
    fiz_person_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM type_booking;")
ver = cursor.fetchall()
for row in ver:
    type_booking = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM room;")
ver = cursor.fetchall()
for row in ver:
    room_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM disscount;")
ver = cursor.fetchall()
for row in ver:
    disscount_count = int(row[0])
conn.commit()

cursor.execute("SELECT COUNT(*) FROM service;")
ver = cursor.fetchall()
for row in ver:
    service_count = int(row[0])
conn.commit()


contract_number = 1000
id_bill = 1
year = 2001
month = 1
day = 1
coin = 1

#заполение договора
for i in range(1000):

    query = "insert into bill(ammount) values (0);"
    cursor.execute(query)
    conn.commit()

    start_date = datetime.date(year, month, day)
    end_day = day + random.randint(1, 14)
    if (end_day > 28):
        month += 1
        end_day = 1
        if (month == 13):
            year += 1
            month = 1
    end_date = datetime.date(year, month,end_day)


    query = f'insert into contract(contract_number, id_client, id_bill, id_worker, start_date, end_date) values' \
            f'({contract_number},' \
            f'{random.randint(1,client_count)},' \
            f'{id_bill},' \
            f'{random.randint(1,worker_count)},' \
            f'\'{start_date}\',' \
            f'\'{end_date}\')'
    coin = random.randint(1,10000)
    if(coin > 9000):
        day+=1
        if(day > 28):
            month += 1
            day = 1
            if (month == 13):
                year += 1
                month = 1
    contract_number+=1
    id_bill+=1
    cursor.execute(query)
    conn.commit()
conn.close()

cursor.execute("SELECT COUNT(*) FROM contract;")
ver = cursor.fetchall()
for row in ver:
    contract_count = int(row[0])
conn.commit()

#заполение бронирования

i = 1
year = 2001
month = 1
day = 1
coin = 1
status = 1
while( i < contract_count):
    setlement = datetime.date(year, month, day)
    booking = datetime.date(year, month, day)

    end_day = day + random.randint(1, 14)
    if (end_day > 28):
        month += 1
        end_day = 1
        if (month == 13):
            year += 1
            month = 1
    departe = datetime.date(year, month,end_day)

    coin = random.randint(1, 10000)
    if(coin > 9000):
        day+=1
        if(day > 28):
            month += 1
            day = 1
            if (month == 13):
                year += 1
                month = 1

    query = f"insert into status_booking (id_type_booking, time_operation) values" \
            f"({random.randint(1,type_booking)}," \
            f"\'{booking}\');"
    cursor.execute(query)
    conn.commit()

    query = f"insert into booking (id_contract, id_status, settlement_time, departure_time, booking_time, id_room) values" \
            f"({i}," \
            f"{status}," \
            f"\'{setlement}\'," \
            f"\'{departe}\'," \
            f"\'{booking}\'," \
            f"{random.randint(1,room_count)})"
    cursor.execute(query)
    conn.commit()
    i+=1
    status+=1

#заполение клиент-бронирование

cursor.execute("SELECT COUNT(*) FROM booking;")
ver = cursor.fetchall()
for row in ver:
    booking_count = int(row[0])
conn.commit()
i = 1
while(i < booking_count):

    query =f"insert into client_booking(id_client, id_booking) values " \
           f"({random.randint(1,client_count)},{i})"
    cursor.execute(query)
    conn.commit()
    coin = random.randint(1,6)
    if(coin < 4):
        i+=1



cursor.execute("SELECT COUNT(*) FROM bill;")
ver = cursor.fetchall()
for row in ver:
    bill_count = int(row[0])
conn.commit()

i = 1

#заполение позиций счета
while(i < bill_count):

    money = random.randint(300,1000)
    query = f"insert into bilt_position(id_bill,id_disscount,without_vat,without_disscount) values" \
            f"({i}," \
            f"{random.randint(1,disscount_count)}," \
            f"{money}," \
            f"{money+ random.randint(100,500)});"
    cursor.execute(query)
    conn.commit()
    coin = random.randint(1, 10)
    if(coin > 3):
        i+=1


cursor.execute("SELECT COUNT(*) FROM bilt_position;")
ver = cursor.fetchall()
for row in ver:
    bill_position_count = int(row[0])
conn.commit()
i=1
#заполение наименований услуг в позициях счета
while(i < bill_position_count):
    query = f"insert into bilt_position_service(id_bilt_position, id_service) values" \
            f"({i}," \
            f"{random.randint(1,service_count)});"
    cursor.execute(query)
    conn.commit()
    i+=1