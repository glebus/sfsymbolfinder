//
//  AnalyzeService.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//
import NaturalLanguage

class AnalyzeService {
    func wordSearch(searchTerm: String) -> [AnalyzeResult]? {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            return nil
        }

        return termToSFSymbol(embedding: embedding, term: searchTerm)
    }

    func sentanceSearch(searchTerm: String) -> [AnalyzeResult]? {
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
            return nil
        }

        return termToSFSymbol(embedding: embedding, term: searchTerm)
    }

    private func termToSFSymbol(embedding: NLEmbedding, term: String) -> [AnalyzeResult] {
        let lowercasedTerm = term.lowercased()

        let distances = SFSymbolIdentifiers.compactMap { symbolIdentifier in
            let distance = embedding.distance(between: lowercasedTerm, and: symbolIdentifier)
            if distance < 2.0 {
                return AnalyzeResult(symbolIdentifier: symbolIdentifier, distance: distance)
            } else {
                return nil
            }
        }

        return distances.sorted(by: { $0.distance < $1.distance })
    }
}
