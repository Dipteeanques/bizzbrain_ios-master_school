//
//  DateSheetViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 03/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class SecondaryExamDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var wc = Webservice.init()
    var selectedRow = 0;
    var month_selecte = Int()
    var year_Select = String()
    var student_id = Int()
    var arrinfo = [Info]()
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var arrDatesheet = NSArray()
    var exam_id = String()
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
        let parameters = ["s_exam_type_id": exam_id]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(upcoming_exam_detail, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
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

extension SecondaryExamDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatesheet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblSecondExamCell
        cell.lblTitle.text = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "subjects_name")as? String
        cell.lblTime.text = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "time")as? String
        cell.lblDate.text = (self.arrDatesheet[indexPath.row]as AnyObject).value(forKey: "start_date")as? String
//        let result = date!.filter { !$0.isNewline && !$0.isWhitespace }
//        cell.lblDate.text = result
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

class tblSecondExamCell: UITableViewCell {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var BackView: UIView! {
        didSet {
            BackView.layer.cornerRadius = 50
            BackView.clipsToBounds = true
        }
    }
    
}
