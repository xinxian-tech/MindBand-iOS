//
//  CommunityViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/5.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var communityScrollView: UIScrollView!
    
    var communityImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityImageView = UIImageView(image: UIImage(named: "Community")!)
        communityScrollView.contentSize = communityImageView!.bounds.size
        communityScrollView.addSubview(communityImageView!)
        communityScrollView.setZoomScale(communityScrollView.bounds.width /
            communityImageView!.bounds.width, animated: true)
    }
    
}


extension CommunityViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return communityImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
    }
}
