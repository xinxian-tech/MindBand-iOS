//
//  MelodyShareViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MelodyShareViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    
    var melody: GeneratedMelody!
    var shouldSaveMelody: Bool {
        get {
            return (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody
        } set {
            (self.navigationController?.viewControllers[0] as! MelodyGenerateViewController).shouldSaveMelody = newValue
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        shouldSaveMelody = true
        let alertController = UIAlertController(title: "Melody Saved.", message: "You can find the melody in your personal center.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if !shouldSaveMelody {
            MBDataManager.defaultManager.removeMelody(id: melody.id!)
        }
        dismiss(animated: true, completion: nil)
    }
}
