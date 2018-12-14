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
    
    //Sounds
    let powerupSound = SKAction.playSoundFileNamed("powerupGained.mp3", waitForCompletion: false)
    let jumpSound = SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("die.mp3", waitForCompletion: false)

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
    
    //Animal Texture Atlas, Sprites
    let animalAtlas = SKTextureAtlas(named:"Animals")
    var animalSprites = Array<Any>()
    
    //Sprite node to hold the Animal
    var animalNode = SKSpriteNode()
    
    //Animation Repeating action
    var animalRepeatingAction  = SKAction()
    
    //AnimalTextureNames - To represent the animations for each animals
   static let birdTextureNames = ["bird1", "bird2", "bird3", "bird4"]
    static let catTextureNames = ["cat-1", "cat-2", "cat-3"]
    static let eagleTextureNames = ["eagle-1", "eagle-2", "eagle-3", "eagle-4"]
    static let cowTextureNames = ["browncow"]
    static let animals = ["Bird", "Eagle", "Cat", "Cow"]
    
    
    /* END GAME VARIABLE DECLARATION */
    
    
    //This function will be responsible for running the scene and updating every move call per frame
    func runScene(){
        
        initalizeGameSceneParams()
        initalizeGameSceneAnimals()
        
        /* ANIMAL ANIMATIONS */
        createAnimalAnimations()
        
        //Create the Score label and add it to the scene
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        //Show the Game Starting Text before the game begins
        gsLabel = showGameStartLabel()
        self.addChild(gsLabel)
    }
    
    //THIS Method is responsible for creating the repeating action for the animal if applicable textures are specified and available
    private func createAnimalAnimations(){
        
        //Create the animation and ensure it repeats forever per frame for the selected animal 
        let animalAnimationAction = SKAction.animate(with: self.animalSprites as! [SKTexture], timePerFrame: 0.1)
        self.animalRepeatingAction = SKAction.repeatForever(animalAnimationAction)
    }
    
    //Do some initalization for the Game Scene with regards to the chosen animal
    private func initalizeGameSceneAnimals(){
        
        let del = UIApplication.shared.delegate as! AppDelegate
        
        /* ANIMAL SPRITE */
        animalSprites = getSelectedAnimalTextureArray(named: del.USER_ANIMAL_SELECTION)
        
        //Handle the animals via a node and add it to the GameScene
        self.animalNode = createAnimalNode()
        self.addChild(animalNode)
        
    }
    
    //This method handles configuring and initalizing a number of Physics and scene related parameters
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
            let background = SKSpriteNode(imageNamed: "Backgroundpt1")
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


    //This method is designed to handle touch events within the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        //If the game has yet to be started with a touch
        if isGameStarted == false{
            
            //Start the game
            isGameStarted =  true
            //Now we want the animal to be affected by gravity and fall down
            animalNode.physicsBody?.affectedByGravity = true
            
            //Create a pause button for the game
            createPauseBtn()
            
            //Remove the initial label from the game screen
            gsLabel.removeFromParent()
            
            //Start the animal texture animation
            self.animalNode.run(animalRepeatingAction)
            
            
            //Handle the spawning of the pillars
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
                })
            
            //Set the spawning delay for each incoming wall pair
            let delay = SKAction.wait(forDuration: 1.5 )
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)

            //Set the distance between each spawning wall pair in terms of height
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
 
            //Apply a movement to the animal
            animalNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            animalNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            
            //Apply the force for movement to the animal with each touch
            if isDead == false {
                animalNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                animalNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        //Handle the location of each touch
        for touch in touches{
            let location = touch.location(in: self)
            
            //If the player has died
            if isDead == true{
                if restartBtn.contains(location){
                    let del = UIApplication.shared.delegate as! AppDelegate
                    
                    //When the reset button is tapped, check the highscore and update it if necessary in the database
                        let hscore = del.PL_HIGHSCORE
                        if hscore < Int(scoreLbl.text!)!{
                            del.PL_HIGHSCORE = Int(scoreLbl.text!)!
                            del.PL_LEVEL = determineLevelUnlock(forScore: Int(scoreLbl.text!)!)
                            let mgr = DBManager()
                            mgr.updatePlayerValues(PlayerName: del.PLAYER_NAME, HighScore: del.PL_HIGHSCORE, UnlockedLevel: del.PL_LEVEL)
                        }
                    //Restart the game
                    restartGameScene()
                }
            } else {
                //If not dead, check if they hit the pause button and update accordingly
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
                //Each tap has a sound
                run(jumpSound)
            }
        }
    }
    
    //This method is designed to handle the Collision Detection and processing 
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //Determine if it is a wall - if it is, game over
        if firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.OBSTACLE_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.OBSTACLE_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.GROUND_CATEGORY || firstBody.categoryBitMask == CollisionBitMask.GROUND_CATEGORY && secondBody.categoryBitMask ==  CollisionBitMask.ANIMAL_CATEGORY {
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDead == false{
                isDead = true
                run(gameOverSound)
                showRestartBtn()
                pauseBtn.removeFromParent()
                self.animalNode.removeAllActions()
            }
            //If the animal has acquired a powerup
        } else if firstBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.POWERUP_CATEGORY {
            run(powerupSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            
            //If the powerup collided with an animal
        } else if firstBody.categoryBitMask == CollisionBitMask.POWERUP_CATEGORY && secondBody.categoryBitMask == CollisionBitMask.ANIMAL_CATEGORY{
            run(powerupSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    //This method receives a score and determines if it is high enough to unlock a new level
    private func determineLevelUnlock(forScore : Int) -> Int{
        
        if(forScore > 10){
            return 2
        }else if forScore > 20{
            return 3
        }else if forScore > 30 {
            return 4
        }else if forScore > 40 {
            return 5
        }else if forScore > 50 {
            return 6
        }else{
            return 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if isGameStarted == true{
            if isDead == false{
                //Move the background a slight amount with each frame update
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
    
    //This Method is called to reset the game scene to its inital state when the player dies to try again
    func restartGameScene(){
        
        //Remove all nodes and actions so they can be reinitalized
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        isGameStarted = false
        score = 0
        //Run the scene start sequence again
        runScene()
    }
    
    // MARK: - Protocol & Unimplemented Method Stubs
    
    //These methods are currently not implemented within the game
    override func sceneDidLoad() { }
    
    func touchDown(atPoint pos : CGPoint) { }
    
    func touchMoved(toPoint pos : CGPoint) { }
    
    func touchUp(atPoint pos : CGPoint) { }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
}
