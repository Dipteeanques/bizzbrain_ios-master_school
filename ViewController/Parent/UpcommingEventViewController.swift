//
//  UpcommingEventViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 09/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class UpcommingEventViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var student_id = Int()
    var wc = Webservice.init()
    var arrEventList = [DatumEvent]()
    
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
        getUpcommingEvent()
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
    }
    
    func getUpcommingEvent() {
                
        let param = ["student_id": student_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: EVENT, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: EventResponsModel?) in
            if success {
                let suc = response?.success
                let message = response?.message
                if suc == true {
                    let data = response?.data
                    self.arrEventList = data!.data
                    self.tblView.reloadData()
                }
                else {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblView.bounds.size.width, height: self.tblView.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblView.backgroundView  = noDataLabel
                    self.tblView.separatorStyle  = .none
                }
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

extension UpcommingEventViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = arrEventList[indexPath.row]
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! commingEventTblCell
        cell.lblTitle.text = event.name
        cell.lblDescription.text = event.datumEventDescription
        cell.lblDate.text = event.dateTime
        url = URL(string: event.image)
        cell.img.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController")as! EventDetailsViewController
        obj.arrEventList = arrEventList
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


class commingEventTblCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backView: UIView! {
        didSet{
            backView.layer.cornerRadius = 8
            backView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
}
