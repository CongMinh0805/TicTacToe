//
//  FiveByFiveGameView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 30/08/2023.
//

//
//  GameView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

struct FiveByFiveGameView: View {
    // Environment objects and state variables
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
                Text(selectedLanguage == "EN" ? "Select a player to start": "Chọn người chơi để bắt đầu")            }
            HStack {
                //player 1 go first
                Button(game.player1.name) {
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                //player 2 go first
                Button(game.player2.name) {
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        let winCombination = game.gameMode == .fiveByFive ? game.winningCombinations5x5 : game.winningCombinations3x3
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
            
            // 5x5 grid of squares
            VStack {
                HStack {
                    ForEach(0...4, id: \.self) { index in
                        SquareViewFiveByFive(index: index)
                    }
                }
                HStack {
                    ForEach(5...9, id: \.self) { index in
                        SquareViewFiveByFive(index: index)
                    }
                }
                HStack {
                    ForEach(10...14, id: \.self) { index in
                        SquareViewFiveByFive(index: index)
                    }
                }
                HStack {
                    ForEach(15...19, id: \.self) { index in
                        SquareViewFiveByFive(index: index)
                    }
                }
                HStack {
                    ForEach(20...24, id: \.self) { index in
                        SquareViewFiveByFive(index: index)
                    }
                }
            }
            .overlay {
                if game.isThinking {
                    VStack {
                        Text(selectedLanguage == "EN" ? " Thinking... ": "Suy nghĩ")    .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled || game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
            
            VStack {
                if game.gameOver {
                    //alert game over
                    Text(selectedLanguage == "EN" ? "Game Over": "Trò chơi kết thúc")
                    if game.possibleMoves.isEmpty {
                        //tie
                        Text(selectedLanguage == "EN" ? "It's a tie!": "Kết quả hoà")
                    } else {
                        //win
                        Text(selectedLanguage == "EN" ? "\(game.currentPlayer.name) wins!": "\(game.currentPlayer.name) thắng!")                    }
                    //reset all moves for new game
                    Button(selectedLanguage == "EN" ? "New Game": "Màn chơi mới") {
                        game.reset()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                //dark/light mode
                    ThemeToggleButtonView()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //spring animation
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
                        Alert(title: Text(selectedLanguage == "EN" ? "End Game": "Kết thúc màn chơi"),
                              message: Text(selectedLanguage == "EN" ? "Are you sure you want to end the game?" : "Bạn muốn kết thúc màn chơi này?"),
                              primaryButton: .destructive(Text(selectedLanguage == "EN" ? "End Game" : "Kết thúc")) {
                                  self.presentationMode.wrappedValue.dismiss()
                              },
                              secondaryButton: .cancel())
                    }


                }
            
        }
        .navigationTitle(selectedLanguage == "EN" ? "Tic Tac Toe": "Cờ caro")
        .onAppear {
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        //navigation stack on top
        .inNavigationStack()
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct FiveByFiveGameView_Previews: PreviewProvider {
    static var previews: some View {
        FiveByFiveGameView(selectedLanguage: .constant("EN"))
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(UserSettings())
    }
}


