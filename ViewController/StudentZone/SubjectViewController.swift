//
//  SubjectViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 28/04/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SubjectViewController: UIViewController {

    @IBOutlet weak var tblSubject: UITableView!
    
    var wc = Webservice.init()
    var arrSubject = [subjectModel]()
    var assignment = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSubject()
        // Do any additional setup after loading the view.
    }
    
    func getSubject() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callGETSimplewebservice(url: get_subject, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response:SubjectResponsModdel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.arrSubject = response!.data
                    self.tblSubject.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }

    @IBAction func btnBackAction(_ sender: Any) {
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

extension SubjectViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!tblSubjectCell
        cell.lblSubject.text = arrSubject[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Subject_id = arrSubject[indexPath.row].id
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubjectNoteExam"), object: Subject_id)
        if assignment == "assignment" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentViewController")as! AssignmentViewController
            obj.Subject_id = arrSubject[indexPath.row].id
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if assignment == "VideoSubject" {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "VideoplayerViewController")as! VideoplayerViewController
                obj.Subject_id = arrSubject[indexPath.row].id
                self.navigationController?.pushViewController(obj, animated: true)
            }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NoteExamPaperViewController")as! NoteExamPaperViewController
            obj.Subject_id = arrSubject[indexPath.row].id
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

class tblSubjectCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
}
