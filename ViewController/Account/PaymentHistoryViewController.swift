//
//  PaymentHistoryViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PaymentHistoryViewController: UIViewController {

   
    @IBOutlet weak var foundView: UIView!
    @IBOutlet weak var tblPayment: UITableView!
    
    var arrPayment = NSArray()
    var arrmembership = NSArray()
    var selectedIndex : NSInteger! = -1
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPayment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getPayment() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(HISTORY, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.arrPayment = data.value(forKey: "data")as! NSArray
                    if self.arrPayment.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tblPayment.reloadData()
                    }
                }
                else {
                    self.foundView.isHidden = false
                }
           }
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: Tableview Method

extension PaymentHistoryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrPayment.count == 0 {
            return 5
        }
        else {
            return arrPayment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrPayment.count == 0 {
            let cell = tblPayment.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblPaymentHistoryCell
            return cell
        }
        else {
            let data = arrPayment[indexPath.row]
            let cell = tblPayment.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblPaymentHistoryCell
            cell.lblTitle.text = (data as AnyObject).value(forKey: "order_number")as? String
            let created_at = (data as AnyObject).value(forKey: "created_at")as? String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate = formatter.date(from: created_at!)
            formatter.dateFormat = "HH:mm dd MMM yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            cell.lblDate.text = myStringafd
            let grossAmount = (data as AnyObject).value(forKey: "amount")as! Int
            cell.lblPrice.text = rupee + String(grossAmount)
           
            cell.imgStaticWaich.hideSkeleton()

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex{
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
            let data = arrPayment[selectedIndex]
            let cell = tblPayment.cellForRow(at: indexPath) as? tblPaymentHistoryCell
            let order_detail = (data as AnyObject).value(forKey: "order_detail")as? NSArray
            let sub_category_image = (order_detail?[0] as AnyObject).value(forKey: "sub_category_image")as? String
            url = URL(string: sub_category_image ?? "")
            cell?.imgPRO.sd_setImage(with: url, completed: nil)
            cell?.lblProName.text = (order_detail?[0] as AnyObject).value(forKey: "sub_category_name")as? String
            cell?.lblType.text = (order_detail?[0] as AnyObject).value(forKey: "type")as? String
            let grossAmount = (data as AnyObject).value(forKey: "amount")as? Int ?? 0
            cell?.lblgross.text = rupee + String(grossAmount)
            
            let discount = (data as AnyObject).value(forKey: "discount")as? Int ?? 0
            
            cell?.lblDiscount.text = rupee + String(discount)
            
            let total_amount = (data as AnyObject).value(forKey: "total_amount")as? Int ?? 0
            
            cell?.lbltotal.text = rupee + String(total_amount)
            cell?.lblPricePro.text = rupee + String(total_amount)
        }
        tblPayment.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex
        {
            return 275
        }else{
            return 75
        }
    }
}

