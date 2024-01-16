
# install Web3 with command pip install web3 first
# set up infura api
from web3 import Web3, HTTPProvider
connection = Web3(HTTPProvider('https://goerli.infura.io/v3/ae6ebad4a80b46299b5ea14e4d506af9'))


# get latest ethereum block number through infura
print ("Latest Ethereum block number", connection.eth.block_number)

