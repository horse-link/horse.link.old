from web3 import Web3
import json

from dotenv import load_dotenv
load_dotenv('../.env')

import os

NODE = os.getenv('node')
CONTRACT_ADDRESS = '0x95f7594Dc262bb6A969Aeb42E4D9E4BedA94FAa0' # os.getenv('address')
print (NODE)

w3 = Web3(Web3.WebsocketProvider(NODE))

with open('./build/contracts/Horse.json') as json_file:
  data = json.load(json_file)
  abi=data['abi']
  bytecode=data['bytecode']

  # print(abi)

  contract = w3.eth.contract(CONTRACT_ADDRESS, abi=abi)
  count = contract.functions.count().call()
  print (count)