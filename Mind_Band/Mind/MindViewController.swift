//
//  MindViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/3.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SceneKit
import SVProgressHUD

class MindViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    private var mediaElements: [PlanetEnum : MediaElement?] = [
        .neptune : nil,
        .saturn : nil,
        .jupiter : nil
    ]
    
    private var inactiveTextMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.lightGray
        return material
    }()
    
    private var activeTextMaterial: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 255/255, green: 72/255, blue: 133/255, alpha: 1)
        return material
    }()
    
    private var jupiterTextNode: SCNNode!
    private var neptuneTextNode: SCNNode!
    private var saturnTextNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSCNView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCreateNShare":
            let destination = (segue.destination as! UINavigationController)
                .viewControllers.first! as! MelodyGenerateViewController
            destination.mediaElements = Array(mediaElements.values).filter({$0 != nil}) as! [MediaElement]
        default:
            break
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showCreateNShare", sender: nil)
    }
    
    private var selectedConditions: [ConditionalElement] = []
    private var planetConditionMap: [PlanetEnum:ConditionalElement] = [
        .neptune : .vocal,
        .saturn : .image,
        .jupiter : .emoji
    ]
    
    private func planetButtonTapped(planet: PlanetEnum) {
        var vc: MediaElementAddViewController!
        switch planet {
        case .saturn:
            vc = ImageElementAddViewController()
        case .neptune:
            vc = HummingElementViewController()
        case .jupiter:
            vc = EmojiElementViewController()
        default:
            break
        }
        vc.mediaElement = mediaElements[planet]!
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    private func setupSCNView() {
        let scene = SCNScene()
        
        // Neptune Setup
        let neptuneNode = PlanetNode(planet: .neptune)
        neptuneNode.position = SCNVector3(0.35, 0.7, 0)
        neptuneNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 20)))
        let locationText = SCNText(string: "Humming", extrusionDepth: 0.02)
        locationText.firstMaterial = inactiveTextMaterial
        neptuneTextNode = SCNNode(geometry: locationText)
        neptuneTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        neptuneTextNode.position = SCNVector3(-0.11, -0.25, 0) + neptuneNode.position
        scene.rootNode.addChildNode(neptuneTextNode)
        scene.rootNode.addChildNode(neptuneNode)
        
        // Saturn Setup
        let saturnNode = PlanetNode(planet: .saturn)
        saturnNode.position = SCNVector3(0, 0.22, 0)
        saturnNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 20)))
        let imageText = SCNText(string: "Image", extrusionDepth: 0.02)
        imageText.firstMaterial = inactiveTextMaterial
        saturnTextNode = SCNNode(geometry: imageText)
        saturnTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        saturnTextNode.position = SCNVector3(-0.07, -0.25, 0) + saturnNode.position
        scene.rootNode.addChildNode(saturnTextNode)
        scene.rootNode.addChildNode(saturnNode)
        
        // Jupiter
        let jupiterNode = PlanetNode(planet: .jupiter)
        jupiterNode.position = SCNVector3(-0.4, 0.7, 0)
        jupiterNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 20)))
        let weatherText = SCNText(string: "Emoji", extrusionDepth: 0.02)
        weatherText.firstMaterial = inactiveTextMaterial
        jupiterTextNode = SCNNode(geometry: weatherText)
        jupiterTextNode.scale = SCNVector3(0.005, 0.005, 0.005)
        jupiterTextNode.position = SCNVector3(-0.11, -0.25, 0) + jupiterNode.position
        scene.rootNode.addChildNode(jupiterTextNode)
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
        scnView.allowsCameraControl = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(location, options: [:])
        if hitResults.count != 0 {
            let result = hitResults.first!.node as? PlanetNode
            guard result != nil else {
                // The result is saturn's loop
                planetButtonTapped(planet: .saturn)
//                switchPlanetSelectStatus(planet: .saturn, childNodeIndex: 2)
                return
            }
            planetButtonTapped(planet: result!.planetType)
        }
    }
    
//    private func switchPlanetSelectStatus(planet: PlanetEnum, childNodeIndex: Int = 0) {
//        TapticEngine.impact.feedback(.heavy)
//        if selectedConditions.contains(planetConditionMap[planet]!) {
//            setPlanetDeselected(planet: planet, childNodeIndex: childNodeIndex)
//        } else {
//            setPlanetSelected(planet: planet, childNodeIndex: childNodeIndex)
//        }
//    }
    
    private func setPlanetSelected(planet: PlanetEnum, childNodeIndex: Int = 0) {
        switch planet {
        case .saturn:
            saturnTextNode.geometry?.firstMaterial = activeTextMaterial
        case .jupiter:
            jupiterTextNode.geometry?.firstMaterial = activeTextMaterial
        case .neptune:
            neptuneTextNode.geometry?.firstMaterial = activeTextMaterial
        default:
            return
        }
        selectedConditions.append(planetConditionMap[planet]!)
    }
    
    private func setPlanetDeselected(planet: PlanetEnum, childNodeIndex: Int = 0) {
        switch planet {
        case .saturn:
            saturnTextNode.geometry?.firstMaterial = inactiveTextMaterial
        case .jupiter:
            jupiterTextNode.geometry?.firstMaterial = inactiveTextMaterial
        case .neptune:
            neptuneTextNode.geometry?.firstMaterial = inactiveTextMaterial
        default:
            return
        }
        selectedConditions = selectedConditions.filter({$0 != planetConditionMap[planet]!})
    }
    
}


extension MindViewController: MediaElementAddDelegate {
    func mediaElementSelected(element: MediaElement) {
        setPlanetDeselected(planet: .neptune)
        setPlanetDeselected(planet: .jupiter)
        setPlanetDeselected(planet: .saturn, childNodeIndex: 2)
        
        switch element.identifier {
        case .humming:
            mediaElements[.neptune] = element
            setPlanetSelected(planet: .neptune)
        case .emoji:
            mediaElements[.jupiter] = element
            setPlanetSelected(planet: .jupiter)
        case .image:
            mediaElements[.saturn] = element
            setPlanetSelected(planet: .saturn, childNodeIndex: 2)
        }
    }
}
