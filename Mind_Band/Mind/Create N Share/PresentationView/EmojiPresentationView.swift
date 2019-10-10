//
//  EmojiPresentationView.swift
//  Mind_Band
//
//  Created by 李灿晨 on 10/6/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit
import SpriteKit

class EmojiPresentationView: SKView, Presentation {
    
    var view: UIView {
        get {
            return self
        }
    }
    
    var emoji: String = "👻"
    var size: CGFloat = 32
    var timeUnit: TimeInterval = 0.4
    var radian: CGFloat = .pi
    var scaleFactor: CGFloat = 3
    var direction: CGVector = CGVector(dx: 100, dy: 100)
    
    var horizontalDistance: CGFloat = 64
    var verticalDistance: CGFloat = 64
    
    private var horizontalNodeCount: Int?
    private var verticalNodeCount: Int?
    private var emojiArray: [EmojiLabelNode] = []
    
    func prepare(mediaElements: [MediaElement]) {
        guard mediaElements.first! is EmojiElement else {return}
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        emoji = (mediaElements.first! as! EmojiElement).emoji!
        presentScene(getScene())
        placeEmojies()
    }
    
    func present() {
        animateEmojies()
    }
    
    private func getScene() -> SKScene {
        let scene = SKScene()
        scene.backgroundColor = .black
        scene.scaleMode = .resizeFill
        return scene
    }
    
    private func placeEmojies() {
        let screenSize = UIScreen.main.bounds.size
        horizontalNodeCount = Int(ceil(screenSize.width / horizontalDistance)) + 2
        verticalNodeCount = Int(ceil(screenSize.height / verticalDistance)) + 2
        let horizontalOffset = screenSize.width / 2.0 - CGFloat(horizontalNodeCount! + 1) / CGFloat(2) * horizontalDistance - direction.dx / CGFloat(2)
        let verticalOffset = screenSize.height / 2.0 - CGFloat(verticalNodeCount! + 1) / CGFloat(2) * verticalDistance - direction.dy / CGFloat(2)
        for row in 0 ..< verticalNodeCount! {
            for col in 0 ..< horizontalNodeCount! {
                let node = EmojiLabelNode(emoji: emoji, size: size)
                node.position = CGPoint(
                    x: horizontalDistance * CGFloat(col) + horizontalOffset,
                    y: verticalDistance * CGFloat(row) + verticalOffset
                )
                emojiArray.append(node)
                scene?.addChild(node)
            }
        }
    }
    
    private func animateEmojies() {
        for node in emojiArray {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Float.random(in: 0 ..< 1)), repeats: false) { timer in
                node.animate(
                    timeUnit: self.timeUnit,
                    radian: self.radian,
                    scaleFactor: self.scaleFactor,
                    direction: self.direction
                )
            }
        }
    }
}


class EmojiLabelNode: SKLabelNode {
    init(emoji: String, size: CGFloat) {
        super.init()
        self.text = emoji
        self.fontSize = size
        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(timeUnit: TimeInterval, radian: CGFloat, scaleFactor: CGFloat, direction: CGVector) {
        let action = SKAction.group([
            .move(by: direction, duration: timeUnit * 2),
            .scale(by: scaleFactor, duration: timeUnit),
            .scale(by: CGFloat(1) / scaleFactor, duration: timeUnit),
            .rotate(byAngle: radian, duration: timeUnit * 2)
        ])
        action.timingMode = .easeInEaseOut
        self.run(.repeatForever(.sequence([
            action,
            action.reversed()
        ])))
    }
}
