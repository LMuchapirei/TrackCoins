//
//  MarketDataService.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import Foundation
import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription : AnyCancellable?
    init(){
        getMarketData()
    }
    
    public func getMarketData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return
        }
        marketDataSubscription = NetworkingManager.download(url: url)
                            .decode(type: GlobalData.self, decoder: JSONDecoder())
                            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedMarketData) in
                                self?.marketData = returnedMarketData.data
                                self?.marketDataSubscription?.cancel()
        })
                    
    }
}

