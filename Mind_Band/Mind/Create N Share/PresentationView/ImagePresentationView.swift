//
//  ImagePresentationView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/6/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePresentationView: UIImageView, Presentation {
    
    var videoPlayer: AVPlayer?
    var videoLayer: AVPlayerLayer?
    let dataManager = MBDataManager.defaultManager
    
    var view: UIView {
        get {
            return self
        }
    }
    
    func prepare(mediaElements: [MediaElement]) {
        guard mediaElements.first! is ImageElement else {return}
        translatesAutoresizingMaskIntoConstraints = false
        if let url = (mediaElements.first! as! ImageElement).imageContentURL {
            if dataManager.isFileExist(url: url.deletingPathExtension().appendingPathExtension("mov")) {
                videoPlayer = AVPlayer(url: url.deletingPathExtension().appendingPathExtension("mov"))
                videoPlayer?.volume = 0.0
                videoLayer = AVPlayerLayer(player: videoPlayer)
                layer.addSublayer(videoLayer!)
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem, queue: .main) { notification in
                    self.videoPlayer?.seek(to: CMTime.zero)
                    self.videoPlayer?.play()
                }
            } else {
                self.image = UIImage(data: try! Data(contentsOf: (mediaElements.first! as! ImageElement).imageContentURL!))
                self.contentMode = .scaleAspectFit
            }
        }
    }
    
    func present() {
        videoPlayer?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer?.frame = bounds
    }
    
}
