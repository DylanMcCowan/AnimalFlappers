//
//  HighScoreViewController.swift
//  AnimalFlappers
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var highScores: [HighScoreObject] = []
    
    @IBOutlet var tvHighscores : UITableView!
    
    func initFakeDetails()
    {
        let highObj = HighScoreObject()
        highObj.initWithData(userName: "Mahadevan Ramakrishnan", highScore: "100")
        
        let highObj2 = HighScoreObject()
        highObj2.initWithData(userName: "Dylan McCowan", highScore: "150")
        
        let highObj3 = HighScoreObject()
        highObj3.initWithData(userName: "Harjot Singh", highScore: "230")
        
        let highObj4 = HighScoreObject()
        highObj4.initWithData(userName: "Gus Dasilva", highScore: "540")
        
        
        highScores.append(highObj)
        highScores.append(highObj2)
        highScores.append(highObj3)
        highScores.append(highObj4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFakeDetails()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : HighScoreTableViewCell = tableView.dequeueReusableCell (withIdentifier: "ProgramCell") as? HighScoreTableViewCell ?? HighScoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ProgramCell")

        let row = indexPath.row
        let rowObj = highScores[row]
        
        tableCell.userName.text = rowObj.userName
       tableCell.highScore.text = rowObj.highScore
        
        return tableCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
