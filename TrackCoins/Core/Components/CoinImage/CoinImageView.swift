//
//  CoinImageView.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 11/1/2025.
//

import SwiftUI


struct CoinImageView: View {
    @StateObject var vm: CoinImageViewModel
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue:CoinImageViewModel(coinModel: coin)) // how you actually reference state objects
    }
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if vm.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.theme.secondaryText)
        }
    }
}

//#Preview {
////    CoinImageView()
//}
