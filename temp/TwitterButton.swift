//
//  TwitterButton.swift
//  temp
//
//  Created by 子不语 on 2016/11/23.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class TwitterButton: UITableViewCell {

    var twitter_url : String?
    var website_url : String?
    var faceboobk_url : String?
    
    @IBOutlet weak var WebsiteButtonText: UIButton!
    @IBOutlet weak var TwitterButtonText: UIButton!
    @IBAction func WebsiteButton(_ sender: Any) {
        if website_url == nil{
             //WebsiteButtonText.setTitle("N/A", for: .normal)
        }
        else{
            if let url = NSURL(string: website_url!){
                UIApplication.shared.open(url as URL, options: [:]){
                    boolean in
                }
            }
        }
    }
    
    
    
    @IBOutlet weak var WebsiteLabel: UILabel!
    
    @IBOutlet weak var TwitterLabel: UILabel!
    
    @IBAction func TwitterButton(_ sender: Any) {
        let t_url = "https://www.twitter.com/" + twitter_url!
        if twitter_url == nil{
            
            // TwitterButtonText.setTitle("N/A", for: .normal)
        }
        else{
            if let url = NSURL(string: t_url){
                UIApplication.shared.open(url as URL, options: [:]){
                boolean in
                }
            }
        }
    } 
    
    @IBOutlet weak var FacebookButtonText: UIButton!
    
    @IBAction func FacebookButton(_ sender: Any) {
        let fb_url = "https://www.facebook.com/" + faceboobk_url!
        if faceboobk_url == nil{
            //FacebookButtonText.setTitle("N/A", for: .normal)
        }
        else{
            if let url = NSURL(string: fb_url){
                UIApplication.shared.open(url as URL, options: [:]){
                    boolean in
                }
            }
        }
    }

    
    @IBOutlet weak var FacebookLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
