//
//  Bullet.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 3/20/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import UIKit
import SpriteKit

class Bullet: SKSpriteNode {

    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        if bulletSound != nil {
            run(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
