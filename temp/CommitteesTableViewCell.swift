//
//  CommitteesTableViewCell.swift
//  temp
//
//  Created by 子不语 on 2016/11/27.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class CommitteesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var names: UILabel!
    
    @IBOutlet weak var commID: UILabel!
    @IBOutlet weak var chamber: UILabel!

}
