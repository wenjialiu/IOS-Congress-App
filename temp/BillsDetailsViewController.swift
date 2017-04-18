//
//  BillsDetailsViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/27.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class BillsDetailsViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {


    var key = "keySaveBill"
//    var data = [String:AnyObject]()   
    var data = [String:AnyObject]()
    var people : [String:AnyObject] = Dictionary()
    
    let yellowStar = UIColor(red: 255/255.0, green: 208/255.0, blue: 55/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.TextView.text = people["official_title"] as?String
        
//        let appDomain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: appDomain)
//        
        TextView.delegate = self
        TableDetails.delegate = self
        TableDetails.dataSource = self
        
        self.navigationItem.title = "Bill Detail"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPage))
        self.starNotFilled()
        
        self.TableDetails.register(UINib(nibName: "ViewDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewDetailTableViewCell")
        
        self.TableDetails.register(UINib(nibName: "LinkDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkDetailTableViewCell")
        
        let defaults = UserDefaults.standard
        
        data["bill_id"] = people["bill_id"] as AnyObject
        data["official_title"] = people["official_title"] as AnyObject
        data["bill_type"] = people["bill_type"] as AnyObject
        data["chamber"] = people["chamber"] as AnyObject
        data["introduced_on"] = people["introduced_on"] as AnyObject
        
        let history = people["history"]?["active"] as!Bool
        data["history"] = [String:[String:AnyObject]]() as AnyObject
        var mid = data["history"] as![String:AnyObject]
        mid["active"] = history as AnyObject
        data["history"] = mid as AnyObject
        
        data["sponsor"] = people["sponsor"] as AnyObject
        
        let first_name = people["sponsor"]?["first_name"] as!String
        let last_name = people["sponsor"]?["last_name"] as!String
        let title = people["sponsor"]?["title"] as!String
        data["sponsor"] = [String:[String:AnyObject]]() as AnyObject
        var mid2 = data["sponsor"] as![String:AnyObject]
        mid2["first_name"] = first_name as AnyObject
        mid2["last_name"] = last_name as AnyObject
        mid2["title"] = title as AnyObject
        data["sponsor"] = mid2 as AnyObject
        
        data["last_version"] = [String:[String:AnyObject]]() as AnyObject?
        let last_version = people["last_version"] as![String:AnyObject]
        let urls = last_version["urls"] as![String:AnyObject]
        var pdf_url : String
        if let pdf = urls["pdf"]{
            if let pdf_ = pdf as?String{
                pdf_url = pdf_
                //data["last_version"] = first as AnyObject?
            }
            else{
                pdf_url = ""
            }
        }
        else{
            pdf_url = ""
        }
        
        var data1 = [String:AnyObject]()
        data1["pdf"] = pdf_url as AnyObject?
        var data2 = [String:AnyObject]()
        data2["urls"] = data1 as AnyObject?
        data["last_version"] = data2 as AnyObject?
        
        
        if let short_title = people["short_title"]{
            if let short_title_ = short_title as?String{
                data["short_title"] = short_title_ as AnyObject?
            }
            else{
                data["short_title"] = "" as AnyObject?
            }
        }
        else{
            data["short_title"] = "" as AnyObject?
        }

        if let last_vote_at = people["last_vote_at"]{
            if let last_vote_at_ = last_vote_at as?String{
                data["last_vote_at"] = last_vote_at_ as AnyObject?
            }
            else{
                data["last_vote_at"] = "" as AnyObject?
            }
        }
        else{
            data["last_vote_at"] = "" as AnyObject?
        }
        
        if let last_action_at = people["last_action_at"]{
            if let last_action_at_ = last_action_at as?String{
                data["last_action_at"] = last_action_at_ as AnyObject?
            }
            else{
                data["last_action_at"] = "" as AnyObject?
            }
        }
        else{
            data["last_action_at"] = "" as AnyObject?
        }
        
        
        
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var favorite : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
           
            var signal = 0
            for i in 0..<favorite.count{
                if NSDictionary(dictionary: favorite[i]).isEqual(to: data){
                    signal = 1
                    let starFilled_img = UIImage(named:"starFilled")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:starFilled_img, style: .plain, target: self, action: #selector(starNotFilled))
                    self.navigationItem.rightBarButtonItem?.tintColor = yellowStar
                }
            }
            if signal == 0{
                let star_img = UIImage(named:"star")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:star_img, style: .plain, target: self, action: #selector(starFilled))
            }
        }
        else{
            let star_img = UIImage(named:"star")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:star_img, style: .plain, target: self, action: #selector(starFilled))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TextView.text = people["official_title"] as?String
        let defaults = UserDefaults.standard
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var favorite : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
           
            var signal = 0
            for i in 0..<favorite.count{
                if NSDictionary(dictionary:favorite[i]).isEqual(to: data){
                    signal = 1
                    let starFilled_img = UIImage(named:"starFilled")
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:starFilled_img, style: .plain, target: self, action: #selector(starNotFilled))
                    self.navigationItem.rightBarButtonItem?.tintColor = yellowStar
                }
            }
            if signal == 0{
                let star_img = UIImage(named:"star")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:star_img, style: .plain, target: self, action: #selector(starFilled))
            }
        }
        else{
            let star_img = UIImage(named:"star")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:star_img, style: .plain, target: self, action: #selector(starFilled))
        }
     
        
    }
    
    func starNotFilled(){
        let star_img = UIImage(named:"star")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:star_img, style: .plain, target: self, action: #selector(starFilled))
        
        let defaults = UserDefaults.standard
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var newArray : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
            var favorite : [[String:AnyObject]] = Array()
            for i in 0..<newArray.count{
                if !(NSDictionary(dictionary: newArray[i]).isEqual(to: data)){
                    favorite.append(newArray[i])
                }
            }
            defaults.set(favorite, forKey: key)
        }
    
        
    }
    
    func starFilled(){
        let starFilled_img = UIImage(named:"starFilled")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:starFilled_img, style: .plain, target: self, action: #selector(starNotFilled))
        self.navigationItem.rightBarButtonItem?.tintColor = yellowStar
        
        let defaults = UserDefaults.standard
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var favorite : [[String:AnyObject]] = testArray! as![[String:AnyObject]]
            favorite.append(data)
            defaults.set(favorite, forKey: key)
        }
        else{
            var emptyFavorite = [[String:AnyObject]]()
            emptyFavorite.append(data)
           
            defaults.set(emptyFavorite,forKey:key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func backToPage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var TableDetails: UITableView!
    

    //table details
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    //    // create a cell for each table view row
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkDetailTableViewCell", for: indexPath) as!LinkDetailTableViewCell
            cell.Link1?.text = "PDF"
            
            let last_version = people["last_version"] as![String:AnyObject]
            let urls = last_version["urls"] as![String:AnyObject]
            if let link = urls["pdf"]{
                if let pdf_url = link as?String{
                    if pdf_url != ""{
                        cell.Link2?.setTitle("PDF Link", for: .normal)
                        cell.url = pdf_url
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDetailTableViewCell", for: indexPath) as!ViewDetailTableViewCell
                        cell.Text1?.text = "PDF"
                        cell.Text2?.text = "N/A"
                    }
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDetailTableViewCell", for: indexPath) as!ViewDetailTableViewCell
                    cell.Text1?.text = "PDF"
                    cell.Text2?.text = "N/A"
                }
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDetailTableViewCell", for: indexPath) as!ViewDetailTableViewCell
                cell.Text1?.text = "PDF"
                cell.Text2?.text = "N/A"
            }
            return cell
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDetailTableViewCell", for: indexPath) as!ViewDetailTableViewCell
        if indexPath.row == 0{
            cell.Text1?.text = "Bill ID"
            cell.Text2?.text = people["bill_id"] as?String
            return cell
        }
        if indexPath.row == 1{
            cell.Text1?.text = "Bill Type"
            cell.Text2?.text = (people["bill_type"] as!String).uppercased()
            return cell
        }
        if indexPath.row == 2{
            cell.Text1?.text = "Sponsor"
            cell.Text2?.text = (people["sponsor"]?["title"] as!String) + " " + (people["sponsor"]?["first_name"] as!String) + " " + (people["sponsor"]?["last_name"] as!String)
            return cell
        }
        if indexPath.row == 3{
            cell.Text1?.text = "Last Action"
            
            if let last_action = people["last_action_at"]{
                if let last_action_ = last_action as?String{
                    let last_action_at = last_action_
                    if last_action_at != ""{
                    var change = Date()
                    if last_action_at.characters.count == 10{
                        let datePrev = DateFormatter()
                        datePrev.dateFormat = "yyyy-MM-dd"
                        change = datePrev.date(from: last_action_at)!
                        
                    }
                    else{
                        let datePrev = DateFormatter()
                        datePrev.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        change = datePrev.date(from: last_action_at)!
                        
                    }
                    let timeFormat = DateFormatter()
                    timeFormat.dateFormat = "dd MMM yyyy"
                    let dateString = timeFormat.string(from: change)
                    
                    cell.Text2?.text = dateString
                    }
                    else{
                        cell.Text2?.text = "N/A"
                    }
                }
                else{
                    cell.Text2?.text = "N/A"
                }
            }
            else{
                cell.Text2?.text = "N/A"
            }

            return cell
        }
        
        if indexPath.row == 5{
            cell.Text1?.text = "Chamber"
            var chamber = people["chamber"] as!String
            if chamber == "senate"{
                chamber = "Senate"
            }
            else{
                chamber = "House"
            }
            cell.Text2?.text = chamber
        }
        if indexPath.row == 6{
            cell.Text1?.text = "Last Vote"
            if let last_vote = people["last_vote_at"]{
                if let last_vote_ = last_vote as?String{
                    let last_vote_at = last_vote_
                    if last_vote_at != ""{
                    var change = Date()
                    if last_vote_at.characters.count == 10{
                        let datePrev = DateFormatter()
                        datePrev.dateFormat = "yyyy-MM-dd"
                        change = datePrev.date(from: last_vote_at)!
                        
                    }
                    else{
                        let datePrev = DateFormatter()
                        datePrev.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        change = datePrev.date(from: last_vote_at)!
                        
                    }
                        
                    let timeFormat = DateFormatter()
                    timeFormat.dateFormat = "dd MMM yyyy"
                    let dateString = timeFormat.string(from: change)
                    
                    cell.Text2?.text = dateString
                    }
                    else{
                        cell.Text2?.text = "N/A"
                    }
                }
                else{
                    cell.Text2?.text = "N/A"
                }
            }
            else{
                cell.Text2?.text = "N/A"
            }

            
            return cell
        }
            if indexPath.row == 7{
                cell.Text1?.text = "Status"
                let history = people["history"] as![String:AnyObject]
                if (history["active"]as!Bool){
                    cell.Text2?.text = "Active"
                }
                else{
                    cell.Text2?.text = "New"
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    

}
