//
//  PlaceholderGeneration.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/6.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class DemoEngine {
    
    static let defaultEngine = DemoEngine()
    
    private let melodyKeyImageNames: [String] = [
        "MelodyTitle_1",
        "MelodyTitle_2",
        "MelodyTitle_3",
        "MelodyTitle_4"
    ]
    
    private let melodyNames: [String] = [
        "Lotus",
        "Lotus_Dual",
        "Lotus_Quartet_1",
        "Lotus_Quartet_2",
        "Lotus_Single",
        "Lotus_Triple"
    ]
    
    private let melodyTitles: [String] = [
        "Shadow Rain",
        "Old Days",
        "Club Hint"
    ]
    
    private let videoNames: [String] = [
        "Spring_1"
    ]
    
    func generateTitle() -> String {
        return melodyTitles[random(min: 0, max: melodyTitles.count)]
    }
    
    func generateMelodyKeyImageName() -> String {
        return melodyKeyImageNames[random(min: 0, max: melodyKeyImageNames.count)]
    }
    
    func generateMelodyName() -> String {
        return melodyNames[random(min: 0, max: melodyNames.count)]
    }
    
    func generateVideoName() -> String {
        return videoNames[random(min: 0, max: videoNames.count)]
    }
    
    private func random(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
}
