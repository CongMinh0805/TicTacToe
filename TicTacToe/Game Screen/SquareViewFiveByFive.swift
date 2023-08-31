//
//  SquareViewFiveByFive.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 31/08/2023.
//

import SwiftUI

struct SquareViewFiveByFive: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    let index: Int
    var body: some View {
        Button {
            if !game.isThinking {
                game.makeMove(at: index)
            }
            if game.gameType == .peer {
                let gameMove = MPGameMove(action: .move, playerName: connectionManager.myPeerId.displayName ,index: index)
                connectionManager.send(gameMove: gameMove)
            }
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width: 70, height: 70)
        }
        .disabled(game.gameBoard[index].player != nil)
        .foregroundColor(.primary)

    }
}

struct SquareViewFiveByFive_Previews: PreviewProvider {
    static var previews: some View {
        SquareViewFiveByFive(index: 1)
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
    }
}
