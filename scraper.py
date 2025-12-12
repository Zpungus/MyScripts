#!/usr/bin/python3
import lxml.html
import requests

page = requests.get('http://localhost:2222/sites/NSC-Contacts.html')
tree = lxml.html.fromstring(page.content)

query = tree.xpath('//td[@class=""]/text()')

print ('Match: ',query)
