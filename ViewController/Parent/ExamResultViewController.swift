//
//  ExamResultViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 06/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ExamResultViewController: UIViewController {
    
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var student_id = Int()
    var arrResult = NSArray()
    let activityIndicator = UIActivityIndicatorView()
    var type_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdefault()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSelection), name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func StudentSelection(notification: NSNotification) {
        setdefault()
    }
    func setdefault() {
        activityIndicator.style = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        if (loggdenUser.value(forKey: STUDENT_ID) != nil) {
            student_id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        }
        examResultAPI()
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
    }
    
    func examResultAPI() {
        let parameters = ["student_id": student_id,
                          "s_exam_type_id":type_id] as [String : Any]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(EXAM_RESULT_DETAIL, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    let result = data.value(forKey: "result")as! NSDictionary
                    self.lblPer.text = result.value(forKey: "percentage")as? String
                    let rank = result.value(forKey: "rank")as? Int
                    self.lblRank.text = String(rank!)
                    self.arrResult = data.value(forKey: "result_data")as! NSArray
                    self.tblView.reloadData()
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblView.bounds.size.width, height: self.tblView.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblView.backgroundView  = noDataLabel
                    self.tblView.separatorStyle  = .none
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
    @IBAction func btnProImageAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ExamResultViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! examTableCell
        cell.lblTitle.text = (self.arrResult[indexPath.row]as AnyObject).value(forKey: "name")as? String
        let total = (self.arrResult[indexPath.row]as AnyObject).value(forKey: "total")as? Int
        cell.lbltotal.text = String(total!)
        let result = (self.arrResult[indexPath.row]as AnyObject).value(forKey: "marks")as? Int
        cell.lblResult.text = String(result!)
        if indexPath.row == arrResult.count - 1 {
            cell.lblTitle.textColor = UIColor.red
            cell.lbltotal.textColor = UIColor.red
            cell.lblResult.textColor = UIColor.red
            cell.lblT.textColor = UIColor.red
            cell.lblR.textColor = UIColor.red
        }
        else {
            cell.lblTitle.textColor = UIColor.black
            cell.lbltotal.textColor = UIColor.black
            cell.lblResult.textColor = UIColor.black
            cell.lblT.textColor = UIColor.black
            cell.lblR.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

class examTableCell: UITableViewCell {
    
    @IBOutlet weak var lblR: UILabel!
    @IBOutlet weak var lblT: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lbltotal: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}
