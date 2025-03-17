//
//  DetailView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 11/2/2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: CoinDetailViewVM
    @State var showMoreText: Bool = false
    let coin: CoinModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewVM(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: coin)
                    .padding(.bottom, 20)
                descriptionSection()
                overview()
                additionalDetails()   
                links()
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
               navigationBarTrailingItems()
            }
        }
    }
    
    @ViewBuilder
    func links() -> some View {
        VStack(spacing:20)
         {
            if let websiteString = vm.websiteUrl, let url = URL(string:websiteString){
                Link("Website",destination: url)
            }
            if let reditUrlString = vm.reditUrl, let url = URL(string:reditUrlString){
                Link("Redit",destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity,alignment: .leading)
        .font(.headline)
    }
    
    @ViewBuilder
    func descriptionSection() -> some View {
        ZStack {
            if let coinDescription = vm.coinDescription,!coinDescription.isEmpty {
                VStack {
                        Text(coinDescription)
                        .font(.callout)
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(showMoreText ? nil : 3)
                        Button {
                            withAnimation(.easeInOut){
                                showMoreText.toggle()
                            }
                        } label: {
                            Text(showMoreText ? "Show Less...":"Read More...")
                                .font(.caption)
                                .accentColor(.blue)
                                .fontWeight(.bold)
                                .padding(.vertical,4)
                        }
                        .frame(maxWidth:.infinity,alignment: .leading)
                }
               
            }
        }
    }
    
    @ViewBuilder
    func navigationBarTrailingItems() -> some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25,height: 25)
        }
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
