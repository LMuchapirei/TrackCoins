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
    @Published var statistics = [StatisticModel(title: "Market Cap", value: "12.34Tr", percentageChange: -2.45),StatisticModel(title: "Total Volume", value: "2.34Tr", percentageChange: 2.45),StatisticModel(title: "Portfolio value", value: "12.34Mil", percentageChange: -8.45),StatisticModel(title: "Trading Volume", value: "2.34Tr", percentageChange: -2.45)]
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){        
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Delay to allow running filtering after a valid word to filter with
            .map(filterCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(searchQuery: String, allCoins: [CoinModel])-> [CoinModel] {
        guard  !searchQuery.isEmpty else {
            return allCoins
        }
        let formattedSearchText = searchQuery.lowercased()
        return  allCoins.filter { $0.name.lowercased().contains(formattedSearchText) || $0.symbol.lowercased().contains(formattedSearchText) || $0.id.lowercased().contains(formattedSearchText)}
    }
    
}
