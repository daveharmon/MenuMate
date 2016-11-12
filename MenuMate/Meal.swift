//
//  Meal.swift
//  MenuMate
//
//  Created by Jack Cardwell on 11/12/16.
//  Copyright © 2016 HarmonCardwell. All rights reserved.
//

import UIKit

class Meal: UITableViewCell {
    //MARK: Properties
    let cellIdentifier = "Meal"
    @IBOutlet var mealLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(text: String) {
        mealLabel.text = text;
    }
}
