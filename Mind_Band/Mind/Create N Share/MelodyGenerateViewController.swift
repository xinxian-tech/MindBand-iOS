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
    @IBOutlet weak var videoWKWebView: WKWebView!
    
    var conditionalElements: [ConditionalElement] = []
    
    var audioPlayer: AVPlayer?
    
    let melody: GeneratedMelody = {
        let melody = MBDataManager.defaultManager.getAndSaveRandomGeneratedMelody()
        return melody
    }()
    var shouldSaveMelody: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = melody.melodyTitle
        setupGradientView()
        setupWebKitView()
        loadGeneratedVideo()
        loadMelodyAudio()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
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
    
    private func setupWebKitView() {
        videoWKWebView.isOpaque = false
        videoWKWebView.scrollView.backgroundColor = .black
        videoWKWebView.scrollView.isScrollEnabled = false
        videoWKWebView.scrollView.maximumZoomScale = 1
        videoWKWebView.scrollView.minimumZoomScale = 1
    }
    
    private func loadMelodyAudio() {
        audioPlayer = AVPlayer(url: Bundle.main.url(forResource: melody.defaultSongName, withExtension: ".m4a")!)
        audioPlayer?.play()
    }
    
    private func loadGeneratedVideo() {
        let gifURL = Bundle.main.url(forResource: melody.defaultVideoName, withExtension: "gif")!
        let gifData = try! Data(contentsOf: gifURL)
        videoWKWebView.load(gifData, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: gifURL)
        delay(for: durationForGifData(data: gifData), block: {self.loadGeneratedVideo()})
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
