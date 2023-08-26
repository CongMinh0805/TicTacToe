//
//  MPGameMove.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import Foundation

struct MPGameMove: Codable {
    enum Action: Int, Codable {
        case start, move, reset, end
    }
    let action: Action
    let playName: String?
    let index: Int?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
