import psycopg2


class RepositoryDataFiller(object):

    def fillQuarters(self, idFirstHalf, idSecondHalf):
        self.repository.execute('INSERT INTO Quarter(half_year_id, quarter_name) '
                                'values (%s,%s)', (idFirstHalf, "Первй квартал"))
        self.repository.execute('INSERT INTO Quarter(half_year_id, quarter_name) '
                                'values (%s,%s)', (idFirstHalf, "Второй квартал"))
        self.repository.execute('INSERT INTO Quarter(half_year_id, quarter_name) '
                                'values (%s,%s)', (idSecondHalf, "Третий квартал"))
        self.repository.execute('INSERT INTO Quarter(half_year_id, quarter_name) '
                                'values (%s,%s)', (idSecondHalf, "Четвертый квартал"))
        pass

    def fillHalfYear(self, idYear):
        self.repository.execute('INSERT INTO halfyear(year_id, half_year) '
                                'values (%s,%s)',
                                (idYear, "Первое полугодие"))
        idFirstHalfYear = self.repository.fetchone()[0]

        self.repository.execute('INSERT INTO halfyear(year_id, half_year) '
                                'values (%s,%s)',
                                (idYear, "Второе полугодие"))
        idSecondHalfYear = self.repository.fetchone()[0]
        self.fillQuarters(idFirstHalfYear, idSecondHalfYear)
        pass

    def fillDate(self):
        query = "select DISTINCT   EXTRACT(YEAR FROM  start_date) from contract;"
        self.hotell.execute(query)
        date = self.hotell.fetchone()[0]
        query = f'INSERT INTO Year(year_name) values (\'{date}\')'
        self.repository.execute(query)
        idYear = self.repository.fetchone()[0]
        self.fillHalfYear(idYear)

    def main(self):
        connectionRepositoryDb = psycopg2.connect(dbname='repository_hotel', user='root',
                                                  password='root', host='localhost')

        connHotell = psycopg2.connect(dbname='postgres', user='root',
                                      password='root', host='localhost')
        self.hotell = connHotell.cursor()
        self.repository = connectionRepositoryDb.cursor()

repository = RepositoryDataFiller()
repository.main()