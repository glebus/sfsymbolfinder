//
//  ViewModel.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//
import Combine
import SwiftUI
import NaturalLanguage

struct SFSymbol: Hashable {
    let symbol: String
    let desc: String
}

struct SearchResult {
    let symbol: SFSymbol
    let distance: Double
}

@Observable
class SymbolFinder {
    let symbols: [SFSymbol] = [
        SFSymbol(symbol: "house", desc: "Home"),
        SFSymbol(symbol: "gear", desc: "Settings"),
        SFSymbol(symbol: "bell", desc: "Notifications"),
        SFSymbol(symbol: "person", desc: "Profile"),
        SFSymbol(symbol: "star", desc: "Favorites"),
        SFSymbol(symbol: "magnifyingglass", desc: "Search"),
        SFSymbol(symbol: "heart", desc: "Health"),
        SFSymbol(symbol: "envelope", desc: "Mail"),
        SFSymbol(symbol: "phone", desc: "Call"),
        SFSymbol(symbol: "calendar", desc: "Schedule")
    ]

    var searchResults: [SearchResult] = []

    var text: String = "" {
        didSet {
            updateProbabilities()
        }
    }

    func updateProbabilities() {
        guard let results = symbolsSearch(symbols: symbols, searchTerm: text) else { return }

        searchResults = results
    }

    private func symbolsSearch(symbols: [SFSymbol], searchTerm: String) -> [SearchResult]? {
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
            return nil
        }

        let lowercasedTerm = searchTerm.lowercased()

        let distances = symbols.compactMap { symbol in
            let distance = embedding.distance(between: lowercasedTerm, and: symbol.desc)
            if distance < 2.0 {
                return SearchResult(symbol: symbol, distance: distance)
            } else {
                return nil
            }
        }

        return distances.sorted(by: { $0.distance < $1.distance })
    }
}
