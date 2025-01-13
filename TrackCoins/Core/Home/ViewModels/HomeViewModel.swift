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
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){        
        $searchText
            .combineLatest(dataService.$allCoins)
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
