//
//  SnakeGameView.swift
//  QuickPlay
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Muhammad Farkhanudin. All rights reserved.
//

import SwiftUI

struct SnakeGameView: View {
    // The size of each cell in the game grid
    private let cellSize: CGFloat = 10

    // The current position of the snake head
    @State private var snakeHeadPosition: CGPoint = CGPoint(x: 100, y: 100)

    // The direction in which the snake is moving
    @State private var direction: CGPoint = CGPoint(x: 1, y: 0)

    // The timer to update the snake movement
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    // The length of the snake
    @State private var snakeLength: Int = 1
    @State private var snakeBody: [CGPoint] = []

    // The position of the food
    @State private var foodPosition: CGPoint = .zero

    // Score variables
    @State private var score: Int = 0
    @State private var highestScore: Int = 0

    // Game over state
    @State private var isGameOver: Bool = false

    // Eating state
    @State private var isEating: Bool = false
    @State private var foodEaten: Int = 0

    // Drag gesture related properties
    @State private var dragStartPosition: CGPoint? = nil
    @State private var isDragging = false {
        didSet {
            // Reset the drag start position after the drag is finished
            if !isDragging {
                self.dragStartPosition = nil
            }
        }
    }

    var body: some View {
        VStack {
            Text("Snake Game")
                .font(.title)
                .padding()

            // Game grid
            GeometryReader { geometry in
                ZStack {
                    Color.orange // Set the background color to orange

                    // Draw the border
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    // Draw the snake
                    ForEach(0..<self.snakeLength, id: \.self) { index in
                        Rectangle()
                            .fill(index == 0 ? Color.black : Color.black)
                            .frame(width: self.cellSize, height: self.cellSize)
                            .position(self.snakeBody.count > index ? self.snakeBody[index] : self.snakeHeadPosition)
                    }

                    // Draw the food
                    Image("meat") // Replace "food" with the name of your food image asset
                        .resizable()
                        .frame(width: self.cellSize, height: self.cellSize)
                        .position(self.foodPosition)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    self.resetGame()
                }
                .gesture(DragGesture()
                            .onChanged { value in
                                // Store the start position of the drag
                                if self.dragStartPosition == nil {
                                    self.dragStartPosition = value.location
                                }

                                // Calculate the change in x and y positions
                                let dx = value.location.x - self.dragStartPosition!.x
                                let dy = value.location.y - self.dragStartPosition!.y

                                // Check if the change is more horizontal or vertical
                                if abs(dx) > abs(dy) {
                                    // Move horizontally
                                    self.direction = CGPoint(x: dx > 0 ? 1 : -1, y: 0)
                                } else {
                                    // Move vertically
                                    self.direction = CGPoint(x: 0, y: dy > 0 ? 1 : -1)
                                }

                                // Set the isDragging state to true to avoid calling resetGame when drag ends
                                self.isDragging = true
                            })
                .onReceive(self.timer) { _ in
                    // Move the snake
                    self.moveSnake()
                }
            }
            .aspectRatio(1, contentMode: .fit)

            // Show current score and highest score
            VStack {
                Text("Score: \(score)")
                Text("Highest Score: \(highestScore)")
            }
        }
        .alert(isPresented: $isGameOver) {
            Alert(
                title: Text("Game Over"),
                message: Text("You scored \(score) points."),
                dismissButton: .default(Text("Play Again"), action: {
                    self.resetGame()
                })
            )
        }
    }

    // Reset the game
    private func resetGame() {
        snakeHeadPosition = CGPoint(x: 100, y: 100)
        direction = CGPoint(x: 1, y: 0)
        snakeLength = 1
        score = 0
        snakeBody.removeAll()
        spawnFood()
        isGameOver = false
        isEating = false
        foodEaten = 0
    }

    // Move the snake
    private func moveSnake() {
        // Check if the snake eats the food
        if snakeHeadPosition == foodPosition {
            score += 1 // Increment the score
            if score > highestScore {
                highestScore = score // Update the highest score
            }
            isEating = true
            foodEaten += 1
            spawnFood()
        } else {
            // Remove the last element from the snake body if it didn't eat the food
            if snakeBody.count > snakeLength {
                snakeBody.removeLast()
            }
        }

        // Add the current head position to the snake body
        snakeBody.insert(snakeHeadPosition, at: 0)

        // Update the position of the snake head
        snakeHeadPosition.x += cellSize * direction.x
        snakeHeadPosition.y += cellSize * direction.y

        // Check for collisions with the game boundaries
        let screenSize = UIScreen.main.bounds.size
        if snakeHeadPosition.x < 0 || snakeHeadPosition.y < 0 || snakeHeadPosition.x >= screenSize.width || snakeHeadPosition.y >= screenSize.height {
            isGameOver = true
            return
        }

        // Check for collisions with the snake's body
        for index in 1..<snakeBody.count {
            if snakeBody[index] == snakeHeadPosition {
                isGameOver = true
                return
            }
        }

        // Check if the ular is eating, then increase the snake length
        if isEating {
            snakeLength += 1
            isEating = false
        }
    }

    // Generate a random position for the food within the game grid
    private func spawnFood() {
        let screenWidth = UIScreen.main.bounds.size.width - cellSize
        let screenHeight = UIScreen.main.bounds.size.height - cellSize
        let randomX = CGFloat.random(in: 0...screenWidth)
        let randomY = CGFloat.random(in: 0...screenHeight)
        foodPosition = CGPoint(x: randomX, y: randomY)
    }
}

struct SnakeGameView_Previews: PreviewProvider {
    static var previews: some View {
        SnakeGameView()
    }
}

