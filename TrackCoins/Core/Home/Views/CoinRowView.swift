//
//  CoinRowView.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 10/1/2025.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColumn: Bool
    var body: some View {
        HStack (alignment:.center){
            leftCoulmn()
            Spacer()
            centerColumn()
            rightColumn()
        }
        .padding(.horizontal,5)
        .font(.subheadline)
    }
    
    @ViewBuilder
    func leftCoulmn() -> some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
/// Seems simpler for me to do this implementation but for learning sake we will implement a custom view to download and show the images
//            if let url = URL(string: coin.image) {
//                AsyncImage(url: url){ phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        image.resizable()
//                            .scaledToFit()
//                    case .failure:
//                        Circle()
//                            
//                    @unknown default:
//                        Circle()
//                            
//                        
//                    }
//                    
//                }
//                .frame(width: 30,height: 30)
//            } else {
//                Circle()
//                    .frame(width: 30,height: 30)
//            }
            CoinImageView(coin: coin)
                .frame(width: 30,height:30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundStyle(Color.theme.accent)

        }
    }
    
    @ViewBuilder
    func centerColumn() -> some View {
        if showHoldingsColumn {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .bold()
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundStyle(Color.theme.accent)
        }
    }
    
    @ViewBuilder
    func rightColumn() -> some View {
        VStack (alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
            Text("\(coin.priceChangePercentage24H?.asPercentString() ?? "0%")")
                .foregroundStyle(coin.priceChangePercentage24H ?? 0 >= 0 ?
                                 Color.theme.green :
                                 Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing) // becuase we are in potrait mode we can get away with this, otherwise we can use a geometry reader
    }
}

#Preview {
    CoinRowView(
        coin: DeveloperPreview.instance.coin,
        showHoldingsColumn: true
    )
}
