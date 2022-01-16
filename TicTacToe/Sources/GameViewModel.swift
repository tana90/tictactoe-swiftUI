//
//  PlayViewModel.swift
//  TicTacToe
//
//  Created by Tudor Octavian Ana on 16.01.2022.
//

import SwiftUI

enum Player {
    case human, computer, none
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return  player == .human ? "xmark" : player == .computer ? "circle" : ""
    }
}

class GameViewModel: ObservableObject {
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5],
                                              [6, 7, 8], [0, 3, 6],
                                              [1, 4, 7], [2, 5, 8],
                                              [0, 4, 8], [2, 4, 6]]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func processPlayerMove(at index: Int) {
        guard !isSquareOccupied(for: index) else { return }
        moves[index] = Move(player: .human, boardIndex: index)
        isGameboardDisabled = true
        
        if checkWinCondition(for: .human) {
            alertItem = AlertContext.humanWins
            return
        }
        
        if checkForDraws() {
            alertItem = AlertContext.draw
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            let computerPosition = strongSelf.determineComputerMovePosition(in: strongSelf.moves)
            strongSelf.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            strongSelf.isGameboardDisabled = false
            
            if strongSelf.checkWinCondition(for: .computer) {
                strongSelf.alertItem = AlertContext.computerWins
                return
            }
            
            if strongSelf.checkForDraws() {
                strongSelf.alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // If computer can win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                if let firstPosition = winPositions.first {
                    let isAvailable = !isSquareOccupied(for: firstPosition)
                    if isAvailable { return firstPosition }
                }
            }
        }
        
        // If computer can't win then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                if let firstPosition = winPositions.first {
                    let isAvailable = !isSquareOccupied(for: firstPosition)
                    if isAvailable { return firstPosition }
                }
            }
        }
        
        // If computer can't block, take middle square
        let centerSquare = 4
        if !isSquareOccupied(for: centerSquare) {
            return centerSquare
        }
        
        let movePosition = Int.random(in: 0..<9)
        
        if isSquareOccupied(for: movePosition) {
            return determineComputerMovePosition(in: moves)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player) -> Bool {
        
        let playerMoves = moves
            .compactMap({ $0 })
            .filter({ $0.player == player })
        let playerPositions = Set(playerMoves.map({ $0.boardIndex }))
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    func checkForDraws() -> Bool {
        return moves.compactMap({ $0 }).count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
