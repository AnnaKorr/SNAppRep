//
//  MyTableViewCell.swift
//  SNApp
//
//  Created by apple on 25.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
   
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var authorTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
