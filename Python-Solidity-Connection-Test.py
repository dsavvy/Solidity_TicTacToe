
# install Web3 with command pip install web3 first
# set up infura api
from web3 import Web3, HTTPProvider
import json


infura_url = "https://sepolia.infura.io/v3/ae6ebad4a80b46299b5ea14e4d506af9"
contract_address = "0xC8B9a188E5840FFba434645F3F3E457f578433F1"
private_key = "6fc7e8886a758928643340a762dab4006bae5c92aace056c0a1846ae65f34287"



connection = Web3(HTTPProvider(infura_url))
tic_tac_toe_contract = connection.eth.contract(address=contract_address, abi=contract_abi)



# get latest ethereum block number through infura
print ("Latest Ethereum block number", connection.eth.block_number)
# import packages


contract_abi = json.load("abi.json")




# start game: As long as the game is running, our boolean game_active will be set to "True".
# ! Fetch this from inFura
game_active = True
# We save our current player as X. When we convert to solidity, we can keep this or switch it to an int value.
# Fetch this from InFura
current_player = 'X'



# This builds our board. We create an empty board that will then get filled. This is not a matrix, it is just an array! :)
# ! Fetch from InFura
board = [" "," "," "," "," "," "," "," "," "," "]


# Firstly, we define all of the functions that we are going to call. 
# Then we build a loop which represents the game Itself. In that, we call the functions one after the other.

# Definition: print board
# this puts our array in a graphical representation that is similar to a tic tac toe board you would have on paper.
def print_board():
    print (board[1] + "|" + board[2] + "|" + board[3] )
    print (board[4] + "|" + board[5] + "|" + board[6] )
    print (board[7] + "|" + board[8] + "|" + board[9] )
print_board()


# Definition: the current player selects a move
def player_move():
    # we fetch the variable and check if the game is still active
    global game_active
    while True:
        # we ask the player for input, in which field he would like to place his marker
        var_player_move = input("Select your move: ")
        try:
            var_player_move = int(var_player_move)
        # These are all error handling: The player cannot input a character, a number outside of 1-9 and also not if the space has already been occupied.
        except ValueError:
            print("Please enter a number between 1 and 9 to select your move")
        else:
            if var_player_move > 0 and var_player_move < 10:
                if board[var_player_move] == ' ':
                    return var_player_move
                else:
                    print("Selected move is already occupied. Please select another move.")
            else:
                print("Please enter a number between 1 and 9 to select your move")

#! Defition: This changes the player's turn. We need to run this in solidity and fetch it here.
def change_player():
    global current_player
    if current_player == 'X':
        current_player = 'O'
    else:
        current_player = 'X'

# Definition: We check if the player has won. First we check the rows, then the columns, and lastly the diagonals.
def winning_condition():
    for i in range(1, 10, 3):
        if board[i] == board[i+1] == board[i+2] != " ":
            return board[i]
    for i in range(1, 4):
        if board[i] == board[i+3] == board[i+6] != " ":
            return board[i]
    if board[1] == board[5] == board[9] != " " or board[3] == board[5] == board[7] != " ":
        return board[5]
        
# We check for a tie by checking if the board is full and the winning condition has not been met.
def tie_condition():
    return ' ' not in board[1:]



# loop while playing: 1. Print Board. 2. print turn of player. 3. Player Input. 4. Set current player's name in the selected field. 
# 5. Check winning condition. 6. Change player if it has not been met.
while game_active:
    print()
    print ("Turn of Player " + current_player)
    move = player_move()
    if move:
        board[move] = current_player
        # aktuelles board ausgeben
        print_board()
        # Kontrolle, ob jemand gewonnen hat
        won = winning_condition()
        if won:
            print ("player " + won + " has won!")
            # We just terminate the game. 
            game_active = False
            break
        # Check if tie
        tie = tie_condition()
        if tie:
            print ("Game has ended with a tie")
            game_active = False
        # Change player
        change_player()
print()
