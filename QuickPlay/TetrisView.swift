//
//  TetrisView.swift
//  QuickPlay
//
//  Created by Muhammad Farkhanudin on 03/08/23.
//  Copyright © 2023 Muhammad Farkhanudin. All rights reserved.
//

import SwiftUI

struct TetrisView: View {
    private let rows = 20
    private let columns = 10
    private let cellSize: CGFloat = 25

    @State private var grid: [[Color?]] = Array(repeating: Array(repeating: nil, count: 10), count: 20)
    @State private var currentTetromino: [[Color?]] = []
    @State private var tetrominoRow: Int = 0
    @State private var tetrominoColumn: Int = 0
    @State private var score: Int = 0

    let tetrominos: [[[Color?]]] = [
        // I
        [
            [nil, nil, nil, nil],
            [.orange, .orange, .orange, .orange],
            [nil, nil, nil, nil],
            [nil, nil, nil, nil]
        ],
        // J
        [
            [.orange, nil, nil],
            [.orange, .orange, .orange],
            [nil, nil, nil]
        ],
        // L
        [
            [nil, nil, .orange],
            [.orange, .orange, .orange],
            [nil, nil, nil]
        ],
        // O
        [
            [.orange, .orange],
            [.orange, .orange]
        ],
        // S
        [
            [nil, .orange, .orange],
            [.orange, .orange, nil],
            [nil, nil, nil]
        ],
        // T
        [
            [nil, .orange, nil],
            [.orange, .orange, .orange],
            [nil, nil, nil]
        ],
        // Z
        [
            [.orange, .orange, nil],
            [nil, .orange, .orange],
            [nil, nil, nil]
        ]
    ]

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<self.columns, id: \.self) { column in
                            Rectangle()
                                .fill(self.grid[row][column] ?? .black)
                                .frame(width: self.cellSize, height: self.cellSize)
                                .border(Color.orange, width: 1) // Orange border for each cell
                        }
                    }
                }
            }
            .onAppear {
                self.startGame()
            }
            .onReceive(NotificationCenter.default.publisher(for: .tetrisStep), perform: { _ in
                self.moveTetrominoDown()
            })
            .background(Color.black)

            HStack {
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)

                Spacer()

                Button(action: {
                    self.startGame()
                }) {
                    Text("Start Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    private func startGame() {
        grid = Array(repeating: Array(repeating: nil, count: 10), count: 20)
        let randomIndex = Int.random(in: 0..<tetrominos.count)
        currentTetromino = tetrominos[randomIndex]
        tetrominoRow = 0
        tetrominoColumn = (columns - currentTetromino[0].count) / 2
        score = 0
        scheduleTetrisStep()
    }

    private func scheduleTetrisStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .tetrisStep, object: nil)
        }
    }

    private func moveTetrominoDown() {
        let newRow = tetrominoRow + 1

        if isCollision(row: newRow, column: tetrominoColumn, shape: currentTetromino) {
            placeTetromino()
            checkForLineClear()
            startGame()
        } else {
            tetrominoRow = newRow
        }
    }

    private func isCollision(row: Int, column: Int, shape: [[Color?]]) -> Bool {
        for r in 0..<shape.count {
            for c in 0..<shape[0].count {
                if let color = shape[r][c], color != .clear {
                    let targetRow = row + r
                    let targetColumn = column + c

                    if targetRow >= rows || targetColumn < 0 || targetColumn >= columns || (targetRow >= 0 && grid[targetRow][targetColumn] != nil) {
                        return true
                    }
                }
            }
        }
        return false
    }

    private func placeTetromino() {
        for r in 0..<currentTetromino.count {
            for c in 0..<currentTetromino[0].count {
                if let color = currentTetromino[r][c], color != .clear {
                    let targetRow = tetrominoRow + r
                    let targetColumn = tetrominoColumn + c
                    grid[targetRow][targetColumn] = color
                }
            }
        }
    }

    private func checkForLineClear() {
        var linesToClear: [Int] = []
        for row in 0..<rows {
            if grid[row].allSatisfy({ $0 != nil }) {
                linesToClear.append(row)
            }
        }

        if linesToClear.isEmpty {
            return
        }

        for line in linesToClear {
            grid.remove(at: line)
            grid.insert(Array(repeating: nil, count: columns), at: 0)
        }

        // Increase the score for each line cleared
        score += linesToClear.count * 10

        // Check if all blocks in a row have the same color and add extra score
        for row in 0..<rows {
            let uniqueColors = Set(grid[row].compactMap({ $0 }))
            if uniqueColors.count == 1, let _ = uniqueColors.first {
                score += grid[row].count * 5
            }
        }
    }
}

extension Notification.Name {
    static let tetrisStep = Notification.Name("tetrisStep")
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
