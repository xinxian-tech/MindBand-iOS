//
//  File.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SceneKit

func delay(for seconds: Double, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
            //catch the error somehow
        }
    }
}

func durationForGifData(data: Data) -> Double {
    let gifSource = CGImageSourceCreateWithData(data as CFData, nil)!
    let numberOfImages = CGImageSourceGetCount(gifSource)
    var duration: Double = 0
    for i in 0 ..< numberOfImages {
        duration += delayForImageAtIndex(index: i, source: gifSource)
    }
    return duration
}

fileprivate func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
    var delay = 0.0
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
    var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
    if delayObject.doubleValue == 0 {
        delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
    }
    delay = delayObject as! Double
    return delay
}

fileprivate let minimumHitArea = CGSize(width: 50, height: 50)

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        return (largerFrame.contains(point)) ? self : nil
    }
}


extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    
    func digitExtended(to digits: Int) -> String {
        var stringRepresentation = String(self)
        while stringRepresentation.count < digits {
            stringRepresentation = "0" + stringRepresentation
        }
        return stringRepresentation
    }
}


func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
}
