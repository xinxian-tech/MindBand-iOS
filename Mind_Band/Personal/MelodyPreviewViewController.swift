//
//  MelodyPreviewViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/7.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import AVKit

class MelodyPreviewViewController: AVPlayerViewController {
    
    var videoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!)
        self.player = player
    }
    
}
