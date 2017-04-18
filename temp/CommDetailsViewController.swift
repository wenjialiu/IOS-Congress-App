//
//  CommDetailsViewController.swift
//  temp
//
//  Created by 子不语 on 2016/11/27.
//  Copyright © 2016年 子不语. All rights reserved.
//

import UIKit

class CommDetailsViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{

    var key = "keySaveComm"
    var data = [String:String]()
    var people : [String:AnyObject] = Dictionary()
    let yellowStar = UIColor(red: 255/255.0, green: 208/255.0, blue: 55/255.0, alpha: 1.0)
    
    @IBOutlet weak var text: UITextView!

    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.delegate = self
        detailTable.delegate = self
        detailTable.dataSource = self
        
        self.text.text = people["name"] as!String
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPage))
        self.starNotFilled()
        
        self.navigationItem.title = "Committee Detail"
        self.detailTable.register(UINib(nibName: "ViewDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewDetailTableViewCell")
        
        let defaults = UserDefaults.standard
        
        data["name"] = people["name"] as?String
        data["committee_id"] = people["committee_id"] as?String
        data["chamber"] = people["chamber"] as?String
        
        if let parent_id = people["parent_committee_id"]{
            if let parent_id_ = parent_id as?String{
                data["parent_committee_id"] = parent_id_
            }
            else{
                data["parent_committee_id"] = ""
            }
        }
        else{
            data["parent_committee_id"] = ""
        }
        
        if let office = people["office"]{
            if let office_ = office as?String{
                data["office"] = office_
            }
            else{
                data["office"] = ""
            }
        }
        else{
            data["office"] = ""
        }
        
        if let phone = people["phone"]{
            if let phone_ = phone as?String{
                data["phone"] = phone_
            }
            else{
                data["phone"] = ""
            }
        }
        else{
            data["phone"] = ""
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
        
        self.text.text = people["name"] as!String
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //table details
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //    // create a cell for each table view row
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDetailTableViewCell", for: indexPath) as!ViewDetailTableViewCell
        if indexPath.row == 0{
            cell.Text1?.text = "ID"
            cell.Text2?.text = people["committee_id"] as?String
        }
        if indexPath.row == 1{
            cell.Text1?.text = "parent ID"
            if let parent_id = people["parent_committee_id"]{
                if let parent_committee_id = parent_id as?String{
                    if parent_committee_id != ""{
                        cell.Text2?.text = parent_committee_id
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
        }
        if indexPath.row == 2{
            cell.Text1?.text = "Chamber"
            cell.Text2?.text = (people["chamber"] as?String)?.capitalized
        }
        if indexPath.row == 3{
            cell.Text1?.text = "Office"
            if let office = people["office"]{
                if let office_ = office as?String{
                    if office_ != ""{
                        cell.Text2?.text = office_
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
        }
        if indexPath.row == 4{
            cell.Text1?.text = "Contact"
            if let contact = people["phone"]{
                if let phone = contact as?String{
                    if phone != ""{
                        cell.Text2?.text = phone
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
        }
        return cell
    }
}
