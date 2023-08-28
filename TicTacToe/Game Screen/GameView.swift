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

    var body: some View {
        VStack {
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy({ $0 == false }) {
                Text("Select a player to start")
            }
            HStack {
                Button(game.player1.name) {
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                Button(game.player2.name) {
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        Task {
                            await game.deviceMove()
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
                    VStack {
                        Text(" Thinking... ")
                            .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled || game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
            
            VStack {
                if game.gameOver {
                    Text("Game Over")
                    if game.possibleMoves.isEmpty {
                        Text("It's a tie!")
                    } else {
                        Text("\(game.currentPlayer.name) wins!")
                    }
                    Button("New Game") {
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
                            ThemeToggleButtonView()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
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
                        Text("End Game")
                    }
                    .buttonStyle(.bordered)
                    .scaleEffect(isTapped ? 0.9 : 1.0)
                    .alert(isPresented: $showingEndGameAlert) {
                        Alert(title: Text("End Game"),
                              message: Text("Are you sure you want to end the game?"),
                              primaryButton: .destructive(Text("End Game")) {
                                  self.presentationMode.wrappedValue.dismiss()
                              },
                              secondaryButton: .cancel())
                    }


                }
            
        }
        .navigationTitle("Tic Tac Toe")
        .onAppear{
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
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
