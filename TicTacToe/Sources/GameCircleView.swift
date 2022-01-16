//
//  GameCircleView.swift
//  TicTacToe
//
//  Created by Tudor Octavian Ana on 16.01.2022.
//

import SwiftUI

struct GameCircleView: View {
    
    var proxy: GeometryProxy
    var imageName: String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
                .frame(width: proxy.size.width / 4, height: proxy.size.width / 3)
            
            Image(systemName: imageName)
                .resizable()
                .frame(width: proxy.size.width / 8, height: proxy.size.width / 8)
                .foregroundColor(.white)
            
        }
    }
}
