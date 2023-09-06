//
//  GameView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: UserSettings
    @State private var isTapped = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEndGameAlert = false
    @Binding var selectedLanguage: String
    
    
    
    var body: some View {
        VStack {
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy({ $0 == false }) {
                Text(selectedLanguage == "EN" ? "Select a player to start": "Chọn người chơi để bắt đầu")
            }
            HStack {
                //select for player 1 to go first
                Button(game.player1.name) {
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                
                //select for player 2 to go first
                Button(game.player2.name) {
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        let winCombination = game.gameMode == .threeByThree ? game.winningCombinations3x3 : game.winningCombinations5x5
                        Task {
                            await game.deviceMove(using: winCombination)
                        }
                    }
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player2.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }
            .disabled(game.gameStarted)
            
            VStack {
                HStack {
                    //lay out 3x3 squares grid
                    ForEach(0...2, id: \.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack {
                    ForEach(3...5, id: \.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack {
                    ForEach(6...8, id: \.self) { index in
                        SquareView(index: index)
                    }
                }
            }
            .overlay {
                if game.isThinking {
                    //give device a 1 second delay before laying its move
                    VStack {
                        Text(selectedLanguage == "EN" ? " Thinking... ": "Suy nghĩ")
                            .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled || game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
            
            VStack {
                //game is over
                if game.gameOver {
                    Text(selectedLanguage == "EN" ? "Game Over": "Trò chơi kết thúc")
                    
                    //tie
                    if game.possibleMoves.isEmpty {
                        Text(selectedLanguage == "EN" ? "It's a tie!": "Kết quả hoà")
                        
                        //there's a winner
                    } else {
                        Text(selectedLanguage == "EN" ? "\(game.currentPlayer.name) wins!": "\(game.currentPlayer.name) thắng!")
                    }
                    //reset the game
                    Button(selectedLanguage == "EN" ? "New Game": "Màn chơi mới") {
                        game.reset()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(settings.isDarkMode ? .black : .primary)
                }
            }
            .font(.largeTitle)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                //dark mode button
                            ThemeToggleButtonView()
                }
            
            //end the game session
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //button animation
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                            self.isTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                                self.isTapped = false
                                self.showingEndGameAlert = true
                            }
                        }
                    }) {
                        Text(selectedLanguage == "EN" ? "End Game": "Kết thúc")
                    }
                    .buttonStyle(.bordered)
                    .scaleEffect(isTapped ? 0.9 : 1.0)
                    .alert(isPresented: $showingEndGameAlert) {
                        //ask user to confirm exiting
                        Alert(title: Text(selectedLanguage == "EN" ? "End Game": "Kết thúc màn chơi"),
                              message: Text(selectedLanguage == "EN" ? "Are you sure you want to end the game?" : "Bạn muốn kết thúc màn chơi này?"),
                              primaryButton: .destructive(Text(selectedLanguage == "EN" ? "End Game" : "Kết thúc")) {
                                  self.presentationMode.wrappedValue.dismiss() //close the game view
                              },
                              secondaryButton: .cancel()) //cancel alert
                    }


                }
            
        }
        .onAppear{
//            playSound(sound: "game-music", type: "mp3")
        }
        .navigationTitle(selectedLanguage == "EN" ? "Tic Tac Toe": "Cờ caro")
        .onAppear{
            //creates a blank square grid
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        //insert navigation stack on top
        .inNavigationStack()
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(selectedLanguage: .constant("EN")) // Provide selectedLanguage here
                   .environmentObject(GameService())
                   .environmentObject(MPConnectionManager(yourName: "Sample"))
                   .environmentObject(UserSettings())

    }
}

struct PlayerButtonStyle: ButtonStyle {
    
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(isCurrent ? Color.green : Color.gray))
            .foregroundColor(.white)
    }
}
