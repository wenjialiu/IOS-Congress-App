//
//  SideMenuViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/25.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LeftMenu: Int {
    case Legislators = 0
    case Bills
    case Committee
    case Favorite
    case About
}

class SideMenuViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var congress: UILabel!
    
    var arrayMenu = ["Legislators", "Bills", "Committee", "Favorite", "About"]
    
    var first_legislators : UITabBarController!
    var second_bills : UITabBarController!
    var third_committee : UITabBarController!
    var favorite : UITabBarController!
    var aboutMe : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.congress?.text = "Congress API"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.first_legislators = storyboard.instantiateViewController(withIdentifier: "legiTab") as! UITabBarController
        
        self.second_bills = storyboard.instantiateViewController(withIdentifier: "billTab") as! UITabBarController
        
        self.third_committee = storyboard.instantiateViewController(withIdentifier: "commTab") as! UITabBarController

        self.favorite = storyboard.instantiateViewController(withIdentifier: "favTab") as! UITabBarController
        
        self.aboutMe = storyboard.instantiateViewController(withIdentifier: "aboutMeTab")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func changeViewController(_ menu: LeftMenu) {
        
        switch menu {
        case .Legislators:
            self.slideMenuController()?.changeMainViewController(self.first_legislators, close: true)
            self.first_legislators.selectedIndex = 0
        case .Bills:
            self.slideMenuController()?.changeMainViewController(self.second_bills, close: true)
            self.second_bills.selectedIndex = 0
        case .Committee:
            self.slideMenuController()?.changeMainViewController(self.third_committee, close: true)
            self.third_committee.selectedIndex = 0
        case .Favorite:
            self.slideMenuController()?.changeMainViewController(self.favorite, close: true)
            self.favorite.selectedIndex = 0
        case .About:
            self.slideMenuController()?.changeMainViewController(self.aboutMe, close: true)
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
        
    }
    
    //return the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayMenu.count
    }
    
    //return cell for given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cellIdentifier = "Menu"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            cell?.textLabel?.text = arrayMenu[indexPath.row]
        
        return cell!
    }


}
