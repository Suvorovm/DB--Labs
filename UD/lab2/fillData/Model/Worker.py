import psycopg2
import random

from Utils.DataRandomMaker import random_date


class Worker(object):


    def __init__(self, connection, constantRepo):
        """Constructor"""
        self.connection = connection
        self.cursor = connection.cursor()
        self.repository = constantRepo
        pass
    def fillWorker(self, countWorkers):
        employment_number = 1000
        # заполение сотрудника
        for i in range(countWorkers):
            addres = f'{random.choice(self.repository.city)}, {random.choice(self.repository.street)} {random.randint(1, 100)}, кв.{random.randint(1, 500)}'
            query = f'INSERT INTO Worker(employment_number, surname, name, lastname, birth_date,  passport, address, itn)'\
                    f' VALUES({employment_number},\'' \
                    f'{random.choice(self.repository.second_name_man)}\'' \
                    f',\'{random.choice(self.repository.first_name_man)}\',' \
                    f'\'{random.choice(self.repository.last_name_man)}\',' \
                    f'\'{random_date("1.1.1950", "1.1.2005", random.random())}\'' \
                    f',\'{str(random.randint(1000000000, 9999999999))}\'' \
                    f',\'{addres}\'' \
                    f',\'{str(random.randint(100000000000, 999999999999))}\')'
            employment_number += 1
            self.cursor.execute(query)
            self.connection .commit()

    def getCountWorker(self):
        self.cursor.execute("SELECT COUNT(*) FROM worker;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]