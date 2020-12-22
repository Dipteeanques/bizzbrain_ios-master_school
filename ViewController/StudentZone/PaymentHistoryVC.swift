//
//  PaymentHistoryVC.swift
//  bizzbrains
//
//  Created by Anques on 16/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PaymentHistoryVC: UIViewController {
    var wc = Webservice.init()
    var arrpaymenthistory = [HistoryData]()
    @IBOutlet weak var lbl_info: UILabel!
    
    @IBOutlet weak var TblPaymentHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getFeesDetail(student_id: Int) {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: get_fees_payment_history, parameters: ["student_id":student_id], headers: headers, fromView: self.view, isLoading: true) { (success, response:PaymentHistoryRoot?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.arrpaymenthistory = response!.data
                    self.TblPaymentHistory.reloadData()
                }
                else {
                    print("jekil")
                }
            }
            else{
                self.TblPaymentHistory.isHidden = true
                self.lbl_info.isHidden = false
            }
        }
    }
}

extension PaymentHistoryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrpaymenthistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentHistoryCell
        cell.lbl_date.text = self.arrpaymenthistory[indexPath.row].created_at
        cell.lbl_invoice_number.text = self.arrpaymenthistory[indexPath.row].invoice_number
        cell.lbl_amount.text = String(self.arrpaymenthistory[indexPath.row].total_fees)
        cell.lbl_paymentmethod.text = self.arrpaymenthistory[indexPath.row].remark
        cell.btn_showreceipt.tag = indexPath.row
        cell.btn_showreceipt.addTarget(self, action: #selector(ShowReceiptAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func ShowReceiptAction(sender:UIButton) {
        print("tag:",sender.tag)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PDFviewcontroller")as! PDFviewcontroller
        obj.strTitle = "Fee Receipt"
        obj.strPdf = self.arrpaymenthistory[sender.tag].invoice_full_url
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}
