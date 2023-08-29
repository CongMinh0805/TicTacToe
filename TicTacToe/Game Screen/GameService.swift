//
//  GameService.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

@MainActor
class GameService: ObservableObject {
    @Published var player1 = Player(gamePiece: .x, name: "Player 1")
    @Published var player2 = Player(gamePiece: .o, name: "Player 2")
    @Published var possibleMoves = Move.all
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var isThinking = false
    
    @Published var leaderboard: [LeaderboardEntry] = []

    var gameType = GameType.single
    
    var aiDifficulty: AIDifficulty = .easy
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
        loadLeaderboard()
    }
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
    }
    
    func reset() {
        player1.isCurrent = false
        player2.isCurrent = false
        player1.moves.removeAll()
        player2.moves.removeAll()
        gameOver = false
        possibleMoves = Move.all
        gameBoard = GameSquare.reset
    }
    
    
    func updateMoves(index: Int) {
        if player1.isCurrent {
            player1.moves.append(index + 1)
            gameBoard[index].player = player1
        } else {
            player2.moves.append(index + 1)
            gameBoard[index].player = player2
        }
    }
    
    func checkWinner() {
            if player1.isWinner {
                gameOver = true
                updateLeaderboard(for: player1)
            } else if player2.isWinner {
                gameOver = true
                updateLeaderboard(for: player2)
            }
        }
    
    func toggleCurrent() {
        player1.isCurrent.toggle()
        player2.isCurrent.toggle()
    }
    
    func makeMove(at index: Int) {
        if gameBoard[index].player == nil {
            withAnimation {
                updateMoves(index: index)
            }
            checkWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: {$0 == (index + 1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
                if gameType == .bot && currentPlayer.name == player2.name {
                    Task {
                        await deviceMove()
                    }
                }
            }
            if possibleMoves.isEmpty {
                gameOver = true
            }
        }
    }
    func randomMove() {
        if let move = possibleMoves.randomElement(),
           let matchingIndex = Move.all.firstIndex(where: {$0 == move}) {
            makeMove(at: matchingIndex)
        }
    }

    func winningMove(for player: Player) -> Bool {
        if let winningMove = winningOrBlockingMove(for: player) {
            makeMove(at: winningMove)
            return true
        }
        return false
    }

    func blockingMove(for player: Player) -> Bool {
        if let blockingMove = winningOrBlockingMove(for: player) {
            makeMove(at: blockingMove)
            return true
        }
        return false
    }
    
    func winningOrBlockingMove(for player: Player) -> Int? {
        for move in possibleMoves {
            // Create a hypothetical board for the move
            var testBoard = gameBoard
            testBoard[move-1].player = player.gamePiece == .x ? player1 : player2
            
            // Check if the move leads to a win
            if gameWon(on: testBoard, by: player) {
                return move-1
            }
        }
        return nil
    }


    func gameWon(on board: [GameSquare], by player: Player) -> Bool {
        // Define the winning combinations
        let winningCombinations: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // Columns
            [0, 4, 8], [2, 4, 6]              // Diagonals
        ]
        
        for combo in winningCombinations {
            if board[combo[0]].player?.gamePiece == player.gamePiece &&
               board[combo[1]].player?.gamePiece == player.gamePiece &&
               board[combo[2]].player?.gamePiece == player.gamePiece {
                return true
            }
        }
        
        return false
    }


    func deviceMove() async {
        isThinking.toggle()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        switch aiDifficulty {
        case .easy:
            randomMove()
        case .medium:
            if !winningMove(for: player2) {
                randomMove()
            }
        case .hard:
            if !winningMove(for: player2) && !blockingMove(for: player1) {
                randomMove()
            }
        }

        isThinking.toggle()
    }

    
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

    
    func saveLeaderboard() {
        if let encodedData = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encodedData, forKey: "leaderboard")
        }
    }

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

