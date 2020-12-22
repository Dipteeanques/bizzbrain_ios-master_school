//
//  CouponslistViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 26/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class CouponslistViewController: UIViewController {

    @IBOutlet weak var tblCoupons: UITableView!
    @IBOutlet weak var foundView: UIView!
    
    var sub_total = String()
    var arrCoupons = NSArray()
    var wc = Webservice.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       CouponsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func CouponsList() {
        let param = ["sub_total":sub_total]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(COUPONSLIST, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                //let message = json.value(forKey: "message")as! String
                if sucess == true {
                    self.arrCoupons = json.value(forKey: "data")as! NSArray
                    self.tblCoupons.reloadData()
                }
                else {
                    self.foundView.isHidden = false
                }
        }
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

extension CouponslistViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCoupons.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblCouponsCell
        cell.lblCoupon.text = (self.arrCoupons[indexPath.row]as AnyObject).value(forKey: "coupon_code")as? String
        cell.lblDiscount.text = (self.arrCoupons[indexPath.row]as AnyObject).value(forKey: "title")as? String
        cell.btnApply.addTarget(self, action: #selector(CouponslistViewController.btnApplyAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func btnApplyAction(_ sender: UIButton) {
        if let indexPath = self.tblCoupons.indexPathForView(sender) {
            let cell = tblCoupons.cellForRow(at: indexPath)as! tblCouponsCell
            cell.activity.startAnimating()
            cell.activity.isHidden = false
            cell.btnApply.setTitle(" ", for: .normal)
            let couponcode = (self.arrCoupons[indexPath.row]as AnyObject).value(forKey: "coupon_code")as! String
            let param = ["sub_total":sub_total,
                         "coupon_code":couponcode]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let headers: HTTPHeaders = ["Xapi": Xapi,
                                        "Authorization":token]
            wc.callSimplewebservice(url: CHECK_COUPONS, parameters: param, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: couponsCheckResponsModel?) in
                if sucess {
                    let data = response?.data
                    let sub_total = data?.sub_total
                    let discount_amount = data?.discount_amount
                    let total_amount = data?.total_amount
                    let object: [String: Any] = ["sub_total": sub_total!, "discount_amount": discount_amount!,"total_amount":total_amount!,"CouponCode":couponcode]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Discount"), object: object)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}



class tblCouponsCell: UITableViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView! {
        didSet {
            activity.isHidden = true
        }
    }
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblCoupon: UILabel!
    
    
}
