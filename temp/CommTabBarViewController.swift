//
//  CommTabBarViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/28.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class CommTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items?[0].title = "House"
        tabBar.items?[1].title = "Senate"
        tabBar.items?[2].title = "Joint"
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
