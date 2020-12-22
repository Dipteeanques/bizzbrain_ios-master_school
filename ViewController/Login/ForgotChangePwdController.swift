//
//  ForgotChangePwdController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 19/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ForgotChangePwdController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var lblnewPassword: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var strEmail = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.isHidden = true
        setDefault()
    }
    
    func setDefault() {
        txtNewPassword.delegate = self
        txtConfirm.delegate = self
        btnsend.layer.cornerRadius = 5
        btnsend.clipsToBounds = true
    }
    
    func changepwd() {
        activity.isHidden = false
        activity.startAnimating()
        btnsend.setTitle(" ", for: .normal)
        if txtNewPassword.text!.isEmpty {
            txtNewPassword.layer.borderColor = UIColor.red.cgColor
            txtNewPassword.layer.borderWidth = 1
            txtNewPassword.layer.cornerRadius = 5
            lblnewPassword.textColor = UIColor.red
            lblConfirm.isHidden = true
            lblnewPassword.isHidden = false
            txtConfirm.layer.borderColor = UIColor.lightText.cgColor
            txtConfirm.placeholder = "Confirm Password"
            activity.isHidden = true
            activity.stopAnimating()
            btnsend.setTitle("Save", for: .normal)
        }
        else if txtConfirm.text!.isEmpty {
            txtConfirm.layer.borderColor = UIColor.red.cgColor
            txtConfirm.layer.borderWidth = 1
            txtConfirm.layer.cornerRadius = 5
            lblConfirm.textColor = UIColor.red
            lblConfirm.isHidden = false
            lblnewPassword.isHidden = true
            txtNewPassword.layer.borderColor = UIColor.lightText.cgColor
            txtNewPassword.placeholder = "New Password"
            activity.isHidden = true
            activity.stopAnimating()
            btnsend.setTitle("Save", for: .normal)
        }
        else if txtNewPassword.text! == txtConfirm.text! {
//            let parem = ["new_password":txtNewPassword.text!,
//                         "confirm_password":txtConfirm.text!,
//                         "username":strEmail]
//            let headers: HTTPHeaders = ["Xapi": Xapi]
//            wc.callSimplewebservice(url: NEW_PASSWORD, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: forgotChangepwd?) in
//                if sucess {
//                    let suces = response?.success
//                    let msg = response?.message
//                    if suces == true {
//                        let uiAlert = UIAlertController(title: "Bizzbrains", message: msg, preferredStyle: UIAlertController.Style.alert)
//                        self.present(uiAlert, animated: true, completion: nil)
//                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                            self.dismiss(animated: true, completion: nil)
//                            self.appDel.gotoLogin()
//                            self.activity.isHidden = true
//                            self.activity.stopAnimating()
//                            self.btnsend.setTitle("Save", for: .normal)
//                        }))
//                    }
//                }
//            }
        }
        else {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Password Does not match.", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.btnsend.setTitle("Save", for: .normal)
            }))
        }
    }
    
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        changepwd()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        appDel.gotoLogin()
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


extension ForgotChangePwdController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNewPassword {
            txtNewPassword.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtNewPassword.layer.borderWidth = 1
            txtNewPassword.layer.cornerRadius = 5
            txtNewPassword.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            txtNewPassword.placeholder = ""
            lblnewPassword.isHidden = false
            lblConfirm.isHidden = true
            txtConfirm.layer.borderColor = UIColor.lightText.cgColor
            txtConfirm.placeholder = "Confirm Password"
        }
        else {
            txtConfirm.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtConfirm.layer.borderWidth = 1
            txtConfirm.layer.cornerRadius = 5
            txtConfirm.placeholder = ""
            lblConfirm.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblConfirm.isHidden = false
            lblnewPassword.isHidden = true
            txtNewPassword.layer.borderColor = UIColor.lightText.cgColor
            txtNewPassword.placeholder = "New Password"
        }
    }
}
