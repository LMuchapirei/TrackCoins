//
//  DetailView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 11/2/2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: CoinDetailViewVM
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewVM(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    DetailView(
        coin: DeveloperPreview.instance.coin
    )
}


struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

//// create state variables to hold the item and navigate flag to trigger the navigation to navigate
/// we used value types here and we need to investigate how these actually work behind the scene
