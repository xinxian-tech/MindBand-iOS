//
//  ConditionElementCollectionViewCell.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ConditionElementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var elementImageView: UIImageView!
    
    var mediaElement: MediaElement? {
        didSet {
            elementImageView.image = mediaElement?.identifier.getCardImage()
        }
    }
    
}
