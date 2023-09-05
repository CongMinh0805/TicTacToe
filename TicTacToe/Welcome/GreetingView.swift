//
//  GreetingView.swift
//  TicTacToe
//
//  Created by user242876 on 9/5/23.
//

import SwiftUI
import AVFoundation


struct GreetingView: View {
    @Binding var active: Bool
    @Binding var yourName: String
    @State private var showStudentInfo = false
    @State private var showGeneralInfo = false
    @State private var showStartView = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedLanguage") var selectedLanguage: String = "EN"


    
    var body: some View {
        ZStack{
            Color("yellowbg").ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20){
                HStack {
                    // Inside GreetingView
                    Button(action: {
                        showGeneralInfo = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 30))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding(16)
                    .sheet(isPresented: $showGeneralInfo, content: {
                        GeneralInfo(selectedLanguage: $selectedLanguage) // Pass selectedLanguage to GeneralInfo
                    })


                    Spacer()
                    Picker("", selection: $selectedLanguage) {
                            Text("EN").tag("EN")
                            Text("VIE").tag("VIE")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                        .padding(.leading)

                    Spacer() // Add a spacer to push the button to the top right corner
                    HStack {
                        Button(action: {
                            showStudentInfo = true // Set the state to true to present the student info view
                        }, label: {
                            Image(systemName: "person.circle") // Use the systemName for the profile icon
                                .font(.system(size: 30))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        })
                        .padding(16)
                        .sheet(isPresented: $showStudentInfo, content: {
                           InfoView(selectedLanguage: $selectedLanguage)
                        })
                    }
                }
                Spacer()
                VStack(spacing: 0) {
                    Text(selectedLanguage == "EN" ? "Tic Tac Toe" : "Cờ Caro")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                                    
                    Text(selectedLanguage == "EN" ? "The game of X and O" : "Trò chơi X và O")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                      
                }
              
                ZStack{
                    Image("LaunchScreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                
                Spacer()

                Button(action: {
                      showStartView = true // Set the state to true to present the StartView
                }, label: {
                    Capsule()
                        .fill(Color.black.opacity(0.8))
                        .padding(8)
                        .frame(height: 80)
                        .overlay(Text(selectedLanguage == "EN" ? "Get Started" : "Bắt Đầu") // Change text based on language selection
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white))
                })
                .fullScreenCover(isPresented: $showStartView, content: {
                    StartView(yourName: yourName, selectedLanguage: $selectedLanguage) // Pass the two-way binding
                        .environmentObject(GameService())
                        .environmentObject(UserSettings())
                })

            }
        }
        .onAppear {
//            playSound(sound: "short-loading", type: "mp3")
//            playSound(sound: "bgmusic", type: "mp3")
        }
//        .background(GradientBackgroundView())
    }
}

struct GreetingView_Previews: PreviewProvider {
    @State static private var selectedLanguage = "EN" // Initialize the selected language
    
    static var previews: some View {
        GreetingView(active: .constant(true), yourName: .constant("User"), selectedLanguage: selectedLanguage)
            .environmentObject(GameService())
            .environmentObject(UserSettings())
    }
}
