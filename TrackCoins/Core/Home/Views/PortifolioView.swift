//
//  PortifolioView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import SwiftUI

struct PortifolioView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing: 0) {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
            }
            .navigationTitle("Edit Portifolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    CustomIconButton(iconName: "xmark") {
                        dismiss()
                    }
                }
            })
        }
    }
}

#Preview {
    PortifolioView()
}
