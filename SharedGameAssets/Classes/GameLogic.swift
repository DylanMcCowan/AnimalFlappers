//
//  GameLogic.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-24.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import SpriteKit

//Structure to define Collision detection masks to apply in the game
struct CollisionBitMask {
    
    static let ANIMAL_CATEGORY:UInt32 = 0x1 << 0
    static let OBSTACLE_CATEGORY:UInt32 = 0x1 << 1
    static let POWERUP_CATEGORY:UInt32 = 0x1 << 2
    static let GROUND_CATEGORY:UInt32 = 0x1 << 3
   // static let OTHER_CATEGORY:UInt32 = 0x1 << 4
}

//An Enum to manage what animals have been selected or defined in the game
enum AnimalNames : String {
   case BIRD = "Bird"
   case EAGLE = "Eagle"
    case COW = "Cow"
    case CAT = "Cat"
}

//EXTENSION - This is an extension from the GameScene.swift class and contains added helper methods necessary for the scene functionality and operation
extension GameScene {
    
    //This method is responsible for returning the desired texture array for a specified animal
    func getSelectedAnimalTextureArray(named : AnimalNames) -> [SKTexture]{
        
        let animalAtlas = SKTextureAtlas(named:"Animals")
        var sprites = [SKTexture]()
        
        switch named{
        
        case .BIRD:
            for texName in GameScene.birdTextureNames{
                sprites.append(animalAtlas.textureNamed(texName))
            }
            break
        case .EAGLE:
            for texName in GameScene.eagleTextureNames{
                sprites.append(animalAtlas.textureNamed(texName))
            }
            break
        case .COW:
            for texName in GameScene.cowTextureNames{
                 sprites.append(animalAtlas.textureNamed(texName))
            }
        case .CAT:
            for texName in GameScene.catTextureNames{
                sprites.append(animalAtlas.textureNamed(texName))
            }
            break
        default:
            sprites.append(animalAtlas.textureNamed("bird-1"))
            break
        }
        
        return sprites
    }
    
    //This method is responsible for creating the inital animal node and specifying its inital params, textures and collision information
    func createAnimalNode() -> SKSpriteNode {
        
        //Load an animal texture from the selection
        let del = UIApplication.shared.delegate as! AppDelegate
      
        //Setup node texture, size and inital position
        let animalNode = SKSpriteNode(texture: getSelectedAnimalTextureArray(named: del.USER_ANIMAL_SELECTION)[0])
        animalNode.size = CGSize(width: 50, height: 50)
        animalNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        //Specify the Physics collision body is a circle the radius of the node's width
        animalNode.physicsBody = SKPhysicsBody(circleOfRadius: animalNode.size.width / 2)
        animalNode.physicsBody?.linearDamping = 1.1
        animalNode.physicsBody?.restitution = 0
        
        //Define the animals collision bitmask properties
        animalNode.physicsBody?.categoryBitMask = CollisionBitMask.ANIMAL_CATEGORY
        animalNode.physicsBody?.collisionBitMask = CollisionBitMask.OBSTACLE_CATEGORY | CollisionBitMask.GROUND_CATEGORY
        animalNode.physicsBody?.contactTestBitMask = CollisionBitMask.OBSTACLE_CATEGORY | CollisionBitMask.POWERUP_CATEGORY | CollisionBitMask.GROUND_CATEGORY
        
        //We don't want it affected by gravity yet
        animalNode.physicsBody?.affectedByGravity = false
        animalNode.physicsBody?.isDynamic = true
        
        //Return the new animal node for use in the game scene
        return animalNode
    }
    
    //Creates a restart button for use in the game scene - for when the player has died
    func showRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restartButtonIcon")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //Create the pause button for the scene
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //Create and return a label to hold the game score
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "Copperplate"
        
        //Background shape to provide contract against the score label
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
 
    //Create and return a label which will be shown before the game begins
    func showGameStartLabel() -> SKLabelNode {
        let gs = SKLabelNode()
        gs.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 50)
        gs.text = "Tap To Begin The Game!"
        gs.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        gs.zPosition = 5
        gs.fontSize = 25
        gs.fontName = "Copperplate-Bold"
        return gs
    }
    
    //Create and return a node to provide functionality for the powerups
    private func createPowerUpNode() -> SKNode {
        // 1
        let powerUpNode = SKSpriteNode(imageNamed: "apple")
        powerUpNode.size = CGSize(width: 40, height: 40)
        powerUpNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        powerUpNode.physicsBody = SKPhysicsBody(rectangleOf: powerUpNode.size)
        powerUpNode.physicsBody?.affectedByGravity = false
        powerUpNode.physicsBody?.isDynamic = false
        powerUpNode.physicsBody?.categoryBitMask = CollisionBitMask.POWERUP_CATEGORY
        powerUpNode.physicsBody?.collisionBitMask = 0
        powerUpNode.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        powerUpNode.color = SKColor.blue
        
        return powerUpNode
    }
    
    //Create a wall node for use in the wall pairs method
    private func createWallNode() -> SKNode{
        
        let wall = SKSpriteNode(imageNamed: "piller")
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionBitMask.OBSTACLE_CATEGORY
        wall.physicsBody?.collisionBitMask = CollisionBitMask.ANIMAL_CATEGORY
        wall.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.affectedByGravity = false
        
        return wall
    }
    
    //Creates to wall nodes and combines them together as a pair node
    private func createWallPairNode() -> SKNode{
       
        let btmWall = createWallNode()
        let topWall = createWallNode()
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)

        
        topWall.zRotation = CGFloat(Double.pi)
        
        let pair = SKNode()
        pair.addChild(btmWall)
        pair.addChild(topWall)
        
        return pair
    }
    
    //Creates the actual node for use in the game scene, takes one pair of walls and adds the powerup node, then returns it to the game scene
    func createWalls() -> SKNode  {
       
        
        let powerUpNode = createPowerUpNode()

        wallPair = createWallPairNode()
        wallPair.name = "wallPair"
        wallPair.zPosition = 1
  

        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(powerUpNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    
    //Random number generation functionality 
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }

}
