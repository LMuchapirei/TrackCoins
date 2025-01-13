//
//  SaecrhBarVIew.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import SwiftUI

struct SaecrhBarVIew: View {
    @Binding var searchText : String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            TextField("Search by name or symbol",text:$searchText)
                .autocorrectionDisabled(true)
                .foregroundStyle(Color.theme.accent)
                .overlay (
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
            /// you may use an overlay on the textfield itself
            /// Add the image as part of the hStack
//            if !searchText.isEmpty {
//                Image(systemName: "xmark.circle.fill")
//                    .foregroundStyle(Color.theme.accent)
//                    .onTapGesture {
//                        searchText = ""
//                    }
//            }
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius : 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10,x: 0,y: 0)
        )
        .padding()
    }
}

#Preview {
    SaecrhBarVIew(searchText: .constant("Hello"))
}
