//
//  MelodyTableViewCell.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/5.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MelodyTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var waveImageView: UIImageView!
    @IBOutlet weak var melodyTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var melody: GeneratedMelody? {
        didSet {
            
        }
    }
    
}
