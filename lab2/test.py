import random
import time
import psycopg2

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

print(random_date("1.1.1950", "1.1.2005", random.random()))


worker_count = 0
client_count = 88
ur_person_count = 15
fiz_person_count = 0
type_booking = 0
room_count = 0
disscount_count = 0
service_count = 0

first_name_man = ('Халим','Максим','Ильяс','Андрей','Святослав','Никита','Георгий','Руслан','Денис','Михаил','Рустам','Дмитрий','Егор','Кирилл','Валерий','Александр','Сергей','Иван','Виктор','Юрий','Игорь')

second_name_man=('Лысенко','Сидоров','Сенченко','Попов','Земнухов','Иванов','Петров','Орлушин','Чистяков','Русин','Хамзин','Суворов','Хусаинов','Пантелеев','Данилов','Назаров','Назаркин','Мельников','Макаров','Якомазов','Луба','Кулишов','Беляков')

last_name_man = ('Халимович','Максимович','Ильясович','Андреевич','Святославович','Никитич','Георгиевич','Русланович','Денисович','Михайлович','Рустамович','Дмитриевич','Егорович','Кириллович','Валерьевич','Александрович','Сергеевич','Иванович','Викторович','Юрьевич','Игоревич')

count_id = 1

street = ('ул.Московская ','ул.Дмитриевская','пр.Победы ','пр.Строителей','ул.Ладожская','ул.Циолковского','ул.Водонаева ','ул.Октябрьская','ул.Ленина','ул.Сталинская','площадь Рефолюции','ул.Дачная','ул.Радужная','ул.Сиреневая','ул.Хорошая','ул.Виражная','ул.Гагарина')
city=('г.Москва','г.Пенза','г.Воронеж','г.Санкт-Петербург','г.Витебск','г.Казань','г.Сочи','г.Иваново','г.Мурманск','г.Волгоград','г.Ростов','г.Кузнецк','г.Сургут','г.Анадырь')
ur_name=['Не юр.лицо','Тинькофф','Microsoft','Apple','YouTube','Mailru','Газпром','Лукойл','Роснефть','ИнтерЭйр','Tortuga','Codeinside','Vigrom','OpenSolutions','Bitgames','Лейхтрум','Молескинес','Пож-центр','Intel','AMD','Foxconn','Qualcomm','Finmax','PickPoint','Ponyexpress','Почта России','Aliexpress']

query = 'INSERT INTO Build(Build_adress,Prestige,Build_number) VALUES (\'ул. Полярная 4\',2,4),(\'ул. Полярная 3\',3,3),(\'ул. Полярная 2\',4,2),(\'ул. Полярная 1\',5,1);'
cursor.execute(query)
conn.commit()

for i in range(800):

    addres = f'{random.choice(city)}, {random.choice(street)} {random.randint(1,100)}, кв.{random.randint(1,500)}'

    number = str(random.randint(11111111111,99999999999))
    query = f'INSERT INTO Client(Adress, Phone_number) values(\'{addres}\',\'{number}\')'
    cursor.execute(query)
    conn.commit()

for i in range(len(ur_name)):
    query = f'INSERT INTO UR_Person(id_client,ITN,Name_organization) values ({count_id},\'{random.randint(1000000000,9999999999)}\',\'{ur_name[i]}\')'
    cursor.execute(query)
    conn.commit()
    count_id += 1

for i in range(320):
    query = f'INSERT INTO fiz_person(id_client,id_ur_person, Surname, forename, Lastname, Birth_date, Passport) VALUES({count_id},{random.randint(1,16)},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',\'{str(random.randint(1000000000, 9999999999))}\')'
    cursor.execute(query)
    conn.commit()
    count_id+=1

for i in range(180):
    query = f'INSERT INTO fiz_person(id_client,id_ur_person, Surname, forename, Lastname, Birth_date, Passport) VALUES({count_id},{1},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',\'{str(random.randint(1000000000, 9999999999))}\')'
    cursor.execute(query)
    conn.commit()
    count_id+=1

employment_number = 1000
for i in range(100):
    addres = f'{random.choice(city)}, {random.choice(street)} {random.randint(1, 100)}, кв.{random.randint(1, 500)}'
    query=f'INSERT INTO Worker(Employment_number, Surname, sorename, Lastname, Birth_date, Sallary, Passport, Address, ITN) values({employment_number},\'{random.choice(second_name_man)}\',\'{random.choice(first_name_man)}\',\'{random.choice(last_name_man)}\',\'{random_date("1.1.1950", "1.1.2005", random.random())}\',{random.randint(15,150)*1000},\'{str(random.randint(1000000000, 9999999999))}\',\'{addres}\',\'{str(random.randint(100000000000, 999999999999))}\')'
    employment_number=+1
    cursor.execute(query)
    conn.commit()
    count_id += 1

conn.close()