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
    @State private var showAddPortfolioSheet = false
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                homeHeader()
                homeStatsView()
                columns()
                    .padding(.top,5)
                SearchBarView(searchText: $vm.searchText)
                    .padding(.top,5)
                if !showPortfolio {
                  allCoins()
                } else {
                   portFolio()
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showAddPortfolioSheet, content: {
                PortifolioView()
                    .environmentObject(vm)
            })
            
        }
       
    }
    
    @ViewBuilder
    func columns() -> some View {
        HStack {
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0: 180))
            }
            .onTapGesture {
                vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
            }
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (vm.sortOption == .holdings || vm.sortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0: 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingReversed : .holdings
                    }
                }
            }
            HStack {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity(
                        (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0: 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            Button(action: {
                vm.reloadData()
            }, label: {
                Image(systemName: "goforward")
            })
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func allCoins() -> some View {
        List {
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .refreshable {
            vm.reloadData()
        }
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    // TODO: Create a grid view showing a coin, trading volume, change in percentage aswell on the coin and links to sites to buy that coin
    @ViewBuilder
    func portFolio() -> some View {
        List {
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin:coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .refreshable {
            print("Now refreshing the portfolio data")
        }
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    

    @ViewBuilder
    func homeHeader()-> some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showAddPortfolioSheet.toggle()
                    }
                }
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
    
    @ViewBuilder
    func homeStatsView()-> some View {

        HStack {
            ForEach(vm.statistics){ stat in
                StatisticView(stat: stat)
                 .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading) /// automatically animated from trailing to leading aliignment when our portfolio changes
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
            .environmentObject(DeveloperPreview.instance.homeVM)
    }
}
