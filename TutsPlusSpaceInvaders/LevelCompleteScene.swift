//
//  LevelCompleteScene.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 4/6/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import Foundation
import SpriteKit

class LevelCompleteScene:SKScene{
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        let starField = SKEmitterNode(fileNamed: "StarField")!
        starField.position = CGPoint(x:size.width/2, y:size.height+300)
        starField.zPosition = -1000
        addChild(starField)
        
        let invaderText = PulsatingText(fontNamed: "ChalkDuster")
        invaderText.setTextFontSizeAndPulsate(theText: "LEVEL COMPLETE", theFontSize: 50)
        invaderText.position = CGPoint(x:size.width/2, y:size.height/2 + 200)
        addChild(invaderText)
        
        let startGameButton = SKSpriteNode(imageNamed: "nextlevelbtn")
        startGameButton.position = CGPoint(x: size.width/2, y: size.height/2-100)
        startGameButton.name = "nextlevel"
        addChild(startGameButton)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode.name == "nextlevel" {
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: transitionType)
        }
    }

}
