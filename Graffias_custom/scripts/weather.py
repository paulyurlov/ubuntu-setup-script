from geopy.geocoders import Nominatim
from config import API_KEY
import geocoder
import requests
import json
import pymorphy2


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

# Получаем текущий город по ip
g = geocoder.ip('me')
Latitude, Longitude = g.latlng
geolocator = Nominatim(user_agent="geoapiExercises")
location = geolocator.reverse(
    str(Latitude) + "," + str(Longitude), language='ru')

# Получаем погоду
url = f'https://api.weather.yandex.ru/v2/informers?lat={str(Latitude)}&lon={str(Longitude)}&[lang=ru_RU]'
req = requests.get(url=url, headers={'X-Yandex-API-Key': API_KEY})
dct = req.json()['fact']

# Изменяем падеж города
morph = pymorphy2.MorphAnalyzer()
dct['name'] = ' '.join([morph.parse(x)[0].inflect(
    {'loct'}).word.title() for x in location.raw['address']['city'].split()])

# Меняем погодные условия на русский
dct['condition'] = trans[dct['condition']]

# Сбрасываем json в файл
with open('weather.json', 'w') as f:
    json.dump(dct, f)
