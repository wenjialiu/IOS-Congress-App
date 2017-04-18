//
//  Legi_table.swift
//  temp
//
//  Created by 子不语 on 2016/11/19.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class Legi_house_table: UITableViewController, UITabBarControllerDelegate, UISearchBarDelegate{
    //, UISearchResultsUpdating
    var TableData = NSArray()
    //var data = Array<Any>()
    
    var datajson : [[String:AnyObject]] = Array()
    var arrListGrouped = [(index: Int, length:Int, title:String)]()
    
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
                controller.people = self.datajson[indexPath.row + arrListGrouped[indexPath.section].index]
                }
            }
        }
    }
    
    var firstTime = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTime = 1
        self.get_Data_From_Legi_URL()
        FirstView()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        SwiftSpinner.show("Fetching data...")
        self.table_refresh()
    }
    
    func backToMenu(){
        self.slideMenuController()?.openLeft()
    }
    
    func FirstView(){
    
        self.navigationItem.title = "Legislators"
        let search_img = UIImage(named:"search")
        let menu_img = UIImage(named:"menu")
        
        let leftButton = UIBarButtonItem(image: menu_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(Legi_house_table.backToMenu))
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: search_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(Legi_house_table.createSearchBar))
        
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
        let rightButton = UIBarButtonItem(image: cancel_img,  style:UIBarButtonItemStyle.plain, target: self, action: #selector(Legi_house_table.viewWillAppear(_:)))
         self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchMode == 1{
            return 1
        }
        return self.arrListGrouped.count
    }
    
    //return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchMode == 1{
            return self.searchResultsData.count
        }
        return self.arrListGrouped[section].length
    }
    
    
    //return section header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchMode == 1{
            return ""
        }
        return self.arrListGrouped[section].title
    }
    
    //  return title list for section index
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchMode == 1{
            return []
        }
        return self.arrListGrouped.map { $0.title }
    }
    
    // return section for given section index title
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchMode == 1{
            return 0
        }
        return index
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    fileprivate func placeNamesIntoSection(){
        
        self.datajson =  self.datajson.sorted(by: {($0["last_name"] as!String)<($1["last_name"] as!String)})
        
        for i in 0..<self.datajson.count{
            var num = self.datajson[i]
            if let district = num["district"]{
                if let district_ = district as?NSNumber{
                    let number = String(describing: district_)
                    num["district"] = number as AnyObject?
                    
                }
                else{
                    num["district"] = "" as AnyObject?
                }
            }
            else{
                num["district"] = "" as AnyObject?
            }
            self.datajson[i] = num
        }
        
        self.datajson.append(["last_name":"A" as AnyObject])
        
        var index = 0
        let firstLastName = self.datajson[0]["last_name"] as!String
        var indexString = "\(firstLastName[firstLastName.startIndex])"
        
        for i in 0..<self.datajson.count{
            
            let currName = self.datajson[i]["last_name"]
            let firstChar = (currName as!String)[((currName as!String).startIndex)]
            let firstString = "\(firstChar)"

            if firstString != indexString{
                let newSection = (index: index, length: i - index, title: indexString)
                arrListGrouped.append(newSection)
                indexString = firstString
                index = i
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstTime == 0{
        self.datajson.removeAll()
        self.arrListGrouped.removeAll()
        self.searchResultsData.removeAll()
        searchMode = 0
        
        FirstView()
        self.get_Data_From_Legi_URL()
        SwiftSpinner.show("Fetching data...")
        self.table_refresh()
        }
        firstTime = 0
    }
    
    
    fileprivate func get_Data_From_Legi_URL(){
        
        Alamofire.request("http://sample-env-2.es472mesmq.us-west-1.elasticbeanstalk.com/index.php?q=house")
            .responseJSON { response in
                SwiftSpinner.hide()
                let json = response.result.value as! [String: AnyObject]
                
                if let resData = json["results"]{
                    self.TableData = resData as! NSArray
                    
                    self.datajson = self.TableData as![[String: AnyObject]]
                    
                    self.placeNamesIntoSection()
                    
                }
                self.table_refresh()
        }
        
    }
    
    
    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }
    
    
    //return cell for given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as!TableViewCell
        
        var contentCell : [String:AnyObject]
        
        if searchMode == 1{
             contentCell = self.searchResultsData[indexPath.row]
        }
        else{
            contentCell = self.datajson[indexPath.row + arrListGrouped[indexPath.section].index]
        }
        //row name
        let first_name = contentCell["first_name"]
        let last_name = contentCell["last_name"]
        let state_name = contentCell["state_name"]
        
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
                //let number = String(describing: district_)
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
        
        cell.Label1?.text = (last_name! as! String) + ", " + (first_name! as! String)
        cell.Label2?.text = (state_name! as! String)
        
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
//        if pickerFilter == 1 && filterGetdata == 0{
//            return
//        }
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







