//
//  ContentView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") private var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    
    @EnvironmentObject var settings: UserSettings
    @State private var showLeaderboard = false


    
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    
    
    var body: some View {
        VStack {
            Picker("Select Game", selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("2 Players 1 Device").tag(GameType.single)
                Text("Challenge your device").tag(GameType.bot)
                Text("Challenge a friend").tag(GameType.peer)
            }
            
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))

            Text(gameType.description)
                .padding()
            VStack {
                switch gameType {
                case .single:
                    VStack {
                        TextField("Opponent Name", text: $opponentName)
                        
                    }
                case .bot:
                    EmptyView()
                case .peer:
                    MPPeersView(startGame: $startGame)
                        .environmentObject(connectionManager)
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            if gameType != .peer {
                Button("Start Game") {
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .single && opponentName.isEmpty
                )
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    
                    
               
                Text("Your username is \(yourName)")
                    .fontWeight(.bold)
                Button("Change my name") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
                
                Button("Show Leaderboard") {
                    showLeaderboard.toggle()
                }
                .buttonStyle(.borderedProminent)

            }
            Spacer()
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeToggleButtonView()
                }
            }
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
        .fullScreenCover(isPresented: $showLeaderboard) {
            LeaderboardView()
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField("New name:", text: $newName)
            Button("Change", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            .padding()
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Warning: Tapping on the Change button will quit the application so you can relaunch with the changed name!")
        })
        .inNavigationStack()
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Sample")
            .environmentObject(GameService())
            .environmentObject(UserSettings())
    }
}
