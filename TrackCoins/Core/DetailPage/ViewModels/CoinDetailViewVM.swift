//
//  CoinDetailViewVM.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 11/2/2025.
//

import Foundation
import Combine


class CoinDetailViewVM: ObservableObject {
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    init(coin:CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(generateStatistics)
            .sink {[weak self] returnedArrays in
                self?.additionalStatistics = returnedArrays.additional
                self?.overviewStatistics = returnedArrays.overview
            }
            .store(in: &cancellables)
    }
    
    private func generateStatistics(coinDetailModel:CoinDetailModel?,coinModel: CoinModel)-> (overview: [StatisticModel],additional:[StatisticModel]) {
        let overviewArray = self.createOverviewArray(coinDetailModel:coinDetailModel, coinModel:coinModel)
        let additionalDetailArray = self.createAdditionalDetailsArray(coinDetailModel:coinDetailModel, coinModel:coinModel)
        return (overviewArray,additionalDetailArray)
    }
    
    private func createOverviewArray(coinDetailModel:CoinDetailModel?,coinModel: CoinModel) -> [StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" +  (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "" )
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [priceStat,marketCapStat,rankStat,volumeStat]
        return overviewArray
    }
    
    private func createAdditionalDetailsArray(coinDetailModel:CoinDetailModel?,coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let priceChangePercent = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: priceChangePercent)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat]
        return additionalArray
    }
}
