//
//  MelodyGenerator.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/1/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import Foundation

class MelodyGenerator: NSObject {
    static var shared = MelodyGenerator()
    
    func generateMelody(mediaElements: [MediaElement], completion: ((URL) -> ())?) {
        completion?(mediaElements.first!.token!.token)
    }
}
