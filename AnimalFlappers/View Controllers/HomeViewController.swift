//
//  HomeViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-16.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //Buttons and labels for use on the Home view for player navigation
    @IBOutlet var btnStartGame : UIButton!
    @IBOutlet var btnChooseAnimal : UIButton!
    @IBOutlet var btnNewUser : UIButton!
    @IBOutlet var btnShowHighScores : UIButton!
    @IBOutlet var lblCurrentPlayer : UILabel!
    
    @IBAction func unwindToHomeViewController(sender: UIStoryboardSegue)
    {   }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Grab the AppDelegate
        let del = UIApplication.shared.delegate as! AppDelegate
        
        //Set the player chosen text to whomever is currently chosen as the player
        lblCurrentPlayer.text = del.PLAYER_NAME
        
    }
    

}
