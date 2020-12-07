import psycopg2
import random

from Utils.DataRandomMaker import random_date


class Client(object):

    def __init__(self, connection, constantRepo):
        """Constructor"""
        self.connection = connection
        self.cursor = connection.cursor()
        self.repository = constantRepo
        pass

    def fillClients(self, countRows):
        for i in range(countRows):
            addres = f'{random.choice(self.repository.city)}, {random.choice(self.repository.street)} {random.randint(1, 100)}, кв.{random.randint(1, 500)}'

            query = f'INSERT INTO client(adress, Phone_number,Surname, name,lastname, Birth_date, Passport, itn, id_ur_person)' \
                    f' VALUES(' \
                    f'\'{addres}\'' \
                    f',\'{str(random.randint(1000000000, 9999999999))}\'' \
                    f',\'{random.choice(self.repository.second_name_man)}\'' \
                    f',\'{random.choice(self.repository.first_name_man)}\'' \
                    f',\'{random.choice(self.repository.last_name_man)}\'' \
                    f',\'{random_date("1.1.1950", "1.1.2005", random.random())}\'' \
                    f',\'{str(random.randint(1111111111, 9999999999))}\'' \
                    f',\'{str(random.randint(1000000000, 9999999999))}\'' \
                    f',\'{"1"}\')'
            self.cursor.execute(query)
            self.connection.commit()

    def getCountClients(self):
        self.cursor.execute("SELECT COUNT(*) FROM client;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]

    def updateClientAccessory(self, id_ur, id_client):
        query = f'UPDATE client set id_ur_person = \'{id_ur}\'' \
                f'  WHERE id_client =\'{id_client}\''
        self.cursor.execute(query)
        self.connection.commit()
