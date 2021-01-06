//
//  ForgotChangePwdController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 19/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class loginWithStudentViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var lblnewPassword: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var btnparentslogin: UIButton!{
        didSet{
            btnparentslogin.layer.cornerRadius = 5
            btnparentslogin.clipsToBounds = true
            btnparentslogin.layer.borderColor = UIColor.red.cgColor
            btnparentslogin.layer.borderWidth = 1.0
        }
    }
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var strEmail = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        setDefault()
    }
    
    func setDefault() {
        btnsend.setTitle("Login", for: .normal)
        UIGraphicsBeginImageContext(self.view.frame.size)
        #imageLiteral(resourceName: "Splash").draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        txtNewPassword.delegate = self
        txtConfirm.delegate = self
        btnsend.layer.cornerRadius = 5
        btnsend.clipsToBounds = true
    }
    
    
    @IBAction func btn_parentsLoginAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginwithmobileController")as! LoginwithmobileController
        self.navigationController?.pushViewController(obj, animated: true)
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
            btnsend.setTitle("Login", for: .normal)
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
            btnsend.setTitle("Login", for: .normal)
        }
        else {
            let FCMToken = loggdenUser.value(forKey: FCM)as! String
            let param = ["username":txtNewPassword.text!,
                         "password":txtConfirm.text!,
                         "device_token":FCMToken,
                         "device_type":"ios"]
            print(param)
            let headers: HTTPHeaders = ["Xapi": Xapi]
            print(headers)
            AF.request(LOGIN, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    print(response)
                    
                    let json = response.value as! NSDictionary
                    let sucess = json.value(forKey: "success")as! Bool
                    let message = json.value(forKey: "message")as! String
                    if sucess == true {
                        let data = json.value(forKey: "data")as! NSDictionary
                        let username = data.value(forKey: "username")as! String
                        loggdenUser.set(username, forKey: USERNAME)
                        
                        let phone_number = data.value(forKey: "phone_number")as! String
                        loggdenUser.set(phone_number, forKey: PHONE_NUMBER)
                        let role_id = data.value(forKey: "role_id")as! Int
                        let name = data.value(forKey: "name")as! String
                        let email = data.value(forKey: "email")as! String
                        let token = data.value(forKey: "token")as! String
                        let profile = data.value(forKey: "profile")as! String
                        let classs = data.value(forKey: "class")as! String
                        let standard = data.value(forKey: "standard")as! String
                        let school_logo = data.value(forKey:"school_logo")as! String
                        let user_id = data.value(forKey: "user_id")as! Int
                        let firebase_email = data.value(forKey: "firebase_email")as? String
                        let firebase_id = data.value(forKey: "firebase_id")as? String
                        let firebase_password = data.value(forKey: "firebase_password")as? String
                        let FinalToken = "Bearer " + token
                        loggdenUser.setValue(profile, forKey: PROFILEMAIN)
                        loggdenUser.setValue(classs, forKey: CLASS)
                        loggdenUser.setValue(standard, forKey: STANDARD)
                        loggdenUser.set(role_id, forKey: ROLE_ID)
                        loggdenUser.set(true, forKey: STUDENT_ISLOGIN)
                        loggdenUser.set(name, forKey: NAME)
                        loggdenUser.set(email, forKey: EMAIL)
                        loggdenUser.set(FinalToken, forKey: TOKEN)
                        loggdenUser.setValue(school_logo, forKey: SCHOOL_LOGO)
                        loggdenUser.setValue(user_id, forKey: USER_ID)
                        loggdenUser.setValue(firebase_email, forKey: FIREBASE_EMAIL)
                        loggdenUser.setValue(firebase_id, forKey: SENDER_ID)
                        loggdenUser.setValue(firebase_password, forKey: FIREBASE_PASSWORD)
                        self.appDel.gotoStudent()
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnsend.setTitle("Login", for: .normal)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnsend.setTitle("Login", for: .normal)
                        }))
                    }
            }
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


extension loginWithStudentViewController: UITextFieldDelegate {
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
