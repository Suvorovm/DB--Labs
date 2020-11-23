import math

import psycopg2
import psycopg2.extras


class RepositoryDataFiller(object):
    dict_quarter = {}

    def selectRightData(self, date):
        year = str(date.year)
        self.repositoryCursor.execute(f"SELECT year_id from repository_hotel.repo_hotel.year where \"year_name\" = \'{year}\'")
        year = self.repositoryCursor.fetchone()
        year_id = year["year_id"]
        month = date.month
        self.repositoryCursor.execute(f"SELECT half_year_id from repository_hotel.repo_hotel.halfyear where \"year_id\"= {year_id}")
        halfYear = self.repositoryCursor.fetchall()
        halfYear_id = 0
        if month < 6:
            halfYear_id = halfYear[0]["half_year_id"]
        else:
            halfYear_id = halfYear[1]["half_year_id"]

        self.repositoryCursor.execute(f"SELECT quarter_id from repository_hotel.repo_hotel.quarter where \"half_year_id\" = {halfYear_id}")
        quarter = self.repositoryCursor.fetchall()

        quarterNumber = math.ceil(month / 3)
        resultQuarter = 0
        if quarterNumber == 1:
            resultQuarter = quarter[0]["quarter_id"]
        elif quarterNumber == 2:
            resultQuarter = quarter[1]["quarter_id"]
        elif quarterNumber == 3:
            resultQuarter = quarter[0]["quarter_id"]
        else:
            resultQuarter = quarter[1]["quarter_id"]
        self.connectionRepository.commit()
        return resultQuarter

    def fillSaleFactTable(self, amount, id_worker, id_room, id_client, id_status_contract, end_date):
        idQuarter = self.selectRightData(end_date)
        query = "INSERT into repository_hotel.repo_hotel.sale_fact(\"sum\", \"sum_with_out_nds\", \"staff_id\", \"quarter_id\", \"room_id\",  \"client_id\", \"status_contract_id\") " \
                "VALUES(%s, %s, %s, %s, %s, %s, %s)"
        self.repositoryCursor.execute(query, (amount, (amount - (amount / 100) * 18), id_worker, idQuarter, id_room, id_client, id_status_contract))
        self.connectionRepository.commit()

    def getCountBookingForClient(self, clientId, roomId):
        query = """select  count(*) as count_records from booking
    inner join occupied_client oc on booking.id_booking = oc.id_booking
    inner join client c on c.id_client = oc.id_client

    inner join booking b on b.id_booking = oc.id_booking
    inner join room r on r.id_room = booking.id_room
    where c.id_client = %s and r.id_room = %s"""
        self.hotellDbCursor.execute(query, (clientId, roomId))
        resultCount = self.hotellDbCursor.fetchone()
        return resultCount["count_records"]


    def fillBooking(self):
        querySelect = """select * from booking
    inner join room on booking.id_room = room.id_room
    inner join status_booking sb on sb.id_status = booking.id_status
    inner join type_booking tb on tb.id_type_booking = sb.id_type_booking
    inner join contract c on c.id_contract = booking.id_contract
    inner join client cli on cli.id_client = c.id_client"""
        self.hotellDbCursor.execute(querySelect)
        bookings = self.hotellDbCursor.fetchall()
        inserQuery = """INSERT INTO repository_hotel.repo_hotel.booking(\"quarter_id\", \"id_status_booking\", \"room_id\", \"count_booking\", \"client_id\") 
            values(%s,%s,%s,%s,%s)
        """
        for booking in bookings:
            idQuarter = self.selectRightData(booking["end_date"])
            idClient = booking["id_client"]
            roomId = booking["id_room"]
            bookingType = booking["id_type_booking"]
            countBooking = self.getCountBookingForClient(idClient, roomId)
            self.repositoryCursor.execute(inserQuery, (idQuarter, bookingType, roomId, countBooking, idClient))
        self.connectionRepository.commit()

    def fillSaleFact(self):
        query = """select * from contract
    inner join client c on c.id_client = contract.id_client
    inner join worker w on w.id_worker = contract.id_worker
    inner join status_contract sc on contract.id_status_contract = sc.id_status_contract
    inner join bilt_position bp on contract.id_contract = bp.id_contract
    inner join room r on r.id_room = bp.id_room
    inner join build b on r.id_build = b.id_build
    inner join category_room cr on cr.id_category_room = r.id_category_room
       WHERE sc.id_status_contract = 1 or sc.id_status_contract = 2"""
        self.hotellDbCursor.execute(query)
        for row in self.hotellDbCursor.fetchall():
            self.fillSaleFactTable(row['amount'], row["id_worker"], row["id_room"], row["id_client"],
                                   row["id_status_contract"], row["end_date"])

    def fillQuarters(self, idFirstHalf, idSecondHalf):
        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.Quarter(\"half_year_id\", \"quarter_name\") '
                                'values (%s,%s)', (idFirstHalf, "Первй квартал"))
        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.Quarter(\"half_year_id\", \"quarter_name\") '
                                'values (%s,%s)', (idFirstHalf, "Второй квартал"))
        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.Quarter(\"half_year_id\",\"quarter_name\") '
                                'values (%s,%s)', (idSecondHalf, "Третий квартал"))
        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.Quarter(\"half_year_id\", \"quarter_name\") '
                                'values (%s,%s)', (idSecondHalf, "Четвертый квартал"))
        self.connectionRepository.commit()
        pass

    def fillHalfYear(self, idYear):
        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.halfyear(\"year_id\", \"half_year\") '
                                'values (%s,%s) returning half_year_id',
                                      (idYear, "Первое полугодие"))
        idFirstHalfYear = self.repositoryCursor.fetchone()

        self.repositoryCursor.execute('INSERT INTO repository_hotel.repo_hotel.halfyear(\"year_id\", \"half_year\") '
                                'values (%s,%s) returning half_year_id',
                                      (idYear, "Второе полугодие"))
        idSecondHalfYear = self.repositoryCursor.fetchone()
        self.fillQuarters(idFirstHalfYear["half_year_id"], idSecondHalfYear["half_year_id"])
        pass

    def fillDate(self):
        query = "select DISTINCT   EXTRACT(YEAR FROM  end_date) from contract;"
        self.hotellDbCursor.execute(query)
        date = self.hotellDbCursor.fetchall()#["date_part"]
        for dateItem in date:
            query = """INSERT INTO repository_hotel.repo_hotel.year("year_name") """ + f' values (\'{str(int(dateItem["date_part"]))}\')'' returning year_id'
            self.repositoryCursor.execute(query)
            self.connectionRepository.commit()
            idYear = self.repositoryCursor.fetchone()["year_id"]
            self.fillHalfYear(idYear)

    def fillRoom(self):
        query = """
            select * from room
                inner join category_room cr on cr.id_category_room = room.id_category_room
                inner join build b on b.id_build = room.id_build; """
        self.hotellDbCursor.execute(query)
        rooms = self.hotellDbCursor.fetchall()
        for room in rooms:
            q = "INSERT INTO repository_hotel.repo_hotel.room(\"cost\", \"name_room\", \"build_id\", \"category_id\") values(%s, %s, %s, %s)"
            self.repositoryCursor.execute(q, (room["room_cost"], room["name"], room["id_build"], room["id_category_room"]))
        self.connectionRepository.commit()

    def fillServiceFact(self):
        query = """
            select * from bilt_position
                inner join contract c on c.id_contract = bilt_position.id_contract
                inner join service s on s.id_service = bilt_position.id_service
                inner join client cli on cli.id_client = c.id_client
                where c.id_status_contract = 1 or c.id_status_contract = 2;"""
        self.hotellDbCursor.execute(query)
        services = self.hotellDbCursor.fetchall()
        insertQuery = """INSERT INTO repository_hotel.repo_hotel.service_fact(\"quarter_id\", \"sum_cost\", \"cost_with_out_nds\", \"type_service_id\", \"client_id\")
                            values (%s, %s, %s, %s, %s)                   
                        """
        for service in services:

            quarterId = self.selectRightData(service["end_date"])

            cost = service["service_cost"]
            costWithOutNds = cost - ((cost / 100) * 18)
            self.repositoryCursor.execute(insertQuery, (quarterId, cost, costWithOutNds, service["id_service"], service["id_client"]))
        self.connectionRepository.commit()

    def main(self):
        connectionRepositoryDb = psycopg2.connect(dbname='repository_hotel', user='root',
                                                  password='root', host='localhost')

        connHotellDb = psycopg2.connect(dbname='postgres', user='root',
                                      password='root', host='localhost')
        self.hotellDbCursor = connHotellDb.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        self.repositoryCursor = connectionRepositoryDb.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        self.connectionHotel = connHotellDb
        self.connectionRepository = connectionRepositoryDb
        self.fillDate()
        self.fillRoom()
        self.fillSaleFact()
        self.fillServiceFact()
        self.fillBooking()

        connectionRepositoryDb.close()
        connHotellDb.close()
        exit(1)






repository = RepositoryDataFiller()
repository.main()
