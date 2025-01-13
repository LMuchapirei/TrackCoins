//
//  StatisticView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    var body: some View {
        VStack (alignment:.leading,spacing: 4) {
            Text("\(stat.title)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text("\(stat.value)")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack (spacing : 4) {
                    Image(systemName: "triangle.fill")
                    .rotationEffect(isPositiveChange ?   .zero : .degrees(180))
                    .foregroundColor(isPositiveChange ? .green: .red)
                    .font(.caption)
                Text((stat.percentageChange?.asPercentString() ?? ""))
                    .font(.caption)
                .bold()
            }
            .foregroundStyle(isPositiveChange ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0) /// take space but don't show it on the screen
        }
    }
    
    var isPositiveChange : Bool {
        return (stat.percentageChange ?? 0) >= 0
    }
}

#Preview {
    Group {
        StatisticView(stat: DeveloperPreview.instance.stat1)
        StatisticView(stat: DeveloperPreview.instance.stat2)
        StatisticView(stat: DeveloperPreview.instance.stat3)
    }

}
