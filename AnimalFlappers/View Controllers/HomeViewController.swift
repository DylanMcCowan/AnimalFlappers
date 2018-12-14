//
//  HomeViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-11-16.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var btnStartGame : UIButton!
    @IBOutlet var btnChooseAnimal : UIButton!
    @IBOutlet var btnNewUser : UIButton!
    @IBOutlet var btnShowHighScores : UIButton!
    
    @IBAction func unwindToHomeViewController(sender: UIStoryboardSegue)
    {   }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
