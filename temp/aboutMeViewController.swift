//
//  aboutMeViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/25.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class aboutMeViewController: UIViewController{

    @IBOutlet weak var aboutMe: UIImageView!
    
    
    @IBOutlet weak var Info: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setNavigationBarItem()
        self.navigationItem.title = "About"
        
        self.Info?.text = "Wenjia Liu\n\n6987-4444-57"
       
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
