//
//  HighScoreTableViewCell.swift
//  AnimalFlappers
//
//  Created by Xcode User on 2018-12-13.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    @IBOutlet var userName : UILabel!
    @IBOutlet var highScore : UILabel!
    @IBOutlet var levelUnlocked : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
