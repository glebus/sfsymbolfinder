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
    @StateObject var viewModel = MainViewModel(analyseService: AnalyzeService())

    var body: some View {
        NavigationStack {
            ScrollView {
                IsSearchingProviderView(isSearchingBinding: $viewModel.isSearching)
                HStack {
                    Text("Results: \(viewModel.state.count.formatted())")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 100))], spacing: 16) {
                    switch viewModel.state {
                    case .symbols(_, let symbols):
                        ForEach(symbols, id: \.self) { symbol in
                            SymbolTileView(symbol: symbol)
                        }
                    case .sectionSymbols(let symbolMap):
                        ForEach(symbolMap.keys.sorted(), id: \.self) { key in
                            Section {
                                ForEach(symbolMap[key] ?? [], id: \.self) { symbol in
                                    SymbolTileView(symbol: symbol)
                                }
                            } header: {
                                HStack {
                                    if case .word = viewModel.searchType {
                                        SFSymbol.wSquare.image
                                    } else {
                                        SFSymbol.arrowRightSquare.image
                                    }
                                    Text(key)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    case .loading:
                        EmptyView()
                    }
                }
                .padding(.horizontal)
            }
            .overlay(
                VStack {
                    if case .loading = viewModel.state {
                        ProgressView()
                            .controlSize(.extraLarge)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .searchable(text: $viewModel.searchTerm, prompt: "Search")
            .searchScopes($viewModel.searchType, activation: .onSearchPresentation) {
                ForEach(MainViewModel.SearchType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                        .tag(type)
                }
            }
            .onSubmit(of: .search) {
                viewModel.searchAction()
            }
            .navigationTitle("SFSymbols Finder")
        }
    }
}

#Preview {
    MainView()
}
