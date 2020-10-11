import random
from datetime import datetime, timedelta

from Model.Client import Client
from Model.Room import Room
from Model.Worker import Worker


class PurchaseService(object):
    def __init__(self, connection, constantRepo):
        """Constructor"""
        self.connection = connection
        self.cursor = connection.cursor()
        self.repository = constantRepo
        self.client = Client(connection, constantRepo)
        self.room = Room(connection, constantRepo)
        self.woker = Worker(connection, constantRepo)
        self.fillStatusContract()
        pass

    def fillStatusContract(self):
        for name in self.repository.status_contract:
            self.cursor.execute(f'INSERT INTO Status_contract(name) values (\'{name}\')')

        self.connection.commit()


    def fillBooking(self):
        countClient = self.client.getCountClients()
        countRooms= self.room.getCountRoom()
        countService = self.getServiceCount()
        notBooked = (list(range(1, countRooms)))
        notUsedClient = (list(range(1, countClient)))
        #TODO: Тут можно сделать более адаптивно и гибко
        for i in range(1, countRooms - 1):
            clintId = random.choice(notUsedClient)
            roomId = random.choice(notBooked)
            notBooked.remove(roomId)
            diffBooking = random.randint(15, 35)
            diffSeatl = random.randint(-14, 20)
            diffDeparture = random.randint(21, 60)
            bookingTime = datetime.now() - timedelta(days= diffBooking)
            settlementTime = bookingTime + timedelta(days= diffSeatl)
            departeTime = settlementTime + timedelta(days= diffDeparture)
            self.cursor.execute(
            'INSERT INTO Booking(settlement_time, departure_time, booking_time, id_room) values (%s,%s,%s,%s)', (settlementTime, departeTime, bookingTime, roomId))
            self.connection.commit()
            self.fillStatusBooking(i, settlementTime)
            self.fillOccupiedClient(i, clintId)
            self.fillContract(clintId, roomId, settlementTime, departeTime)
            self.fillBiltPosition( roomId, i)
            self.updateBookingContract(i)
            self.updateBiltPosition(i, roomId)

    def getCountBooking(self):
        self.cursor.execute("SELECT COUNT(*) FROM booking;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]

    def fillStatusBooking(self, bookingId, settlementTime):
        self.cursor.execute('INSERT INTO Status_booking(id_type_booking, time_operation) values (%s,%s)', (1, settlementTime))
        self.connection.commit()
        self.cursor.execute(
                'UPDATE  booking set id_status = %s where id_booking = %s ', (bookingId, bookingId))
        self.connection.commit()

    def fillOccupiedClient(self, idBooking, clintId):
        self.cursor.execute('INSERT INTO Occupied_client(id_client, id_booking) values (%s,%s)', (clintId , idBooking))
        self.connection.commit()
        pass

    def fillContract(self, clintId, roomId, settlementTime, departeTime):
        contractnumber = random.randint(11111111, 99999999)
        roomCost = self.getRoomCostById(roomId)
        countworker = self.woker.getCountWorker()
        self.cursor.execute('INSERT INTO Contract(contract_number, start_date, end_date, amount, id_status_contract, id_client, id_worker) '
                            'values (%s,%s,%s,%s,%s,%s,%s)',
                            (contractnumber, settlementTime, departeTime,roomCost + random.randint(150, 15564), 3, clintId, random.randint(1, countworker)))
        self.connection.commit()
        pass

    def getRoomCostById(self, roomId):
        self.cursor.execute("SELECT room_cost FROM Room where id_room = " + str(roomId))
        cost = self.cursor.fetchall()
        self.connection.commit()
        return cost[0][0]

    def fillBiltPosition(self, roomId, contractId):
        serviceCount = self.getServiceCount()
        self.cursor.execute('INSERT INTO Bilt_position(id_contract, id_disscount, id_room, id_service, with_discount) '
                            'values (%s,%s,%s,%s,%s)',
                            (contractId, 1, roomId, random.randint(1, serviceCount), self.getRoomCostById(roomId)))
        pass


    def getServiceCount(self):
        self.cursor.execute("SELECT COUNT(*) FROM Service;")
        rows = self.cursor.fetchall()
        self.connection.commit()
        return rows[0][0]

    def updateBookingContract(self, idBooking):
        self.cursor.execute(
            'UPDATE  booking set id_contract = %s where id_booking = %s ', (idBooking, idBooking))
        self.connection.commit()
        pass

    def updateBiltPosition(self, contractId, roomId):

        serviceCount = self.getServiceCount()
        self.cursor.execute('INSERT INTO Bilt_position(id_contract, id_disscount, id_service, with_discount) '
                            'values (%s,%s,%s ,%s)',
                            (contractId, 1,  random.randint(1, serviceCount), self.getRoomCostById(roomId)))
        self.connection.commit()
        pass
