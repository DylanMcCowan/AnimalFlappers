//
//  GameViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-15.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var btnQuit : UIButton!
    @IBOutlet var skView : SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Fit to the size of the SKView size which is set
                sceneNode.scaleMode = .resizeFill
                
                // Present the scene
                if let view = skView {
                    view.presentScene(sceneNode)
                    
                    //Allow us to place objects irrespective of their orders
                    view.ignoresSiblingOrder = false
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
