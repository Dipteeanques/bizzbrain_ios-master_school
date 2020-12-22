//
//  ExamResultListViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 06/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ExamResultListViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var student_id = Int()
    var arrDatesheet = NSArray()
    let activityIndicator = UIActivityIndicatorView()
    
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
        let parameters = ["student_id": student_id]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(EXAM_RESULTS, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    self.arrDatesheet = json.value(forKey: "data") as! NSArray
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


extension ExamResultListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatesheet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblDatesheetCell
        cell.lblTitle.text = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "name")as? String
        cell.lblDate.text = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "start_date")as? String
//        let result = date!.filter { !$0.isNewline && !$0.isWhitespace }
//        cell.lblDate.text = result
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "id")as? Int
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultViewController")as! ExamResultViewController
        obj.type_id = String(id!)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
