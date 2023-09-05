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
            .frame(minHeight: 130, idealHeight: 170, maxHeight: 200, alignment: .center)
            .modifier(ShadowModifier())
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(logoFileName: "rmit-casino-logo")
    }
}
