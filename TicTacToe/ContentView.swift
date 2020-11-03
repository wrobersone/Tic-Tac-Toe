//
//  ContentView.swift
//  TicTacToe
//
//  Created by William Robersone on 10/7/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var moves : [String] = Array(repeating: "", count: 9)
    @State var isPlaying = true
    @State var gameOver = false
    @State var message = ""
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                
                ForEach(0..<9, id: \.self) { index in
                    
                    ZStack {
                        // Animation
                        Color.yellow
                        
                        Color.secondary
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.red)
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    
                    
                    // Add move when pressed
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            if moves[index] == "" {
                                moves[index] = isPlaying ? "X" : "0"
                                isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        // Updates the game to find out the winner
        .onChange(of: moves, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text("Winner"), message: Text(message), dismissButton: .destructive(Text("Play Again?"), action: {
                // restart the game
                withAnimation(Animation.easeIn(duration: 0.5)) {
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        })
    }
    
    // Calculate the width
    func getWidth() -> CGFloat {
        
        // For the Horizontal View
        let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }
    
    // Check for the Winner
    
    func checkWinner() {
        if checkMoves(player: "X") {
            // send alert
            message = "Player X Wins!!!"
            gameOver.toggle()
        } else if checkMoves(player: "0") {
            message = "Player 0 Wins!!!"
            gameOver.toggle()
        } else {
            // check for no moves
            let status = moves.contains { (value) -> Bool in
                return value == ""
            }
            
            if !status {
                message = "Game Over, It's a Tie!"
                gameOver.toggle()
            }
        }
    }
    
    func checkMoves(player: String) -> Bool {
        // Horizontal Moves
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player {
                return true
            }
        }
        
        // Vertical Moves
        for i in 0...2 {
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player {
                return true
            }
        }
        
        // Checking Diagonal
        if moves[0] == player && moves[4] == player && moves[8] == player {
            return true
        }
        
        if moves[2] == player && moves[4] == player && moves[6] == player {
            return true
        }
        
        return false
    }
}
