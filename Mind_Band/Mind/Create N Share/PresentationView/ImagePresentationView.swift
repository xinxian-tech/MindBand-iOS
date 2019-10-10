//
//  ImagePresentationView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/6/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit

class ImagePresentationView: UIImageView, Presentation {
    
    var view: UIView {
        get {
            return self
        }
    }
    
    func prepare(mediaElements: [MediaElement]) {
        guard mediaElements.first! is ImageElement else {return}
        translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(data: try! Data(contentsOf: (mediaElements.first! as! ImageElement).imageContentURL!))
        self.contentMode = .scaleAspectFit
    }
    
    func present() {
    }
    
}
