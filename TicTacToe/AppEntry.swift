//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

@main
struct AppEntry: App {
    @AppStorage("yourName") var yourName = ""
    @State private var selectedLanguage: String = "EN" // Define the selectedLanguage state
    @StateObject var game = GameService()
    @StateObject var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            } else {
                StartView(yourName: yourName, selectedLanguage: $selectedLanguage) // Pass selectedLanguage
                    .environmentObject(game)
                    .environmentObject(userSettings)
            }
            
        }
    }
}

