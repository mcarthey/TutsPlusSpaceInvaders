//
//  Invader.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 3/19/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import UIKit
import SpriteKit

class Invader: SKSpriteNode {

    var invaderRow = 0
    var invaderColumn = 0
    
    init() {
        let texture = SKTexture(imageNamed: "invader1")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "invader"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Invader
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireBullet(scene: SKScene){
        let bullet = InvaderBullet(imageName: "laser",bulletSound: nil)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y - self.size.height/2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
    }
}
