//
//  WatchProgramObject.swift
//  AnimalFlappers
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class WatchProgramObject: NSObject {
    var animalName: String?
    
    func initWithData(animalName: String){
        self.animalName = animalName
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.animalName, forKey:"animalName")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard
            let animalName = aDecoder.decodeObject(forKey: "animalName") as? String
            else{
                return nil
        }
        
        self.init()
        self.initWithData(animalName: animalName)
    }
    
}


