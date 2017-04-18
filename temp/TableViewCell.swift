//
//  TableViewCell.swift
//  temp
//
//  Created by 子不语 on 2016/11/26.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Label2: UILabel!
    
    @IBOutlet weak var party: UILabel!
    @IBOutlet weak var district: UILabel!
}
