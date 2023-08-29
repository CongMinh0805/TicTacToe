//
//  GradientBackgroundView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 29/08/2023.
//

import SwiftUI

struct GradientBackgroundView: View {
    // Access the current color scheme (light or dark mode)
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Apply the gradient based on the color scheme
            LinearGradient(gradient: gradientForScheme, startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // Your Start View content goes here
        }
    }

    // Define the gradient for the current color scheme
    private var gradientForScheme: Gradient {
        switch colorScheme {
        case .light:
            return Gradient(colors: [Color.green, Color.pink, Color.red, Color.orange])
        case .dark:
            return Gradient(colors: [Color.lighterBlue, Color.darkRed, Color.purple])
        @unknown default:
            return Gradient(colors: [Color.green, Color.pink, Color.red, Color.orange])
        }
    }
}

extension Color {
    // Define custom colors
    static let lighterBlue = Color(red: 70/255, green: 130/255, blue: 180/255) // Steel Blue
    static let darkRed = Color(red: 55/255, green: 5/255, blue: 15/255)
}

struct GradientBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GradientBackgroundView()
                .environment(\.colorScheme, .light)
            
            GradientBackgroundView()
                .environment(\.colorScheme, .dark)
        }
    }
}
