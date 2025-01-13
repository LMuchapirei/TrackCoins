//
//  CoinViewModel.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 11/1/2025.
//

import Foundation
import Combine
import SwiftUI


class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    private let coin: CoinModel
    private let dataService : CoinImageService
    private var cancellables = Set<AnyCancellable>()
    init(coinModel: CoinModel){
        self.coin = coinModel
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    
    private func  addSubscribers(){
        dataService.$image
            .sink { [weak self ] _ in
                self?.isLoading = false
            } receiveValue: {[weak self ]  (uiImage) in
                self?.image = uiImage
            }
            .store(in: &cancellables)
    
    }
}
