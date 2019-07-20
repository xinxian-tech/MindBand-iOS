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
    
    var melody: GeneratedMelody!
    var shouldSaveMelody: Bool {
        get {
            return (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody
        } set {
            (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody = newValue
        }
    }
    
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
        setupVideoPlayer()
        setupAudioPlayer()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if isPlaying {
            pausePlaying()
        } else {
            if didFinishedPlay {
                replayAudio()
                replayVideo()
            } else {
                resumePlay()
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        shouldSaveMelody = true
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
        if !shouldSaveMelody {
            MBDataManager.defaultManager.removeMelody(id: melody.id!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setupVideoPlayer() {
        videoPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultVideoName, withExtension: "mov")!)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = CGRect(x: 20, y: 0, width: 300, height: 400)
        videoContainerView.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem)
    }
    
    private func setupAudioPlayer() {
        audioPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultSongName, withExtension: "m4a")!)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: audioPlayer?.currentItem)
    }
    
    @objc private func replayVideo() {
        isPlaying = true
        videoPlayer.seek(to: CMTime.zero)
        videoPlayer.play()
    }
    
    private func replayAudio() {
        isPlaying = true
        didFinishedPlay = false
        audioPlayer.seek(to: CMTime.zero)
        audioPlayer.play()
    }
    
    private func pausePlaying() {
        isPlaying = false
        videoPlayer.pause()
        audioPlayer.pause()
    }
    
    @objc private func finishedPlaying() {
        pausePlaying()
        didFinishedPlay = true
    }
    
    private func resumePlay() {
        isPlaying = true
        videoPlayer.play()
        audioPlayer.play()
    }
    
}
