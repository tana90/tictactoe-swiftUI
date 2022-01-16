//
//  Alerts.swift
//  TicTacToe
//
//  Created by Tudor Octavian Ana on 16.01.2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWins = AlertItem(title: Text("You win"), message:Text( "Human wins"), buttonTitle: Text("Play again"))
    static let computerWins = AlertItem(title: Text("You lost"), message: Text("Computer wins"), buttonTitle: Text("Play again"))
    static let draw = AlertItem(title: Text("Nobody wins"), message: Text("It's a draw"), buttonTitle: Text("Play again"))
}
