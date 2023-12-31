//
//  InfoView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 04/09/2023.
//

import SwiftUI

struct InfoView: View {
  @Environment(\.dismiss) var dismiss
    @Binding var selectedLanguage: String // Add the selectedLanguage binding
  var body: some View {
      ZStack{
          //Yellow background
          Color("YellowRMIT")
          //Rmit logo on top
          VStack(alignment: .center, spacing: 10) {
            LogoView(logoFileName: "rmit-logo")
            Spacer()
            
            Form {
                //game's information
                Section(header: Text(selectedLanguage == "EN" ? "Application Information" : "Thông tin ứng dụng").bold()) {
                    HStack {
                      Text(selectedLanguage == "EN" ? "App Name" : "Tên ứng dụng")
                      Spacer()
                      Text("Tic Tac Toe")
                    }
                    HStack {
                      Text(selectedLanguage == "EN" ? "Course" : "Môn Học")
                      Spacer()
                      Text("COSC2659")
                    }
                    HStack {
                      Text(selectedLanguage == "EN" ? "Year Published" : "Năm Xuất Bản")
                      Spacer()
                      Text("2023")
                    }
                    HStack {
                      Text(selectedLanguage == "EN" ? "Location" : "Địa điểm")
                      Spacer()
                        Text(selectedLanguage == "EN" ? "RMIT Saigon South Campus" : "RMIT Nam Sài Gòn")
                    }
              }
                //Student information
                Section(header: Text(selectedLanguage == "EN" ? "Student Information" : "Thông tin sinh viên").bold()) {
                    HStack {
                        Text(selectedLanguage == "EN" ? "Name" : "Tên")
                      Spacer()
                      Text("Đặng Công Minh")
                    }
                    HStack {
                        Text(selectedLanguage == "EN" ? "Student ID" : "Số Sinh Viên")
                      Spacer()
                      Text("S3904941")
                    }
                    
                    
              }
            }
            .font(.system(.body, design: .rounded))
          }
          .padding(.top, 40)
          .overlay(
            //Close the view
            Button(action: {
                playSound(sound: "modern-select", type: "wav")
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
            .onAppear(perform: {
                
            })
      }
    
  }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(selectedLanguage: .constant("EN")) // Provide a value for selectedLanguage
    }
}
