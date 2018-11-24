//
//  CoreElements.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-24.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    
    static let ANIMAL_CATEGORY:UInt32 = 0x1 << 0
    static let OBSTACLE_CATEGORY:UInt32 = 0x1 << 1
    static let POWERUP_CATEGORY:UInt32 = 0x1 << 2
    static let GROUND_CATEGORY:UInt32 = 0x1 << 3
   // static let OTHER_CATEGORY:UInt32 = 0x1 << 4
}

extension GameScene {
    
    
    
    func createAnimalNode() -> SKSpriteNode {
        
        //Load an animal texture from the selection
        //TODO It should be based on player animal SELECTION
        let animalNode = SKSpriteNode(texture: SKTextureAtlas(named:"Animals").textureNamed("bird1"))
        animalNode.size = CGSize(width: 50, height: 50)
        animalNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        
        //2
        animalNode.physicsBody = SKPhysicsBody(circleOfRadius: animalNode.size.width / 2)
        animalNode.physicsBody?.linearDamping = 1.1
        animalNode.physicsBody?.restitution = 0
        
        
        //3
        animalNode.physicsBody?.categoryBitMask = CollisionBitMask.ANIMAL_CATEGORY
        animalNode.physicsBody?.collisionBitMask = CollisionBitMask.OBSTACLE_CATEGORY | CollisionBitMask.GROUND_CATEGORY
        
        animalNode.physicsBody?.contactTestBitMask = CollisionBitMask.OBSTACLE_CATEGORY | CollisionBitMask.POWERUP_CATEGORY | CollisionBitMask.GROUND_CATEGORY
        
        
        //4
        animalNode.physicsBody?.affectedByGravity = false
        animalNode.physicsBody?.isDynamic = true
        
        return animalNode
    }
    
    //1
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //2
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //3
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    //4
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    //5
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //6
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    
    
    func createWalls() -> SKNode  {
        // 1
        let powerUpNode = SKSpriteNode(imageNamed: "flower")
        powerUpNode.size = CGSize(width: 40, height: 40)
        powerUpNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        powerUpNode.physicsBody = SKPhysicsBody(rectangleOf: powerUpNode.size)
        powerUpNode.physicsBody?.affectedByGravity = false
        powerUpNode.physicsBody?.isDynamic = false
        powerUpNode.physicsBody?.categoryBitMask = CollisionBitMask.POWERUP_CATEGORY
        powerUpNode.physicsBody?.collisionBitMask = 0
        powerUpNode.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        powerUpNode.color = SKColor.blue
        // 2
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "piller")
        let btmWall = SKSpriteNode(imageNamed: "piller")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.OBSTACLE_CATEGORY
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.ANIMAL_CATEGORY
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.OBSTACLE_CATEGORY
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.ANIMAL_CATEGORY
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        // 3
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(powerUpNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }

}



class CoreElements: NSObject {  }
