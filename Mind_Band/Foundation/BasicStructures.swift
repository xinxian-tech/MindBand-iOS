//
//  BasicStructures.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SceneKit

enum ConditionalElement: Int {
    case image = 0
    case light = 1
    case emoji = 2
    case weather = 3
    case vocal = 4
    case health = 5
    case location = 6
    
    func getCardImage() -> UIImage {
        switch self {
        case .image:
            return UIImage(named: "ImageCard")!
        case .light:
            return UIImage(named: "LightCard")!
        case .emoji:
            return UIImage(named: "EmojiCard")!
        case .weather:
            return UIImage(named: "WeatherCard")!
        case .vocal:
            return UIImage(named: "VocalCard")!
        case .health:
            return UIImage(named: "HealthCard")!
        case .location:
            return UIImage(named: "LocationCard")!
        }
    }
}


class Planet: NSObject {
    var diffuse: UIImage
    var specular: UIImage?
    var emission: UIImage?
    var normal: UIImage?
    var radius: CGFloat
    var anxisTime: Double
    var revolutionTime: Double?
    var distance: Double
    var hasChild:Bool?
    
    init(radius: CGFloat, diffuse: UIImage, specular: UIImage? = nil, emission:
        UIImage? = nil, normal: UIImage? = nil, anxisTime: Double, revolTime:
        Double = 0, distance: Double, hasChild: Bool? = false ) {
        self.radius = radius
        self.diffuse = diffuse
        self.specular = specular
        self.emission = emission
        self.normal = normal
        self.anxisTime = anxisTime
        self.revolutionTime = revolTime
        self.distance = distance
        self.hasChild = hasChild
    }
}


enum PlanetEnum {
    case sun
    case mercury
    case venus
    case earth
    case moon
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    case pluto
    
    func getPlanet() -> Planet {
        switch self {
        case .sun:
            return Planet(radius: 0.1, diffuse: UIImage(named: "sun")!, specular: nil, emission:
                UIImage(named: "sun_halo"), normal: nil, anxisTime: 0, revolTime:
                0, distance: 0, hasChild: true)
        case .mercury:
            return Planet(radius: 0.02, diffuse: UIImage(named: "mercury")!, anxisTime:
                10, revolTime: 12, distance: 0.4);
        case .venus:
            return Planet(radius: 0.12, diffuse: UIImage(named: "venus")!, anxisTime:
                12, revolTime: 14, distance: 0.6);
        case .earth:
            return Planet(radius: 0.05, diffuse: UIImage(named: "earth_diffuse")!, specular:
                UIImage(named: "earth_specular")!, emission: UIImage(named: "earth-emissive")!, normal:
                nil, anxisTime: 16, revolTime: 18, distance: 0.8, hasChild:true);
        case .moon:
            return Planet(radius: 0.01, diffuse: UIImage(named: "moon")!, specular:
                nil, emission: nil, normal: nil, anxisTime: 2, revolTime: 6, distance: 0.1);
        case .mars:
            return Planet(radius: 0.1, diffuse: UIImage(named: "mars")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 14, revolTime: 16, distance: 1.0);
        case .jupiter:
            return Planet(radius: 0.15, diffuse: UIImage(named: "jupiter")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 24, revolTime: 28, distance: 1.4);
        case .saturn:
            return Planet(radius: 0.12, diffuse: UIImage(named: "saturn")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 32, revolTime: 30, distance: 1.68, hasChild:true);
        case .uranus:
            return Planet(radius: 0.09, diffuse: UIImage(named: "uranus")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 20, revolTime: 32, distance: 1.95);
        case .neptune:
            return Planet(radius: 0.15, diffuse: UIImage(named: "neptune")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 28, revolTime: 36, distance: 2.14);
        case .pluto:
            return Planet(radius: 0.04, diffuse: UIImage(named: "pluto")!, specular: nil, emission:
                nil, normal: nil, anxisTime: 32, revolTime: 40, distance: 2.319);
        }
    }
}


class PlanetNode: SCNNode {
    /// Planet type
    let planetType:PlanetEnum
    ///
    var node:SCNNode!
    /// Use average of recent virtual object distances to avoid rapid changes in object scale.
    private var recentVirtualObjectDistances = [Float]()
    
    /// Resets the objects poisition smoothing.
    func reset() {
        recentVirtualObjectDistances.removeAll()
    }
    
    init(planet: PlanetEnum) {
        
        self.planetType = planet
        let planetData = planet.getPlanet()
        
        super.init()
        
        let geome = SCNSphere(radius: planetData.radius)
        geome.firstMaterial?.diffuse.contents = planetData.diffuse
        geome.firstMaterial?.specular.contents = planetData.specular
        geome.firstMaterial?.emission.contents = planetData.emission
        geome.firstMaterial?.normal.contents = planetData.normal
        self.position = SCNVector3(planetData.distance, 0, 0)
        
        if(planetData.hasChild!) {
            
            node = SCNNode()
            node.geometry = geome
            node.position = SCNVector3(0, 0, 0)
            self.addChildNode(node)
            
            if !planetData.anxisTime.isZero {
                node.runAction(getPlanetRotation(duration: planetData.anxisTime)) }
        } else {
            
            self.geometry = geome
            if !planetData.anxisTime.isZero {
                self.runAction(getPlanetRotation(duration: planetData.anxisTime)) }
        }
        
        /// addLight as sun
        self.addLight(planet: planet)
        /// addLoop as saturn
        self.addPlanetLoop(planet: planet)
    }
    
    private func getPlanetOribit(planet: Planet) -> SCNNode {
        
        let oribitNode = SCNNode()
        oribitNode.position = SCNVector3(0, 0, 0)
        
        let ringRadius = planet.distance
        oribitNode.geometry = SCNTorus(ringRadius: CGFloat(ringRadius), pipeRadius: 0.0004)
        oribitNode.geometry?.firstMaterial?.multiply.contents = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3)
        
        return oribitNode
    }
    //
    private func addPlanetLoop(planet: PlanetEnum) {
        
        if planet == .saturn {
            
            let loopNode = PlanetLoop(planet: planet)
            self.addChildNode(loopNode)
        }
    }
    //
    private func addLight(planet: PlanetEnum) {
        
        if planet == .sun {
            
            let lightNode = SCNNode()
            
            lightNode.light = SCNLight()
            lightNode.light?.color = UIColor.white
            lightNode.light?.type = .omni
            node?.addChildNode(lightNode)
            
            /// add sun halo
            let haloNode = SCNNode()
            haloNode.geometry = SCNPlane(width: 1.2, height: 1.2)
            haloNode.rotation = SCNVector4(0, 0, 1, -Float.pi/2)
            haloNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "sun_halo")
            haloNode.geometry?.firstMaterial?.lightingModel = .constant
            haloNode.geometry?.firstMaterial?.writesToDepthBuffer = false
            haloNode.opacity = 0.8
            node?.addChildNode(haloNode)
        }
    }
    //
    private func getPlanetRotation(duration: Double) -> SCNAction {
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: duration)
        let forever = SCNAction.repeatForever(action)
        return forever
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PlanetNode {
    
    /// Returns a `PlanetNode` if one exists as an ancestor to the provided node.
    static func existingObjectContainingNode(_ node: SCNNode) -> PlanetNode? {
        if let planetNodeRoot = node as? PlanetNode {
            return planetNodeRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a `planetNode`.
        return existingObjectContainingNode(parent)
    }
}


class PlanetLoop: SCNNode {
    init(planet: PlanetEnum) {
        
        super.init()
        
        self.opacity = 0.4;
        self.geometry = SCNBox(width: 0.55, height: 0, length: 0.55, chamferRadius: 0)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "saturn_loop")
        //self.geometry?.firstMaterial?.diffuse.mipFilter = .linear;
        self.rotation = SCNVector4Make(0, 0, 1, Float(30.degreesToRadians));
        //self.geometry?.firstMaterial?.lightingModel = .constant;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

