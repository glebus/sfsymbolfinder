//
//  ViewModel.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//
import Combine
import SwiftUI
import SFSymbolEnum

class MainViewModel: ObservableObject {
    enum SearchType: String, CaseIterable {
        case plain
        case word
        case sentence
    }

    enum State {
        case symbols(Int, [SFSymbol])
        case sectionSymbols([String: [SFSymbol]])
        case loading

        var count: Int {
            switch self {
            case .symbols(let count, _):
                return count
            case .sectionSymbols(let symbolMap):
                return symbolMap.values.flatMap { $0 }.count
            case .loading:
                return 0
            }
        }
    }

    @Published var isSearching: Bool = false
    @Published var searchType: SearchType = .plain
    @Published var state: State = .loading
    @Published var searchTerm: String = ""

    private var analyseService: AnalyzeService

    var cancellables: [AnyCancellable] = []

    init(analyseService: AnalyzeService) {
        self.analyseService = analyseService

        setupBindings()
        loadSymbols()
    }

    private func setupBindings() {
        $isSearching.sink { [weak self] value in
            if !value {
                self?.reset()
            }
        }
        .store(in: &cancellables)
    }

    private func loadSymbols() {
        state = .loading

        Task.detached(priority: .userInitiated) {
            let state: State

            if self.searchTerm.isEmpty {
                state = .symbols(SFSymbol.allCases.count, SFSymbol.allCases)
            } else {
                switch self.searchType {
                case .plain:
                    let results = self.plainSearch(searchTerm: self.searchTerm)
                    state = .symbols(results.count, results)
                case .word:
                    state = .sectionSymbols(self.wordSearch(searchTerm: self.searchTerm))
                case .sentence:
                    state = .sectionSymbols(self.sentanceSearch(searchTerm: self.searchTerm))
                }
            }

            await MainActor.run {
                self.state = state
            }
        }
    }

    func reset() {
        searchTerm = ""
        loadSymbols()
    }

    func searchAction() {
        loadSymbols()
    }

    private func plainSearch(searchTerm: String) -> [SFSymbol] {
        return SFSymbol.allCases
            .filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
    }

    private func wordSearch(searchTerm: String) -> [String: [SFSymbol]] {
        guard let results = analyseService.wordSearch(searchTerm: searchTerm) else {
            return [:]
        }

        let symbolResults = results.map {($0.symbolIdentifier, plainSearch(searchTerm: $0.symbolIdentifier))}

        return Dictionary(uniqueKeysWithValues: symbolResults)
    }

    private func sentanceSearch(searchTerm: String) -> [String: [SFSymbol]] {
        guard let results = analyseService.sentanceSearch(searchTerm: searchTerm) else {
            return [:]
        }

        let symbolResults = results.map {($0.symbolIdentifier, plainSearch(searchTerm: $0.symbolIdentifier))}

        return Dictionary(uniqueKeysWithValues: symbolResults)

    }
}
