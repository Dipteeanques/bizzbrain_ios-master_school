//
//  AccountViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var tblAccount: UITableView!
    
    var arrMenu = [["image":#imageLiteral(resourceName: "ProfileMenu"),"Title":"My Profile"],["image":#imageLiteral(resourceName: "history"),"Title":"Test Exam History"],["image":#imageLiteral(resourceName: "subscription"),"Title":"Order History"],["image":#imageLiteral(resourceName: "terms"),"Title":"Privacy Policy"],["image":#imageLiteral(resourceName: "terms"),"Title":"Terms and conditions"],["image":#imageLiteral(resourceName: "support"),"Title":"Support"],["image":#imageLiteral(resourceName: "changePwd"),"Title":"Change Password"],["image":#imageLiteral(resourceName: "logout"),"Title":"Logout"]]
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension AccountViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = arrMenu[indexPath.row]
        let cell = tblAccount.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblAccountCell
        let strtitle = (menu as AnyObject).value(forKey: "Title")as! String
        cell.lblName.text = strtitle
        cell.imgIcon.image = (menu as AnyObject).value(forKey: "image") as! UIImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditviewController")as! ProfileEditviewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResultHistoryViewcontroller")as! ResultHistoryViewcontroller
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryViewController")as! PaymentHistoryViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TermsSupporPrivacyController")as! TermsSupporPrivacyController
            obj.Common = "privacy-policy"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 4 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TermsSupporPrivacyController")as! TermsSupporPrivacyController
            obj.Common = "terms"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TermsSupporPrivacyController")as! TermsSupporPrivacyController
            obj.Common = "support"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChangepasswordController")as! ChangepasswordController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 7 {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Are you sure to logout?", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                loggdenUser.set(false, forKey: ISLOGIN)
                loggdenUser.set(false, forKey: PARENT_ISLOGIN)
                loggdenUser.set(false, forKey: STUDENT_ISLOGIN)
                loggdenUser.removeObject(forKey: CARTCOUNT)
                loggdenUser.removeObject(forKey: CARTVALUE)
                loggdenUser.removeObject(forKey: TOKEN)
                loggdenUser.removeObject(forKey: DOB)
                loggdenUser.removeObject(forKey: GENDER)
                loggdenUser.removeObject(forKey: CITYLog)
                loggdenUser.removeObject(forKey: STATELog)
                loggdenUser.removeObject(forKey: PHONE_NUMBER)
                loggdenUser.removeObject(forKey: NAME)
                loggdenUser.removeObject(forKey: EMAIL)
                self.appDel.gotoLogin()
            }))
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

