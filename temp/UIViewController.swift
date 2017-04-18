//
//  File.swift
//  temp
//
//  Created by 子不语 on 2016/11/25.
//  Copyright © 2016年 子不语. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
}
