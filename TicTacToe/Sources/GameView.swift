//
//  ContentView.swift
//  TicTacToe
//
//  Created by Tudor Octavian Ana on 16.01.2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel: GameViewModel

    init(viewModel: GameViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { index in
                        GameCircleView(proxy: geometry, imageName: viewModel.moves[index]?.indicator ?? "")
                            .onTapGesture {
                                viewModel.processPlayerMove(at: index)
                            }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.isGameboardDisabled = false
                    viewModel.resetGame()
                }))
            }
        }
    }
}

struct PlayViewPreview: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
