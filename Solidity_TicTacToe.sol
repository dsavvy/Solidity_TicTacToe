// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
 * @title TicTacToe
 * @dev A simple smart contract implementation of Tic Tac Toe
 * @custom:dev-run-script "contracts/artifacts/TicTacToe.json"
 */
contract TicTacToe {
    // Variable to check if the game is active.
    bool public gameActive = true;
    // Keep track of the Current Player
    string public currentPlayer = 'X';
    // Game board. We do not use the first spot to have [1-9] designated as the game board.
    string[10] public board = [" "," "," "," "," "," "," "," "," "," "];
    // Keep track of wins for each player.
    int public Xwins = 0;
    int public Owins = 0;

    // Export a printed Board in Tic-Tac-Toe formatting
    event PrintBoard(string boardRow1, string boardRow2, string boardRow3);
    // Unused. Would be to ask for the current turn.
    event PlayerMoveRequested();
    // Emit the move made back to the player.
    event PlayerMoveMade(string player, uint256 move);
    // Emit when someone has won a single game and show the score.
    event PlayerWon(string player, int Xwins, int Owins);
    // Emit if the Game ends tied.
    event GameTied();
    // Emit if a player has won three games.
    event EndsiegAchieved(string message);
    // Resets the game.
    event GameReset();

    // Reset the game: Clear board, activate board, Reset win counter.
    function ResetGame () external {
      emit GameReset();
      board = [" "," "," "," "," "," "," "," "," "," "];
      gameActive = true;
      Xwins = 0;
      Owins = 0;
    }

    // Print the board in Tic-Tac-Toe formatting.
    function printBoard() external {
        emit PrintBoard(
            string(abi.encodePacked(board[1], "|", board[2], "|", board[3])),
            string(abi.encodePacked(board[4], "|", board[5], "|", board[6])),
            string(abi.encodePacked(board[7], "|", board[8], "|", board[9]))
        );
    }
    // Internal function to print the board within another function. We didn't manage to call the external function internally,
    // although some sources suggest it. 
      function printBoardint() internal {
        emit PrintBoard(
            string(abi.encodePacked(board[1], "|", board[2], "|", board[3])),
            string(abi.encodePacked(board[4], "|", board[5], "|", board[6])),
            string(abi.encodePacked(board[7], "|", board[8], "|", board[9]))
        );
    }
    // Function unused as of presentation.
    function requestPlayerMove() external {
        emit PlayerMoveRequested();
    }
    // Get the player move, input it, and check for the winning condition after the turn. 
    // Main function of the game.
    function makePlayerMove(uint256 move) external {
        // Confirm the game is active.
        require(gameActive, "Game is not active");
        // Check whether the player made an correct integer input.
        // It is not possible to through a specific error message for String input - the transaction will simply fail :(
        require(move >= 1 && move <= 9, "Invalid move. Please enter a number between 1 and 9.");
        require(bytes(board[move])[0] == bytes(" ")[0], "Selected move is already occupied. Please select another move.");

        // Insert the move made into the board and emit.
        board[move] = currentPlayer;
        emit PlayerMoveMade(currentPlayer, move);

        // Check winning condition by calling the function.
        if (checkWinningCondition()) {
          if (keccak256(abi.encodePacked(currentPlayer)) == keccak256(abi.encodePacked('X'))) {
                Xwins = Xwins+1;
                emit PlayerWon(currentPlayer, Xwins, Owins);
                board = [" "," "," "," "," "," "," "," "," "," "];
            }
          else {
                Owins = Owins+1;
                emit PlayerWon(currentPlayer, Xwins, Owins);
                board = [" "," "," "," "," "," "," "," "," "," "];
            }
        }
        // Check Tie Condition by calling the function.
         else if (checkTieCondition()) {
            emit GameTied();
            board = [" "," "," "," "," "," "," "," "," "," "];
         }
            
        else {
            // Change player
            changePlayer();
        }
        // Check Endsieg status to End all games. 
        if (Xwins == 3) {
        gameActive = false;
        emit EndsiegAchieved("Player X has won the Best-of-Five");
        }
        else if (Owins == 3) {
        gameActive = false;
        emit EndsiegAchieved("Player O has won the Best-of-Five");
        }
        else {
        return printBoardint();
        }
    }

    // Changes player: Check if X is the player -> Yes: Switch to O -> No: Switch to X.
    function changePlayer() internal {
        bytes memory x = bytes("X");
        bytes memory o = bytes("O");
        currentPlayer = keccak256(bytes(currentPlayer)) == keccak256(x) ? string(o) : string(x);
    }

    //Check the Winning Condition
    function checkWinningCondition() internal view returns (bool) {
        // Check each Row: 1-3/4-6/7-9
        // We verify if the length == 1 (X/O/empty) [kind of unneccessary but eh], if the fields match each other and if they are not " "(empty) 
        for (uint i = 1; i < 10; i += 3) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(board[i+1])[0] && bytes(board[i])[0] == bytes(board[i+2])[0] && bytes(board[i])[0] != bytes(" ")[0]) {
                return true;
            }
        }
        // Check each Column: 1/4/7, 2/5,8, 3/6/9
        // We verify if the length == 1 (X/O/empty) [kind of unneccessary but eh], if the fields match each other and if they are not " "(empty) 
        for (uint i = 1; i < 4; i++) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(board[i+3])[0] && bytes(board[i])[0] == bytes(board[i+6])[0] && bytes(board[i])[0] != bytes(" ")[0]) {
                return true;
            }
        }
        // Check both diagonals: 1/5/9, 3/5/7
        if ((bytes(board[1]).length == 1 && bytes(board[1])[0] == bytes(board[5])[0] && bytes(board[1])[0] == bytes(board[9])[0] &&
            bytes(board[5])[0] != bytes(" ")[0]) ||
            (bytes(board[3]).length == 1 && bytes(board[3])[0] == bytes(board[5])[0] && bytes(board[3])[0] == bytes(board[7])[0]) &&
            bytes(board[5])[0] != bytes(" ")[0]) {
            return true;
        }
        else {
        // no winner yet!
        return false;
        }
    }

    // Check Tie Function
    function checkTieCondition() internal view returns (bool) {
        // Check for every field in the array [1-9] if it is length==1, and still " ". If there is still an empty field, return false. 
        // We dont check if the game can theoretically still be won, we wait for it to be full.
        for (uint i = 1; i <= 9; i++) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(" ")[0]) {
                return false;
            }
        }
        return true;
    }
}