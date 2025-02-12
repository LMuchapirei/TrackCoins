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
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewVM(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    var body: some View {
        ScrollView {
            VStack {
                Text("")
                    .frame(height: 150)
                overview()
                additionalDetails()
                
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
    
    
    @ViewBuilder
    func overview()-> some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
        
        Divider()
        LazyVGrid(
            columns:columns,
            alignment: .leading,
            pinnedViews: []
        ) {
            ForEach(vm.overviewStatistics){ stat in
                StatisticView(stat: stat)
                
            }
        }
    }
    
    
    @ViewBuilder
    func additionalDetails() -> some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
        Divider()
        LazyVGrid(
            columns:columns,
            alignment: .leading,
            pinnedViews: []
        ) {
            ForEach(vm.additionalStatistics){ stat in
                StatisticView(stat: stat)
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(
            coin: DeveloperPreview.instance.coin
        )
    }
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
