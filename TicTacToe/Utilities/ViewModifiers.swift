//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 26/08/2023.
//

import SwiftUI

struct NavStackContainer: ViewModifier {
//    init() {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .blue // Setting the navigation bar's background color to blue
//            
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            UINavigationBar.appearance().compactAppearance = appearance
//        }
    
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
         
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}
struct ShadowModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .shadow(color:Color("ColorBlackTransparent"), radius: 7)
    }
}
extension View {
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackContainer())
    }
}
