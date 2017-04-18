//
//  CommSenateTableViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/19.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class CommSenateTableViewController: UITableViewController, UITabBarControllerDelegate, UISearchBarDelegate{
    var TableData = NSArray()
    var datajson : [[String:AnyObject]] = Array()
    
    var searchResultsData : [[String:AnyObject]] = Array()
    
    var searchBar = UISearchBar()
    var searchMode = 0
    
    //MARK: lifecycle
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    var firstTime = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTime = 1
        self.get_Data_From_Legi_URL()
        SwiftSpinner.show("Fetching data...")
        FirstView()
        
        self.tableView.register(UINib(nibName: "CommitteesTableViewCell", bundle: nil), forCellReuseIdentifier: "CommitteesTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if firstTime == 0{
        self.get_Data_From_Legi_URL()
        SwiftSpinner.show("Fetching data...")
        FirstView()
        self.tableView.register(UINib(nibName: "CommitteesTableViewCell", bundle: nil), forCellReuseIdentifier: "CommitteesTableViewCell")
        }
        firstTime = 0
    }
    
    func FirstView(){
        
        self.navigationItem.title = "Committee"
        let search_img = UIImage(named:"search")
        let menu_img = UIImage(named:"menu")
        
        let leftButton = UIBarButtonItem(image: menu_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(CommSenateTableViewController.backToMenu))
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: search_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(CommSenateTableViewController.createSearchBar))
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.titleView = nil
        
        self.searchBar.isHidden = true
        self.searchBar.delegate = self
        searchMode = 0
    }
    
    func backToMenu(){
        self.slideMenuController()?.openLeft()
    }
    
    
    func createSearchBar(){
        
        
        searchMode = 1
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
        self.navigationItem.titleView = self.searchBar
        self.searchBar.isHidden = false
        self.searchBar.text = ""
        
        let cancel_img = UIImage(named:"cancel")
        let rightButton = UIBarButtonItem(image: cancel_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(CommSenateTableViewController.viewWillAppear(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchMode == 1{
            return self.searchResultsData.count
        }
        return self.datajson.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    fileprivate func get_Data_From_Legi_URL(){
        
        Alamofire.request("http://sample-env-2.es472mesmq.us-west-1.elasticbeanstalk.com/index.php?q=comm_senate")
            .responseJSON { response in
                SwiftSpinner.hide()
                let json = response.result.value as! [String: AnyObject]
                
                if let resData = json["results"]{
                    self.TableData = resData as! NSArray
                    
                    self.datajson = self.TableData as![[String: AnyObject]]
                    self.datajson = self.datajson.sorted(by: {($0["name"] as!String)<($1["name"] as!String)})
                }
                self.table_refresh()
        }
    }
    
    
    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }
    
    
    //return cell for given row
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
        cell.chamber?.text = "Chamber: " + ((contentCell["chamber"] as?String)?.capitalized)!
        
        return cell
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







