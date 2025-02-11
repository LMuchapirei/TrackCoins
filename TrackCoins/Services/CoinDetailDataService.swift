//
//  CoinDetailDataService.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 11/2/2025.
//

import Foundation

import Combine

class CoinDetailDataService {
    @Published var coinDetail: CoinDetailModel?
    var coinDetailSubscription : AnyCancellable?
    let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
        getCoinDetail()
    }
    
    public func getCoinDetail(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return
        }
        coinDetailSubscription = NetworkingManager.download(url: url)
                            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
                            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetailModel) in
                                self?.coinDetail = returnedCoinDetailModel
                                self?.coinDetailSubscription?.cancel()
        })
                    
    }
}
