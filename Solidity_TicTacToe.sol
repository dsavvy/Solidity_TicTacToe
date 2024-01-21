// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
 * @title TicTacToe
 * @dev A simple smart contract implementation of Tic Tac Toe
 * @custom:dev-run-script "contracts/artifacts/TicTacToe.json"
 */
contract TicTacToe {
    bool public gameActive = true;
    string public currentPlayer = 'X';
    string[10] public board = [" "," "," "," "," "," "," "," "," "," "];
    int public Xwins = 0;
    int public Owins = 0;

    event PrintBoard(string boardRow1, string boardRow2, string boardRow3);
    event PlayerMoveRequested();
    event PlayerMoveMade(string player, uint256 move);
    event PlayerWon(string player, int Xwins, int Owins);
    event GameTied();

    function printBoard() external {
        emit PrintBoard(
            string(abi.encodePacked(board[1], "|", board[2], "|", board[3])),
            string(abi.encodePacked(board[4], "|", board[5], "|", board[6])),
            string(abi.encodePacked(board[7], "|", board[8], "|", board[9]))
        );
    }

    function requestPlayerMove() external {
        emit PlayerMoveRequested();
    }

    function makePlayerMove(uint256 move) external {
        require(gameActive, "Game is not active");
        require(move >= 1 && move <= 9, "Invalid move. Please enter a number between 1 and 9.");

        require(bytes(board[move])[0] == bytes(" ")[0], "Selected move is already occupied. Please select another move.");

        board[move] = currentPlayer;
        emit PlayerMoveMade(currentPlayer, move);

        // Check winning condition
        if (checkWinningCondition()) {
            if (keccak256(abi.encodePacked(currentPlayer)) == keccak256(abi.encodePacked('X'))) {
                Xwins = Xwins+1;
            }
            else {
                Owins = Owins+1;
            }
            emit PlayerWon(currentPlayer, Xwins, Owins);
            board = [" "," "," "," "," "," "," "," "," "," "];
        } else if (checkTieCondition()) {
            emit GameTied();
            board = [" "," "," "," "," "," "," "," "," "," "];
            
        } else {
            // Change player
            changePlayer();
        }
    }

    function changePlayer() internal {
        bytes memory x = bytes("X");
        bytes memory o = bytes("O");
        currentPlayer = keccak256(bytes(currentPlayer)) == keccak256(x) ? string(o) : string(x);
    }

    function checkWinningCondition() internal view returns (bool) {
        for (uint i = 1; i < 10; i += 3) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(board[i+1])[0] && bytes(board[i])[0] == bytes(board[i+2])[0] && bytes(board[i])[0] != bytes(" ")[0]) {
                return true;
            }
        }
        for (uint i = 1; i < 4; i++) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(board[i+3])[0] && bytes(board[i])[0] == bytes(board[i+6])[0] && bytes(board[i])[0] != bytes(" ")[0]) {
                return true;
            }
        }
        if ((bytes(board[1]).length == 1 && bytes(board[1])[0] == bytes(board[5])[0] && bytes(board[1])[0] == bytes(board[9])[0] &&
            bytes(board[5])[0] != bytes(" ")[0]) ||
            (bytes(board[3]).length == 1 && bytes(board[3])[0] == bytes(board[5])[0] && bytes(board[3])[0] == bytes(board[7])[0]) &&
            bytes(board[5])[0] != bytes(" ")[0]) {
            return true;
        }
        else {
        return false;
        }
    }

    function checkTieCondition() internal view returns (bool) {
        for (uint i = 1; i <= 9; i++) {
            if (bytes(board[i]).length == 1 && bytes(board[i])[0] == bytes(" ")[0]) {
                return false;
            }
        }
        return true;
    }
}

