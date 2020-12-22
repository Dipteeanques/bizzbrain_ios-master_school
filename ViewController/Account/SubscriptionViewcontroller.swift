//
//  SubscriptionViewcontroller.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SubscriptionViewcontroller: UIViewController {

    @IBOutlet weak var foundView: UIView!
    @IBOutlet weak var tblSubscription: UITableView!
    
    var arrSubscription = NSArray()
    var strNumber = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         getCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false       
    }
    
    func getResult() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(SUBSCRIPTION, method: .post, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.arrSubscription = data.value(forKey: "data")as! NSArray
                    if self.arrSubscription.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tblSubscription.reloadData()
                    }
                }
                else {
                    self.foundView.isHidden = false
                }
          }
    }
    
    func getCall() {
       let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(CallSetting, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.strNumber = data.value(forKey: "contact_us_phone_number")as! String
                }
               
          }
    }
    
   
    @IBAction func btnCallAction(_ sender: UIButton) {
        strNumber.makeAColl()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SubscriptionViewcontroller: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSubscription.count == 0 {
            return 10
        }
        else {
            return arrSubscription.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrSubscription.count == 0 {
            let cell = tblSubscription.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblSubscriptioncell
            return cell
        }
        else {
            let subscription = arrSubscription[indexPath.row]
            let cell = tblSubscription.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblSubscriptioncell
            let dic = (subscription as AnyObject).value(forKey: "main_categories")as! NSDictionary
            let title = dic.value(forKey: "title")as! String
            cell.lblTitle.text = title
            let created_at = (subscription as AnyObject).value(forKey: "created_at")as! String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate = formatter.date(from: created_at)
            formatter.dateFormat = "HH:mm dd MMM yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            cell.lblDate.text = myStringafd
            let is_expire = (subscription as AnyObject).value(forKey: "is_expire")as! Int
            if is_expire == 1 {
                cell.btnRenew.isHidden = false
                cell.btnRenew.layer.cornerRadius = 5
                cell.btnRenew.clipsToBounds = true
            }
            else {
                cell.btnRenew.isHidden = true
            }
            
            let is_free = (subscription as AnyObject).value(forKey: "is_free")as! Int
            if is_free == 1 {
                cell.lblExpire.text = "Free"
            }
            else {
                if (subscription as AnyObject).value(forKey: "expiry_date") is NSNull {
                    cell.lblExpire.text = "Free"
                }
                else {
                    let expiry_date = (subscription as AnyObject).value(forKey: "expiry_date")as! String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let yourDate = formatter.date(from: expiry_date)
                    formatter.dateFormat = "dd MMM yyyy"
                    let myStringafd = formatter.string(from: yourDate!)
                    cell.lblExpire.text = "Expired on " + myStringafd
                }
            }
            
            cell.imgStatic.hideSkeleton()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
