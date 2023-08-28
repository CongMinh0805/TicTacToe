//
//  LeaderboardView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 28/08/2023.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isButtonPressed: Bool = false

    
    // Sample data for the leaderboard
    let leaderboardEntries: [LeaderboardEntry] = [
        LeaderboardEntry(username: "Alex", wins: 10),
        LeaderboardEntry(username: "Jordan", wins: 7),
        LeaderboardEntry(username: "Charlie", wins: 5),
        //... add more entries as needed
    ]
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Username")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Wins")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                ForEach(leaderboardEntries) { entry in
                    HStack {
                        Text(entry.username)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(entry.wins)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
            .navigationTitle("Leaderboard")
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
