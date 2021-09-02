# import urllib library
from urllib.request import urlopen

# from web3 import Web3
import json

from dotenv import load_dotenv
load_dotenv('../.env')

import os

NODE = os.getenv('node')
CONTRACT_ADDRESS = '0x95f7594Dc262bb6A969Aeb42E4D9E4BedA94FAa0' # os.getenv('address')
print (NODE)

response = urlopen('https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2021-09-02/meetings?jurisdiction=QLD')
data_json = json.loads(response.read())
  
# print the json response
print(data_json)

# w3 = Web3(Web3.WebsocketProvider(NODE))

# with open('./build/contracts/Horse.json') as json_file:
#   data = json.load(json_file)
#   abi=data['abi']
#   bytecode=data['bytecode']

#   # print(abi)

#   contract = w3.eth.contract(CONTRACT_ADDRESS, abi=abi)
#   count = contract.functions.count().call()
#   print (count)