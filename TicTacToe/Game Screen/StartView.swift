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
    @State private var showGreetingView = false
    @Environment(\.presentationMode) private var presentationMode


    @EnvironmentObject var settings: UserSettings
    @State private var showLeaderboard = false
    
    @State private var selectedDifficulty: GameService.AIDifficulty = .easy

    //initialize the variables
    init(yourName: String, selectedLanguage: Binding<String>) {
        self._selectedLanguage = selectedLanguage // Initialize selectedLanguage first
        self._connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
        self.yourName = yourName
    }

    
    var body: some View {
        
        VStack {
            // select game mode
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
            
            //Select board's size
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
                        //if game mode is 2 players in same device
                        //prompt user to enter 2nd player's name
                        TextField(selectedLanguage == "EN" ? "Opponent Name" : "Tên đối thủ", text: $opponentName)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                case .bot:
                    Picker(selectedLanguage == "EN" ? "AI Difficulty" : "Độ khó AI", selection: $selectedDifficulty) {
                        //displays AI difficulty
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
                    playSound(sound: "shutter-click", type: "wav")
                    playSound(sound: "bgmusic", type: "mp3", isBackgroundMusic: true)
                    // Setting up the game
                    switch gameType {
                    case .single:
                        game.setupGame(gameType: .single, player1Name: yourName, player2Name: opponentName, aiDifficulty: .easy) // Set default or chosen AI difficulty
                    case .bot:
                        game.setupGame(gameType: .bot, player1Name: yourName, player2Name: UIDevice.current.name, aiDifficulty: selectedDifficulty)
                        //proceed with selected AI difficulty
                    case .peer:
                        //in development
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
                //label image
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                 //display username
                Text(selectedLanguage == "EN" ? "Your username is \(yourName)": "Tên tài khoản của bạn là \(yourName)")
                    .fontWeight(.bold)
                //option to change name
                Button(selectedLanguage == "EN" ? "Change my name" : "Đổi tên") {
                    playSound(sound: "shutter-click", type: "wav")
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
                .padding()
                
                //display game's leaderboard
                Button(action: {
                    playSound(sound: "shutter-click", type: "wav")
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
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    //return back to greeting View
                    Button(action: {
                        playSound(sound: "shutter-click", type: "wav")
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                                        .font(.title)
                    }
            }
        }
        //open the greeting view in full screen
        .fullScreenCover(isPresented: $startGame) {
            if game.gameMode == .threeByThree {
                GameView(selectedLanguage: $selectedLanguage)
                    .environmentObject(connectionManager)
            } else if game.gameMode == .fiveByFive {
                FiveByFiveGameView(selectedLanguage: $selectedLanguage)
                    .environmentObject(connectionManager)
            }
        }
        //open leaderboard in full screen
        .fullScreenCover(isPresented: $showLeaderboard) {
            LeaderboardView(gameService: game, selectedLanguage: $selectedLanguage)
        }
        //ask user to confirm if they want to change username
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField(selectedLanguage == "EN" ? "New name:" : "Điền tên mới", text: $newName)
                .foregroundColor(Color.black)
            //confirm to change the name
            Button(selectedLanguage == "EN" ? "Change" : "Đổi tên", role: .destructive) {
                playSound(sound: "shutter-click", type: "wav")
                yourName = newName
                exit(-1)
            }
            .padding()
            //close the alert
            Button(selectedLanguage == "EN" ? "Cancel" : "Huỷ", role: .cancel) {
                playSound(sound: "shutter-click", type: "wav")
            }
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
