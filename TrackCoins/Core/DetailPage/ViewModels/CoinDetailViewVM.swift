//
//  CoinDetailViewVM.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 11/2/2025.
//

import Foundation
import Combine


class CoinDetailViewVM: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    init(coin:CoinModel){
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetail
            .sink { returnedCoinDetail in
                print("RECEIVED COIN DETAIL")
                print(returnedCoinDetail)
            }
            .store(in: &cancellables)
    }
}
