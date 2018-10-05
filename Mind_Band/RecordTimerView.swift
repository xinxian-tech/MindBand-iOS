//
//  RecordTimerView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class RecordTimerView: UIView {
    
    @IBOutlet weak var blurView: UIVisualEffectView! {
        didSet {
            blurView.layer.cornerRadius = blurView.frame.height / 2
            blurView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var recordingIndicatorView: UIView! {
        didSet {
            recordingIndicatorView.layer.cornerRadius = recordingIndicatorView.frame.height / 2
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    var currentTime: Int = 0
    
    lazy var timer: Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
        self.updateTime()
    }
    
    private func updateTime() {
        currentTime += 1
        let minuteNotation = (currentTime / 60).digitExtended(to: 2)
        let secondNotation = (currentTime % 60).digitExtended(to: 2)
        currentTimeLabel.text = minuteNotation + ":" + secondNotation
    }
    
}
