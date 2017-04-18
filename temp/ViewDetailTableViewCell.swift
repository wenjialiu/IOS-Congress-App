//
//  ViewDetailTableViewCell.swift
//  temp
//
//  Created by 子不语 on 2016/11/26.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class ViewDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var Text1: UILabel!
    @IBOutlet weak var Text2: UILabel!
}
