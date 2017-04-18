//
//  FavoriteBillsTableViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/29.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
//import SwiftSpinner

class FavoriteBillsTableViewController: UITableViewController, UISearchBarDelegate {

    let key = "keySaveBill"
    
    var hasFavorite = 1
    var datajson : [[String:AnyObject]] = Array()
    var searchResultsData : [[String:AnyObject]] = Array()
    
    var searchBar = UISearchBar()
    var searchMode = 0
    
    //MARK: lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue"{
            let controller = segue.destination as! BillsDetailsViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                if searchMode == 1{
                    controller.people = self.searchResultsData[indexPath.row]
                }
                else{
                    controller.people = self.datajson[indexPath.row]
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        FirstView()
        
        let defaults = UserDefaults.standard
        
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            let favorite : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
            self.datajson = favorite
            self.datajson =  self.datajson.sorted(by: {($0["introduced_on"] as!String)>($1["introduced_on"] as!String)})
        }
        else{
            hasFavorite = 0
        }
        
        self.tableView.register(UINib(nibName: "BillsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillsTableViewCell")
        
        self.table_refresh()
    }
    
    func backToMenu(){
        self.slideMenuController()?.openLeft()
    }
    
    func FirstView(){
        
        self.navigationItem.title = "Bills"
        let search_img = UIImage(named:"search")
        let menu_img = UIImage(named:"menu")
        
        let leftButton = UIBarButtonItem(image: menu_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteBillsTableViewController.backToMenu))
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: search_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteBillsTableViewController.createSearchBar))
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.titleView = nil
        
        self.searchBar.isHidden = true
        self.searchBar.delegate = self
        searchMode = 0
    }
    
    func createSearchBar(){
        
        
        searchMode = 1
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
        self.navigationItem.titleView = self.searchBar
        self.searchBar.isHidden = false
        self.searchBar.text = ""
        
        let cancel_img = UIImage(named:"cancel")
        let rightButton = UIBarButtonItem(image: cancel_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(Legi_house_table.viewDidLoad))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.setNavigationBarItem()
        FirstView()
        
        let defaults = UserDefaults.standard
        
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            let favorite : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
            self.datajson = favorite
            self.datajson =  self.datajson.sorted(by: {($0["introduced_on"] as!String)>($1["introduced_on"] as!String)})
        }
        else{
            hasFavorite = 0
        }
        
        self.tableView.register(UINib(nibName: "BillsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillsTableViewCell")
        
        self.table_refresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if hasFavorite == 0{
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMode == 1{
            return self.searchResultsData.count
        }
        if hasFavorite == 0{
            return 0
        }
        return self.datajson.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillsTableViewCell", for: indexPath) as!BillsTableViewCell
        
        if hasFavorite == 0{
            return cell
        }
        
        var contentCell : [String:AnyObject]
        
        if searchMode == 1{
            contentCell = self.searchResultsData[indexPath.row]
        }
        else{
            contentCell = self.datajson[indexPath.row]
        }
       
        cell.bill_id?.text = contentCell["bill_id"] as?String
        
        if let title = contentCell["short_title"]{
            if let short_title = title as?String{
                if short_title != ""{
                    cell.title?.text = short_title
                }
                else{
                    cell.title?.text = contentCell["official_title"] as?String
                }
            }
            else{
                cell.title?.text = contentCell["official_title"] as?String
            }
        }
        else{
            cell.title?.text = contentCell["official_title"] as?String
        }
        
        cell.introduced_on?.text = contentCell["introduced_on"] as?String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            searchMode = 0
        }
        else{
            searchMode = 1
            let lower = searchBar.text?.lowercased()
            self.searchResultsData = self.datajson.filter({($0["official_title"]as!String).lowercased().range(of: lower!) != nil})
            self.table_refresh()
        }
    }
    
}
