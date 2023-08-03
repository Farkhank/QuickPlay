//
//  ContentView.swift
//  QuickPlay
//
//  Created by Muhammad Farkhanudin on 02/08/23.
//  Copyright © 2023 Muhammad Farkhanudin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showHome = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // Remove the background color

                VStack(spacing: 0) {
                    VStack {
                        Text("QuickPlay")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3, x: 0, y: 4)
                            .padding(.top, 0) // Move the text up and add padding

                        Image("joystick")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 240, height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 30)
                            .padding(.top, 40) // Move the image down and add padding

                        Spacer() // Add spacer to push the button to the bottom
                    }

                    NavigationLink(destination: Home(), isActive: $showHome) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.orange) // Change to orange color
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 2) // Add black border
                                )
                            Text("Get Started")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .frame(width: 200, height: 70)
                    .padding(.bottom, 30) // Add padding to move the button up
                    .onTapGesture {
                        self.showHome = true
                    }
                }
                .animation(.default) // Add animation
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
