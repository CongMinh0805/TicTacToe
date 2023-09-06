//
//  GeneralInfo.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 04/09/2023.
//

import SwiftUI

struct GeneralInfo: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLanguage: String
    
    var body: some View {
        ZStack{
//            Color("yellowbg")
            Image("wallpaper")
                .resizable()
          
            VStack(alignment: .center, spacing: 10) {
              LogoView(logoFileName: "LaunchScreen")
              Spacer()
              
              Form {
                  //Game instruction
                  Section(header: Text(selectedLanguage == "EN" ? "How To Play" : "Hướng dẫn trò chơi").bold()) {
                if selectedLanguage == "EN" {
                    Text("1. There are 3 game modes for you:\n Share a device\n Play with your device\n Play with other devices that also has this game")
                    Text("2. Select 3x3 or 5x5 for the board size you like")
                    Text("3. If you are playing with your device. You can select press enter and the game will start.")
                    Text("4. If you are playing 2 players in the same device, enter the 2nd player's name and you can start the game")
                    Text("5. You can change your username and the game will exit and reload with a new username.")
                    //language option
                } else if selectedLanguage == "VIE" {
                    Text("1. Có 3 chế độ chơi cho bạn:\n Chia sẻ thiết bị\n Chơi với thiết bị của bạn\n Chơi với các thiết bị khác cũng có trò chơi này")
                    Text("2. Chọn kích thước bảng 3x3 hoặc 5x5 theo sở thích của bạn")
                    Text("3. Nếu bạn đang chơi với thiết bị của bạn. Bạn có thể nhấn enter và trò chơi sẽ bắt đầu.")
                    Text("4. Nếu bạn đang chơi 2 người chơi trên cùng một thiết bị, nhập tên người chơi thứ 2 và bạn có thể bắt đầu trò chơi")
                    Text("5. Bạn có thể thay đổi tên người dùng và trò chơi sẽ thoát và tải lại với tên người dùng mới.")
                 }
                }
              }
              .font(.system(.body, design: .rounded))
            }
            .padding(.top, 40)
            .overlay(
                //close the view
              Button(action: {
                dismiss()
              }) {
                Image(systemName: "xmark.circle")
                  .font(.title)
              }
              .foregroundColor(.white)
              .padding(.top, 30)
              .padding(.trailing, 20),
              alignment: .topTrailing
              )
              
        }
      
    }
}


struct GeneralInfo_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfo(selectedLanguage: .constant("EN")) // Provide a value for selectedLanguage
    }
}





