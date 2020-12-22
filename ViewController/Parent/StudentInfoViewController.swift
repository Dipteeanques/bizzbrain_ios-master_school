//
//  StudentInfoViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

struct Info {
    let name: String?
    let desc: String?
}

class StudentInfoViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblMain: UITableView!
    
    var wc = Webservice.init()
    var selectedRow = 0;
    var month_selecte = Int()
    var year_Select = String()
    var student_id = Int()
    var arrinfo = [Info]()
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    
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
        if (loggdenUser.value(forKey: STUDENT_ID) != nil) {
            student_id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        }
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
        getInfo()
    }
    
    func getInfo() {
        let param = ["student_id": student_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: STUDENTS_INFO, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: InfoModelRespons?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    let name = data?.name
                    let email = data?.email
                    let mobile = data?.phoneNumber
                    let schoolname = data?.schoolName
                    let school_address = data?.schoolAddress
                    let school_email = data?.schoolEmail
                    let section = data?.section
                    let hod_name = data?.hodName
                    let hod_phone_number = data?.hodPhoneNumber
                    let teacher_name = data?.teacherName
                    let teacher_phone_number = data?.teacherPhoneNumber
                    
                    self.arrinfo.append(Info.init(name: "Student Name", desc: name))
                    self.arrinfo.append(Info.init(name: "Student Email Address", desc: email))
                    self.arrinfo.append(Info.init(name: "Parents Mobile no.", desc: mobile))
                    self.arrinfo.append(Info.init(name: "HOD Name", desc: hod_name))
                    self.arrinfo.append(Info.init(name: "HOD Mobile no.", desc: hod_phone_number))
                    self.arrinfo.append(Info.init(name: "Teacher name", desc: teacher_name))
                    self.arrinfo.append(Info.init(name: "Teacher Mobile no.", desc: teacher_phone_number))
                    self.arrinfo.append(Info.init(name: "Student division/section", desc: section))
                    self.arrinfo.append(Info.init(name: "School Name", desc: schoolname))
                    self.arrinfo.append(Info.init(name: "School Mobile no.", desc: teacher_phone_number))
                    self.arrinfo.append(Info.init(name: "School Email Address", desc: school_email))
                    self.arrinfo.append(Info.init(name: "School Address", desc: school_address))
                    self.tblMain.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }
    
    @IBAction func btnProImageAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
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

extension StudentInfoViewController: UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrinfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! StudentInfoTableViewCell
        cell.lblTitle.text = arrinfo[indexPath.row].name
        cell.lblDesc.text = arrinfo[indexPath.row].desc
        if cell.lblTitle.text == "Student Email Address" {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-new-post-100"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "Parents Mobile no." {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-phone-96"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "HOD Mobile no." {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-phone-96"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "Teacher Mobile no." {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-phone-96"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "School Mobile no." {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-phone-96"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "School Email Address" {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-new-post-100"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else {
            cell.btnIcon.isHidden = true
        }
        cell.btnIcon.tintColor = redcolor
        cell.btnIcon.addTarget(self, action: #selector(self.btnIconAction), for: .touchUpInside)
        return cell
    }
    
    
    @objc func btnIconAction(_ sender: UIButton) {
        if let indexpath = tblMain.indexPathForView(sender) {
            let title = arrinfo[indexpath.row].name
            let Descrip = arrinfo[indexpath.row].desc
            if title == "School Email Address" {
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([Descrip!])

                    present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }
            else {
                if let url = URL(string: "tel://\(String(describing: Descrip))"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}
