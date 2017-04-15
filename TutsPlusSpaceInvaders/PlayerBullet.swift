//
//  PlayerBullet.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 3/20/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerBullet: Bullet {
    
    override init(imageName: String, bulletSound:String?){
        super.init(imageName: imageName, bulletSound: bulletSound)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.PlayerBullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}

