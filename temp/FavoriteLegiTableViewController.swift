//
//  FavoriteLegiTableViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/25.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit


class FavoriteLegiTableViewController: UITableViewController, UISearchBarDelegate {

    
    let key = "keySave"
    
    var hasFavorite = 1
    var datajson : [[String:AnyObject]] = Array()
    var searchResultsData : [[String:AnyObject]] = Array()
    
    var searchBar = UISearchBar()
    var searchMode = 0
    
    //MARK: lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue"{
            let controller = segue.destination as! Legi_ViewDetails
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
            self.datajson =  self.datajson.sorted(by: {($0["last_name"] as!String)<($1["last_name"] as!String)})
            
            }
        else{
            hasFavorite = 0
        }

        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        
        self.table_refresh()
    }

    func backToMenu(){
        self.slideMenuController()?.openLeft()
    }
    
    func FirstView(){
        
        self.navigationItem.title = "Legislators"
        let search_img = UIImage(named:"search")
        let menu_img = UIImage(named:"menu")
        
        let leftButton = UIBarButtonItem(image: menu_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteLegiTableViewController.backToMenu))
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: search_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteLegiTableViewController.createSearchBar))
        
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
            let favorite : [[String:String]] = testArray! as![[String:String]]
          
            self.datajson = favorite as [[String : AnyObject]]
            self.datajson =  self.datajson.sorted(by: {($0["last_name"] as!String)<($1["last_name"] as!String)})
        }
        else{
            hasFavorite = 0
        }
        
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        
        self.table_refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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

    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as!TableViewCell
        
        var contentCell : [String:AnyObject]
        
        if hasFavorite == 0{
            
            return cell
        }
        
        if searchMode == 1{
            contentCell = self.searchResultsData[indexPath.row]
        }
        else{
            contentCell = self.datajson[indexPath.row]
        }
        
        //row name
        let first_name = contentCell["first_name"]
        let last_name = contentCell["last_name"]
        let state_name = contentCell["state_name"]
        
        cell.Label1?.text = (last_name! as! String) + ", " + (first_name! as! String)
        cell.Label2?.text = (state_name! as! String)
        
        let pty = contentCell["party"] as!String
        
        var party = ""
        if pty == "D"{
            party = "Democrat"
        }
        if pty == "R"{
            party = "Republican"
        }
        if pty == "I"{
            party = "Independent"
        }
        
        if let district = contentCell["district"]{
            if let district_ = district as?String{
                if district_ != ""{
                    cell.district?.text = "District: " + district_
                }
                else{
                    cell.district?.text = "District: N/A"
                }
            }
            else{
                cell.district?.text = "District: N/A"
            }
        }
        else{
            cell.district?.text = "District: N/A"
        }
        cell.party?.text = party
        
        //row picture
        let img_url = contentCell["bioguide_id"]
        
        let img_jpg = "http://theunitedstates.io/images/congress/225x275/" + (img_url! as! String) + ".jpg"
        if let url = URL(string: img_jpg){
            if let data = try? Data(contentsOf: url){
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
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
            self.searchResultsData = self.datajson.filter({($0["last_name"]as!String).lowercased().range(of: lower!) != nil})
            self.table_refresh()
        }
    }
    
}
