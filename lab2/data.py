import random
import time
import psycopg2
import datetime
conn = psycopg2.connect(dbname='hetelaaa', user='admin',
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
#
# #Добавление корпусов
# cursor.execute("INSERT INTO Build(Build_adress,Prestige,Build_number) VALUES ('ул. Полярная 4',2,4),('ул. Полярная 3',3,3),('ул. Полярная 2',4,2),('ул. Полярная 1',5,1);");
# conn.commit()

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

#Заполнение отзывов
cursor.execute("INSERT INTO FeedBack(id_client,Mark,Descroption) VALUES "
               "(1,4,'Неплохое обслуживание Юр лиц.'),"
               "(2,4,'Обязательно вернемся в следующем году!'),"
               "(3,4,'Высокое качество обслуживаения.'),"
               "(4,3,'Некоторые наши сотрудники остались недовольны завтраком.'),"
               "(5,3,'Один из наших сотрудников отравился.'),"
               "(7,4,'Приятный персонал, много опций для номеров.'),"
               "(8,4,'Все отлично, но цены для такой гостиницы должны быть чуть ниже.'),"
               "(11,5,'Весь отдых прошел на высшем уровне!'),"
               "(12,5,'Лучшая гостиница, которую я когда-либо посещал.'),"
               "(14,2,'Отвратительно организован процесс бронирования, не смог вернуть полную стоимость после отмены заказа.'),"
               "(15,3,'В целом неплохо, завтрак оставляет желать лучшего.'),"
               "(16,4,'Обслуживание прошло на должном уровне.'),"
               "(22,5,'Прекрасный отель. Буду советовать своим знакомым и друзьям!'),"
               "(26,5,'Сервис был на высшем уровне. Порадовало количество и качество дополнительных услуг'),"
               "(27,4,'Понравилось обслуживание и рабочий персонал'),"
               "(34,4,'Хорошее расположение отеля, все нужные места в шаговой доступности'),"
               "(37,1,'Ужасное обслуживание, в номере не убираются, ТВ не работает, поражает непрофессионализм сотрудников!'),"
               "(42,2,'Отдых прошел неплохо, но некоторые сотрудники по хамски себя вели. Советую пересмотреть ваши кадры.'),"
               "(44,2,'Научитесь готовить нормальную еду! Ужас просто!'),"
               "(54,2,'Не приносили завтрак в номер, ТВ работает через раз, арендованный ноутбук слишком слабый.'),"
               "(59,2,'Не работает кондиционер в номере отеля. '),"
               "(62,3,'Для этих денег должны быть более лучшие условия'),"
               "(66,3,'Редко проводятся уборки в отеле'),"
               "(67,3,'Из всего меню понравились только грудка по-французски с макаронами'),"
               "(69,4,'Благодаря высокой скорости Интернета смог посмотреть свой любимый матч без единой задержки.'),"
               "(70,4,'Очень красивые уборщицы доставляли зрительное наслаждение каждое утро'),"
               "(77,5,'Провел отличные выходные в этом отеле. Воспоминания со мной останутся надолго'),"
               "(79,5,'Прекрасная сауна с бассейном, в которую включено барное обслуживание. Особенно понравился коктейль \"Гимнаст\". '),"
               "(80,5,'Всё общение с персоналом было приятным. Хорошие номера и большой их выбор. '),(83,4,'Администратор подобрал подходящий для меня номер очень быстро и в соответствии с моим кошельком. '),"
               "(45,4,'Поиграл в свою любимую фифу, благодаря playstation в моем номере и в целом провел время с удовольствием'),"
               "(46,4,'Иногда прерывалось Wi-Fi соединение, но то, что мне нужно я успел найти'),"
               "(47,2,'В номере остался минибар с открытыми и недопитами бутылками.'),"
               "(48,3,'Хорошие салаты в меню, но напитки так себе'),"
               "(49,4,'Есть хорошая возможность воспользоваться услугами массажиста. Было очень приятно!'),"
               "(50,4,'Улыбчивый персонал и хороший администратор, который ответил на все вопросы'),"
               "(51,3,'Мини-бар в номере оставляет желать лучшего. Нет ни русской водки, ни портвейна. '),"
               "(52,3,'Холодильник в номере начал протекать, его починили оперативно, но было неприятно'),"
               "(53,4,'Богатый шведский стол, практически всегда всё вкусно, за исключением отдельных блюд'),"
               "(28,4,'Удобные матрацы в номере обеспечили мне приятный сон на протяжении всей недели'),"
               "(29,5,'Всё было на высшем уровне от персонала до меню ресторана'),"
               "(30,5,'Прекрасно организован вечерний досуг с музыкой и танцами, некогда скучать. '),"
               "(31,5,'Этот отель останется в моей памяти на долгие годы. Очень хорошие воспоминания!'),"
               "(32,5,'Обязательно вернемся в следующий раз.'),"
               "(33,5,'Прекрасный отель!');")
conn.commit()

#Добавление комнат
cursor.execute("INSERT INTO Room(Beds_count, floor_lvl, Room_number, Room_cost, id_Build) VALUES "
               "(1,1,101,7650,4),(1,1,102,7650,4),(1,1,103,7650,4),(1,1,104,7650,4),(1,1,105,7650,4),(1,1,106,7650,4),(1,2,201,8000,4),(1,2,202,8000,4),(1,2,203,8000,4),(1,2,204,8000,4),(1,2,205,8000,4),(1,2,206,8000,4),(1,3,301,8400,4),(1,3,302,8400,4),(1,3,303,8400,4),(2,1,107,8800,4),(2,1,108,8800,4),(2,2,207,9800,4),(2,2,208,9800,4),(2,3,303,11000,4),(2,3,304,11000,4),(2,3,305,11000,4),(3,3,306,15000,4),(3,4,401,18000,4),(3,4,402,18000,4),"
               "(3,4,403,18000,4),(3,4,404,18000,4),(4,5,501,27000,4),(4,5,502,27000,4),(1,1,101,5000,3),(1,1,102,5000,3),(1,1,103,5000,3),(1,1,104,5000,3),(1,1,105,5000,3),(1,2,201,5300,3),(1,2,202,5300,3),(1,2,203,5300,3),(1,2,204,5300,3),(1,2,205,5300,3),(1,3,301,5700,3),(1,3,302,5700,3),(1,3,303,5700,3),(1,3,304,5700,3),(1,3,305,5700,3),(1,4,401,6100,3),(1,4,402,6100,3),(1,4,403,6100,3),(1,4,404,6100,3),(1,4,405,6100,3),(2,1,106,7000,3),(2,1,107,7000,3),(2,2,206,7500,3),(2,2,207,7500,3),(2,3,306,7900,3),(2,3,307,7900,3),(2,4,406,8300,3),(2,4,407,8300,3),(2,5,501,8800,3),(2,5,502,8800,3),(3,5,503,8800,3),(3,5,504,10000,3),(3,6,601,11200,3),(3,6,602,11200,3),(3,6,603,11200,3),(3,6,604,11200,3),(3,7,701,12300,3),(4,7,702,24000,3),(4,7,703,24000,3),(4,8,801,25600,3),(4,8,802,25600,3),(1,1,101,3000,2),(1,1,102,3000,2),(1,1,103,3000,2),(1,1,104,3000,2),(1,1,105,3000,2),(1,2,201,3200,2),(1,2,202,3200,2),(1,2,203,3200,2),(1,2,204,3200,2),"
               "(1,2,205,3200,2),(1,3,301,3400,2),(1,3,302,3400,2),(1,3,303,3400,2),(1,3,304,3400,2),(1,3,305,3400,2),(1,4,401,3700,2),(1,4,402,3700,2),(1,4,403,3700,2),(1,4,404,3700,2),(1,4,405,3700,2),(1,5,501,4000,2),(1,5,502,4000,2),(1,5,503,4000,2),(1,5,504,4000,2),(1,5,505,4000,2),(2,1,106,5000,2),(2,1,107,5000,2),(2,1,108,5000,2),(2,2,206,5300,2),(2,2,207,5300,2),(2,2,208,5300,2),(2,3,306,5600,2),(2,3,307,5600,2),(2,3,308,5600,2),(2,4,406,6000,2),(2,4,407,6000,2),(2,4,408,6000,2),(2,5,506,6300,2),(2,5,507,6300,2),(2,5,508,6300,2),(3,1,109,8000,2),(3,1,110,8000,2),(3,1,111,8000,2),(3,2,209,8700,2),(3,2,210,8700,2),(3,2,211,8700,2),(3,3,309,9200,2),(3,3,310,9200,2),(3,3,311,9200,2),(3,4,409,9800,2),(4,4,410,13000,2),(4,4,411,13000,2),(4,5,509,14000,2),(4,5,510,14000,2),(4,5,511,14000,2),(4,5,512,14000,2),(1,1,101,2000,1),(1,1,102,2000,1),(1,1,103,2000,1),(1,1,104,2000,1),(1,1,105,2000,1),(1,1,101,3000,1),(1,1,102,3000,1),(1,1,103,3000,1),(1,1,104,3000,1),(1,1,105,3000,1),(1,1,201,3200,1),(1,1,202,3200,1),(1,1,203,3200,1),(1,1,204,3200,1),(1,1,205,3200,1),(1,1,301,3400,1),(1,1,302,3400,1),(1,1,303,3400,1),(1,1,304,3400,1),(1,1,305,3400,1),(1,1,401,3700,1),(1,1,402,3700,1),(1,1,403,3700,1),(1,1,404,3700,1),(1,1,405,3700,1),(1,1,501,4000,1),(1,1,502,4000,1),(1,1,503,4000,1),(1,1,504,4000,1),(1,1,505,4000,1),(2,1,106,5000,1),(2,1,107,5000,1),(2,1,108,5000,1),(2,1,206,5300,1),(2,1,207,5300,1),(2,1,208,5300,1),(2,1,306,5600,1),(2,1,307,5600,1),(2,1,308,5600,1),(2,1,406,6000,1),(2,1,407,6000,1),(2,1,408,6000,1),(2,1,506,6300,1),(2,1,507,6300,1),(2,1,508,6300,1),(3,1,109,8000,1),(3,1,110,8000,1),(3,1,111,8000,1),(3,1,209,8700,1),(3,1,210,8700,1),(3,1,211,8700,1),(3,1,309,9200,1),(3,1,310,9200,1),(3,1,311,9200,1),(3,1,409,9800,1),(4,1,410,13000,1),(4,1,411,13000,1),(4,1,509,14000,1),(4,1,510,14000,1),(4,1,511,14000,1),(4,1,512,14000,1);")
conn.commit()
#Заполнение услуг
cursor.execute("INSERT INTO service (service_name, service_cost) values ('Завтрак в номер',600),('Обед в номер',1500),('Ежедневная уборка',600),('Ужин в номер',700),('Минибар',3000),('Wi-fi',200),('Стирка личных вещей',300),('Глажка одежды',200),('Тренажерный зал',900),('Сейф',400),('Аренда ноутбука',1000),('Игровая приставка(PS4)',600),('Цифровое ТВ',300),('Сауна',1200),('Хамам',900),('Русская баня',900),('Бассейн',500),('Инструктор по фитнесу',1000),('Инструктор по плаванию',900),('Кружок детского творчества',400),('Аквапарк',1300),('Казино',2200),('Аренда беседки и гриля',2000),('Сеанс массажа',700),('Аренда переговорной комнаты',1500);")
conn.commit()

cursor.execute(""
               "INSERT INTO service_for_room(id_room,id_service) VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),(2,13),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9),(3,10),(3,11),(3,12),(3,13),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8),(4,9),(4,10),(4,11),(4,12),(4,13),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),(5,13),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),(6,11),(6,12),(6,13),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8),(7,9),(7,10),(7,11),(7,12),(7,13),(8,1),(8,2),(8,3),(8,4),(8,5),(8,6),(8,7),(8,8),(8,9),(8,10),(8,11),(8,12),(8,13),(9,1),(9,2),(9,3),(9,4),(9,5),(9,6),(9,7),(9,8),(9,9),(9,10),(9,11),(9,12),(9,13),(10,1),(10,2),(10,3),(10,4),(10,5),(10,6),(10,7),(10,8),(10,9),(10,10),(10,11),(10,12),(10,13),(11,1),(11,2),(11,3),(11,4),(11,5),(11,6),(11,7),(11,8),(11,9),(11,10),(11,11),(11,12),(11,13),(12,1),(12,2),(12,3),(12,4),(12,5),(12,6),(12,7),(12,8),(12,9),(12,10),(12,11),(12,12),(12,13),(13,1),(13,2),(13,3),(13,4),(13,5),(13,6),(13,7),(13,8),(13,9),(13,10),(13,11),(13,12),(13,13),(14,1),(14,2),(14,3),(14,4),(14,5),(14,6),(14,7),(14,8),(14,9),(14,10),(14,11),(14,12),(14,13),(15,1),(15,2),(15,3),(15,4),(15,5),(15,6),(15,7),(15,8),(15,9),(15,10),(15,11),(15,12),(15,13),(16,1),(16,2),(16,3),(16,4),(16,5),(16,6),(16,7),(16,8),(16,9),(16,10),(16,11),(16,12),(16,13),(17,1),(17,2),(17,3),(17,4),(17,5),(17,6),(17,7),(17,8),(17,9),(17,10),(17,11),(17,12),(17,13),(18,1),(18,2),(18,3),(18,4),(18,5),(18,6),(18,7),(18,8),(18,9),(18,10),(18,11),(18,12),(18,13),(19,1),(19,2),(19,3),(19,4),(19,5),(19,6),(19,7),(19,8),(19,9),(19,10),(19,11),(19,12),(19,13),(20,1),(20,2),(20,3),(20,4),(20,5),(20,6),(20,7),(20,8),(20,9),(20,10),(20,11),(20,12),(20,13),(21,1),(21,2),(21,3),(21,4),(21,5),(21,6),(21,7),(21,8),(21,9),(21,10),(21,11),(21,12),(21,13),(22,1),(22,2),(22,3),(22,4),(22,5),(22,6),(22,7),(22,8),(22,9),(22,10),(22,11),(22,12),(22,13),(23,1),(23,2),(23,3),(23,4),(23,5),(23,6),(23,7),(23,8),(23,9),(23,10),(23,11),(23,12),(23,13),(24,1),(24,2),(24,3),(24,4),(24,5),(24,6),(24,7),(24,8),(24,9),(24,10),(24,11),(24,12),(24,13),(25,1),(25,2),(25,3),(25,4),(25,5),(25,6),(25,7),(25,8),(25,9),(25,10),(25,11),(25,12),(25,13),(26,1),(26,2),(26,3),(26,4),(26,5),(26,6),(26,7),(26,8),(26,9),(26,10),(26,11),(26,12),(26,13),(27,1),(27,2),(27,3),(27,4),(27,5),(27,6),(27,7),(27,8),(27,9),(27,10),(27,11),(27,12),(27,13),(28,1),(28,2),(28,3),(28,4),(28,5),(28,6),(28,7),(28,8),(28,9),(28,10),(28,11),(28,12),(28,13),(29,1),(29,2),(29,3),(29,4),(29,5),(29,6),(29,7),(29,8),(29,9),(29,10),(29,11),(29,12),(29,13);"
               "INSERT INTO service_for_room(id_room,id_service) VALUES (30,1),(30,2),(30,3),(30,4),(30,5),(30,6),(30,7),(30,13),(31,1),(31,2),(31,3),(31,4),(31,5),(31,6),(31,7),(31,13),(32,1),(32,2),(32,3),(32,4),(32,5),(32,6),(32,7),(32,13),(33,1),(33,2),(33,3),(33,4),(33,5),(33,6),(33,7),(33,13),(34,1),(34,2),(34,3),(34,4),(34,5),(34,6),(34,7),(34,13),(35,1),(35,2),(35,3),(35,4),(35,5),(35,6),(35,7),(35,13),(36,1),(36,2),(36,3),(36,4),(36,5),(36,6),(36,7),(36,13),(37,1),(37,2),(37,3),(37,4),(37,5),(37,6),(37,7),(37,13),(38,1),(38,2),(38,3),(38,4),(38,5),(38,6),(38,7),(38,13),(39,1),(39,2),(39,3),(39,4),(39,5),(39,6),(39,7),(39,13),(40,1),(40,2),(40,3),(40,4),(40,5),(40,6),(40,7),(40,13),(41,1),(41,2),(41,3),(41,4),(41,5),(41,6),(41,7),(41,13),(42,1),(42,2),(42,3),(42,4),(42,5),(42,6),(42,7),(42,13),(43,1),(43,2),(43,3),(43,4),(43,5),(43,6),(43,7),(43,13),(44,1),(44,2),(44,3),(44,4),(44,5),(44,6),(44,7),(44,13),(45,1),(45,2),(45,3),(45,4),(45,5),(45,6),(45,7),(45,13),(46,1),(46,2),(46,3),(46,4),(46,5),(46,6),(46,7),(46,13),(47,1),(47,2),(47,3),(47,4),(47,5),(47,6),(47,7),(47,13),(48,1),(48,2),(48,3),(48,4),(48,5),(48,6),(48,7),(48,13),(49,1),(49,2),(49,3),(49,4),(49,5),(49,6),(49,7),(49,13),(50,1),(50,2),(50,3),(50,4),(50,5),(50,6),(50,7),(50,13),(51,1),(51,2),(51,3),(51,4),(51,5),(51,6),(51,7),(51,13),(52,1),(52,2),(52,3),(52,4),(52,5),(52,6),(52,7),(52,13),(53,1),(53,2),(53,3),(53,4),(53,5),(53,6),(53,7),(53,13),(54,1),(54,2),(54,3),(54,4),(54,5),(54,6),(54,7),(54,13),(55,1),(55,2),(55,3),(55,4),(55,5),(55,6),(55,7),(55,13),(56,1),(56,2),(56,3),(56,4),(56,5),(56,6),(56,7),(56,13),(57,1),(57,2),(57,3),(57,4),(57,5),(57,6),(57,7),(57,13),(58,1),(58,2),(58,3),(58,4),(58,5),(58,6),(58,7),(58,13),(59,1),(59,2),(59,3),(59,4),(59,5),(59,6),(59,7),(59,13),(60,1),(60,2),(60,3),(60,4),(60,5),(60,6),(60,7),(60,13),(61,1),(61,2),(61,3),(61,4),(61,5),(61,6),(61,7),(61,13),(62,1),(62,2),(62,3),(62,4),(62,5),(62,6),(62,7),(62,13),(63,1),(63,2),(63,3),(63,4),(63,5),(63,6),(63,7),(63,13),(64,1),(64,2),(64,3),(64,4),(64,5),(64,6),(64,7),(64,13),(65,1),(65,2),(65,3),(65,4),(65,5),(65,6),(65,7),(65,13),(66,1),(66,2),(66,3),(66,4),(66,5),(66,6),(66,7),(66,13),(67,1),(67,2),(67,3),(67,4),(67,5),(67,6),(67,7),(67,13),(68,1),(68,2),(68,3),(68,4),(68,5),(68,6),(68,7),(68,13),(69,1),(69,2),(69,3),(69,4),(69,5),(69,6),(69,7),(69,13),(70,1),(70,2),(70,3),(70,4),(70,5),(70,6),(70,7),(70,13);"
               "INSERT INTO service_for_room(id_room,id_service) VALUES (71,1),(71,2),(71,3),(71,6),(71,13),(72,1),(72,2),(72,3),(72,6),(72,13),(73,1),(73,2),(73,3),(73,6),(73,13),(74,1),(74,2),(74,3),(74,6),(74,13),(75,1),(75,2),(75,3),(75,6),(75,13),(76,1),(76,2),(76,3),(76,6),(76,13),(77,1),(77,2),(77,3),(77,6),(77,13),(78,1),(78,2),(78,3),(78,6),(78,13),(79,1),(79,2),(79,3),(79,6),(79,13),(80,1),(80,2),(80,3),(80,6),(80,13),(81,1),(81,2),(81,3),(81,6),(81,13),(82,1),(82,2),(82,3),(82,6),(82,13),(83,1),(83,2),(83,3),(83,6),(83,13),(84,1),(84,2),(84,3),(84,6),(84,13),(85,1),(85,2),(85,3),(85,6),(85,13),(86,1),(86,2),(86,3),(86,6),(86,13),(87,1),(87,2),(87,3),(87,6),(87,13),(88,1),(88,2),(88,3),(88,6),(88,13),(89,1),(89,2),(89,3),(89,6),(89,13),(90,1),(90,2),(90,3),(90,6),(90,13),(91,1),(91,2),(91,3),(91,6),(91,13),(92,1),(92,2),(92,3),(92,6),(92,13),(93,1),(93,2),(93,3),(93,6),(93,13),(94,1),(94,2),(94,3),(94,6),(94,13),(95,1),(95,2),(95,3),(95,6),(95,13),(96,1),(96,2),(96,3),(96,6),(96,13),(97,1),(97,2),(97,3),(97,6),(97,13),(98,1),(98,2),(98,3),(98,6),(98,13),(99,1),(99,2),(99,3),(99,6),(99,13),(100,1),(100,2),(100,3),(100,6),(100,13),(101,1),(101,2),(101,3),(101,6),(101,13),(102,1),(102,2),(102,3),(102,6),(102,13),(103,1),(103,2),(103,3),(103,6),(103,13),(104,1),(104,2),(104,3),(104,6),(104,13),(105,1),(105,2),(105,3),(105,6),(105,13),(106,1),(106,2),(106,3),(106,6),(106,13),(107,1),(107,2),(107,3),(107,6),(107,13),(108,1),(108,2),(108,3),(108,6),(108,13),(109,1),(109,2),(109,3),(109,6),(109,13),(110,1),(110,2),(110,3),(110,6),(110,13),(111,1),(111,2),(111,3),(111,6),(111,13),(112,1),(112,2),(112,3),(112,6),(112,13),(113,1),(113,2),(113,3),(113,6),(113,13),(114,1),(114,2),(114,3),(114,6),(114,13),(115,1),(115,2),(115,3),(115,6),(115,13),(116,1),(116,2),(116,3),(116,6),(116,13),(117,1),(117,2),(117,3),(117,6),(117,13),(118,1),(118,2),(118,3),(118,6),(118,13),(119,1),(119,2),(119,3),(119,6),(119,13),(120,1),(120,2),(120,3),(120,6),(120,13),(121,1),(121,2),(121,3),(121,6),(121,13),(122,1),(122,2),(122,3),(122,6),(122,13),(123,1),(123,2),(123,3),(123,6),(123,13),(124,1),(124,2),(124,3),(124,6),(124,13),(125,1),(125,2),(125,3),(125,6),(125,13);"
               "INSERT INTO service_for_room(id_room,id_service) VALUES (126,1),(126,3),(126,13),(127,1),(127,3),(127,13),(128,1),(128,3),(128,13),(129,1),(129,3),(129,13),(130,1),(130,3),(130,13),(131,1),(131,3),(131,13),(132,1),(132,3),(132,13),(133,1),(133,3),(133,13),(134,1),(134,3),(134,13),(135,1),(135,3),(135,13),(136,1),(136,3),(136,13),(137,1),(137,3),(137,13),(138,1),(138,3),(138,13),(139,1),(139,3),(139,13),(140,1),(140,3),(140,13),(141,1),(141,3),(141,13),(142,1),(142,3),(142,13),(143,1),(143,3),(143,13),(144,1),(144,3),(144,13),(145,1),(145,3),(145,13),(146,1),(146,3),(146,13),(147,1),(147,3),(147,13),(148,1),(148,3),(148,13),(149,1),(149,3),(149,13),(150,1),(150,3),(150,13),(151,1),(151,3),(151,13),(152,1),(152,3),(152,13),(153,1),(153,3),(153,13),(154,1),(154,3),(154,13),(155,1),(155,3),(155,13),(156,1),(156,3),(156,13),(157,1),(157,3),(157,13),(158,1),(158,3),(158,13),(159,1),(159,3),(159,13),(160,1),(160,3),(160,13),(161,1),(161,3),(161,13),(162,1),(162,3),(162,13),(163,1),(163,3),(163,13),(164,1),(164,3),(164,13),(165,1),(165,3),(165,13),(166,1),(166,3),(166,13),(167,1),(167,3),(167,13),(168,1),(168,3),(168,13),(169,1),(169,3),(169,13),(170,1),(170,3),(170,13),(171,1),(171,3),(171,13),(172,1),(172,3),(172,13),(173,1),(173,3),(173,13),(174,1),(174,3),(174,13),(175,1),(175,3),(175,13),(176,1),(176,3),(176,13),(177,1),(177,3),(177,13),(178,1),(178,3),(178,13),(179,1),(179,3),(179,13),(180,1),(180,3),(180,13),(181,1),(181,3),(181,13),(182,1),(182,3),(182,13),(183,1),(183,3),(183,13),(184,1),(184,3),(184,13),(185,1),(185,3),(185,13),(186,1),(186,3),(186,13),(187,1),(187,3),(187,13);"
               )
conn.commit()

cursor.execute("INSERT INTO Disscount (Disscount_name,Diss_person, Diss_legal) VALUES ('Постоянный клиент',12,12),('Заказ более 5 номеров за раз',10,15),('Заказ более 10 номеров за раз',15,20),('Заказ более 20 номеров за раз',25,30),('Скидка к случаю дня рождения',40,0),('Вернувшийся клиент(2 посещение)',10,15),('Скидки нет',0,0);")
conn.commit()

cursor.execute("INSERT INTO type_booking(Name_type) VALUES ('Оплачено'),('Забронированно'),('Отмена заказа');")
conn.commit()


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
    print("type_booking = ", type_booking)
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

    status = random.randint(1,3)
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
    query = f"insert into bilt_position(id_bill,id_disscount,without_vat,without_disscount,with_discount) values" \
            f"({i}," \
            f"{random.randint(1,disscount_count)}," \
            f"{money}," \
            f"{money+ random.randint(100,500)}," \
            f"{money});"
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



conn.close()