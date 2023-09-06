//
//  LeaderboardView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 28/08/2023.
//

import SwiftUI

//show the leaderboard
struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isButtonPressed: Bool = false
    @ObservedObject var gameService: GameService
    @Binding var selectedLanguage: String // Add the selectedLanguage binding
    
    // Sample data for the leaderboard
    let leaderboardEntries: [LeaderboardEntry] = [
//        LeaderboardEntry(username: "Alex", wins: 10),
//        LeaderboardEntry(username: "Jordan", wins: 7),
//        LeaderboardEntry(username: "Charlie", wins: 5),
        //... add more entries as needed
    ]
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    //username column
                    Text(selectedLanguage == "EN" ? "Username" : "Tên người chơi")
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                    //number of wins column
                    Text(selectedLanguage == "EN" ? "Wins" : "Số chiến thắng")
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                ForEach(gameService.leaderboard) { entry in
                    HStack {
                        //insert new winner names
                        Text(entry.username)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        //update number of wins
                        Text("\(entry.wins)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    //return back
                    Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)) {
                                    isButtonPressed.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)) {
                                        isButtonPressed.toggle()
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .foregroundColor(.primary)
                                    .scaleEffect(isButtonPressed ? 1.2 : 1.0)
                            }
                }
            }
            .navigationTitle(selectedLanguage == "EN" ? "Leaderboard" : "Bảng xếp hạng")
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var mockGameService: GameService = {
        let service = GameService()
        service.leaderboard = [
//            LeaderboardEntry(username: "Alex", wins: 10),
//            LeaderboardEntry(username: "Jordan", wins: 7),
//            LeaderboardEntry(username: "Charlie", wins: 5)
        ]
        return service
    }()
    
    static var previews: some View {
           LeaderboardView(gameService: mockGameService, selectedLanguage: .constant("EN")) // Provide a value for selectedLanguage
       }
}

