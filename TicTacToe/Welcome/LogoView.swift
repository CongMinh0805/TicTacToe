//
//  LogoView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 04/09/2023.
//

import SwiftUI

struct LogoView: View {
    var logoFileName: String
    
    var body: some View {
        Image(logoFileName)
            .resizable()
            .scaledToFit()
            .frame(minHeight: 50, idealHeight: 75, maxHeight: 100, alignment: .center) // Adjust the frame dimensions here
            .modifier(ShadowModifier())
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(logoFileName: "rmit-logo")
    }
}
