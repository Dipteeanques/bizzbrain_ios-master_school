//
//  HelpDeskViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

struct arrHelp {
    let title: String?
    let Description: String?
}


class HelpDeskViewController: UIViewController {

    @IBOutlet weak var tblMain: UITableView!
    
    var url: URL?
    var student_id = Int()
    var wc = Webservice.init()
    var helpDaskDic = [arrHelp]()
    var arrFilterSearchDatum = [FilterSearchDatum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (loggdenUser.value(forKey: STUDENT_ID) != nil) {
            student_id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        }
        getHelpDesk()
        // Do any additional setup after loading the view.
    }
    
    func getHelpDesk() {
        let param = ["student_id": student_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: HELP_DESK, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: HelpDeskRespons?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    let name = data?.name
                    let email = data?.emailID
                    let mobile = data?.contanctNumber
                    let address = data?.address
                   
                    self.helpDaskDic.append(arrHelp.init(title: "School name", Description: name))
                    self.helpDaskDic.append(arrHelp.init(title: "School Email Address", Description: email))
                    self.helpDaskDic.append(arrHelp.init(title: "School Mobile no.", Description: mobile))
                    self.helpDaskDic.append(arrHelp.init(title: "School Address", Description: address))
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

extension HelpDeskViewController: UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpDaskDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! HelpDeskTableViewCell
    
//        let image = UIImage(named: "image_name")?.withRenderingMode(.alwaysTemplate)

        cell.lblTitle.text = helpDaskDic[indexPath.row].title
        if cell.lblTitle.text == "School Email Address" {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-new-post-100"), for: .normal)
            cell.btnIcon.isHidden = false
        }
        else if cell.lblTitle.text == "School Mobile no." {
            cell.btnIcon.setImage(#imageLiteral(resourceName: "icons8-phone-96"), for: .normal)
            cell.btnIcon.isHidden = false
//            button.setImage(image, for: .normal)
           
        }
        else {
            cell.btnIcon.isHidden = true
        }
        cell.btnIcon.tintColor = redcolor
        cell.lblDesc.text = helpDaskDic[indexPath.row].Description
        cell.btnIcon.addTarget(self, action: #selector(self.btnIconAction), for: .touchUpInside)
        return cell
    }
    
    @objc func btnIconAction(_ sender: UIButton) {
        if let indexpath = tblMain.indexPathForView(sender) {
            let title = helpDaskDic[indexpath.row].title
            let Descrip = helpDaskDic[indexpath.row].Description
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
