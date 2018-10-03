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
            destination.conditionalElements = selectedConditions
        default:
            break
        }
    }
    
    private var selectedConditions: [ConditionalElement] = [.image, .vocal, .health, .emoji]

    @IBAction func pictureButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .image
        floatingWindowView?.keyImageName = "ImageCondition"
        floatingWindowView?.confirmButtonText = "Camera"
        floatingWindowView?.cancelButtonText = "Album"
        animateFloatingWindowIn()
    }
    
    @IBAction func weatherButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .weather
        
        animateFloatingWindowIn()
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        floatingWindowView?.keyImageName = "LocationCondition"
        floatingWindowView?.confirmButtonText = "Confirm"
        floatingWindowView?.cancelButtonText = "Edit"
        animateFloatingWindowIn()
    }
    
    @IBAction func hummingButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .vocal
        floatingWindowView?.confirmButtonText = "Start"
        floatingWindowView?.cancelButtonText = "Quit"
        animateFloatingWindowIn()
    }
    
    @IBAction func workoutButtonTapped(_ sender: UIButton) {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .health
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
        guard floatingWindowView != nil else {return}
        switch floatingWindowView!.conditionalElement {
        case .image:
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func cancelButtonDidTapped() {
        guard floatingWindowView != nil else {return}
        switch floatingWindowView!.conditionalElement {
        case .image:
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        default:
            break
        }
    }
}


extension MindViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        floatingWindowView?.keyImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
