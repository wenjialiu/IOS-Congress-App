//
//  Legi_ViewDetails.swift
//  temp
//
//  Created by 子不语 on 2016/11/22.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Legi_ViewDetails: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet weak var imageFromURL: UIImageView!
    
    @IBOutlet weak var tableContent: UITableView!
    
    
    var people : [String:AnyObject] = Dictionary()
    var image : UIImage?
    
    let yellowStar = UIColor(red: 255/255.0, green: 208/255.0, blue: 55/255.0, alpha: 1.0)
    
    //var favorite = [[String:String]]()
    let key = "keySave"
    var data = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
//        let appDomain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: appDomain)

        self.navigationItem.title = "Legislator Detail"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPage))
        
        
        self.tableContent.register(UINib(nibName: "ViewDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewDetailTableViewCell")
        
        
        self.tableContent.register(UINib(nibName: "LinkDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkDetailTableViewCell")
        
        //show imageView
        let img_url = people["bioguide_id"] as!String
        let img_jpg = "http://theunitedstates.io/images/congress/225x275/" + img_url + ".jpg"
        if let image_url = URL(string: img_jpg){
            if let image_data = try? Data(contentsOf: image_url){
            image = UIImage(data: image_data)
            imageFromURL.image = image
            }
        }

        
        tableContent.delegate = self
        tableContent.dataSource = self
        
        let defaults = UserDefaults.standard
       
        data["first_name"] = people["first_name"] as? String
        data["last_name"] = people["last_name"] as?String
        data["state_name"] = people["state_name"] as?String
        data["birthday"] = people["birthday"] as?String
        data["gender"] = people["gender"] as?String
        data["chamber"] = people["chamber"] as?String
        data["office"] = people["office"] as?String
        data["term_end"] = people["term_end"] as?String
        data["bioguide_id"] = people["bioguide_id"] as?String
        data["party"] = people["party"] as?String
        
        if let district = people["district"]{
            if let district_ = district as?String{
                //let number = String(describing: district_)
                data["district"] = district_
                
            }
            else{
                data["district"] = ""
            }
        }
        else{
            data["district"] = ""
        }
        
        if let fax = people["fax"]{
            if let fax_ = fax as?String{
                data["fax"] = fax_
            }
            else{
                data["fax"] = ""
            }
        }
        else{
            data["fax"] = ""
        }
        
        if let twitter_id = people["twitter_id"]{
            if let twitter_id_ = twitter_id as?String{
                data["twitter_id"] = twitter_id_
            }
            else{
                data["twitter_id"] = ""
            }
        }
        else{
            data["twitter_id"] = ""
        }
        
        if let facebook_id = people["facebook_id"]{
            if let facebook_id_ = facebook_id as?String{
                data["facebook_id"] = facebook_id_
            }
            else{
                data["facebook_id"] = ""
            }
        }
        else{
            data["facebook_id"] = ""
        }
        
        if let website = people["website"]{
            if let website_ = website as?String{
                data["website"] = website_
            }
            else{
                data["website"] = ""
            }
        }
        else{
            data["website"] = ""
        }
        
        
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var favorite : [[String:String]] = testArray! as![[String:String]]
            
            var signal = 0
            for i in 0..<favorite.count{
                if favorite[i] == data{
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
        
        let defaults = UserDefaults.standard
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject??{
            var favorite : [[String:String]] = testArray! as![[String:String]]
    
            var signal = 0
            for i in 0..<favorite.count{
                if favorite[i] == data{
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
            var newArray : [[String:String]] = testArray! as![[String:String]]
            var favorite : [[String:String]] = Array()
            for i in 0..<newArray.count{
                if newArray[i] != data{
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
            var favorite : [[String:String]] = testArray! as![[String:String]]
            favorite.append(data)
            defaults.set(favorite, forKey: key)
        }
        else{
            var emptyFavorite = [[String:String]]()
            emptyFavorite.append(data)
           
            defaults.set(emptyFavorite,forKey:key)
        }
        UserDefaults.standard.synchronize()
     
    }
    
    func backToPage(){
        self.dismiss(animated: true, completion: nil)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SenateTableViewController") as! SenateTableViewController
//        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    

    //return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

//    // create a cell for each table view row
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            cell.Text1?.text = "First Name"
            cell.Text2?.text = people["first_name"] as?String
            return cell
        }
        if indexPath.row == 1{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            cell.Text1?.text = "Last Name"
            cell.Text2?.text = people["last_name"] as?String
            return cell
        }
        if indexPath.row == 2{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            cell.Text1?.text = "State"
            cell.Text2?.text = people["state_name"] as?String

            //cell.textLabel?.text = "State               " + (people["state_name"] as!String)
            return cell
        }
        if indexPath.row == 3{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            let datePrev = DateFormatter()
            datePrev.dateFormat = "yyyy-MM-dd"
            
            let change = datePrev.date(from: (people["birthday"] as!String))
            
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "dd MMM yyyy"
            let dateString = timeFormat.string(from: change!)
            
            cell.Text1?.text = "Birth date"
            cell.Text2?.text = dateString
            
            //cell.textLabel?.text = "Birth date       " + dateString
            return cell
        }
        if indexPath.row == 4{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            cell.Text1?.text = "Gender"
            
            if people["gender"] as!String == "M"{
            cell.Text2?.text = "Male"
            }
            if people["gender"] as!String == "F"{
            cell.Text2?.text = "Female"
            }
            return cell
        }
        if indexPath.row == 5{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            cell.Text1?.text = "Chamber"
            
            if people["chamber"] as!String == "house"{
            cell.Text2?.text = "House"
            }
            if people["chamber"] as!String == "senate"{
            cell.Text2?.text = "Senate"
            }
            return cell
        }
        if indexPath.row == 6{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            cell.Text1?.text = "Fax No."
            
            if let fax_ = people["fax"]{
                if let realFax = fax_  as?String{
                    if realFax != ""{
                        cell.Text2?.text = realFax
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

            if let twitterID = people["twitter_id"]{
                
                if let realTwitterID = twitterID as?String {
                    if realTwitterID != ""{
                    let cellIdentifier = "LinkDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!LinkDetailTableViewCell
                    let idTwitter = realTwitterID
                    
                    cell.url = "http://twitter.com/" + idTwitter
                    
                    cell.Link1?.text = "Twitter"
                    cell.Link2?.setTitle("Twitter Link", for: .normal)
                    
                    return cell
                    }
                    else{
                        let cellIdentifier = "ViewDetailTableViewCell"
                        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                        cell.Text1?.text = "Twitter"
                        cell.Text2?.text = "N/A"
                        return cell
                    }
                }
                else{
                    let cellIdentifier = "ViewDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                    cell.Text1?.text = "Twitter"
                    cell.Text2?.text = "N/A"
                    return cell
                }
            }
            else{
                let cellIdentifier = "ViewDetailTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                cell.Text1?.text = "Twitter"
                cell.Text2?.text = "N/A"
                return cell
            }
        }
        if indexPath.row == 8{
            if let facebookID = people["facebook_id"] {
                if let realFacebookID = facebookID as?String{
                    if realFacebookID != ""{
                    let cellIdentifier = "LinkDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!LinkDetailTableViewCell
                    let idFacebook = realFacebookID
                    
                    cell.Link1?.text = "Facebook"
                    cell.Link2?.setTitle("Facebook Link", for: .normal)
                    cell.url = "http://facebook.com/" + idFacebook
                    return cell
                    }
                    else{
                        let cellIdentifier = "ViewDetailTableViewCell"
                        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                        cell.Text1?.text = "Facebook"
                        cell.Text2?.text = "N/A"
                        return cell
                    }
                }
                else{
                    let cellIdentifier = "ViewDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                    cell.Text1?.text = "Facebook"
                    cell.Text2?.text = "N/A"
                    return cell
                }
            }
            else{
                let cellIdentifier = "ViewDetailTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                cell.Text1?.text = "Facebook"
                cell.Text2?.text = "N/A"
                return cell
            }
        }
        if(indexPath.row == 9){
            if let website = people["website"] {
                if let realWebsite = website as?String{
                    if realWebsite != ""{
                    let cellIdentifier = "LinkDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!LinkDetailTableViewCell
                        cell.url = realWebsite
                    
                        cell.Link1?.text = "Website"
                        cell.Link2?.setTitle("Website", for: .normal)
                    return cell
                    }
                    else{
                        let cellIdentifier = "ViewDetailTableViewCell"
                        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                        cell.Text1?.text = "Website"
                        cell.Text2?.text = "N/A"
                        return cell
                    }
                }
                else{
                    let cellIdentifier = "ViewDetailTableViewCell"
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                    cell.Text1?.text = "Website"
                    cell.Text2?.text = "N/A"
                    return cell
                }
                
            }
            else{
                let cellIdentifier = "ViewDetailTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
                cell.Text1?.text = "Website"
                cell.Text2?.text = "N/A"
                return cell
            }

        }
        if indexPath.row == 10{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            let officeLocation : String? = people["office"] as?String
            
            cell.Text1?.text = "Office No."
            
            if officeLocation == nil || officeLocation == ""{
                cell.Text2?.text = "N/A"
            }
            else{
                cell.Text2?.text = officeLocation
            }
            return cell
        }
        if indexPath.row == 11{
            let cellIdentifier = "ViewDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!ViewDetailTableViewCell
            
            cell.Text1?.text = "Term ends on"
            
            let datePrev = DateFormatter()
            datePrev.dateFormat = "yyyy-MM-dd"
            let change = datePrev.date(from: (people["term_end"] as!String))
            
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "dd MMM yyyy"
            let dateString = timeFormat.string(from: change!)
            
            cell.Text2?.text = dateString
            return cell
        }
        return UITableViewCell()
    }

}
