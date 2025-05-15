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
    
    // For debouncing search
    private var searchTask: Task<Void, Never>? = nil
    
    // NaturalLanguage embedding - initialize once
    private let embedding: NLEmbedding? = NLEmbedding.sentenceEmbedding(for: .english)

    var text: String = "" {
        didSet {
            debouncedSearch()
        }
    }

    func updateProbabilities() {
        debouncedSearch()
    }

    private func debouncedSearch() {
        searchTask?.cancel()

        if text.isEmpty {
            searchResults = []
            return
        }

        searchTask = Task { [weak self] in
            guard let self = self else { return }

            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
            
            if Task.isCancelled { return }

            if let results = await performSearch() {
                await MainActor.run {
                    if !Task.isCancelled {
                        self.searchResults = results
                    }
                }
            }
        }
    }

    private func performSearch() async -> [SearchResult]? {
        let searchTerm = text.lowercased()

        return await Task.detached { () -> [SearchResult]? in
            guard let embedding = self.embedding else { return nil }
            
            let distances = self.symbols.compactMap { symbol in
                let distance = embedding.distance(between: searchTerm, and: symbol.desc.lowercased())
                if distance < 2.0 {
                    return SearchResult(symbol: symbol, distance: distance)
                } else {
                    return nil
                }
            }
            
            return distances.sorted(by: { $0.distance < $1.distance })
        }.value
    }
}
