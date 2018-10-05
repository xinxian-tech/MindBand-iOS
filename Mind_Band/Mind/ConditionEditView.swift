//
//  ConditionEditView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol ConditionEditDelegate: class {
    func closeButtonDidTapped()
    func confirmButtonDidTapped()
    func cancelButtonDidTapped()
}

enum ControlState {
    case ready
    case active
    case done
}

class ConditionEditView: UIView {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var keyImageView: UIImageView! {
        didSet {
            keyImageView.image = UIImage(named: keyImageName ?? "No Image")
            keyImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.cornerRadius = 16
            confirmButton.setTitle(confirmButtonText, for: .normal)
        }
    }
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 16
            cancelButton.setTitle(cancelButtonText, for: .normal)
        }
    }
    @IBOutlet weak var timerView: RecordTimerView! {
        didSet {
            let nib = UINib(nibName: "RecordTimer", bundle: Bundle.main)
            let view = nib.instantiate(withOwner: self, options: nil).first as? RecordTimerView
            view?.frame = timerView.frame
            timerView = view
            self.addSubview(timerView)
            timerView.isHidden = true
        }
    }
    
    var confirmButtonText: String = "Start" {
        didSet {
            guard confirmButton != nil else {return}
            confirmButton.setTitle(confirmButtonText, for: .normal)
        }
    }
    var cancelButtonText: String = "Quit" {
        didSet {
            guard cancelButton != nil else {return}
            cancelButton.setTitle(cancelButtonText, for: .normal)
        }
    }
    var keyImageName: String? {
        didSet {
            guard keyImageView != nil else {return}
            keyImageView.image = UIImage(named: keyImageName ?? "No Image")
        }
    }
    var controlState: ControlState = .ready
    
    var conditionalElement: ConditionalElement = .image
    
    weak var delegate: ConditionEditDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeButtonDidTapped()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cancelButtonDidTapped()
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        delegate?.confirmButtonDidTapped()
    }
    
    func activateTimer() {
        timerView.isHidden = false
        timerView.timer.fire()
    }
    
    func stopTimer() {
        timerView.timer.invalidate()
    }
    
}
