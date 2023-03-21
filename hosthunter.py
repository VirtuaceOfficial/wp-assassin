from bs4 import BeautifulSoup
import platform
import os
import socks
import httpagentparser
import gettext

target = open("iptarget.txt")
contents = target.read()

reqNum = input("Enter number of desired requests to send: \n")
for x in range(reqNum):
    from stem import Signal
    from stem.control import Controller
    from urllib.request import URLopener

def create_tor_session():
    session = requests.session()
    session.proxies = {'http:': 'socks5://127.0.0.1:9050',
                       'https': 'socks5://127.0.0.1:9050'}
    
    return session
session = create_tor_session()
print("\nYour IP: ")
print(session.get('https://api.ipify.org/').text)
print(requests.get('https://api.ipify.org/').text)

#try:
    #r = requests.get()