//
//  HomeView.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 10/1/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio: Bool = false
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()

            VStack {
                homeHeader()
                columns()
                SearchBarView(searchText: $vm.searchText)
                if !showPortfolio {
                   portFolio()
                } else {
                   allCoins()
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    @ViewBuilder
    func columns() -> some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func portFolio() -> some View {
        List {
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    @ViewBuilder
    func allCoins() -> some View {
        List {
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    

    @ViewBuilder
    func homeHeader()-> some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
              }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
            .environmentObject(DeveloperPreview.instance.homeVM)
    }
}
