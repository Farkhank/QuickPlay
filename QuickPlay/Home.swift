//
//  Home.swift
//  QuickPlay
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Muhammad Farkhanudin. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            ScrollView { // Add ScrollView here
                VStack(spacing: 20) {
                    HStack {
                        Image("joystick")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("QuickPlay")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 10)

                    Text("Welcome to QuickPlay! Choose from a selection of mini-games and have fun playing!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)

                    HStack(spacing: 60) {
                        GameLink(imageName: "snake", title: "Snake", destination: SnakeGameView())
                        GameLink(imageName: "tictactoe-1", title: "TicTacToe", destination: TictactoeGameView())
                        GameLink(imageName: "tetris", title: "Tetris", destination: TetrisView())
                    }
                    .padding(.horizontal, 10)

                    VStack(alignment: .leading) {
                        Text("GameTeaTime")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 0)
                        ScrollView {
                            VStack {
                                NewsItem(imageName: "berita1", title: "Esport Sea games", description: "PBESI Cuma Pilih 6 Game di Cabor Esports SEA Games 2023")
                                NewsItem(imageName: "berita2", title: "MPL Hadir Kembali !!", description: "MPL Turnamen Mobile legend kembali hadir 18 Januarii")
                                NewsItem(imageName: "berita3", title: "Indonesia Gudangnya Gamers!!", description: "62,1 Juta Orang Indonesia Aktif Main Game")
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
}

struct GameLink<Destination: View>: View {
    let imageName: String
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 70, height: 70) // Change the size of the image
                    .cornerRadius(20)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
            }
        }
    }
}

struct NewsItem: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.footnote)
                    .fontWeight(.bold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
