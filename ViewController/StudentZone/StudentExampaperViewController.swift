//
//  StudentExampaperViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/03/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class StudentExampaperViewController : UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrResults = NSArray()
    var url: URL?
    var Subject_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSubject), name: NSNotification.Name(rawValue: "SubjectNoteExam"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func StudentSubject(notification: NSNotification) {
        Subject_id = notification.object as! Int
        getNote()
    }
    
    
    func getNote() {
      let token = loggdenUser.value(forKey: TOKEN)as! String
        let param = ["s_subject_id":Subject_id]
      let headers: HTTPHeaders = ["Xapi": Xapi,
                             "Authorization":token]
      AF.request(getExamPaperNote, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
          .responseJSON { response in
              print(response)
              let json = response.value as! NSDictionary
              let success = json.value(forKey: "success")as! Bool
            let message = json.value(forKey: "message")as? String
              if success == true {
                  let data = json.value(forKey: "data")as! NSDictionary
                  self.arrResults = data.value(forKey: "data")as! NSArray
                  if self.arrResults.count == 0 {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblView.bounds.size.width, height: self.tblView.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblView.backgroundView  = noDataLabel
                    self.tblView.separatorStyle  = .none
                  }
                  else {
                      self.tblView.reloadData()
                  }
              }
              else{
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

}

extension StudentExampaperViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblstudentExampaperCell
        let note = arrResults[indexPath.row]
        cell.lblTitle.text = (note as AnyObject).value(forKey: "name")as? String
        cell.lblDate.text = (note as AnyObject).value(forKey: "date")as? String
        cell.lblSubject.text = (note as AnyObject).value(forKey: "subject")as? String
        let tech = (note as AnyObject).value(forKey: "teacher")as? String
        cell.lblBy.text = "by " + tech!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = arrResults[indexPath.row]
        let arrImage = (note as AnyObject).value(forKey: "teacher_note_files")as? [String]
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewViewController")as! ImageViewViewController
        obj.arrImg = arrImage!
        self.navigationController?.pushViewController(obj, animated: true)
    }
}



class tblstudentExampaperCell: UITableViewCell {
    
    @IBOutlet weak var lblBy: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewDate: UIView! {
        didSet {
            viewDate.layer.cornerRadius = 10
            viewDate.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgnote: UIImageView!
}
