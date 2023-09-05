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
    @StateObject var audioManager = AudioManager()

    
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            } else {
                GreetingView(active: .constant(true), yourName: $yourName, selectedLanguage: selectedLanguage) // Start with GreetingView
                    .environmentObject(game)
                    .environmentObject(userSettings)
            }
            
        }
    }
}

