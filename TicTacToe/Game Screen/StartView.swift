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
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedLanguage: String // Add the selectedLanguage binding


    @EnvironmentObject var settings: UserSettings
    @State private var showLeaderboard = false
    
    @State private var selectedDifficulty: GameService.AIDifficulty = .easy

    
    init(yourName: String, selectedLanguage: Binding<String>) {
        self._selectedLanguage = selectedLanguage // Initialize selectedLanguage first
        self._connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
        self.yourName = yourName
    }

    
    var body: some View {
        
        VStack {
            Picker(selectedLanguage == "EN" ? "Select Game" : "Chọn trò chơi", selection: $gameType) {
                    Text(selectedLanguage == "EN" ? "Select Game Type" : "Chọn chế độ chơi").tag(GameType.undetermined)
                    Text(selectedLanguage == "EN" ? "2 Players 1 Device" : "2 Người chơi 1 Thiết bị").tag(GameType.single)
                    Text(selectedLanguage == "EN" ? "Challenge your device" : "Đối đầu thiết bị của bạn").tag(GameType.bot)
                    Text(selectedLanguage == "EN" ? "Invite other devices" : "Mời thiết bị khác").tag(GameType.peer)
                       }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
        

            Text(gameType.description)
                .padding()
            
            Picker("Select Game Mode", selection: $game.gameMode) {
                Text("3x3").tag(GameService.GameMode.threeByThree)
                Text("5x5").tag(GameService.GameMode.fiveByFive)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.trailing)
            
            VStack {
                switch gameType {
                case .single:
                    VStack {
                        TextField(selectedLanguage == "EN" ? "Opponent Name" : "Tên đối thủ", text: $opponentName)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                case .bot:
                    Picker(selectedLanguage == "EN" ? "AI Difficulty" : "Độ khó AI", selection: $selectedDifficulty) {
                        ForEach(GameService.AIDifficulty.allCases) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }

                    }
                    .pickerStyle(DefaultPickerStyle())
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
                Button(selectedLanguage == "EN" ? "Start Game" : "Bắt đầu trò chơi") {
                    // Setting up the game
                    switch gameType {
                    case .single:
                        game.setupGame(gameType: .single, player1Name: yourName, player2Name: opponentName, aiDifficulty: .easy) // Set default or chosen AI difficulty
                    case .bot:
                        game.setupGame(gameType: .bot, player1Name: yourName, player2Name: UIDevice.current.name, aiDifficulty: selectedDifficulty)
                    case .peer:
                        // Setup logic for .peer (if any)
                        break
                    case .undetermined:
                        break
                    }
                    
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .disabled(
                    gameType == .undetermined ||
                    (gameType == .single && opponentName.isEmpty)
                )
                .onTapGesture {
                    if game.gameMode == .threeByThree {
                        startGame.toggle()
                    } else if game.gameMode == .fiveByFive {
                        startGame.toggle()
                    }
                }
                
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    
                Text(selectedLanguage == "EN" ? "Your username is \(yourName)": "Tên tài khoản của bạn là \(yourName)")
                    .fontWeight(.bold)
                Button(selectedLanguage == "EN" ? "Change my name" : "Đổi tên") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button(action: {
                    showLeaderboard.toggle()
                }) {
                    Text(selectedLanguage == "EN" ? "Leaderboard" : "Bảng điểm")
                        .frame(width: 200, height: 50)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle()) // Remove the default button style

            }
            Spacer()
        }
        .padding()
       
        .navigationTitle(selectedLanguage == "EN" ? "Tic Tac Toe": "Cờ caro")
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ThemeToggleButtonView()
                }
            }
        .fullScreenCover(isPresented: $startGame) {
            if game.gameMode == .threeByThree {
                GameView(selectedLanguage: $selectedLanguage)
                    .environmentObject(connectionManager)
            } else if game.gameMode == .fiveByFive {
                FiveByFiveGameView(selectedLanguage: $selectedLanguage)
                    .environmentObject(connectionManager)
            }
        }

        .fullScreenCover(isPresented: $showLeaderboard) {
            LeaderboardView(gameService: game, selectedLanguage: $selectedLanguage)
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField(selectedLanguage == "EN" ? "New name:" : "Điền tên mới", text: $newName)
                .foregroundColor(Color.black)
            Button(selectedLanguage == "EN" ? "Change" : "Đổi tên", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            .padding()
            Button(selectedLanguage == "EN" ? "Cancel" : "Huỷ", role: .cancel) {}
        }, message: {
            Text(selectedLanguage == "EN" ? "Warning: Tapping on the Change button will quit the application so you can relaunch with the changed name!\n This is normal and you can relaunch the app and play with your updated username." : "Lưu ý: Sau khi nhấn đổi tên tài khoản ứng dụng sẽ tự động đóng để cập nhật tên tài khoản.\n Đây là điều bình thường và bạn có thể mở lại và chơi với tên tài khoản mới.")
        })
        .inNavigationStack()
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Sample", selectedLanguage: .constant("EN")) // Provide a value for selectedLanguage
            .environmentObject(GameService())
            .environmentObject(UserSettings())
    }
}
