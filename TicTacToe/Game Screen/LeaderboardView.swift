//
//  LeaderboardView.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 28/08/2023.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode

    
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
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.primary)
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
