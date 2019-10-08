//
//  ConditionalMelody.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/1/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import Foundation

class ConditionalMelody {
    
    var mediaElements: [MediaElement]
    var cashedAudioFileURL: URL?
    
    init(mediaElements: [MediaElement]) {
        self.mediaElements = mediaElements
    }
    
    func generate() {
        MelodyGenerator.shared.generateMelody(mediaElements: self.mediaElements) { url in
            self.cashedAudioFileURL = url
        }
    }
    
}
