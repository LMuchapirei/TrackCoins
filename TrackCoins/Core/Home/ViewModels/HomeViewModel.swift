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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    @Published var sortOption: SortOption = .holdings
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank,rankReversed,holdings,holdingReversed,price,priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){        
        $searchText
            .combineLatest(coinDataService.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Delay to allow running filtering after a valid word to filter with
            .map(filterAndSortCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink {[weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsOnDemand(coins:returnedCoins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(generateStatistics)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
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
    
    func reloadData() {
        self.isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        NotificationManager.notification(type: .success)
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
    
    private func filterAndSortCoins(searchQuery: String, allCoins: [CoinModel],sortOption:SortOption)-> [CoinModel]{
        var filteredCoins = filterCoins(searchQuery:searchQuery,allCoins:allCoins)
        sortCoins(sort: sortOption, coins: &filteredCoins) // we are changing the array in place we have to set it using the & in front, indicate an appropriate param to an inout function
        return filteredCoins
    }
    /// inout means sort or deal with the array in place and the sort function does that
    private func sortCoins(sort: SortOption,coins: inout [CoinModel]) {
        switch sort {
        case .rank,.holdings:
                 coins.sort { $0.rank < $1.rank }
        case .rankReversed,.holdingReversed:
                 coins.sort { $0.rank > $1.rank }
            case .price:
                 coins.sort { $0.currentPrice < $1.currentPrice }
            case .priceReversed:
                 coins.sort { $0.currentPrice > $1.currentPrice }
           
        }
    }
    
    private func sortPortfolioCoinsOnDemand(coins:[CoinModel]) -> [CoinModel] {
        // sort only by holdings or revesed holdings if needed
        switch sortOption {
        case .holdings:
                return  coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingReversed:
                 return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    private func filterCoins(searchQuery: String, allCoins: [CoinModel])-> [CoinModel] {
        guard  !searchQuery.isEmpty else {
            return allCoins
        }
        let formattedSearchText = searchQuery.lowercased()
        return  allCoins.filter { $0.name.lowercased().contains(formattedSearchText) || $0.symbol.lowercased().contains(formattedSearchText) || $0.id.lowercased().contains(formattedSearchText)}
    }
    
}
