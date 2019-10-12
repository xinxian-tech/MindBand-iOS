//
//  MelodyPresentationView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/6/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

protocol Presentation {
    var view: UIView {get}
    func prepare(mediaElements: [MediaElement])
    func present()
}

class MelodyPresentationView: UIView {
    
    var mediaElements: [MediaElement]?
    var audioPlayer: AVAudioPlayer?
    
    var presentationView: Presentation?
    
    func preparePresentation(mediaElements: [MediaElement], audioURL: URL) {
        audioPlayer = try! AVAudioPlayer(contentsOf: audioURL)
        audioPlayer?.numberOfLoops = -1
        switch mediaElements.first!.identifier {
        case .emoji:
            presentationView = EmojiPresentationView()
        case .image:
            presentationView = ImagePresentationView()
        case .humming:
            break
        }
        addSubview(presentationView!.view)
        NSLayoutConstraint.activate([
            presentationView!.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            presentationView!.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            presentationView!.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            presentationView!.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        presentationView!.prepare(mediaElements: mediaElements)
    }
    
    func showPresentation() {
        presentationView?.present()
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
}



