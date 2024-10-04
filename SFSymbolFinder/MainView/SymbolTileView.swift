//
//  File.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//
import SwiftUI
import SFSymbolEnum

struct SymbolTileView: View {
    var symbol: SFSymbol

    var body: some View {
        VStack {
            symbol.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 50)

            Text(symbol.rawValue)
                .font(.caption)
        }
    }
}
