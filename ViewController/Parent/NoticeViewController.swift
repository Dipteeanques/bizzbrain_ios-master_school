//
//  NoticeViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 06/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class NoticeViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    var flag = ""
    
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var student_id = Int()
    var arrNotice = NSMutableArray()
    let activityIndicator = UIActivityIndicatorView()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var pagecount = 1
    
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
        noticeAPI(page: pagecount, strcheck: false)
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
    }
    
    func noticeAPI(page:Int,strcheck:Bool) {
        let parameters = ["student_id": student_id,"page":page]
        print("parameters:",parameters)
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(push_notification_list, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                   
                    if strcheck == true{
                        let arr = data.value(forKey: "data")
                        self.arrNotice.addObjects(from: arr as! [Any])//adding(arr!)
                    }
                    else {
                        let arr = data.value(forKey: "data") as! NSArray
                        self.arrNotice = arr.mutableCopy() as! NSMutableArray//as! NSArray
                    }
                    self.tblView.reloadData()
                    self.flag = ""
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

extension NoticeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblNoticeCell
        let title = (self.arrNotice[indexPath.row]as AnyObject).value(forKey: "title")as? String
        cell.lblNewassign.text = title
        cell.lblDate.text = (self.arrNotice[indexPath.row]as AnyObject).value(forKey: "date")as? String
        cell.lblDesc.text = (self.arrNotice[indexPath.row]as AnyObject).value(forKey: "body")as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let redirect_action = (self.arrNotice[indexPath.row]as AnyObject).value(forKey: "redirect_action")as? String
        if redirect_action == "assignment" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentViewController")as! AssignmentViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else{
            appDel.gotoParent()
        }
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == arrNotice.count {
//            print("do something")
//            self.pagecount = self.pagecount + 1
//            self.noticeAPI(page: self.pagecount)
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            print("load more rows")
            if flag == ""{
                flag = "ok"
            self.pagecount = self.pagecount + 1
                self.noticeAPI(page: self.pagecount, strcheck: true)
            }
        }
    }
}



class tblNoticeCell: UITableViewCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNewassign: UILabel!
    @IBOutlet weak var backView: UIView! {
           didSet {
               backView.layer.cornerRadius = 8
               backView.layer.borderWidth = 1
               backView.layer.borderColor = UIColor.black.cgColor
           }
       }
}
