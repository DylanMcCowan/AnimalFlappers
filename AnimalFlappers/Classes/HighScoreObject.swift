//
//  HighScoreObject.swift
//  AnimalFlappers
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HighScoreObject: NSObject, NSCoding {
    
    var userName : String?
    var highScore : String?
    
    func initWithData (userName: String, highScore: String)
    {
        self.userName = userName
        self.highScore = highScore
        
    }
    
    func encode(with aCoder: NSCoder) {
      
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
       
        self.init()
        self.initWithData(userName: userName!, highScore: highScore!)
        
    }

}
