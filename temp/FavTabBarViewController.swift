//
//  FavTabBarViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/28.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class FavTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.items?[0].title = "Legislators"
        tabBar.items?[1].title = "Bills"
        tabBar.items?[2].title = "Committees"
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
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
