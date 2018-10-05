//
//  BasicStructures.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

enum ConditionalElement: Int {
    case image = 0
    case light = 1
    case emoji = 2
    case weather = 3
    case vocal = 4
    case health = 5
    case location = 6
    
    func getCardImage() -> UIImage {
        switch self {
        case .image:
            return UIImage(named: "ImageCard")!
        case .light:
            return UIImage(named: "LightCard")!
        case .emoji:
            return UIImage(named: "EmojiCard")!
        case .weather:
            return UIImage(named: "WeatherCard")!
        case .vocal:
            return UIImage(named: "VocalCard")!
        case .health:
            return UIImage(named: "HealthCard")!
        case .location:
            return UIImage(named: "LocationCard")!
        }
    }
}

