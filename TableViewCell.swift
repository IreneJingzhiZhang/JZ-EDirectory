//
//  TableViewCell.swift
//  JZ-EDirectory
//
//  Created by Jingzhi Zhang on 10/3/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpse: create a table view cell to hold employee's id, title, name and image

import UIKit

class TableViewCell: UITableViewCell {
    
    //Markup: Outlets for tableviewcell
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var employeeIDname: UILabel!
    @IBOutlet weak var employeeIDvalue: UILabel!
    
    @IBOutlet weak var employeeTitle: UILabel!
    @IBOutlet weak var employeeFirst: UILabel!
    @IBOutlet weak var employeeLast: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
