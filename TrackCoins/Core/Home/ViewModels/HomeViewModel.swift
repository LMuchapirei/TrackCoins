//
//  HomeViewModel.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 10/1/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){        
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Delay to allow running filtering after a valid word to filter with
            .map(filterCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(generateStatistics)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func generateStatistics(marketDataModel: MarketDataModel?)-> [StatisticModel] {
        var statisticsData : [StatisticModel] = []
        guard let data = marketDataModel else { return statisticsData}
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24hr Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portifolio Value", value: "$0.0",percentageChange: 0)
        statisticsData.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return statisticsData
    }
    
    
    private func filterCoins(searchQuery: String, allCoins: [CoinModel])-> [CoinModel] {
        guard  !searchQuery.isEmpty else {
            return allCoins
        }
        let formattedSearchText = searchQuery.lowercased()
        return  allCoins.filter { $0.name.lowercased().contains(formattedSearchText) || $0.symbol.lowercased().contains(formattedSearchText) || $0.id.lowercased().contains(formattedSearchText)}
    }
    
}
