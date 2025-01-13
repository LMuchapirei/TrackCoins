//
//  TrackCoinsApp.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 13/1/2025.
//

import SwiftUI

@main
struct TrackCoinsApp: App {
    @StateObject private var vm  = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
