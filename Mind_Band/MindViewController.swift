//
//  MindViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MindViewController: UIViewController {
    
    private var floatingWindowLockFrame: CGRect = CGRect(x: 23, y: 90, width: 329, height: 597)
    private var floatingWindowView: ConditionEditView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showGenerateViewController":
            let destination = (segue.destination as! UINavigationController)
                .viewControllers.first! as! MelodyGenerateViewController
            // Do Someting
        default:
            break
        }
    }

    @IBAction func pictureButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        animateFloatingWindowIn()
    }
    
    @IBAction func weatherButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        animateFloatingWindowIn()
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        animateFloatingWindowIn()
    }
    
    @IBAction func hummingButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        animateFloatingWindowIn()
    }
    
    @IBAction func workoutButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        animateFloatingWindowIn()
    }
    
    private func prepareFloatingWindow() {
        let nib = UINib(nibName: "ConditionEditView", bundle: Bundle.main)
        floatingWindowView = nib.instantiate(withOwner: self, options: nil).first as? ConditionEditView
        floatingWindowView?.frame = floatingWindowLockFrame
        floatingWindowView?.delegate = self
        floatingWindowView?.alpha = 0
        self.view.addSubview(floatingWindowView!)
    }
    
    private func animateFloatingWindowIn() {
        UIView.animate(withDuration: 0.2, delay: 0, options:
            UIView.AnimationOptions.curveLinear, animations: {
                self.floatingWindowView?.alpha = 1
        }, completion: nil)
    }
    
    private func animateFloatingWindowOut(completion: (() -> ())?) {
        UIView.animate(withDuration: 0.2, delay: 0, options:
            UIView.AnimationOptions.curveLinear, animations: {
                self.floatingWindowView?.alpha = 0
        }, completion: nil)
    }
    
}


extension MindViewController: ConditionEditDelegate {
    func closeButtonDidTapped() {
        animateFloatingWindowOut() {
            self.floatingWindowView?.removeFromSuperview()
        }
    }
    
    func confirmButtonDidTapped() {
        // Confirmation Code
    }
    
    func cancelButtonDidTapped() {
        // Cancellation Code
    }
}
