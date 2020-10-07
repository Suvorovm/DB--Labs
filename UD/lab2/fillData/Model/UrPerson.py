import psycopg2
import random



class UrPerson(object):


    def __init__(self, connection, constantRepo):
        """Constructor"""
        self.connection = connection
        self.cursor = connection.cursor()
        self.repository = constantRepo
        pass
    def fillUrPerson(self):
        for i in range(len(self.repository.ur_name)):
            query = f'INSERT INTO UR_Person(itn,name_organization) values (\'{random.randint(1000000000, 9999999999)}\',\'{self.repository.ur_name[i]}\')'
            self.cursor.execute(query)
            self.connection.commit()

    def getCountUrPerson(self):
        self.cursor.execute("SELECT COUNT(*) FROM ur_person;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]