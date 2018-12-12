//
//  ChooseAnimalViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-12-12.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class ChooseAnimalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    @IBOutlet var pvAnimalSelector : UIPickerView!
    @IBOutlet var ivAnimalPreview : UIImageView!
    @IBOutlet var btnSelectAnimal : UIButton!
    
    private var del = UIApplication.shared.delegate as! AppDelegate
    private var currSelectedAnimal = AnimalNames.BIRD
    
    @IBAction func updateSelectedAnimal(){
       del.USER_ANIMAL_SELECTION = currSelectedAnimal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ivAnimalPreview.image = UIImage(named: GameScene.birdTextureNames[0])
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
