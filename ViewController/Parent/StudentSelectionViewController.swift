//
//  StudentSelectionViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class StudentSelectionViewController: UIViewController {

    @IBOutlet weak var tblMain: UITableView!
    var wc = Webservice.init()
    var mobile = String()
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mobile = loggdenUser.value(forKey: PHONE_NUMBER) as! String
       // getstudent()
        // Do any additional setup after loading the view.
    }
    
    func getstudent() {
        let param = ["mobile_number": mobile]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: STUDENT_GET, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: FilterSearchStudentGetResponseModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.arrFilterSearchDatum = response!.data
                    self.tblMain.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
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

extension StudentSelectionViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilterSearchDatum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = arrFilterSearchDatum[indexPath.row]
        let cell = tblMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! StudentTableViewCell
        cell.lblName.text = student.name
        cell.lblDescription.text = student.standard + " - " + student.section
        let strImage = student.profile
        url = URL(string: strImage)
        cell.img.sd_setImage(with: url, completed: nil)
        cell.img.layer.cornerRadius = 10
        cell.img.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = arrFilterSearchDatum[indexPath.row]
        loggdenUser.set(student.profile, forKey: PROFILE_IMAGE)
        loggdenUser.set(student.name, forKey: NAME)
        loggdenUser.set(student.id, forKey: STUDENT_ID)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
