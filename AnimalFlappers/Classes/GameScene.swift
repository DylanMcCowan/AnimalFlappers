//
//  GameScene.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-15.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* GAME VARIABLES -- Refactor to GameLogic class? */
    
    //Has the game started?
    var isGameStarted = Bool(false)
    
    //Keep track of if the player has died
    var isDead = Bool(false)
    
    //Sounds?
    
    //Player Variables
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    
    //Animal Texture Atlas
    let animalAtlas = SKTextureAtlas(named:"Animals")
    var animalSprites = Array<Any>()
    var animalNode = SKSpriteNode()
    var animalRepeatingAction  = SKAction()
    
    
    /* END GAME VARIABLE DECLARATION */
    
    
    //This function will be responsible for running the scene and updating every move call per frame
    func runScene(){
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.GROUND_CATEGORY
        self.physicsBody?.collisionBitMask = CollisionBitMask.ANIMAL_CATEGORY
        self.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        self.physicsBody?.isDynamic = false
        
        //Don't let gravity affect the animals falling off the screen
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        //Create the Background for the scene
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        
        /* ANIMAL SPRITES */
        //TODO - Replace hardcoded value with variable based on player selection
        animalSprites.append(animalAtlas.textureNamed("bird1"))
        animalSprites.append(animalAtlas.textureNamed("bird2"))
        animalSprites.append(animalAtlas.textureNamed("bird3"))
        animalSprites.append(animalAtlas.textureNamed("bird4"))
        
        
        self.animalNode = createAnimalNode()
        self.addChild(animalNode)
        
        
        /* ANIMAL ANIMATIONS */
        
        //Create the animation and ensure it repeats forever per frame
        let animalAnimationAction = SKAction.animate(with: self.animalSprites as! [SKTexture], timePerFrame: 0.1)
        self.animalRepeatingAction = SKAction.repeatForever(animalAnimationAction)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
    }
    
    override func didMove(to view: SKView) {
        runScene()
    }
    
    
    override func sceneDidLoad() {

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if isGameStarted == false{
            
            //1
            isGameStarted =  true
            animalNode.physicsBody?.affectedByGravity = true
            createPauseBtn()
            //2
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            //3
            self.animalNode.run(animalRepeatingAction)
            
            //1
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            //2
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            //3
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            
            
            animalNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            animalNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            //4
            if isDead == false {
                animalNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                animalNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        ////
        
        for touch in touches{
            let location = touch.location(in: self)
            //1
            if isDead == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartGameScene()
                }
            } else {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
        
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.OBSTACLE_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.OBSTACLE_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.GROUND_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.GROUND_CATEGORY && secondBody.categoryBitMask ==  CollisionBitMask.ANIMAL_CATEGORY {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDead == false{
                isDead = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.animalNode.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.POWERUP_CATEGORY {
          //  run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.POWERUP_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY{
            //run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if isGameStarted == true{
            
            if isDead == false{
                
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
                
                
            }
        }
        
        
    }
    
    func restartGameScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        isGameStarted = false
        score = 0
        runScene()
    }
}
