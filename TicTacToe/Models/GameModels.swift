//
//  GameModels.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

enum GameType {
    case single, bot, peer, undetermined
    
    var description: String {
        switch self {
        case .single:
            return "Share you iPhone and play against a friend."
        case .bot:
            return "Play against this iPhone."
        case .peer:
            return "Invite someone near you who has this app running to play."
        case .undetermined:
            return ""
        }
    }
}

enum GamePiece: String {
    case x, o
    var image: Image {
        Image(self.rawValue)
    }
}
//all player variables
struct Player {
    let gamePiece: GamePiece
    var name: String
    var moves: [Int] = []
    var isCurrent = false
    
    var gameMode: GameService.GameMode // Add this property
    
    // Modify the isWinner property based on the game mode
    var isWinner: Bool {
        let winningMoves: [[Int]]
        switch gameMode {
        case .threeByThree:
            winningMoves = Move.winningMoves
        case .fiveByFive:
            winningMoves = FiveByFiveMove.winningMoves
        }
        
        for moves in winningMoves {
            if moves.allSatisfy(self.moves.contains) {
                return true
            }
        }
        return false
    }
}

//all moves and win combinations in 3x3 game
enum Move {
   static var all = [1,2,3,4,5,6,7,8,9]

   static var winningMoves = [
        [1,2,3],
        [4,5,6],
        [7,8,9],
        [1,4,7],
        [2,5,8],
        [3,6,9],
        [1,5,9],
        [3,5,7]
    ]
}
//all moves and win combinations in 5x5 game
enum FiveByFiveMove {
    static var all = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]

    static var winningMoves = [
        [1,2,3,4,5],
        [6,7,8,9,10],
        [11,12,13,14,15],
        [16,17,18,19,20],
        [21,22,23,24,25],
        [1,6,11,16,21],
        [2,7,12,17,22],
        [3,8,13,18,23],
        [4,9,14,19,24],
        [5,10,15,20,25],
        [1,7,13,19,25],
        [5,9,13,17,21]
    ]
}

