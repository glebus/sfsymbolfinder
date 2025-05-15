//
//  ContentView.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//

import SwiftUI
import NaturalLanguage
import SFSymbolEnum

struct MainView: View {
    @State var viewModel = SymbolFinder()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 100))], spacing: 16) {
                    ForEach(viewModel.symbols, id: \.self) { symbol in
                        SymbolTileView(symbol: symbol, searchResult: nil)
                    }
                }
                .padding()
            }
            .navigationTitle("SFSymbols Finder")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                bottomView
            }
        }
    }

    var bottomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Top Results")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 10)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 100))], spacing: 16) {
                ForEach(Array(viewModel.searchResults.prefix(4)), id: \.symbol) { result in
                    SymbolTileView(symbol: result.symbol, searchResult: result)
                }
            }
            .frame(height: 100)

            HStack {
                TextField("Search symbols...", text: $viewModel.text)
                    .padding(12)
                    .background(Color(.systemFill))
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    MainView()
}
