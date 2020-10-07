import psycopg2
import random

from Utils.DataRandomMaker import random_date


class Room(object):

    def __init__(self, connection, constantRepo):
        """Constructor"""
        self.connection = connection
        self.cursor = connection.cursor()
        self.repository = constantRepo
        pass
    def fillRoomsAndCategory(self, countRooms):
        self.fillCategoryRoom()
        self.fillRoom(countRooms)
    def fillRoom(self, countRows):
        countBuilding = self.getCountBuilding()
        countCategoryRoom = self.getCountCategoryRoom()
        counter = 1
        for i in range(0, countRows):
            self.cursor.execute('INSERT INTO Room(id_category_room, floor_lvl,room_number, room_cost, id_Build ) values (%s,%s,%s,%s,%s)',
                                (
                                 random.randint(1, countCategoryRoom),
                                 random.randint(1, 4),
                                 counter,
                                 random.randint(1600, 10000),
                                 random.randint(1, countBuilding),
                                 ))
            counter += 1
            self.connection.commit()


    def fillCategoryRoom(self):
        for i in range(0, len(self.repository.category_room_name)):
            self.cursor.execute('INSERT INTO Category_room(name,beds_count) values (%s,%s)', (random.choice(self.repository.category_room_name), random.randint(1,4)))
            self.connection.commit()

    def getCountRoom(self):
        self.cursor.execute("SELECT COUNT(*) FROM Room;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]

    def getCountCategoryRoom(self):
        self.cursor.execute("SELECT COUNT(*) FROM Category_room;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]
    #эта функйия должан быть не тут
    def getCountBuilding(self):
        self.cursor.execute("SELECT COUNT(*) FROM Build;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]
