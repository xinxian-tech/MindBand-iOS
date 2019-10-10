//
//  MediaElement.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/13/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit

enum MediaElementIdentifier {
    case humming
    case image
    case emoji
    
    func getCardImage() -> UIImage {
        switch self {
        case .image:
            return UIImage(named: "ImageCard")!
        case .emoji:
            return UIImage(named: "EmojiCard")!
        case .humming:
            return UIImage(named: "VocalCard")!
        }
    }
}

protocol MediaElement {
    var identifier: MediaElementIdentifier {get set}
    var token: MediaElementToken? {get set}
    func prepareContent(content: Any)
    func fetchToken(completion: (() -> ())?)
}

class HummingElement: MediaElement {
    var identifier: MediaElementIdentifier = .humming
    var token: MediaElementToken?
    var hummingContentURL: URL?
    
    func prepareContent(content: Any) {
        guard content is URL else {return}
        hummingContentURL = content as? URL
    }
    
    func fetchToken(completion: (() -> ())?) {
        guard hummingContentURL != nil else {return}
        TokenGenerator.shared.getHummingToken(url: hummingContentURL!) { token in
            self.token = token
            completion?()
        }
    }
}

class EmojiElement: MediaElement {
    var identifier: MediaElementIdentifier = .emoji
    var token: MediaElementToken?
    var emoji: String?
    
    func prepareContent(content: Any) {
        guard content is String else {return}
        emoji = content as? String
    }
    
    func fetchToken(completion: (() -> ())?) {
        guard emoji != nil else {return}
        TokenGenerator.shared.getEmojiToken(emoji: emoji!) { token in
            self.token = token
            completion?()
        }
    }
}

class ImageElement: MediaElement {
    var identifier: MediaElementIdentifier = .image
    var token: MediaElementToken?
    var imageContentURL: URL?
    
    func prepareContent(content: Any) {
        guard content is URL else {return}
        imageContentURL = content as? URL
    }
    
    func fetchToken(completion: (() -> ())?) {
        guard imageContentURL != nil else {return}
        TokenGenerator.shared.getImageToken(url: imageContentURL!) { token in
            self.token = token
            completion?()
        }
    }
}
