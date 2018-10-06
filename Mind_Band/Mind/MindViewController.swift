//
//  MindViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SceneKit

class MindViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    private var floatingWindowLockFrame: CGRect = CGRect(x: 23, y: 90, width: 329, height: 597)
    private var floatingWindowView: ConditionEditView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSCNView()
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
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    private var selectedConditions: [ConditionalElement] = [.image, .vocal, .health, .emoji]

    func pictureButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .image
        floatingWindowView?.keyImageName = "ImageCondition"
        floatingWindowView?.confirmButtonText = "Camera"
        floatingWindowView?.cancelButtonText = "Album"
        animateFloatingWindowIn()
    }
    
    func weatherButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .weather
        animateFloatingWindowIn()
    }
    
    func locationButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.keyImageName = "LocationCondition"
        floatingWindowView?.confirmButtonText = "Confirm"
        floatingWindowView?.cancelButtonText = "Edit"
        animateFloatingWindowIn()
    }
    
    func hummingButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .vocal
        floatingWindowView?.confirmButtonText = "Start"
        floatingWindowView?.confirmButton.backgroundColor = UIColor(red: 249/255, green:
            58/255, blue: 96/255, alpha: 0.6)
        floatingWindowView?.cancelButtonText = "Cancel"
        floatingWindowView?.keyImageName = "HummingCondition"
        animateFloatingWindowIn()
    }
    
    func workoutButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .health
        animateFloatingWindowIn()
    }
    
    private func setupSCNView() {
        let scene = SCNScene()
        
        // Neptune Setup
        let neptuneNode = PlanetNode(planet: .neptune)
        neptuneNode.position = SCNVector3(0.2, 0.7, -0.3)
        scene.rootNode.addChildNode(neptuneNode)
        neptuneNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 20)))
        
        // Venus Setup
        let venusNode = PlanetNode(planet: .venus)
        venusNode.position = SCNVector3(0.3, 0.2, -0.1)
        scene.rootNode.addChildNode(venusNode)
        venusNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 20)))
        
        // Saturn Setup
        let saturnNode = PlanetNode(planet: .saturn)
        saturnNode.position = SCNVector3(-0.2, 0, 0)
        scene.rootNode.addChildNode(saturnNode)
        saturnNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 25)))
        
        // Mars Setup
        let marsNode = PlanetNode(planet: .mars)
        marsNode.position = SCNVector3(-0.4, 0.5, 0.1)
        scene.rootNode.addChildNode(marsNode)
        marsNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 37)))
        
        // Jupiter
        let jupiterNode = PlanetNode(planet: .jupiter)
        jupiterNode.position = SCNVector3(0.4, -0.3, -0.15)
        scene.rootNode.addChildNode(jupiterNode)
        jupiterNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 45)))
        
        // Camera Setup
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        scene.rootNode.addChildNode(cameraNode)
        
        // Environment Light Setup
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        scene.background.contents = UIImage(named: "Nebula")!
        scnView.scene = scene
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        scnView.addGestureRecognizer(pressGesture)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Tap Gesture Detected.")
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == UIGestureRecognizer.State.ended else {return}
        let location = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(location, options: [:])
        if hitResults.count != 0 {
            let result = hitResults.first!.node as? PlanetNode
            guard result != nil else {
                // The result is saturn's loop
                pictureButtonTapped()
                return
            }
            switch result!.planetType {
            case .saturn:
                pictureButtonTapped()
            case .jupiter:
                weatherButtonTapped()
            case .mars:
                hummingButtonTapped()
            case .neptune:
                locationButtonTapped()
            case .venus:
                workoutButtonTapped()
            default:
                break
            }
        }
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
        case .vocal:
            switch floatingWindowView!.controlState {
            case .ready:
                floatingWindowView?.activateTimer()
                floatingWindowView?.confirmButton.setTitle("Stop", for: .normal)
                floatingWindowView?.controlState = .active
            case .active:
                floatingWindowView?.stopTimer()
                floatingWindowView?.confirmButton.setTitle("Save", for: .normal)
                floatingWindowView?.controlState = .done
            case .done:
                closeButtonDidTapped()
            }
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
        case .vocal:
            closeButtonDidTapped()
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
