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
    var gsLabel = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var userAnimalSelection = ""
    
    
    //Animal Texture Atlas
    let animalAtlas = SKTextureAtlas(named:"Animals")
    var animalSprites = Array<Any>()
    var animalNode = SKSpriteNode()
    var animalRepeatingAction  = SKAction()
    
    
    /* END GAME VARIABLE DECLARATION */
    
    
    //This function will be responsible for running the scene and updating every move call per frame
    func runScene(){
        
        initalizeGameSceneParams()
        initalizeGameSceneAnimals()
        
        /* ANIMAL ANIMATIONS */
        createAnimalAnimations()
        
        //Create the Score label
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
      //  highscoreLbl = createHighscoreLabel()
       // self.addChild(highscoreLbl)
        //createLogo()
        
        
        //Show the Game Starting Text
        gsLabel = showGameStartLabel()
        self.addChild(gsLabel)
        
    }
    
    private func createAnimalAnimations(){
        
        //Create the animation and ensure it repeats forever per frame for the selected animal 
        let animalAnimationAction = SKAction.animate(with: self.animalSprites as! [SKTexture], timePerFrame: 0.1)
        self.animalRepeatingAction = SKAction.repeatForever(animalAnimationAction)
     
    }
    
    private func initalizeGameSceneAnimals(){
        
        let del = UIApplication.shared.delegate as! AppDelegate
        
        
        /* ANIMAL SPRITES */
        //TODO - Replace hardcoded value with variable based on player selection
        var selectedAnimalTextureArray = [SKTexture]()
        selectedAnimalTextureArray.append(animalAtlas.textureNamed("cat-1"))
        selectedAnimalTextureArray.append(animalAtlas.textureNamed("cat-2"))

        selectedAnimalTextureArray.append(animalAtlas.textureNamed("cat-3"))

        
        //animalSprites.append()
        animalSprites = selectedAnimalTextureArray
       // animalSprites.append(animalAtlas.textureNamed("cat-3"))
        //animalSprites.append(animalAtlas.textureNamed("eagle-4"))
        
        //Handle the animals via a node and add it to the GameScene
        self.animalNode = createAnimalNode()
        self.addChild(animalNode)
        
    }
    
    private func initalizeGameSceneParams(){
        
        
        //COLLISION - Configure the Scene physics for collision detection
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.GROUND_CATEGORY
        self.physicsBody?.collisionBitMask = CollisionBitMask.ANIMAL_CATEGORY
        self.physicsBody?.contactTestBitMask = CollisionBitMask.ANIMAL_CATEGORY
        self.physicsBody?.isDynamic = false
        
        //Disable the animals being affected by scene gravity directly to keep them on the screen
        self.physicsBody?.affectedByGravity = false
        
        //Specifcy that the Delegate for the physics is in this class
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        
        //This loop will create the background so it looks like it is continuously scrolling along
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
    }
    
    //This method is called when the GameScene SKView is displayed on the device
    override func didMove(to view: SKView) {
        //Run the game scene
        runScene()
    }
    
    
    override func sceneDidLoad() { }
    
    //These methods are currently not used within the game
    func touchDown(atPoint pos : CGPoint) { }
    
    func touchMoved(toPoint pos : CGPoint) { }
    
    func touchUp(atPoint pos : CGPoint) { }
    
    
    //This method is designed to handle touch events within the game
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
            gsLabel.removeFromParent()
            
            
            //3
            self.animalNode.run(animalRepeatingAction)
            
            //1
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            //2
            let delay = SKAction.wait(forDuration: 1.5 )
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
    
    //This method is designed to handle the Collision Detection and processing 
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
                showRestartBtn()
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
