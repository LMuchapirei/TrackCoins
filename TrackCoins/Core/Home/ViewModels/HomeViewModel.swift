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
    private let portfolioDataService = PortfolioDataService()
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
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink {[weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(generateStatistics)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        

    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins:[CoinModel],portfolioEntities:[PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {
                    return nil
                }
                
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    func updatePortfolio(coin: CoinModel,amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func generateStatistics(marketDataModel: MarketDataModel?,portfolioCoins:[CoinModel])-> [StatisticModel] {
        var statisticsData : [StatisticModel] = []
        guard let data = marketDataModel else { return statisticsData}
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24hr Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0,+)
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0.0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue ) / previousValue) * 100
        let portfolio = StatisticModel(title: "Portifolio Value", value: portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange)
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
