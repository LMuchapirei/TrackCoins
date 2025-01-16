//
//  PortifolioView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import SwiftUI

struct PortifolioView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin : CoinModel?
    @State private var quantity: String = ""
    @State private var showCheckMark = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    buildCoinSelectionList()
                    
                    if selectedCoin != nil {
                        buildPortfolioInput()
                    }
                }
            }
            .navigationTitle("Edit Portifolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    CustomIconButton(iconName: "xmark") {
                        dismiss()
                    }
                }
                
                if !quantity.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                       saveHoldings()
                    }

                }
            })
            .onChange(of: vm.searchText) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
    
    @ViewBuilder
    func saveHoldings()-> some View {
        HStack {
            if showCheckMark {
                Image(systemName: "checkmark")
            }
            Button (action:{
                savePressed()
            }) {
                Text("SAVE")
            }
        }
    }
    
    @ViewBuilder
    func buildCoinSelectionList() -> some View {
        ScrollView(.horizontal,showsIndicators:false) {
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .conditionalModifier(selectedCoin?.id == coin.id, modifier: { view in
                            view.background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.theme.green,lineWidth:1)
                            )
                        })
                }
                .padding(.vertical,4)
                .padding(.leading)
                .padding(.bottom,5)
            }
        }
    }
    
    @ViewBuilder
    func buildPortfolioInput()-> some View {
        VStack(spacing:20){
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text("\(selectedCoin?.currentPrice.asNumberString() ?? "")")
            }
            .padding(.top,5)
            
            Divider()
            HStack {
                Text("Amount in your holdings")
                Spacer()
                TextField("Ex: 1.5",text:$quantity)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            
            Divider()
            
            HStack {
                Text("Current Value")
                Spacer()
                Text("\(getCurrentValue().asCurrencyWith2Decimals())")
            }
            
        }
        .padding(.horizontal,10)

    }
    
    private func getCurrentValue()-> Double {
        guard let quantityValue = Double(quantity),let currentPrice = selectedCoin?.currentPrice else { return 0.0 }
        return quantityValue * currentPrice
    }
    
    private func savePressed() {
        guard let coin = selectedCoin else { return }
        
        /// save to portfolio
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        vm.searchText = ""
        selectedCoin = nil
    }
}

#Preview {
    PortifolioView()
        .environmentObject(DeveloperPreview.instance.homeVM)
}
