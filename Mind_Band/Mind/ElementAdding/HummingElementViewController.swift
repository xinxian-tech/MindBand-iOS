//
//  HummingElementViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/18/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation

class HummingElementViewController: MediaElementAddViewController {
    
    var switchRecordingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Recording", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(switchRecordingButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var switchPreviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        button.addTarget(self, action: #selector(switchPreviewingButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let audioCaptureDevice = AVCaptureDevice.default(for: .audio)
    private var audioRecorder: AVAudioRecorder?
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?
    private var isRecording: Bool = false {
        didSet {
            if isRecording {
                if isPreviewing {
                    audioPlayer?.pause()
                    isPreviewing = false
                }
                switchRecordingButton.setTitle("Stop Recording", for: .normal)
            } else {
                switchRecordingButton.setTitle("Start Recording", for: .normal)
            }
            switchPreviewButton.isHidden = isRecording
        }
    }
    private var isPreviewing: Bool = false {
        didSet {
            if isPreviewing {
                switchPreviewButton.setImage(UIImage(named: "PauseButton"), for: .normal)
            } else {
                switchPreviewButton.setImage(UIImage(named: "PlayButton"), for: .normal)
            }
        }
    }
    
    let dataManager = MBDataManager.defaultManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMediaElement()
        contentView.addSubview(switchRecordingButton)
        contentView.addSubview(switchPreviewButton)
        NSLayoutConstraint.activate([
            switchRecordingButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            switchRecordingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            switchRecordingButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor, multiplier: 1),
            switchRecordingButton.heightAnchor.constraint(equalTo: confirmButton.heightAnchor, multiplier: 1)
        ])
        NSLayoutConstraint.activate([
            switchPreviewButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            switchPreviewButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            switchPreviewButton.widthAnchor.constraint(equalToConstant: 64),
            switchPreviewButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    @objc func switchRecordingButtonTapped(_ sender: UIButton) {
        if isRecording {
            audioRecorder?.stop()
            mediaElement?.prepareContent(content: audioURL!)
            audioPlayer = try! AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.delegate = self
            setConfirmButtonEnabled()
        } else {
            audioURL = dataManager.getTemporaryURL(postfix: "wav")
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(.playAndRecord, mode: .default)
            try! session.setActive(true)
            let recordSettings: [String : Any] = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try! AVAudioRecorder(url: audioURL!, settings: recordSettings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
        isRecording = !isRecording
    }
    
    @objc func switchPreviewingButtonTapped(_ sender: UIButton) {
        if isPreviewing {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPreviewing = !isPreviewing
    }
    
    private func loadMediaElement() {
        if mediaElement == nil {
            mediaElement = HummingElement()
        } else {
            setConfirmButtonEnabled()
            audioURL = (mediaElement as! HummingElement).hummingContentURL!
            audioPlayer = try! AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.delegate = self
            switchPreviewButton.isHidden = false
        }
    }
}

extension HummingElementViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.pause()
        audioPlayer?.currentTime = 0
        isPreviewing = false
    }
}
