//
//  MindViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SceneKit
import TapticEngine
import SVProgressHUD

class MindViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    private var floatingWindowLockFrame: CGRect = CGRect(x: 23, y: 90, width: 329, height: 597)
    private var floatingWindowView: ConditionEditView?
    
    private var currentImage: UIImage? {
        didSet {
            if floatingWindowView != nil {
                floatingWindowView?.cancelButtonText = "Edit"
                floatingWindowView?.confirmButtonText = "Save"
            }
        }
    }
    
    private var inactiveTextMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.lightGray
        return material
    }()
    
    private var activeTextMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 1, green: 72/255, blue: 133/255, alpha: 1)
        return material
    }()

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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Generating ...")
        delay(for: 2) {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "showCreateNShare", sender: nil)
        }
    }
    
    private var selectedConditions: [ConditionalElement] = []
    private var planetConditionMap: [PlanetEnum:ConditionalElement] = [
        .neptune : .location,
        .venus : .health,
        .saturn : .image,
        .mars : .vocal,
        .jupiter : .weather
    ]

    private func pictureButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .image
        floatingWindowView?.keyImageName = "ImageCondition"
        floatingWindowView?.keyImageView.image = currentImage
        floatingWindowView?.confirmButtonText = "Camera"
        floatingWindowView?.cancelButtonText = "Album"
        floatingWindowView?.titleLabel.text = "Add a Picture"
        floatingWindowView?.descriptionLabel.text = "Add a picture to the melody, and feel its feeling."
        animateFloatingWindowIn()
    }
    
    private func weatherButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .weather
        floatingWindowView?.keyImageName = "WorkoutCondition"
        floatingWindowView?.titleLabel.text = "Add a Weather"
        floatingWindowView?.confirmButtonText = "Save"
        floatingWindowView?.descriptionLabel.text = "Turn the weather into a part of melody."
        animateFloatingWindowIn()
    }
    
    private func locationButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.keyImageName = "LocationCondition"
        floatingWindowView?.confirmButtonText = "Confirm"
        floatingWindowView?.conditionalElement = .location
        floatingWindowView?.cancelButtonText = "Edit"
        floatingWindowView?.titleLabel.text = "Add a Location"
        floatingWindowView?.descriptionLabel.text = "Listen to the melody of the certain location."
        animateFloatingWindowIn()
    }
    
    private func hummingButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .vocal
        floatingWindowView?.keyImageName = "HummingCondition"
        floatingWindowView?.confirmButtonText = "Start"
        floatingWindowView?.confirmButton.backgroundColor = UIColor(red: 249/255, green:
            58/255, blue: 96/255, alpha: 0.6)
        floatingWindowView?.cancelButtonText = "Cancel"
        animateFloatingWindowIn()
    }
    
    private func workoutButtonTapped() {
        prepareFloatingWindow()
        floatingWindowView?.conditionalElement = .health
        floatingWindowView?.keyImageName = "WorkoutCondition"
        floatingWindowView?.titleLabel.text = "Add Workout Info"
        floatingWindowView?.confirmButtonText = "Save"
        floatingWindowView?.descriptionLabel.text = "The melody would tell what you're feeling right now."
        animateFloatingWindowIn()
    }
    
    private func setupSCNView() {
        let scene = SCNScene()
        
        // Neptune Setup
        let neptuneNode = PlanetNode(planet: .neptune)
        neptuneNode.position = SCNVector3(0.2, 0.7, -0.3)
        neptuneNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 30)))
        let locationText = SCNText(string: "Location", extrusionDepth: 0.02)
        locationText.firstMaterial = inactiveTextMaterial
        let neptuneTextNode = SCNNode(geometry: locationText)
        neptuneTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        neptuneTextNode.position = SCNVector3(-0.11, -0.25, 0)
        neptuneNode.addChildNode(neptuneTextNode)
        scene.rootNode.addChildNode(neptuneNode)
        
        // Venus Setup
        let venusNode = PlanetNode(planet: .venus)
        venusNode.position = SCNVector3(0.3, 0.2, -0.1)
        venusNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 40)))
        let workoutText = SCNText(string: "Workout", extrusionDepth: 0.02)
        workoutText.firstMaterial = inactiveTextMaterial
        let venusTextNode = SCNNode(geometry: workoutText)
        venusTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        venusTextNode.position = SCNVector3(-0.11, -0.20, 0)
        venusNode.addChildNode(venusTextNode)
        scene.rootNode.addChildNode(venusNode)
        
        // Saturn Setup
        let saturnNode = PlanetNode(planet: .saturn)
        saturnNode.position = SCNVector3(-0.2, 0, 0)
        saturnNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 35)))
        let imageText = SCNText(string: "Image", extrusionDepth: 0.02)
        imageText.firstMaterial = inactiveTextMaterial
        let saturnTextNode = SCNNode(geometry: imageText)
        saturnTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        saturnTextNode.position = SCNVector3(-0.07, -0.25, 0)
        saturnNode.addChildNode(saturnTextNode)
        scene.rootNode.addChildNode(saturnNode)
        
        // Mars Setup
        let marsNode = PlanetNode(planet: .mars)
        marsNode.position = SCNVector3(-0.4, 0.5, 0.1)
        marsNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 52)))
        let hummingText = SCNText(string: "Humming", extrusionDepth: 0.02)
        hummingText.firstMaterial = inactiveTextMaterial
        let marsTextNode = SCNNode(geometry: hummingText)
        marsTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        marsTextNode.position = SCNVector3(-0.12, -0.18, 0)
        marsNode.addChildNode(marsTextNode)
        scene.rootNode.addChildNode(marsNode)
        
        // Jupiter
        let jupiterNode = PlanetNode(planet: .jupiter)
        jupiterNode.position = SCNVector3(0.4, -0.3, -0.15)
        jupiterNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 84)))
        let weatherText = SCNText(string: "Weather", extrusionDepth: 0.02)
        weatherText.firstMaterial = inactiveTextMaterial
        let jupiterTextNode = SCNNode(geometry: weatherText)
        jupiterTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        jupiterTextNode.position = SCNVector3(-0.11, -0.25, 0)
        jupiterNode.addChildNode(jupiterTextNode)
        scene.rootNode.addChildNode(jupiterNode)
        
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
        let location = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(location, options: [:])
        if hitResults.count != 0 {
            let result = hitResults.first!.node as? PlanetNode
            guard result != nil else {
                switchPlanetSelectStatus(planet: .saturn, childNodeIndex: 2)
                return
            }
            switch result!.planetType {
            case .saturn:
                switchPlanetSelectStatus(planet: .saturn, childNodeIndex: 2)
            case .jupiter:
                switchPlanetSelectStatus(planet: .jupiter)
            case .mars:
                switchPlanetSelectStatus(planet: .mars)
            case .neptune:
                switchPlanetSelectStatus(planet: .neptune)
            case .venus:
                switchPlanetSelectStatus(planet: .venus)
            default:
                break
            }
        }
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == UIGestureRecognizer.State.began else {return}
        gestureRecognizer.state = .ended
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
    
    private func removeFloatingWindow() {
        animateFloatingWindowOut() {
            self.floatingWindowView?.removeFromSuperview()
        }
    }
    
    private func switchPlanetSelectStatus(planet: PlanetEnum, childNodeIndex: Int = 0) {
        TapticEngine.impact.feedback(.heavy)
        if selectedConditions.contains(planetConditionMap[planet]!) {
            setPlanetDeselected(planet: planet, childNodeIndex: childNodeIndex)
        } else {
            setPlanetSelected(planet: planet, childNodeIndex: childNodeIndex)
        }
    }
    
    private func setPlanetSelected(planet: PlanetEnum, childNodeIndex: Int = 0) {
        for node in scnView.scene!.rootNode.childNodes {
            if node is PlanetNode && (node as! PlanetNode).planetType == planet {
                node.childNodes[childNodeIndex].geometry?.firstMaterial = activeTextMaterial
                selectedConditions.append(planetConditionMap[planet]!)
            }
        }
    }
    
    private func setPlanetDeselected(planet: PlanetEnum, childNodeIndex: Int = 0) {
        for node in scnView.scene!.rootNode.childNodes {
            if node is PlanetNode && (node as! PlanetNode).planetType == planet {
                node.childNodes[childNodeIndex].geometry?.firstMaterial = inactiveTextMaterial
                selectedConditions = selectedConditions.filter({$0 != planetConditionMap[planet]!})
            }
        }
    }
    
}


extension MindViewController: ConditionEditDelegate {
    func closeButtonDidTapped() {
        currentImage = nil
        removeFloatingWindow()
    }
    
    func confirmButtonDidTapped() {
        guard floatingWindowView != nil else {return}
        switch floatingWindowView!.conditionalElement {
        case .image:
            if currentImage == nil {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
            } else {
                animateFloatingWindowOut(completion: nil)
            }
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
                removeFloatingWindow()
            }
        default:
            break
        }
    }
    
    func cancelButtonDidTapped() {
        guard floatingWindowView != nil else {return}
        switch floatingWindowView!.conditionalElement {
        case .image:
            if currentImage == nil {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
            } else {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                let alertController = UIAlertController(title: "Choose the photo source", message: nil, preferredStyle: .actionSheet)
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true, completion: nil)
                }
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true, completion: nil)
                }
                alertController.addAction(photoLibraryAction)
                alertController.addAction(cameraAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alertController, animated: true, completion: nil)
            }
        default:
            removeFloatingWindow()
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
        currentImage = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
