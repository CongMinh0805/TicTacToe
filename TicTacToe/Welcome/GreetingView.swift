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
            //yellow background
            Color("yellowbg").ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20){
                HStack {
                    // Inside GreetingView
                    //Button to open InfoView
                    Button(action: {
                        showGeneralInfo = true
                    }) {
                        //give button an icon
                        Image(systemName: "info.circle")
                            .font(.system(size: 30))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding(16)
                    .sheet(isPresented: $showGeneralInfo, content: {
                        GeneralInfo(selectedLanguage: $selectedLanguage) // Pass selectedLanguage to GeneralInfo
                    })


                    Spacer()
                    
                    //Language selecting picker
                    Picker("", selection: $selectedLanguage) {
                        //change language to english
                            Text("EN").tag("EN")
                        //Change language to Vietnamese
                            Text("VIE").tag("VIE")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                        .padding(.leading)

                    Spacer() // Add a spacer to push the button to the top right corner
                    HStack {
                        //Open Student Info
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
                    //Game Name
                    Text(selectedLanguage == "EN" ? "Tic Tac Toe" : "Cờ Caro")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                    //game subheading
                    Text(selectedLanguage == "EN" ? "The game of X and O" : "Trò chơi X và O")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                      
                }
              
                ZStack{
                    //game's icon
                    Image("LaunchScreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                
                Spacer()

                //Start the game by openning StartView
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
                //Open StartView fullscreen
                .fullScreenCover(isPresented: $showStartView, content: {
                    StartView(yourName: yourName, selectedLanguage: $selectedLanguage) // Pass the two-way binding
                        .environmentObject(GameService())
                        .environmentObject(UserSettings())
                })

            }
        }
        .onAppear {
//            playSound(sound: "short-loading", type: "mp3")
            //Play background music when view opens
//            playSound(sound: "bgmusic", type: "mp3")
        }
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
