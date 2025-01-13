//
//  CoinImageService.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 11/1/2025.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    var imageSubscription : AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return
        }
        imageSubscription = NetworkingManager.download(url: url)
                            .tryMap({(data) -> UIImage? in
                                return UIImage(data: data)
                            })
                            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                                guard let self = self,let downloadedImage = returnedImage else { return } /// guard on the returnedImage fixed an error thrown on the return type of out tryMap call above
                                self.image = downloadedImage
                                self.imageSubscription?.cancel()
                                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
        })
    }
}
