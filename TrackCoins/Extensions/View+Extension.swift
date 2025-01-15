//
//  View+Extension.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 14/1/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
        func conditionalModifier<Content: View>(
            _ condition: Bool,
            modifier: (Self) -> Content
        ) -> some View {
            if condition {
                modifier(self)
            } else {
                self
            }
        }
}
