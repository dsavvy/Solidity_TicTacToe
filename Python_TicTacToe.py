# import packages


# connect to infura



# build board
board = [" ","1","2","3","4","5","6","7","8","9"]

# print board
def print_board():
    print (board[1] + "|" + board[2] + "|" + board[3] )
    print (board[4] + "|" + board[5] + "|" + board[6] )
    print (board[7] + "|" + board[8] + "|" + board[9] )
print_board()

# make move
player_move = input("Select your move: ")
player_move = int(player_move)


def player_move():
    while True:
        player_move = input("Select your move: ")
        try:
            player_move = int(spielzug)
        except ValueError:
            print("Please enter a number between 1 and 9 to select your move")
        else:
            if player_move > 0 and player_move < 10:
                return player_move
            else:
                print("Number must be between 1 and 9 to match the board")
turn = player_move()
print("player's move: " + str(player_move))
