//
//  XMarkButton.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 14/1/2025.
//

import SwiftUI

struct CustomIconButton: View {
    var iconName: String
    var action: () -> Void

    
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
            Image(systemName: iconName)
        })
    }
}

#Preview {
    CustomIconButton(iconName: "xmark"){
        print("Hello world")
    }
}
