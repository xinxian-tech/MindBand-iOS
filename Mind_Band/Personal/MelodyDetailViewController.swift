//
//  MelodyDetailViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/7.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD

class MelodyDetailViewController: UIViewController {
    
    @IBOutlet weak var publishButton: UIButton!
    
    var melody: GeneratedMelody!
    var shouldSaveMelody: Bool {
        get {
            return (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody
        } set {
            (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody = newValue
        }
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var playButtonBlurView: UIVisualEffectView! {
        didSet {
            playButtonBlurView.layer.cornerRadius = 15
            playButtonBlurView.layer.masksToBounds = true
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
        publishButton.layer.cornerRadius = 16
        setupVideoPlayer()
        setupAudioPlayer()
        titleLabel.text = melody.melodyTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        SVProgressHUD.showSuccess(withStatus: "Published!")
        delay(for: 2) {
            SVProgressHUD.dismiss()
        }
    }
    
    private func setupVideoPlayer() {
        videoPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultVideoName, withExtension: "mov")!)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = CGRect(x: 40, y: 0, width: 300, height: 400)
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
