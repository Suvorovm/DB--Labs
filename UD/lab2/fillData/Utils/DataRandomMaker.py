import time
def random_date(start, end, prop):
    return str_time_prop(start, end, '%d.%m.%Y', prop)

def str_time_prop(start, end, format, prop):
    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))
    ptime = stime + prop * (etime - stime)
    return time.strftime(format, time.localtime(ptime))