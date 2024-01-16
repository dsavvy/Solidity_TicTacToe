connection = Web3(HTTPProvider('https://mainnet.infura.io/v3/ae6ebad4a80b46299b5ea14e4d506af9'))
print ("Latest Ethereum block number", connection.eth.blockNumber)
