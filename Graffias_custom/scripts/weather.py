from geopy.geocoders import Nominatim
from config import API_KEY
import geocoder
import requests
import json
import pymorphy2
import urllib
import time
import logging


logger = logging.getLogger('weather_script')
logger.setLevel(logging.INFO)
fh = logging.FileHandler('~/.config/conky/Graffias/weather.log', mode='w')
fh.setLevel(logging.INFO)
logger.addHandler(fh)
logger.info('Started script')


def check_internet():
    works = False
    for _ in range(10):
        try:
            urllib.request.urlopen("http://google.com")
            works = True
        except IOError:
            time.sleep(3)
            works = False
        if works:
            break
    if works:
        return 'Connected succesfully'
    return 'Something wrong'


trans = {'clear': 'ясно',
         'partly-cloudy': 'малооблачно',
         'cloudy': 'облачно с прояснениями',
         'overcast': 'пасмурно',
         'drizzle': 'морось',
         'light-rain': 'небольшой дождь',
         'rain': 'дождь',
         'moderate-rain': 'умеренно сильный дождь',
         'heavy-rain': 'сильный дождь',
         'continuous-heavy-rain': 'длительный сильный дождь',
         'showers': 'ливень',
         'wet-snow': 'дождь со снегом',
         'light-snow': 'небольшой снег',
         'snow': 'снег',
         'snow-showers': 'снегопад',
         'hail': 'град',
         'thunderstorm': 'гроза',
         'thunderstorm-with-rain': 'дождь с грозой',
         'thunderstorm-with-hail': 'гроза с градом'}


# Проверяем подключение к интернету
logger.info('Checking internet')
con = check_internet()
logger.info(con)
# Получаем текущий город по ip
Latitude, Longitude = None, None
location = None
try:
    g = geocoder.ip('me')
    Latitude, Longitude = g.latlng
    geolocator = Nominatim(user_agent="geoapiExercises")
    location = geolocator.reverse(
        str(Latitude) + "," + str(Longitude), language='ru')
except:
    Latitude, Longitude = 55.7522, 37.6156
logger.info(f'Got location: {location.raw}')
# Получаем погоду
url = f'https://api.weather.yandex.ru/v2/informers?lat={str(Latitude)}&lon={str(Longitude)}&[lang=ru_RU]'
req = requests.get(url=url, headers={'X-Yandex-API-Key': API_KEY})
dct = req.json()['fact']
logger.info(f'Got weather: {dct}')

# Изменяем падеж города
try:
    morph = pymorphy2.MorphAnalyzer()
    dct['name'] = ' '.join([morph.parse(x)[0].inflect(
        {'loct'}).word.title() for x in location.raw['address']['city'].split()])
except Exception as e:
    logger.critical(e, exc_info=True)
    try:
        morph = pymorphy2.MorphAnalyzer()
        dct['name'] = ' '.join([morph.parse(x)[0].inflect(
            {'loct'}).word.title() for x in location.raw['address']['town'].split()])
    except Exception as e:
        logger.critical(e, exc_info=True)
        morph = pymorphy2.MorphAnalyzer()
        dct['name'] = ' '.join([morph.parse(x)[0].inflect(
            {'loct'}).word.title() for x in location.raw['address']['region'].split()])

# Меняем погодные условия на русский
dct['condition'] = trans[dct['condition']]

# Сбрасываем json в файл
with open('weather.json', 'w') as f:
    json.dump(dct, f)
logger.info(f'All good!')
