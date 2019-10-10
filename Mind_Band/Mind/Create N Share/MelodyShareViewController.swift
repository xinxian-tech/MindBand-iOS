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

    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var publishButton: UIButton! {
        didSet {
            publishButton.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var presentationContrainerView: UIView!
    
    let melodyGenerator = MelodyGenerator.shared
    
    var melodyPresentationView: MelodyPresentationView = {
        let view = MelodyPresentationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var mediaElements: [MediaElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationContrainerView.addSubview(melodyPresentationView)
        NSLayoutConstraint.activate([
            melodyPresentationView.topAnchor.constraint(equalTo: presentationContrainerView.topAnchor, constant: 0),
            melodyPresentationView.bottomAnchor.constraint(equalTo: presentationContrainerView.bottomAnchor, constant: 0),
            melodyPresentationView.leadingAnchor.constraint(equalTo: presentationContrainerView.leadingAnchor, constant: 0),
            melodyPresentationView.trailingAnchor.constraint(equalTo: presentationContrainerView.trailingAnchor, constant: 0)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        melodyGenerator.generateMelody(mediaElements: mediaElements) { audioURL in
            self.melodyPresentationView.preparePresentation(
                mediaElements: self.mediaElements,
                audioURL: audioURL
            )
            self.melodyPresentationView.showPresentation()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
