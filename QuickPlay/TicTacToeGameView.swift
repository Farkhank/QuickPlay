//
//  TicTacToeGameView.swift
//  QuickPlay
//
//  Created by Muhammad Farkhanudin on 03/08/23.
//  Copyright © 2023 Muhammad Farkhanudin. All rights reserved.
//

import SwiftUI

struct TictactoeGameView: View {
    enum Player: String {
        case human = "X"
        case bot = "O"
    }

    // Game grid
    @State private var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)

    // Player's turn
    @State private var currentPlayer: Player = .human

    // Game result
    @State private var gameResult: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Tic Tac Toe")
                .font(.title)
                .padding(.top)

            // Show current player's turn
            Text("Current Player: \(currentPlayer.rawValue)")
                .font(.headline)
                .padding(.top, 10)

            VStack(spacing: 10) {
                // Game board
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { column in
                            Button(action: {
                                self.onTileTapped(row: row, column: column)
                            }) {
                                Text(self.board[row][column]?.rawValue ?? "")
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.black)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }

            // Description of symbols used by Human and Bot
            HStack {
                Text("Human: \(Player.human.rawValue)")
                Spacer()
                Text("Bot: \(Player.bot.rawValue)")
            }

            Button(action: {
                self.resetGame()
            }) {
                Text("Restart")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .alert(isPresented: .constant(!gameResult.isEmpty)) {
            Alert(title: Text("Game Over"), message: Text(gameResult), dismissButton: .default(Text("OK"), action: {
                self.resetGame()
            }))
        }
        .navigationBarHidden(true)
    }

    private func onTileTapped(row: Int, column: Int) {
        guard board[row][column] == nil else {
            return // Tile already occupied, do nothing
        }

        board[row][column] = .human
        currentPlayer = .bot

        // Check for win or draw
        if checkWin(for: .human) {
            // Human wins
            gameResult = "You Win!"
            return
        } else if isBoardFull() {
            // Draw
            gameResult = "It's a Draw!"
            return
        }

        // Bot's turn
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.makeBotMove()
            self.currentPlayer = .human

            // Check for win or draw after bot's move
            if self.checkWin(for: .bot) {
                // Bot wins
                self.gameResult = "Bot Wins!"
            } else if self.isBoardFull() {
                // Draw
                self.gameResult = "It's a Draw!"
            }
        }
    }

    private func makeBotMove() {
        // Find an empty tile and place bot's move
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column] == nil {
                    board[row][column] = .bot
                    return
                }
            }
        }
    }

    private func checkWin(for player: Player) -> Bool {
        // Check rows, columns, and diagonals for a win
        for i in 0..<3 {
            if board[i][0] == player && board[i][1] == player && board[i][2] == player {
                return true // Row win
            }

            if board[0][i] == player && board[1][i] == player && board[2][i] == player {
                return true // Column win
            }
        }

        if board[0][0] == player && board[1][1] == player && board[2][2] == player {
            return true // Diagonal win
        }

        if board[0][2] == player && board[1][1] == player && board[2][0] == player {
            return true // Diagonal win
        }

        return false
    }

    private func isBoardFull() -> Bool {
        // Check if the board is full (draw)
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column] == nil {
                    return false
                }
            }
        }
        return true
    }

    private func resetGame() {
        // Clear the board and set the first player to human
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .human
        gameResult = ""
    }
}

struct TictactoeGameView_Previews: PreviewProvider {
    static var previews: some View {
        TictactoeGameView()
    }
}
