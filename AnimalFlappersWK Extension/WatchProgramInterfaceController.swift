//
//  WatchProgramInterfaceController.swift
//  AnimalFlappersWK Extension
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class WatchProgramInterfaceController: WKInterfaceController, WCSessionDelegate{
    

    @IBOutlet var lblAnimalName : WKInterfaceLabel!
    var programs : [WatchProgramObject] = []
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        //receive sata from phone
//
//        var replyValues = Dictionary<String, AnyObject>()
//        let loadedData = message["progData"]
//
//        //added line
//        NSKeyedUnarchiver.setClass(WatchProgramObject.self, forClassName: "WatchProgramObject")
//
//        //decoding received data
//        let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [WatchProgramObject]
//
//        programs = loadedPerson!
//
//        replyValues["status"] = "Program Received" as AnyObject?
//        replyHandler(replyValues)
//    }
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let msg = message["message"]
        self.lblAnimalName.setText(msg as! String)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
         //initiate connection
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //check if phone and watch is too far
//
//        if(WCSession.default.isReachable){
//            let message = ["getProgData":[:]]
//            WCSession.default.sendMessage(message, replyHandler:
//                {(result) -> Void in
//                    if result["progData"] != nil{
//                        let loadedData = result["progData"]
//                        NSKeyedUnarchiver.setClass(WatchProgramObject.self, forClassName: "WatchProgramObject")
//                        let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [WatchProgramObject]
//                        self.programs = loadedPerson!
//
//
//                        self.lblAnimalName.setText(self.programs[0].animalName)
//                    }
//            }, errorHandler: {(error) -> Void in
//                print(error)
//                print("Error Indeed")
//            })
//        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
