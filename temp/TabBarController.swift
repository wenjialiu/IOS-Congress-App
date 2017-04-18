//
//  TabBarController.swift
//  temp
//
//  Created by 子不语 on 2016/11/24.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
import SwiftSpinner

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.delegate = self
        
        tabBar.items?[0].title = "State"
        tabBar.items?[1].title = "House"
        tabBar.items?[2].title = "Senate"
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
    }
    
    
//    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        let index : Int = (tabBarController.viewControllers?.index(of: viewController))!
//     
//        
//        if index == 0 || index == 1 || index == 2
//        {
//            print(index)
//            //SwiftSpinner.show("Fetching data...")
//            
//        }
//        
//    }
    
    

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
