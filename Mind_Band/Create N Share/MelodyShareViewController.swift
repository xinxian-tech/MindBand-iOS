//
//  MelodyShareViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MelodyShareViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 16
        publishButton.layer.cornerRadius = 16
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
