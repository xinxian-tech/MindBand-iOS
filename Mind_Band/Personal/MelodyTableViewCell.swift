//
//  MelodyTableViewCell.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/5.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MelodyTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            guard melody != nil else {return}
            backgroundImageView.image = UIImage(named: melody!.titleImageName!)
        }
    }
    @IBOutlet weak var melodyTitleLabel: UILabel! {
        didSet {
            guard melody != nil else {return}
            melodyTitleLabel.text = melody?.melodyTitle
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            guard melody != nil else {return}
            dateLabel.text = dateFormatter.string(from: melody!.date! as Date)
        }
    }
    @IBOutlet weak var blurView: UIVisualEffectView! {
        didSet {
            blurView.layer.cornerRadius = 12
            blurView.layer.masksToBounds = true
        }
    }
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. dd"
        return dateFormatter
    }()
    
    var melody: GeneratedMelody? {
        didSet {
            guard backgroundImageView != nil else {return}
            backgroundImageView.image = UIImage(named: melody!.titleImageName!)
            guard melodyTitleLabel != nil else {return}
            melodyTitleLabel.text = melody?.melodyTitle
            guard dateLabel != nil else {return}
            dateLabel.text = dateFormatter.string(from: melody!.date! as Date)
        }
    }
    
}
