//
//  NotificationManager.swift
//  TrackCoins
//
//  Created by Linval Muchapirei on 16/1/2025.
//

import Foundation
import SwiftUI

class NotificationManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
