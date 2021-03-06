class ConstantRepository(object):
    first_name_man = (
        'Халим', 'Максим', 'Ильяс', 'Андрей', 'Святослав', 'Никита', 'Петр', 'Георгий', 'Руслан', 'Денис', 'Михаил',
        'Рустам',
        'Дмитрий', 'Егор', 'Кирилл', 'Валерий', 'Александр', 'Сергей', 'Иван', 'Виктор', 'Юрий', 'Игорь')
    second_name_man = (
        'Лысенко', 'Гаврилов', 'Данилов', 'Красовский', 'Дюжев', 'Макаров', 'Сидоров', 'Сенченко', 'Попов', 'Земнухов',
        'Иванов', 'Петров', 'Орлушин', 'Чистяков', 'Русин', 'Хамзин', 'Суворов', 'Хусаинов', 'Пантелеев', 'Данилов',
        'Назаров',
        'Назаркин', 'Мельников', 'Макаров', 'Якомазов', 'Луба', 'Кулишов', 'Беляков')
    last_name_man = (
        'Халимович', 'Максимович', 'Ильясович', 'Андреевич', 'Святославович', 'Никитич', 'Георгиевич', 'Русланович',
        'Денисович', 'Михайлович', 'Рустамович', 'Дмитриевич', 'Егорович', 'Кириллович', 'Валерьевич', 'Александрович',
        'Сергеевич', 'Иванович', 'Викторович', 'Юрьевич', 'Игоревич')

    count_id = 1

    street = (
        'ул.Московская ', 'ул.Дмитриевская', 'пр.Победы ', 'пр.Строителей', 'ул.Ладожская', 'ул.Циолковского',
        'ул.Водонаева ',
        'ул.Октябрьская', 'ул.Ленина', 'ул.Сталинская', 'площадь Рефолюции', 'ул.Дачная', 'ул.Радужная', 'ул.Сиреневая',
        'ул.Хорошая', 'ул.Виражная', 'ул.Гагарина')
    city = (
        'г.Москва', 'г.Пенза', 'г.Воронеж', 'г.Санкт-Петербург', 'г.Витебск', 'г.Казань', 'г.Сочи', 'г.Иваново',
        'г.Мурманск',
        'г.Волгоград', 'г.Ростов', 'г.Кузнецк', 'г.Сургут', 'г.Анадырь')
    ur_name = ['Не юр.лицо', 'Тинькофф', 'Microsoft', 'Apple', 'YouTube', 'Mailru', 'Газпром', 'Лукойл', 'Роснефть',
               'ИнтерЭйр', 'Tortuga', 'Codeinside', 'Vigrom', 'OpenSolutions', 'Bitgames', 'Лейхтрум', 'Молескинес',
               'Пож-центр', 'Intel', 'AMD', 'Foxconn', 'Qualcomm', 'Finmax', 'PickPoint', 'Ponyexpress', 'Почта России',
               'Aliexpress']
    category_room_name = [
        "Семейная",
        "Холостятска",
        "Все включено",
        "Мечта"
    ]

    status_contract = ["Расторгнут", "Истек", "Активен"]
    def __init__(self):
        pass