//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}
