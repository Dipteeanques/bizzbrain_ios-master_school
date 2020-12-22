//
//  FeesDetailsVC.swift
//  bizzbrains
//
//  Created by Anques on 14/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FeesDetailsVC: UIViewController {
    
    var wc = Webservice.init()
    var dicFeesdata : FeesData?

    @IBOutlet weak var tbl2_height: NSLayoutConstraint!
    @IBOutlet weak var tbl1_height: NSLayoutConstraint!
    @IBOutlet weak var totalpaymentview: UIView!{
        didSet{
            totalpaymentview.layer.cornerRadius = 5.0
            totalpaymentview.clipsToBounds = true
            totalpaymentview.layer.borderWidth = 1
            totalpaymentview.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var lbl_remailpayment: UILabel!
    
    @IBOutlet weak var tbl_feesBreakup: UITableView!{
        didSet{
            tbl_feesBreakup.layer.cornerRadius = 5.0
            tbl_feesBreakup.clipsToBounds = true
            tbl_feesBreakup.layer.borderWidth = 1
            tbl_feesBreakup.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var tbl_feesinstallment: UITableView!{
        didSet{
            tbl_feesinstallment.layer.cornerRadius = 5.0
            tbl_feesinstallment.clipsToBounds = true
            tbl_feesinstallment.layer.borderWidth = 1
            tbl_feesinstallment.layer.borderColor = UIColor.gray.cgColor
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13, *){
            
        }
        else{
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
        }
       
        if (loggdenUser.value(forKey: ROLE_ID) != nil) {
            let role_id = loggdenUser.value(forKey: ROLE_ID)as! Int
            if role_id == 6 {
                let user_id = loggdenUser.value(forKey: USER_ID)as? Int ?? 0
                getFeesDetail(student_id: user_id)
            }
            else{
                let student_id = loggdenUser.value(forKey: STUDENT_ID)as? Int ?? 0
                getFeesDetail(student_id: student_id)
            }
        }
    }
    

    @IBAction func btn_BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getFeesDetail(student_id: Int) {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: get_fessdetail, parameters: ["student_id":student_id], headers: headers, fromView: self.view, isLoading: true) { (success, response:RootClass?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.dicFeesdata = response!.data
//                    self.tblSubject.reloadData()
                    self.lbl_remailpayment.text = "₹ " + String(self.dicFeesdata?.remain_fees ?? 0)
                    
                    self.tbl_feesBreakup.reloadData()
                    self.tbl_feesinstallment.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tbl1_height?.constant = self.tbl_feesBreakup.contentSize.height
        self.tbl2_height?.constant = self.tbl_feesinstallment.contentSize.height
    }
}

extension FeesDetailsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbl_feesBreakup{
            return dicFeesdata?.fees_types.count ?? 0
        }
        else{
            return dicFeesdata?.fees_dues.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
            FeesCell
        
        if tableView == self.tbl_feesBreakup{
            cell.lbl_feestitle1.text = dicFeesdata?.fees_types[indexPath.row].title
            cell.lbl_fees1.text = "₹ " + String(dicFeesdata?.fees_types[indexPath.row].fees ?? 0)
        }
        else{
            cell.lbl_feestitle2.text = dicFeesdata?.fees_dues[indexPath.row].title
            cell.lbl_duedate.text = dicFeesdata?.fees_dues[indexPath.row].due_date
            cell.lbl_fees2.text = "₹ " + String(dicFeesdata?.fees_dues[indexPath.row].pay_fees ?? 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}



extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
