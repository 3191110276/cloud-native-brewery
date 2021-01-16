from selenium.webdriver.chrome.options import Options
from kubernetes import client,config
from selenium import webdriver
import logging
import random
import base64
import time
import sys


logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    stream=sys.stdout,
    level=logging.INFO
)


def load_env_file(name):
    with open("/etc/customization/{}".format(name), "r") as f:
        return f.read()


try:
    logging.info('Trying to load Kubeconfig')
    config.load_kube_config()
except:
    logging.info('Kubeconfig could not be loaded, loading in-cluster Kubeconfig')
    config.load_incluster_config()
api_instance = client.CoreV1Api()
api_response = api_instance.read_namespaced_service(
    load_env_file("INGRESS_DNS"),
    load_env_file("INGRESS_NS")
)
host = api_response.spec.load_balancer_ip
logging.info('Fetched LoadBalancer IP: {}'.format(api_response.spec.load_balancer_ip))

run = 1

lagspike = False
lagspike_duration = 0


def generate_user_agent():
    user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
        "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25",
        "Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36",
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1",
        "Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
        "Mozilla/5.0 (Linux; Android 7.0; SM-G892A Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Mobile Safari/537.36",
        "Mozilla/5.0 (Linux; Android 7.0; SM-G930VC Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/58.0.3029.83 Mobile Safari/537.36",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/13.2b11866 Mobile/16A366 Safari/605.1.15",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
        "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.114 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    ]
    
    probability = [
        150,
        50,
        50,
        200,
        10,
        100,
        10,
        5,
        1,
        10,
        10,
        5,
        5,
        1,
        100,
        400
    ]
    
    return "--user-agent={}".format(random.choices(population=user_agents,weights=probability,k=1)[0])


def set_chrome_options():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
#    chrome_prefs = {}
#    chrome_options.experimental_options["prefs"] = chrome_prefs
#    chrome_prefs["profile.default_content_settings"] = {"images": 2}
    chrome_options.add_argument(generate_user_agent())

    return chrome_options


#countries = https://docs.appdynamics.com/display/PRO45/Browser+RUM+Countries+and+Regions+by+Geo+Dashboard
def get_env():
    loc_list = [
        {
            'country': "Algeria",
            'region': "Alger",
            'city': "Alger",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Argentina",
            'region': "Buenos Aires",
            'city': "Buenos Aires",
            'localIP': "1.1.1.1",
            'delay': 100
        },
        {
            'country': "Argentina",
            'region': "Tierra del Fuego",
            'city': "Tolhuin",
            'localIP': "1.1.1.1",
            'delay': 150
        },
        {
            'country': "Australia",
            'region': "New South Wales",
            'city': "Sydney",
            'localIP': "1.1.1.1",
            'delay': 200
        },
        {
            'country': "Australia",
            'region': "Victoria",
            'city': "Melbourne",
            'localIP': "1.1.1.1",
            'delay': 200
        },
        {
            'country': "Australia",
            'region': "Western Australia",
            'city': "Perth",
            'localIP': "1.1.1.1",
            'delay': 250
        },
        {
            'country': "Austria",
            'region': "Burgenland",
            'city': "Neusiedl am See",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Austria",
            'region': "Oberosterreich",
            'city': "Linz",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Austria",
            'region': "Salzburg",
            'city': "Salzburg",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Austria",
            'region': "Steiermark",
            'city': "Graz",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Austria",
            'region': "Tirol",
            'city': "Innsbruck",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Austria",
            'region': "Wien",
            'city': "Wien",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Azerbaijan",
            'region': "Astara",
            'city': "Astara",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Belarus",
            'region': "Minsk",
            'city': "Minsk",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Belgium",
            'region': "Antwerpen",
            'city': "Antwerpen",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Belgium",
            'region': "Brussels Hoofdstedelijk Gewest",
            'city': "Brussel",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Belgium",
            'region': "Liege",
            'city': "Liege",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Belgium",
            'region': "Oost-Vlaanderen",
            'city': "Ghent",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Belize",
            'region': "Belize",
            'city': "Caye Caulker",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Bolivia",
            'region': "La Paz",
            'city': "La Paz",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Bosnia and Herzegovina",
            'region': "Republika Srpska",
            'city': "Sarajevo",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Botswana",
            'region': "South-East",
            'city': "Gabrone",
            'localIP': "1.1.1.1",
            'delay': 60
        },
        {
            'country': "Bulgaria",
            'region': "Sofiya",
            'city': "Sofiya",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Brazil",
            'region': "Rio de Janeiro",
            'city': "Rio de Janeiro",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Brazil",
            'region': "Sao Paulo",
            'city': "Sao Paulo",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Cambodia",
            'region': "Phnum Penh",
            'city': "Phnum Penh",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Canada",
            'region': "Alberta",
            'city': "Calgary",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Canada",
            'region': "British Columbia",
            'city': "Vancouver",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Canada",
            'region': "Ontario",
            'city': "Toronto",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Canada",
            'region': "Quebec",
            'city': "Quebec City",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Chile",
            'region': "Valparaiso",
            'city': "Valparaiso",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "China",
            'region': "Beijing",
            'city': "Beijing",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Colombia",
            'region': "Bolivar Department",
            'city': "Cartagena",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Costa Rica",
            'region': "San Jose",
            'city': "San Jose",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Croatia",
            'region': "Grad Zagreb",
            'city': "Zagreb",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Czech Republic",
            'region': "Hlavni mesto Praha",
            'city': "Praha",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Czech Republic",
            'region': "Jihomoravsky kraj",
            'city': "Brno",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Czech Republic",
            'region': "Moravskoslezsky kraj",
            'city': "Ostrava",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Czech Republic",
            'region': "Zlinsky kraj",
            'city': "Zlin",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Denmark",
            'region': "Hovedstaden",
            'city': "Kobenhavn",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Denmark",
            'region': "Midtjylland",
            'city': "Aarhus",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Ecuador",
            'region': "Esmeraldas",
            'city': "Esmeraldas",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Egypt",
            'region': "Al Bahr al Ahmar",
            'city': "Hurghada",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "El Salvador",
            'region': "San Salvador",
            'city': "San Salvador",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Estonia",
            'region': "Tallinn",
            'city': "Tallinn",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Equatorial Guinea",
            'region': "Litoral",
            'city': "Bata",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Finland",
            'region': "Southern Finland",
            'city': "Helsinki",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "France",
            'region': "Bretagne",
            'city': "Brest",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "France",
            'region': "Ile-de-France",
            'city': "Paris",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Gabon",
            'region': "Estuaire",
            'city': "Libreville",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Georgia",
            'region': "T'bilisi",
            'city': "T'bilisi",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Germany",
            'region': "Baden-Wurttemberg",
            'city': "Stuttgart",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Germany",
            'region': "Bayern",
            'city': "Muenchen",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Germany",
            'region': "Berlin",
            'city': "Berlin",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Germany",
            'region': "Hamburg",
            'city': "Hamburg",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Germany",
            'region': "Hessen",
            'city': "Frankfurt",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Germany",
            'region': "Germany, NordrheinWestfalen",
            'city': "Duesseldorf",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Germany",
            'region': "NordrheinWestfalen",
            'city': "Koeln",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Germany",
            'region': "Sachsen",
            'city': "Dresden",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Greece",
            'region': "Kefallinia",
            'city': "Sami",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Guatemala",
            'region': "Guatemala",
            'city': "Guatemala",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Greece",
            'region': "Kikladhes",
            'city': "Mikonos",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Guyana",
            'region': "Demerara-Mahaica",
            'city': "Georgetown",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Honduras",
            'region': "Francisco Morazan",
            'city': "	Tegucigalpa",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Hungary",
            'region': "Budapest",
            'city': "Budapest",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Iceland",
            'region': "Vesturland",
            'city': "Akranes",
            'localIP': "1.1.1.1",
            'delay': 70
        }, 
        {
            'country': "India",
            'region': "Maharashtra",
            'city': "Mumbai",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Indonesia",
            'region': "Jakarta Raya",
            'city': "Jakarta",
            'localIP': "1.1.1.1",
            'delay': 40
        }, 
        {
            'country': "Ireland",
            'region': "Cork",
            'city': "Cork",
            'localIP': "1.1.1.1",
            'delay': 25
        }, 
        {
            'country': "Ireland",
            'region': "Dublin",
            'city': "Dublin",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Ireland",
            'region': "Galway",
            'city': "Galway",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Ireland",
            'region': "Limerick",
            'city': "Limerick",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Israel",
            'region': "Tel Aviv",
            'city': "Tel Aviv-Yafo",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Italy",
            'region': "Campania",
            'city': "Napoli",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Italy",
            'region': "Lombardia",
            'city': "Milano",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Japan",
            'region': "Kyoto",
            'city': "Kyoto",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Japan",
            'region': "Tokyo",
            'city': "Tokyo",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Kazakhstan",
            'region': "Almaty City",
            'city': "Almaty",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Korea, Republic of",
            'region': "Pusan-jikhalsi",
            'city': "Busan",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Korea, Republic of",
            'region': "Seoul Teukbyeolsi",
            'city': "Seoul",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Kyrgyzstan",
            'region': "Bishkek",
            'city': "Bishkek",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Latvia",
            'region': "Riga",
            'city': "Riga",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Lithuania",
            'region': "Vilniaus Apskritis",
            'city': "Vilniaus",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Malaysia",
            'region': "Kuala Lumpur",
            'city': "Kuala Lumpur",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Maldives",
            'region': "Maale",
            'city': "Male",
            'localIP': "1.1.1.1",
            'delay': 60
        },
        {
            'country': "Mexico",
            'region': "Baja California",
            'city': "Mexicali",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Mexico",
            'region': "Distrito Federal",
            'city': "Ciudad de Mexico",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Mexico",
            'region': "Quintana Roo",
            'city': "Cancun",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Mexico",
            'region': "Yucatan",
            'city': "Merida",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Mongolia",
            'region': "Ulaanbaatar",
            'city': "Ulaanbaatar",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Morocco",
            'region': "Grand Casablanca",
            'city': "Casablanca",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Myanmar",
            'region': "Yangon",
            'city': "Yangon",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Namibia",
            'region': "Windhoek",
            'city': "Windhoek",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Netherlands",
            'region': "Noord-Brabant",
            'city': "Eindhoven",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "Netherlands",
            'region': "Noord-Holland",
            'city': "Amsterdam",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "New Zealand",
            'region': "Auckland",
            'city': "Auckland",
            'localIP': "1.1.1.1",
            'delay': 250
        },
        {
            'country': "Nicaragua",
            'region': "Managua",
            'city': "Managua",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Norway",
            'region': "Hordaland",
            'city': "Bergen",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Norway",
            'region': "Oslo",
            'city': "Oslo",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Norway",
            'region': "Troms",
            'city': "Tromso",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Panama",
            'region': "Panama",
            'city': "Panama",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Papua New Guinea",
            'region': "Central",
            'city': "Port Moresby",
            'localIP': "1.1.1.1",
            'delay': 60
        },
        {
            'country': "Paraguay",
            'region': "Itapua",
            'city': "Encarnacion",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Philippines",
            'region': "Manila",
            'city': "Manila",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Peru",
            'region': "Lima",
            'city': "Lima",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Poland",
            'region': "Malopolskie",
            'city': "Krakow",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Poland",
            'region': "Mazowieckie",
            'city': "Warszawa",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Portugal",
            'region': "Lisboa",
            'city': "Lisboa",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Romania",
            'region': "Bucuresti",
            'city': "Bucuresti",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Russian Federation",
            'region': "Moskva",
            'city': "Moskva",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Russian Federation",
            'region': "Primorsky Krai",
            'city': "Vladivostok",
            'localIP': "1.1.1.1",
            'delay': 60
        },
        {
            'country': "Seychelles",
            'region': "Mont Fleuri",
            'city': "Mont Fleuri",
            'localIP': "1.1.1.1",
            'delay': 60
        },
        {
            'country': "Slovakia",
            'region': "Bratislava",
            'city': "Bratislava",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Slovenia",
            'region': "Ljubljana",
            'city': "Ljubljana",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "South Africa",
            'region': "Western Cape",
            'city': "Cape Town",
            'localIP': "1.1.1.1",
            'delay': 80
        },
        {
            'country': "Spain",
            'region': "Catalonia",
            'city': "Barcelona",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "Spain",
            'region': "Comunidad Valenciana",
            'city': "Valencia",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Spain",
            'region': "Madrid",
            'city': "Madrid",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Spain",
            'region': "Pais Vasco",
            'city': "Bilbao",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Sri Lanka",
            'region': "Colombo",
            'city': "Colombo",
            'localIP': "1.1.1.1",
            'delay': 50
        },
        {
            'country': "Sweden",
            'region': "Stockholms Lan",
            'city': "Stockholm",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Sweden",
            'region': "Uppsala Lan",
            'city': "Uppsala",
            'localIP': "1.1.1.1",
            'delay': 20
        },
        {
            'country': "Taiwan",
            'region': "T'ai-pei",
            'city': "Tʻai-pei",
            'localIP': "1.1.1.1",
            'delay': 40
        },
        {
            'country': "Thailand",
            'region': "Chon Buri",
            'city': "Laem Chabang",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Suriname",
            'region': "Paramaribo",
            'city': "Paramaribo",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Switzerland",
            'region': "Bern",
            'city': "Bern",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Switzerland",
            'region': "Geneve",
            'city': "Geneve",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Switzerland",
            'region': "Luzern",
            'city': "Luzern",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Switzerland",
            'region': "Zuerich",
            'city': "Zuerich",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "Turkey",
            'region': "Antalyag",
            'city': "Antalya",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Turkmenistan",
            'region': "Ahal",
            'city': "Ashgabat",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Ukraine",
            'region': "Kyyiv",
            'city': "Kyyiv",
            'localIP': "1.1.1.1",
            'delay': 40
        }, 
        {
            'country': "United Kingdom",
            'region': "Aberdeen City",
            'city': "Aberdeen",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "United Kingdom",
            'region': "Glasgow City",
            'city': "Glasgow",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "United Kingdom",
            'region': "Liverpool",
            'city': "Liverpool",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United Kingdom",
            'region': "London",
            'city': "London",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United Kingdom",
            'region': "Manchester",
            'city': "Manchester",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United States",
            'region': "California",
            'city': "Los Angeles",
            'localIP': "1.1.1.1",
            'delay': 5
        },
        {
            'country': "United States",
            'region': "California",
            'city': "San Diego",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "United States",
            'region': "California",
            'city': "San Francisco",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United States",
            'region': "California",
            'city': "San Jose",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United States",
            'region': "Minnesota",
            'city': "Minneapolis",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "United States",
            'region': "New York",
            'city': "New York",
            'localIP': "1.1.1.1",
            'delay': 0
        },
        {
            'country': "United States",
            'region': "Oregon",
            'city': "Portland",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "United States",
            'region': "Texas",
            'city': "Houston",
            'localIP': "1.1.1.1",
            'delay': 10
        },
        {
            'country': "United States",
            'region': "Washington",
            'city': "Seattle",
            'localIP': "1.1.1.1",
            'delay': 15
        },
        {
            'country': "Uruguay",
            'region': "Montevideo",
            'city': "Montevideo",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Uzbekistan",
            'region': "Toshkent",
            'city': "Toshkent",
            'localIP': "1.1.1.1",
            'delay': 25
        },
        {
            'country': "Vietnam",
            'region': "Da Nang",
            'city': "Da Nang",
            'localIP': "1.1.1.1",
            'delay': 15
        }
    ]
    
    return random.choice(loc_list)


def delay():
    global lagspike
    global lagspike_duration
    
    x = random.randint(0, 1000)
    
    if lagspike_duration == 0:
        lagspike = False
        
    delay = random.randint(10, 60)
    
    if x == 999:
        lagspike = True
        lagspike_duration = random.randint(10, 200)
    elif x > 980:
        delay = random.randint(800, 2000)
    elif x > 900:
        delay = random.randint(400, 1000)
    elif x > 800:
        delay = random.randint(80, 600)
    elif x > 700:
        delay = random.randint(40, 120)
    
    if lagspike:
        delay += random.randint(500, 1000)
        lagspike_duration -= 1
    
    return delay
    
    

def run_trafficgen():
    global host
    global run
    
    env = get_env()
    
    logging.info('Run {} - starting request for {}/{}'.format(
        run,
        env['country'],
        env['region']
    ))
    
    driver = webdriver.Chrome(options=set_chrome_options())
    
    latency = delay()+env['delay'] # additional latency (ms)
    download_throughput = random.randint(100, 500) * 1024
    upload_throughput = random.randint(100, 500) * 1024
    
    driver.set_network_conditions(
        offline=False,
        latency = latency,  
        download_throughput = download_throughput,
        upload_throughput = upload_throughput
    )
    
    logging.info('Setting network conditions: {} Down, {} Up, {}ms Latency'.format(
        download_throughput,
        upload_throughput,
        latency
    ))
    
    env_string = '{}+{}+{}+{}'.format(
        env['country'],
        env['region'],
        env['city'],
        env['localIP']
    )
    env_base64 = base64.b64encode(env_string.encode('ascii')).decode()
    
    logging.info('Created location string: {}'.format(env_string))
    
    logging.info('Loading web page')
    driver.get("http://{}?env={}".format(host, env_base64))
    
    time.sleep(random.randint(1500, 4000)/1000)

    logging.info('Locating input field')
    elem = driver.find_element_by_xpath("//*[@id=\"content\"]/div[1]/input")
    
    logging.info('Clearing input field')
    elem.clear()
    elem.send_keys(random.randint(1, 50))


    time.sleep(random.randint(1500, 4000)/1000)

    logging.info('Locating button')
    elem = driver.find_element_by_xpath("//*[@id=\"content\"]/div[1]/button")
    
    logging.info('Clicking button')
    elem.click();
    
    time.sleep(random.randint(14000, 16000)/1000)
    
    logging.info('Run {} - closing request'.format(run))
    run += 1

    driver.close()


time.sleep(random.randint(0, 8000)/1000)
for i in range(len(20)):
    try:
        run_trafficgen()
    except Exception as e:
        logging.warning('Encountered error while running request')
        logging.warning(e)