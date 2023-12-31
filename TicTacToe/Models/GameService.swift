//
//  GameService.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

@MainActor
class GameService: ObservableObject {
    @Published var player1: Player // Remove the initialization here
    @Published var player2: Player // Remove the initialization here
    @Published var possibleMoves = Move.all
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var isThinking = false
    
    @Published var leaderboard: [LeaderboardEntry] = []
    
    //there are two board sizes 3x3 and 5x5
    enum GameMode {
          case threeByThree
          case fiveByFive
      }

    var gameMode: GameMode = .threeByThree // Set the default mode to be 3x3
    var gameType = GameType.single
    var aiDifficulty: AIDifficulty = .easy //default is easy
    
    enum AIDifficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    var currentPlayer: Player {
        if player1.isCurrent {
            return player1
        } else {
            return player2
        }
    }
    
    var gameStarted: Bool {
        player1.isCurrent || player2.isCurrent
    }
    
    var boardDisabled: Bool {
        gameOver || !gameStarted || isThinking
    }
    
    init() {
            // Initialize player1 and player2 with default game mode (3x3)
            player1 = Player(gamePiece: .x, name: "Player 1", gameMode: gameMode)
            player2 = Player(gamePiece: .o, name: "Player 2", gameMode: gameMode)
            loadLeaderboard()
        }
    
    //set up a game everytime entering
    func setupGame(gameType: GameType, player1Name: String, player2Name: String, aiDifficulty: AIDifficulty) {
        switch gameType {
        case .single:
            self.gameType = .single
            player2.name = player2Name
        case .bot:
            self.gameType = .bot
            player2.name = UIDevice.current.name
        case .peer:
            self.gameType = .peer
        case .undetermined:
            break
        }
        player1.name = player1Name
        self.aiDifficulty = aiDifficulty
        
        // Update player creation with gameMode parameter
        player1 = Player(gamePiece: .x, name: player1Name, gameMode: gameMode)
        player2 = Player(gamePiece: .o, name: player2Name, gameMode: gameMode)
               
    }
    
    //reset the board for a new game
    func reset() {
        player1.isCurrent = false
        player2.isCurrent = false
        player1.moves.removeAll()
        player2.moves.removeAll()
        gameOver = false
        possibleMoves = Move.all
        gameBoard = GameSquare.reset
//        playSound(sound: "game-music", type: "mp3")
    }
    
    //update after a player has made a move
    func updateMoves(index: Int) {
        if player1.isCurrent {
            player1.moves.append(index + 1)
            gameBoard[index].player = player1
        } else {
            player2.moves.append(index + 1)
            gameBoard[index].player = player2
        }
    }
    
    //check if there is a winner
    func checkWinner() {
        if player1.isWinner {
            gameOver = true
            updateLeaderboard(for: player1)
            playSound(sound: "win", type: "wav") // Play sound for winner
        } else if player2.isWinner {
            gameOver = true
            updateLeaderboard(for: player2)
            playSound(sound: "win", type: "wav") // Play sound for winner
        }
    }

    
    func toggleCurrent() {
        player1.isCurrent.toggle()
        player2.isCurrent.toggle()
    }
    
    //allows players to place X or O on a square
    func makeMove(at index: Int) {
        if gameBoard[index].player == nil {
            withAnimation {
                updateMoves(index: index)
            }
            playSound(sound: "tap", type: "wav") // Play sound for move
            checkWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: {$0 == (index + 1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
                if gameType == .bot && currentPlayer.name == player2.name {
                    var winCombination: [[Int]]
                    if gameMode == .threeByThree {
                        winCombination = winningCombinations3x3
                    } else {
                        winCombination = winningCombinations5x5
                    }
                    Task {
                        await deviceMove(using: winCombination)
                    }
                }
            }
            if possibleMoves.isEmpty {
                gameOver = true
            }
        }
    }

    //device will put mark on random
    func randomMove() {
        if let move = possibleMoves.randomElement(),
           let matchingIndex = Move.all.firstIndex(where: {$0 == move}) {
            makeMove(at: matchingIndex)
        }
    }

    //device tries to achieve a win combination
    func winningMove(for player: Player, using winCombination: [[Int]]) -> Bool {
        if let winningMove = winningOrBlockingMove(for: player, using: winCombination) {
            makeMove(at: winningMove)
            return true
        }
        return false
    }

    //blocks player if a combination is almost achieved
    func blockingMove(for player: Player, using winCombination: [[Int]]) -> Bool {
        if let blockingMove = winningOrBlockingMove(for: player, using: winCombination) {
            makeMove(at: blockingMove)
            return true
        }
        return false
    }
    
    func winningOrBlockingMove(for player: Player, using winCombination: [[Int]]) -> Int? {
        for move in possibleMoves {
            // Create a hypothetical board for the move
            var testBoard = gameBoard
            testBoard[move-1].player = player.gamePiece == .x ? player1 : player2
            
            // Check if the move leads to a win
            if gameWon(on: testBoard, by: player, using: winCombination) {
                return move-1
            }
        }
        return nil
    }

    public let winningCombinations3x3: [[Int]] = [
           [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Rows
           [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Columns
           [0, 4, 8], [2, 4, 6]              // Diagonals
       ]

    public let winningCombinations5x5: [[Int]] = [
        [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [20, 21, 22, 23, 24],  // Rows
        [0, 5, 10, 15, 20], [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23], [4, 9, 14, 19, 24],  // Columns
        [0, 6, 12, 18, 24], [4, 8, 12, 16, 20]  // Diagonals
    ]
    
    func gameWon(on board: [GameSquare], by player: Player, using winCombination: [[Int]]) -> Bool {
        for combo in winCombination {
            if combo.allSatisfy({ board[$0].player?.gamePiece == player.gamePiece }) {
                return true
               
            }
        }
        return false
    }

    //device will "think" for 1 second for making its next move
    func deviceMove(using winCombination: [[Int]]) async  {
        isThinking.toggle()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        switch aiDifficulty {
        case .easy:
            randomMove()
        case .medium:
            if !winningMove(for: player2, using: winCombination) {
                randomMove()
            }
        case .hard:
            if !winningMove(for: player2, using: winCombination) && !blockingMove(for: player1, using: winCombination) {
                randomMove()
            }
        }

        isThinking.toggle()
        if player2.isWinner { // Device wins
               playSound(sound: "lose", type: "wav")
           } else {
               playSound(sound: "tap", type: "wav")
           }
    }
    
    //update new winner to leaderboard
    func updateLeaderboard(for player: Player) {
        if let index = leaderboard.firstIndex(where: { $0.username == player.name }) {
            // Player exists in the leaderboard. Update their wins.
            leaderboard[index].wins += 1
        } else {
            // Player doesn't exist in the leaderboard. Add a new entry.
            leaderboard.append(LeaderboardEntry(username: player.name, wins: 1))
        }
        // Sort the leaderboard based on wins (optional).
        leaderboard.sort(by: { $0.wins > $1.wins })
        
        // Save the updated leaderboard.
        saveLeaderboard()
    }
    
    //save new winner username and add 1 to number of wins
    func saveLeaderboard() {
        if let encodedData = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encodedData, forKey: "leaderboard")
        }
    }

    //load leaderboard info
    func loadLeaderboard() {
        if let savedData = UserDefaults.standard.data(forKey: "leaderboard"),
           let decodedData = try? JSONDecoder().decode([LeaderboardEntry].self, from: savedData) {
            self.leaderboard = decodedData
        }
    }
}
struct LeaderboardEntry: Identifiable, Codable, Equatable {
    var id: UUID
    let username: String
    var wins: Int

    // Default initializer
    init(username: String, wins: Int) {
        self.id = UUID()
        self.username = username
        self.wins = wins
    }
}

//players return corresponding mark
extension Player {
    var opponentGamePiece: GamePiece? {
        switch self.gamePiece {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}

//make the AI levels identifiable
extension GameService.AIDifficulty: Identifiable {
    public var id: Self { self }
}

