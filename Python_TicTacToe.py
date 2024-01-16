# import packages
from web3 import Web3, HTTPProvider

# connect to infura

connection = Web3(HTTPProvider('https://mainnet.infura.io/v3/ae6ebad4a80b46299b5ea14e4d506af9'))
print ("Latest Ethereum block number", connection.eth.blockNumber)


# start game
# ! Fetch this from inFura
game_active = True
# Fetch this from InFura
current_player = 'X'



# build board
# ! Fetch from InFura
board = [" "," "," "," "," "," "," "," "," "," "]


# print board
def print_board():
    print (board[1] + "|" + board[2] + "|" + board[3] )
    print (board[4] + "|" + board[5] + "|" + board[6] )
    print (board[7] + "|" + board[8] + "|" + board[9] )
print_board()


# player selects a move
def player_move():
    global game_active
    while True:
        var_player_move = input("Select your move: ")
        try:
            var_player_move = int(var_player_move)
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
                
def change_player():
    global current_player
    if current_player == 'X':
        current_player = 'O'
    else:
        current_player = 'X'

def winning_condition():
    # wenn alle 3 Felder gleich sind, hat der entsprechende player gewonnen
    # Kontrolle auf Reihen
    for i in range(1, 10, 3):
        if board[i] == board[i+1] == board[i+2] != " ":
            return board[i]
    for i in range(1, 4):
        if board[i] == board[i+3] == board[i+6] != " ":
            return board[i]
    if board[1] == board[5] == board[9] != " " or board[3] == board[5] == board[7] != " ":
        return board[5]
        

def tie_condition():
    return ' ' not in board[1:]
# move is being sent to infura
#[]


# loop while playing
print_board()
while game_active:
    # Eingabe des aktiven players
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
            game_active = False
            break
        # Check if tie
        tie = tie_condition()
        if tie:
            print ("Game has ended with a tie")
            game_active = False
        # player wechseln
        change_player()
print()
