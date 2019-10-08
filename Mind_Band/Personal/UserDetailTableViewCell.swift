//
//  UserDetailTableViewCell.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/5.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userPortraitImageView: UIImageView! {
        didSet {
            userPortraitImageView.layer.cornerRadius = userPortraitImageView.frame.width / 2
            userPortraitImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    
}
