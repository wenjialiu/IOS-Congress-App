//
//  LinkDetailTableViewCell.swift
//  temp
//
//  Created by 子不语 on 2016/11/27.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class LinkDetailTableViewCell: UITableViewCell {

    
    var url : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func LinkButton(_ sender: Any) {
        
        if let url = NSURL(string: url!){
            UIApplication.shared.open(url as URL, options: [:]){
                boolean in
            }
        }

        
    }
    @IBOutlet weak var Link2: UIButton!
    @IBOutlet weak var Link1: UILabel!
}
