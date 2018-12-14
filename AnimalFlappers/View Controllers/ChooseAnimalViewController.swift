//
//  ChooseAnimalViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-12-12.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit
import WatchConnectivity

class ChooseAnimalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, WCSessionDelegate {
 
    @IBOutlet var pvAnimalSelector : UIPickerView!
    @IBOutlet var ivAnimalPreview : UIImageView!
    @IBOutlet var btnSelectAnimal : UIButton!
    
    private var del = UIApplication.shared.delegate as! AppDelegate
    private var currSelectedAnimal = AnimalNames.BIRD
    
    //When the player chooses an animal, update the selected animal in the app delegate and show that selection in the watch app as well
    @IBAction func updateSelectedAnimal(){
       del.USER_ANIMAL_SELECTION = currSelectedAnimal
        
        sendWatchNewMessage(animalSelection: del.USER_ANIMAL_SELECTION.rawValue)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ivAnimalPreview.image = UIImage(named: GameScene.birdTextureNames[0])
        
        // Do any additional setup after loading the view.
        
        /* CODE BELOW: Author: Gus */
        if WCSession.isSupported(){
         let session = WCSession.default
         session.delegate = self
         session.activate()
         sendWatchNewMessage(animalSelection: del.USER_ANIMAL_SELECTION.rawValue)
         if session.isPaired != true {
            print("apple watch not paired")
         }
         if session.isWatchAppInstalled{
            print("watchkit app not installed")
         }
         }
         else{
            print("watchconnectivety not supported")
         }
        /* END OF GUS CODE */
 
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GameScene.animals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return GameScene.animals[row]
    }
    
    //THis picker view will show the associated animal image based on which animal was selected in the row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let name = GameScene.animals[row]
        
        switch name{
        case "Bird":
            ivAnimalPreview.image = UIImage(named: GameScene.birdTextureNames[0])
            currSelectedAnimal = AnimalNames.BIRD
            break
        case "Cow":
            ivAnimalPreview.image = UIImage(named: GameScene.cowTextureNames[0])
            currSelectedAnimal = AnimalNames.COW
            break
        case "Eagle":
            ivAnimalPreview.image = UIImage(named: GameScene.eagleTextureNames[0])
            currSelectedAnimal = AnimalNames.EAGLE
            break
        case "Cat":
            ivAnimalPreview.image = UIImage(named: GameScene.catTextureNames[0])
            currSelectedAnimal = AnimalNames.CAT
            break
        default:
            print("Error, image not found")
        }
        
    }
    
    // MARK: WatchConnectivity Code
    
    //AUTHOR: GUS
    func sendWatchNewMessage(animalSelection : String)
    {
        if WCSession.default.isReachable{
            let message = ["message" : animalSelection]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
            
        }
    }
    
    //MARK: - Protocol stubs
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    


}
