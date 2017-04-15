//
//  PulsatingText.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 4/14/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import UIKit
import SpriteKit

class PulsatingText: SKLabelNode {

    func setTextFontSizeAndPulsate(theText: String, theFontSize: CGFloat){
        self.text = theText;
        self.fontSize = theFontSize
        
        let scaleAction1 = SKAction.scale(to: 2.0, duration: 1)
        let scaleAction2 = SKAction.scale(to: 1.0, duration: 1)
        let scaleSequence = SKAction.sequence([scaleAction1, scaleAction2])
        let scaleForever = SKAction.repeatForever(scaleSequence)
        self.run(scaleForever)
    }
}
