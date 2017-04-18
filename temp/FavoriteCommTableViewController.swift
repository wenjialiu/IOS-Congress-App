//
//  FavoriteCommTableViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/29.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class FavoriteCommTableViewController: UITableViewController,UISearchBarDelegate {

    let key = "keySaveComm"
    
    var hasFavorite = 1
    var datajson : [[String:AnyObject]] = Array()
    var searchResultsData : [[String:AnyObject]] = Array()
    
    var searchBar = UISearchBar()
    var searchMode = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue"{
            let controller = segue.destination as! CommDetailsViewController
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
            let favorite : [[String:String]] = testArray! as![[String:String]]
            self.datajson = favorite as [[String : AnyObject]]
            self.datajson =  self.datajson.sorted(by: {($0["name"] as!String)<($1["name"] as!String)})
        }
        else{
            hasFavorite = 0
        }
        
        self.tableView.register(UINib(nibName: "CommitteesTableViewCell", bundle: nil), forCellReuseIdentifier: "CommitteesTableViewCell")
        
        self.table_refresh()
    }
    
    
    func backToMenu(){
        self.slideMenuController()?.openLeft()
    }
    
    func FirstView(){
        
        self.navigationItem.title = "Legislators"
        let search_img = UIImage(named:"search")
        let menu_img = UIImage(named:"menu")
        
        let leftButton = UIBarButtonItem(image: menu_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteCommTableViewController.backToMenu))
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: search_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteCommTableViewController.createSearchBar))
        
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
        let rightButton = UIBarButtonItem(image: cancel_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteCommTableViewController.viewDidLoad))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    
    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        FirstView()
        
        let defaults = UserDefaults.standard
        
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            let favorite : [[String:String]] = testArray! as![[String:String]]
            self.datajson = favorite as [[String : AnyObject]]
            self.datajson =  self.datajson.sorted(by: {($0["name"] as!String)<($1["name"] as!String)})
        }
        else{
            hasFavorite = 0
        }
        
        self.tableView.register(UINib(nibName: "CommitteesTableViewCell", bundle: nil), forCellReuseIdentifier: "CommitteesTableViewCell")
        
        self.table_refresh()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if hasFavorite == 0{
            return 0
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
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var contentCell : [String:AnyObject]
        
        if searchMode == 1{
            contentCell = self.searchResultsData[indexPath.row]
        }
        else{
            contentCell = self.datajson[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitteesTableViewCell", for: indexPath) as!CommitteesTableViewCell
        
        cell.names?.text = contentCell["name"] as?String
        cell.commID?.text = contentCell["committee_id"] as?String
        cell.chamber?.text = "Chamber: " + (contentCell["chamber"] as!String).capitalized
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
            self.searchResultsData = self.datajson.filter({($0["name"]as!String).lowercased().range(of: lower!) != nil})
            self.table_refresh()
        }
    }


}
