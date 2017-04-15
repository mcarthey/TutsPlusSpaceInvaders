//
//  GameScene.swift
//  TutsPlusSpaceInvaders
//
//  Created by Mark McArthey on 3/19/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

var currentLevel = 1

struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = []
    let player: Player = Player()
    var livesText: SKLabelNode = SKLabelNode(text: "Lives:")
    let maxLevels = 3
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        backgroundColor = SKColor.black
        
        let starField = SKEmitterNode(fileNamed: "StarField")!
        starField.position = CGPoint(x: size.width/2, y: size.height+300)
        starField.zPosition = -1000
        addChild(starField)
        
        livesText.fontName = "ChalkDuster"
        livesText.horizontalAlignmentMode = .left
        livesText.position = CGPoint(x: 0, y: size.height-livesText.fontSize)
        addChild(livesText)
        
        rightBounds = self.size.width - 30
        setupInvaders()
        setupPlayer()
        invokeInvaderFire()
        setupAccelerometer()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.fireBullet(scene: self)
    }
    override func update(_ currentTime: TimeInterval) {
        moveInvaders()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
            NSLog("Invader and Player Bullet Contact")
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            let invadersPerRow = currentLevel * 2 + 1
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            let newInvaderColumn = theInvader.invaderColumn
            if(newInvaderRow >= 1){
                self.enumerateChildNodes(withName: "invader") { node, stop in
                    let invader = node as! Invader
                    if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
                        self.invadersWhoCanFire.append(invader)
                        stop.pointee = true
                    }
                }
            }
            let invaderIndex = findIndex(array: invadersWhoCanFire,valueToFind: firstBody.node as! Invader)
            if(invaderIndex != nil){
                invadersWhoCanFire.remove(at: invaderIndex!)
            }
            theInvader.removeFromParent()
            secondBody.node?.removeFromParent()
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            NSLog("Player and Invader Bullet Contact")
            livesText.text = "Lives:\(player.lives)"
            player.die()
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            NSLog("Invader and Player Collision Contact")
            player.kill()
            
        }
    }
    func setupInvaders() {
        let numberOfColumns = currentLevel * 2 + 1
        let invaderRowBuffer: CGFloat = 10
        let invaderColBuffer: CGFloat = 14
        
        for row in 1...rowsOfInvaders {
            for col in 1...numberOfColumns {
                let tempInvader: Invader = Invader()
                let invaderWidthSpace = tempInvader.size.width + invaderRowBuffer
                let invaderHeightSpace = tempInvader.size.height + invaderColBuffer
                
                let invaderRowSpace: CGFloat = CGFloat(numberOfColumns) * invaderWidthSpace
                
                let xPositionStart:CGFloat = size.width/2 - invaderRowSpace/2
                let invaderPosition = CGPoint(x:xPositionStart + CGFloat(col-1) * invaderWidthSpace,
                                              y:self.size.height - CGFloat(row) * invaderHeightSpace)
                
                tempInvader.position = invaderPosition
                tempInvader.invaderRow = row
                tempInvader.invaderColumn = col
                
                addChild(tempInvader)
                
                // only the bottommost invaders can fire
                if row == rowsOfInvaders {
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }
    func setupPlayer() {
        player.position = CGPoint(x:self.frame.midX, y:player.size.height/2 + 10) // 10 points off bottom
        livesText.text = "Lives:\(player.lives)"
        addChild(player)
    }
    
    func moveInvaders() {
        var changeDirection = false
        
        enumerateChildNodes(withName: "invader") { node, stop in
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if invader.position.x > self.rightBounds - invaderHalfWidth ||
                invader.position.x < self.leftBounds + invaderHalfWidth {
                changeDirection = true
            }
            
            if changeDirection == true {
                self.invaderSpeed *= -1
                self.enumerateChildNodes(withName: "invader") { node, stop in
                    let invader = node as! SKSpriteNode
                    invader.position.y -= CGFloat(46)
                }
                changeDirection = false
            }
        }
    }
    
    func invokeInvaderFire() {
        let fireBullet = SKAction.run() {
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
    }
    func fireInvaderBullet() {
        if invadersWhoCanFire.isEmpty {
            currentLevel += 1
            levelComplete()
        } else {
            let randomInvader = invadersWhoCanFire.randomElement()
            randomInvader.fireBullet(scene: self)
        }
    }
    
    func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
        for (index,value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    func levelComplete(){
        if(currentLevel <= maxLevels){
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(levelCompleteScene,transition: transitionType)
        }else{
            currentLevel = 1
            newGame()
        }
    }
    func newGame() {
        let gameOverScene = StartGameScene(size: size)
        gameOverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: transitionType)
    }
    func setupAccelerometer() {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerometerData: CMAccelerometerData!, error: Error!) in
            let acceleration = accelerometerData.acceleration
            self.accelerationX = CGFloat(acceleration.x)
        })
    }
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: accelerationX*600, dy: 0)
    }
}
