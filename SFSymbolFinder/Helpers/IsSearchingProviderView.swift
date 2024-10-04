//
//  IsSearchingProviderView.swift
//  SFSymbolFinder
//
//  Created by Gleb Ustymenko on 04/10/2024.
//
import SwiftUI

struct IsSearchingProviderView: View {
    @Environment(\.isSearching) private var isSearching
    @Binding var isSearchingBinding: Bool

    var body: some View {
        EmptyView()
            .onChange(of: isSearching) { _, newValue in
                isSearchingBinding = newValue
            }
    }
}
