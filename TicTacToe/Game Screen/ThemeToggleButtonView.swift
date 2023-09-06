//
//  ThemeToggleButtonView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 28/08/2023.
//

import SwiftUI

//dark/light mode button
struct ThemeToggleButtonView: View {
    @EnvironmentObject var settings: UserSettings  // Changed from @ObservedObject

    var body: some View {
        Button(action: {
            //turn on dark mode
            settings.isDarkMode.toggle()
            print("Dark mode is now: \(settings.isDarkMode)")
        }) {
            Image(systemName: settings.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .imageScale(.large)
                .foregroundColor(settings.isDarkMode ? .yellow : .red)
        }        
    }
}

struct ThemeToggleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeToggleButtonView()
            .environmentObject(UserSettings())
    }
}


class UserSettings: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
}
