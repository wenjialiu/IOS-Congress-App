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

class Legi_table: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var TableData = NSArray()
    var datajson : [[String:AnyObject]] = Array()
    
    var arrListGrouped : [(index:Int, length: Int, title:String)] = Array()
  
    
    var US = ["All States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia", "Hawaii","Idaho", "Illinois",  "Indiana",   "Iowa","Kansas", "Kentucky", "Louisiana","Maine","Maryland", "Massachusetts", "Michigan", "Minnesota","Mississippi","Missouri","Montana","Nebraska", "Nevada","New Hampshire","New Jersey","New Mexico", "New York","North Carolina","North Dakota", "Ohio", "Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina", "South Dakota","Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington","West Virginia", "Wisconsin", "Wyoming"]
    
    
    var pickerState : String?
    var pickerFilterData : [[String:AnyObject]] = Array()
    var arrListPickerFilteredGrouped = [(index: Int, length:Int, title:String)]()
    
    
    var filterGetdata = 0
    var pickerFilter = 0
    
    
    @IBAction func backTo(_ sender: Any) {
        pickerFilter = 0
    }
    
 
    @IBAction func FilterButton(_ sender: Any) {
   
        pickerFilter = 1
        filterGetdata = 0
        pickerFilterData.removeAll()
        self.table_refresh()
    }

    //indexPath.row + self.arrListGrouped[indexPath.section].index
    
    
    //MARK: lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue"{
            let controller = segue.destination as! Legi_ViewDetails
            if let indexpath = self.tableView.indexPathForSelectedRow{
                if filterGetdata == 1{
                    
                    controller.people = self.pickerFilterData[indexpath.row]
                    filterGetdata = 0
                    pickerFilter = 0
                }
                else{
                    controller.people = self.datajson[indexpath.row + self.arrListGrouped[indexpath.section].index]
                }
            }
        }
    }
    
    var firstTime = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.get_Data_From_Legi_URL()
        
        self.setNavigationBarItem()
        
        firstTime = 1
        self.tableView.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        SwiftSpinner.show("Fetching data...")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if firstTime == 0{
        SwiftSpinner.show("Fetching data...")
        datajson.removeAll()
        arrListGrouped.removeAll()
        pickerFilterData.removeAll()
        arrListPickerFilteredGrouped.removeAll()
        pickerFilter = 0
        filterGetdata = 0
        
        self.get_Data_From_Legi_URL()
        
        self.table_refresh()
        }
        firstTime = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pickerFilter == 1 && filterGetdata == 0{
            return UIScreen.main.bounds.height
        }
        else{
            return 60
        }
    }
    
    //return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if pickerFilter == 1 && filterGetdata == 0{
            return 1
        }
        if filterGetdata == 1{
            return 1
        }
        return self.arrListGrouped.count
    }
    
    //return the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if pickerFilter == 1 && filterGetdata == 0{
            return 1
        }
//        return self.arrListGrouped[section].length
        if filterGetdata == 1{
            return pickerFilterData.count
        }
        return self.arrListGrouped[section].length
    }
    
    
    //return section header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pickerFilter == 1 && filterGetdata == 0{
            return nil
        }
//        return self.arrListGrouped[section].title
        if filterGetdata == 1{
            let state = self.pickerFilterData[0]["state_name"] as!String
            return "\(state[state.startIndex])"
        }
        return self.arrListGrouped[section].title
    }
    
    //  return title list for section index
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if pickerFilter == 1 && filterGetdata == 0{
            return []
        }
        if filterGetdata == 1{
            let state = self.pickerFilterData[0]["state_name"] as!String
            return ["\(state[state.startIndex])"]
        }
        return self.arrListGrouped.map { $0.title }
    }
    
    // return section for given section index title
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if pickerFilter == 1 && filterGetdata == 0{
            return 0
        }
        if filterGetdata == 1{
            return 1
        }
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pickerFilter == 1 && filterGetdata == 0{
            return
        }
        performSegue(withIdentifier: "showDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    fileprivate func placeNamesIntoSection(){
        
        self.datajson =  self.datajson.sorted{
            if ($0["state_name"] as!String) == ($1["state_name"] as!String){
                return ($0["last_name"] as!String) < ($1["last_name"] as!String)
            }
            else{
                return ($0["state_name"] as!String) < ($1["state_name"] as!String)
            }
        }
        //print(self.datajson.count)
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
        //print(self.datajson.count)
        self.datajson.append(["state_name":"A" as AnyObject])
        
        var index = 0
        let firstLastName = self.datajson[0]["state_name"] as!String
        var indexString = "\(firstLastName[firstLastName.startIndex])"
        
        for i in 0..<self.datajson.count{
            
            let currName = self.datajson[i]["state_name"]
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
    
    
  
    fileprivate func get_Data_From_Legi_URL(){

        Alamofire.request("http://sample-env-2.es472mesmq.us-west-1.elasticbeanstalk.com/index.php?q=legislators")
            .responseJSON { response in
                let json = response.result.value as! [String: AnyObject]
                SwiftSpinner.hide()
                if let resData = json["results"]{
                    self.TableData = resData as! NSArray
               
                    self.datajson = self.TableData as![[String: AnyObject]]
                    
                    self.placeNamesIntoSection()
                    self.table_refresh()
                }
                
        }
        
    }
    
    fileprivate func table_refresh(){
        self.tableView.reloadData()
    }
    
    
    var contentCell :[String : AnyObject] = [:]
    var cell = TableViewCell()
    
    //return cell for given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pickerFilter == 1 && filterGetdata == 0{
            let identifier = "PickerTableViewCell"
            let PickerCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!PickerTableViewCell
            
            PickerCell.myPickerView.dataSource = self
            PickerCell.myPickerView.delegate = self
            return PickerCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as!TableViewCell
            
            if filterGetdata == 1{
                contentCell = pickerFilterData[indexPath.row]
            }
            else{
                contentCell = datajson[indexPath.row + self.arrListGrouped[indexPath.section].index]
            }
        
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
//                    let number = String(describing: district_)
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
            
        cell.Label1?.text = (last_name as!String) + ", " + (first_name! as!String)
        cell.Label2?.text = (state_name! as!String)
        
        
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
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.US.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.US[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerState = self.US[row] 
        if pickerState == "All States"{
            for i in 0..<self.datajson.count{
                self.pickerFilterData.append(self.datajson[i])
            }
            //viewWillAppear(true)
            filterGetdata = 0
            pickerFilter = 0
            viewDidLoad()
        }
        else{
        self.pickerFilterState()
        
        self.arrListGrouped.removeAll()
        
        filterGetdata = 1
        self.table_refresh()
        }
    }
    
    func pickerFilterState(){
        
        for i in 0..<self.datajson.count{
            if (self.datajson[i]["state_name"] as!String) == self.pickerState{
                self.pickerFilterData.append(self.datajson[i])
            }
        }
        self.pickerFilterData = self.pickerFilterData.sorted(by: {($0["last_name"] as!String)<($1["last_name"] as!String)})
        
    }

}







