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
    var searchResult: SearchResult?

    var body: some View {
        VStack {
            Image(systemName: symbol.symbol)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 50)

            Text(symbol.desc)
                .font(.caption)

            if let searchResult {
                Text(searchResult.distance.formatted())
                    .font(.caption)
            }
        }
    }
}
