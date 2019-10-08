//
//  MelodyShareViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD

class MelodyShareViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var playButtonBlurView: UIVisualEffectView! {
        didSet {
            playButtonBlurView.layer.cornerRadius = 15
            playButtonBlurView.layer.masksToBounds = true
        }
    }
    
    var mediaElements: [MediaElement] = []
    
    private var videoPlayer: AVPlayer!
    private var audioPlayer: AVPlayer!
    
    private var didFinishedPlay: Bool = true
    private var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playButton.setTitle("Pause", for: .normal)
            } else {
                playButton.setTitle("Play", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 16
        publishButton.layer.cornerRadius = 16
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Melody Saved.", message:
            "You can find the melody in your personal center.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        SVProgressHUD.showSuccess(withStatus: "Published!")
        delay(for: 2) {
            self.doneButtonTapped(sender)
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
