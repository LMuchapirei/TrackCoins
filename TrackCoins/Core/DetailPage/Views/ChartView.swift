//
//  ChartView.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 4/3/2025.
//

import SwiftUI

struct ChartView: View {
    private  let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        self.endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    // Maths to come up with the graph
    // 60,000 - max
    // 50,000 - min
    // 60,000 - 50,000 = 10,000 - yAxis
    // 52,000 - data point
    // 52,000 - 50,000 = 2,000 / 10,000 = 20%
    var body: some View {
        VStack {
            chartView()
             .frame(height: 200)
             .background {
                 chartBackground()
             }
             .overlay(
                 yAxisLabelView()
                    .padding(.horizontal,4)
                ,alignment: .leading
             )
            datesView()
        }
        .font(.caption)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation (.linear(duration: 2.0)){
                    percentage = 1.0
                }
            }
        }
    }
    
    @ViewBuilder
    func datesView()-> some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
    @ViewBuilder
    func chartBackground() -> some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    @ViewBuilder
    func yAxisLabelView()-> some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY+minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    
    @ViewBuilder
    func chartView() -> some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1-CGFloat((data[index]-minY) / yAxis)) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from:0,to: percentage)
            .stroke(self.lineColor,style: StrokeStyle(lineWidth:2 ,lineCap: .round,lineJoin: .round))
            .shadow(color:lineColor,radius: 6,x:0.0,y:10)
            .shadow(color:lineColor.opacity(0.5),radius: 6,x:0.0,y:20)
            .shadow(color:lineColor.opacity(0.2),radius: 6,x:0.0,y:30)
            .shadow(color:lineColor.opacity(0.1),radius: 6,x:0.0,y:40)

        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}
