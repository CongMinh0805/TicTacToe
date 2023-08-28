//
//  LeaderboardEntry.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 28/08/2023.
//

import Foundation
struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let username: String
    let wins: Int
}

