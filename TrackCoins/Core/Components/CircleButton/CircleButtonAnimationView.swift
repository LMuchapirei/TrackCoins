//
//  CircleButtonAnimationView.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 10/1/2025.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    var body: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 5.0))
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeIn(duration: 1.0): .none,value: animate)

    }
}

#Preview {
    CircleButtonAnimationView(
        animate: .constant(false)
    )
}
