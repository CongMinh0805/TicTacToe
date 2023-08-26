//
//  GameModels.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import Foundation

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
