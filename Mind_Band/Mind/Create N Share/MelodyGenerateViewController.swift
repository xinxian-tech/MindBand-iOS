//
//  MelodyGenerateViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class MelodyGenerateViewController: UIViewController {

    @IBOutlet weak var conditionElementCollectionView: UICollectionView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    
    var conditionalElements: [ConditionalElement] = []
    
    var audioPlayer: AVPlayer?
    var videoPlayer: AVPlayer?
    
    var melody: GeneratedMelody! = {
        let melody = MBDataManager.defaultManager.getAndSaveRandomGeneratedMelody()
        return melody
    }()
    var shouldSaveMelody: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = melody.melodyTitle
        updateMelodyWithCondition()
        setupGradientView()
        loadMelodyAudio()
        loadVideoPlayer()
        updateMelodyWithCondition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMelodyShareViewController" {
            let destination = segue.destination as! MelodyShareViewController
            destination.melody = melody
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        if !shouldSaveMelody {
            MBDataManager.defaultManager.removeMelody(id: melody.id!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = topGradientView.bounds
        topGradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func loadMelodyAudio() {
        print(melody.defaultSongName)
        audioPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultSongName, withExtension: "m4a")!)
        audioPlayer?.play()
    }
    
    private func loadVideoPlayer() {
        videoPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultVideoName!, withExtension: "mov")!)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = self.view.bounds
        playerView.layer.addSublayer(playerLayer)
        videoPlayer?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem)
    }
    
    private func updateMelodyWithCondition() {
        switch conditionalElements.count {
        case 0:
            melody.defaultVideoName = "Galaxy"
        case 1:
            melody.defaultSongName = "Lotus_Single"
        case 2:
            melody.defaultSongName = "Lotus_Dual"
        case 3:
            melody.defaultSongName = "Lotus_Triple"
        case 4:
            if conditionalElements.contains(.health) {
                melody.defaultSongName = "Lotus_Quartet_2"
            } else {
                melody.defaultSongName = "Lotus_Quartet_1"
            }
        default:
            return
        }
        MBDataManager.defaultManager.updateMelody(melody: melody)
    }
    
    @objc private func replayVideo() {
        videoPlayer?.seek(to: CMTime.zero)
        videoPlayer?.play()
    }
    
}


extension MelodyGenerateViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return conditionalElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "conditionElementCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
        cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ConditionElementCollectionViewCell
        cell.conditionalElement = conditionalElements[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
