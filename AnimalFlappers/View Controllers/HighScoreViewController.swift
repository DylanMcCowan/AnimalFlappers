//
//  HighScoreViewController.swift
//  AnimalFlappers
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   let mgr = DBManager()

    
    @IBOutlet var tvHighscores : UITableView!
    @IBOutlet var lblChosen : UILabel!
    @IBOutlet var btnChoosePlayer : UIButton!
    
     var timer : Timer!
    
    private var  tempPlayerName : String = ""
    private var  tempHighScore : Int = 0
    private var  tempLevelUnlocked: Int = 0
    
    @IBAction func selectPlayer(){
    let del = UIApplication.shared.delegate as! AppDelegate
        del.PLAYER_NAME = self.tempPlayerName
        del.PL_HIGHSCORE = self.tempHighScore
        del.PL_LEVEL = self.tempLevelUnlocked
        
        lblChosen.text = "You chose: \(tempPlayerName)!"
    }
    
    @objc func refreshTable(){
        
        if mgr.retrievedData != nil{
            if (mgr.retrievedData?.count)! > 0 {
                self.tvHighscores.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnChoosePlayer.isHidden = true
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true)

        mgr.loadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mgr.retrievedData != nil {
          return (mgr.retrievedData?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : HighScoreTableViewCell = tableView.dequeueReusableCell (withIdentifier: "ProgramCell") as? HighScoreTableViewCell ?? HighScoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ProgramCell")

        let row = indexPath.row
        let rowObj = mgr.retrievedData![row]
        
        tableCell.userName.text = rowObj["PlayerName"] as! String
        tableCell.highScore.text = rowObj["HighScore"] as! String
        tableCell.levelUnlocked.text = rowObj["UnlockedLevel"] as! String
        
        return tableCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = tableView.cellForRow(at: indexPath) as? HighScoreTableViewCell
        
        tempPlayerName = selectedPlayer?.userName.text as! String
        tempHighScore = Int((selectedPlayer?.highScore.text)!)!
        tempLevelUnlocked = Int((selectedPlayer?.levelUnlocked.text)!)!
        
        lblChosen.text = "Select \(tempPlayerName)!?"
        btnChoosePlayer.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        btnChoosePlayer.isHidden = true
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
