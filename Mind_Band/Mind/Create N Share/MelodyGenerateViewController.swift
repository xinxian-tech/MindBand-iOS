//
//  MelodyGenerateViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class MelodyGenerateViewController: UIViewController {

    @IBOutlet weak var conditionElementCollectionView: UICollectionView!
    @IBOutlet weak var topGradientView: UIView!
    
    var mediaElements: [MediaElement] = []
    var melodyPresentationView: MelodyPresentationView = {
        let view = MelodyPresentationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let melodyGenerator = MelodyGenerator.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView()
        view.insertSubview(melodyPresentationView, at: 0)
        NSLayoutConstraint.activate([
            melodyPresentationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            melodyPresentationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            melodyPresentationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            melodyPresentationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show(withStatus: "Analyzing Media Types")
        self.melodyPresentationView.preparePresentation(
            mediaElements: self.mediaElements
//            audioURL: audioURL
        )
        SVProgressHUD.dismiss()
        self.melodyPresentationView.showPresentation()
//        mediaElements.first!.fetchToken() {
//            self.melodyGenerator.generateMelody(mediaElements: self.mediaElements) { audioURL in
//                self.melodyPresentationView.preparePresentation(
//                    mediaElements: self.mediaElements,
//                    audioURL: audioURL
//                )
//                SVProgressHUD.dismiss()
//                self.melodyPresentationView.showPresentation()
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMelodyShareViewController" {
            let destination = segue.destination as! MelodyShareViewController
            destination.mediaElements = mediaElements
            destination.melodyPresentationView = melodyPresentationView
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = topGradientView.bounds
        topGradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}


extension MelodyGenerateViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return mediaElements.count
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
        cell.mediaElement = mediaElements[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
