//
//  AssignmentViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class AssignmentViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblMain: UITableView!
    
    var url: URL?
    var student_id = Int()
    var wc = Webservice.init()
    var arrAssignment = [DatumAssign]()
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var Subject_id = Int()
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
        getAssignment()
    }
    
    func getAssignment() {
                
        let param = ["s_subject_id": Subject_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                "Authorization":token]
        
        wc.callSimplewebservice(url: ASSIGNMENT, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: AssignmentResponsModel?) in
            if success {
                let suc = response?.success
                let message = response?.message
                if suc == true {
                    let data = response?.data
                    self.arrAssignment = data!.data
                    print(self.arrAssignment)
                    self.tblMain.reloadData()
                }
                else {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblMain.bounds.size.width, height: self.tblMain.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblMain.backgroundView  = noDataLabel
                    self.tblMain.separatorStyle  = .none
                }
            }
        }
    }
    

    @IBAction func btnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProfileAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnOlderAssignmentAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OlderAssignmentViewController")as! OlderAssignmentViewController
        obj.Subject_id = Subject_id
        self.navigationController?.pushViewController(obj, animated: true)
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

extension AssignmentViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrAssignment.count == 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblMain.bounds.size.width, height: self.tblMain.bounds.size.height))
            noDataLabel.text          = "Norecord Found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.tblMain.backgroundView  = noDataLabel
            self.tblMain.separatorStyle  = .none
        }
        else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblMain.bounds.size.width, height: self.tblMain.bounds.size.height))
            noDataLabel.text          = ""
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.tblMain.backgroundView  = noDataLabel
            self.tblMain.separatorStyle  = .none
        }
        return arrAssignment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrAssignment[indexPath.row]
        let cell = tblMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! AssignmentTblCell
        cell.lblztitle.text = data.name
        
        cell.lblDes.text = "by " +  data.teacher
        let date = data.lastDate
        cell.lblDate.text = "Last Date : " + date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PDFviewcontroller")as! PDFviewcontroller
        let data = arrAssignment[indexPath.row]
        obj.strTitle = "Assignments"
        obj.strPdf = data.assignmentFile[0].file
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
