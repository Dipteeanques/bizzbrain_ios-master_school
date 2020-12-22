//
//  SignupViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var pwdTop: NSLayoutConstraint!
    @IBOutlet weak var mobHeight: NSLayoutConstraint!
    @IBOutlet weak var collegeHeight: NSLayoutConstraint!
    @IBOutlet weak var pwdHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtMob: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSignup: UIButton!{
        didSet{
            btnSignup.alpha = 0.5
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMob: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var arrState = [String]()
    var strState = String()
    var arrCity = [String]()
    var strCity = String()
    var fb_id = String()
    var fb_name = String()
    var FCMToken = String()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var img_mobile: UIImageView!
    @IBOutlet var img_username: UIImageView!
    @IBOutlet var img_email: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        activity.isHidden = true
    }
    
    func setDefault() {
        txtname.delegate = self
        txtMob.delegate = self
        txtUserName.delegate = self
        txtEmail.delegate = self
        txtpassword.delegate = self
        txtSchool.delegate = self
        txtpassword.isSecureTextEntry = true
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtMob.keyboardType = UIKeyboardType.numberPad
        btnSignup.layer.cornerRadius = 5
        btnSignup.clipsToBounds = true
//        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.SearchState), name: NSNotification.Name(rawValue: "SearchingState"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.SearchingCity), name: NSNotification.Name(rawValue: "SearchingCity"), object: nil)
        if fb_id.count == 0 {
            txtname.text = nil
        }
        else {
            txtname.text = fb_name
            pwdHeight.constant = 0
            pwdTop.constant = 0
            txtpassword.isHidden = true
        }
    }
    
    
    
    func registrationAPI() {
        if loggdenUser.value(forKey: FCM) != nil {
            FCMToken = loggdenUser.value(forKey: FCM)as! String
        }
        else {
            print("jekil")
        }
        activity.isHidden = false
        activity.startAnimating()
        btnSignup.setTitle(" ", for: .normal)
        let param = ["name":txtname.text!,
                     "password":txtpassword.text!,
                     "username":txtUserName.text!,
                     "phone_number":txtMob.text!,
                     "email":txtEmail.text!,
                     "facebook_id":fb_id,
                     "device_token":FCMToken,
                     "device_type":"ios"]
        
        let headers: HTTPHeaders = ["Xapi": Xapi]
        
        AF.request(REGISTER, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
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
                    let FinalToken = "Bearer " + token
                    loggdenUser.set(role_id, forKey: ROLE_ID)
                    loggdenUser.set(true, forKey: ISLOGIN)
                    loggdenUser.set(name, forKey: NAME)
                    loggdenUser.set(email, forKey: EMAIL)
                    loggdenUser.set(FinalToken, forKey: TOKEN)
                    self.appDel.gotoTabbar()
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.btnSignup.setTitle("Sign Up", for: .normal)
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnSignup.setTitle("Sign Up", for: .normal)
                    }))
                }
              
        }
    }
    
    func registervalidatorAPI(type:String,check_values:String) {
//        activity.isHidden = false
//        activity.startAnimating()
        var param = [String:String]()
        if type == "username"{
            param = [   "check_values":txtUserName.text!,
                        "type":type]
        }
        else if type == "email"{
            param = [   "check_values":txtEmail.text!,
                        "type":type]
        }
        else if type == "phone_no"{
            param = [   "check_values":txtMob.text!,
                        "type":type]
        }
       
        let headers: HTTPHeaders = ["Xapi": Xapi]
        
        AF.request(REGISTER_VALIDATOR, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
//                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    if type == "username"{
                        self.img_username.image = UIImage(named: "right-1")
                    }
                    else if type == "email"{
                        self.img_email.image = UIImage(named: "right-1")
                    }
                    else if type == "phone_no"{
                        self.img_mobile.image = UIImage(named: "right-1")
                    }
                    
                }
                else {
                    if type == "username"{
                        self.img_username.image = UIImage(named: "wrong")
                    }
                    else if type == "email"{
                        self.img_email.image = UIImage(named: "wrong")
                    }
                    else if type == "phone_no"{
                        self.img_mobile.image = UIImage(named: "wrong")
                    }
                }
                self.checkvalidate()
              
        }
    }
    
    func checkvalidate() {
        if self.img_username.image == UIImage(named: "right-1") && self.img_email.image == UIImage(named: "right-1") && self.img_mobile.image == UIImage(named: "right-1"){
            btnSignup.alpha = 1.0
        }
        else{
            btnSignup.alpha = 0.5
        }
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func Registration() {
        
        if fb_id.count == 0 {
            if txtname.text!.isEmpty {
                txtname.layer.borderColor = UIColor.red.cgColor
                txtname.layer.borderWidth = 1
                txtname.layer.cornerRadius = 5
                lblName.textColor = UIColor.red
                lblName.isHidden = false
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if txtMob.text!.isEmpty {
                txtMob.layer.borderColor = UIColor.red.cgColor
                txtMob.layer.borderWidth = 1
                txtMob.layer.cornerRadius = 5
                lblMob.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = false
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if isValidPhone(phone: txtMob.text!) == false {
                txtMob.layer.borderColor = UIColor.red.cgColor
                txtMob.layer.borderWidth = 1
                txtMob.layer.cornerRadius = 5
                lblMob.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = false
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if txtUserName.text!.isEmpty {
                txtUserName.layer.borderColor = UIColor.red.cgColor
                txtUserName.layer.borderWidth = 1
                txtUserName.layer.cornerRadius = 5
                lblUsername.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblUsername.isHidden = false
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if txtpassword.text!.isEmpty {
                txtpassword.layer.borderColor = UIColor.red.cgColor
                txtpassword.layer.borderWidth = 1
                txtpassword.layer.cornerRadius = 5
                lblPassword.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = false
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
                
            else if txtEmail.text!.isEmpty {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                txtEmail.layer.borderWidth = 1
                txtEmail.layer.cornerRadius = 5
                lblEmail.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = false
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
            }
                
            else if txtEmail.text?.isValidEmail() == false {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                txtEmail.layer.borderWidth = 1
                txtEmail.layer.cornerRadius = 5
                lblEmail.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = false
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
            }
            else {
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewcontroller")as! CategoriesViewcontroller
//                obj.strName = txtname.text!
//                obj.strMob = txtMob.text!
//                obj.strPassword = txtpassword.text!
//                obj.strEmail = txtEmail.text!
//                obj.fb_id = fb_id
//                self.navigationController?.pushViewController(obj, animated: true)
                registrationAPI()
            }
        }
        else {
            if txtname.text!.isEmpty {
                txtname.layer.borderColor = UIColor.red.cgColor
                txtname.layer.borderWidth = 1
                txtname.layer.cornerRadius = 5
                lblName.textColor = UIColor.red
                lblName.isHidden = false
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if txtMob.text!.isEmpty {
                txtMob.layer.borderColor = UIColor.red.cgColor
                txtMob.layer.borderWidth = 1
                txtMob.layer.cornerRadius = 5
                lblMob.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = false
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if isValidPhone(phone: txtMob.text!) == false {
                txtMob.layer.borderColor = UIColor.red.cgColor
                txtMob.layer.borderWidth = 1
                txtMob.layer.cornerRadius = 5
                lblMob.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = false
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if txtUserName.text!.isEmpty {
                txtUserName.layer.borderColor = UIColor.red.cgColor
                txtUserName.layer.borderWidth = 1
                txtUserName.layer.cornerRadius = 5
                lblUsername.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = true
                lblUsername.isHidden = false
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
                txtEmail.layer.borderColor = UIColor.lightText.cgColor
                txtEmail.placeholder = "Email Address"
            }
            else if fb_id.count == 0 {
                if txtpassword.text!.isEmpty {
                    txtpassword.layer.borderColor = UIColor.red.cgColor
                    txtpassword.layer.borderWidth = 1
                    txtpassword.layer.cornerRadius = 5
                    lblPassword.textColor = UIColor.red
                    lblName.isHidden = true
                    lblMob.isHidden = true
                    lblPassword.isHidden = false
                    lblEmail.isHidden = true
                    lblUsername.isHidden = true
                    txtUserName.layer.borderColor = UIColor.lightText.cgColor
                    txtUserName.placeholder = "Username"
                    txtname.layer.borderColor = UIColor.lightText.cgColor
                    txtname.placeholder = "Name"
                    txtMob.layer.borderColor = UIColor.lightText.cgColor
                    txtMob.placeholder = "Mobile Number"
                    txtEmail.layer.borderColor = UIColor.lightText.cgColor
                    txtEmail.placeholder = "Email Address"
                }
                else {
                    print("jekil")
                }
            }
                
            else if txtEmail.text!.isEmpty {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                txtEmail.layer.borderWidth = 1
                txtEmail.layer.cornerRadius = 5
                lblEmail.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = false
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
            }
                
            else if txtEmail.text?.isValidEmail() == false {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                txtEmail.layer.borderWidth = 1
                txtEmail.layer.cornerRadius = 5
                lblEmail.textColor = UIColor.red
                lblName.isHidden = true
                lblMob.isHidden = true
                lblPassword.isHidden = true
                lblEmail.isHidden = false
                lblUsername.isHidden = true
                txtUserName.layer.borderColor = UIColor.lightText.cgColor
                txtUserName.placeholder = "Username"
                txtname.layer.borderColor = UIColor.lightText.cgColor
                txtname.placeholder = "Name"
                txtMob.layer.borderColor = UIColor.lightText.cgColor
                txtMob.placeholder = "Mobile Number"
                txtpassword.layer.borderColor = UIColor.lightText.cgColor
                txtpassword.placeholder = "Password"
            }
            else {
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewcontroller")as! CategoriesViewcontroller
//                obj.strName = txtname.text!
//                obj.strMob = txtMob.text!
//                obj.strPassword = txtpassword.text!
//                obj.strEmail = txtEmail.text!
//                obj.fb_id = fb_id
//                self.navigationController?.pushViewController(obj, animated: true)
                registrationAPI()
            }
        }
        
    }
    
    @IBAction func btnStateAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchingViewController")as! SearchingViewController
        obj.strTitle = "Select State"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnCityAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchingViewController")as! SearchingViewController
        obj.strTitle = "Select City"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignupAction(_ sender: UIButton) {
        Registration()
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


extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtname {
            txtname.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtname.layer.borderWidth = 1
            txtname.layer.cornerRadius = 5
            txtname.placeholder = ""
            lblName.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = false
            lblMob.isHidden = true
            lblPassword.isHidden = true
            lblEmail.isHidden = true
            lblUsername.isHidden = true
            txtUserName.layer.borderColor = UIColor.lightText.cgColor
            txtUserName.placeholder = "UserName"
            txtMob.layer.borderColor = UIColor.lightText.cgColor
            txtMob.placeholder = "Mobile Number"
            txtpassword.layer.borderColor = UIColor.lightText.cgColor
            txtpassword.placeholder = "Password"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtSchool.layer.borderColor = UIColor.lightText.cgColor
            txtSchool.placeholder = "School / Collage Name"
            lblSchool.isHidden = true
        }
        else if textField == txtMob {
            registervalidatorAPI(type: "phone_no", check_values: txtMob.text ?? "")
            txtMob.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtMob.layer.borderWidth = 1
            txtMob.layer.cornerRadius = 5
            txtMob.placeholder = ""
            lblMob.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = true
            lblMob.isHidden = false
            lblPassword.isHidden = true
            lblEmail.isHidden = true
            lblUsername.isHidden = true
            txtUserName.layer.borderColor = UIColor.lightText.cgColor
            txtUserName.placeholder = "UserName"
            txtname.layer.borderColor = UIColor.lightText.cgColor
            txtname.placeholder = "Name"
            txtpassword.layer.borderColor = UIColor.lightText.cgColor
            txtpassword.placeholder = "Password"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtSchool.layer.borderColor = UIColor.lightText.cgColor
            txtSchool.placeholder = "School / Collage Name"
            lblSchool.isHidden = true
        }
        else if textField == txtUserName {
            registervalidatorAPI(type: "username", check_values: txtUserName.text ?? "")
            txtUserName.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtUserName.layer.borderWidth = 1
            txtUserName.layer.cornerRadius = 5
            txtUserName.placeholder = ""
            lblUsername.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = true
            lblMob.isHidden = true
            lblUsername.isHidden = false
            lblPassword.isHidden = true
            lblEmail.isHidden = true
            txtMob.layer.borderColor = UIColor.lightText.cgColor
            txtMob.placeholder = "Mobile Number"
            txtname.layer.borderColor = UIColor.lightText.cgColor
            txtname.placeholder = "Name"
            txtpassword.layer.borderColor = UIColor.lightText.cgColor
            txtpassword.placeholder = "Password"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtSchool.layer.borderColor = UIColor.lightText.cgColor
            txtSchool.placeholder = "School / Collage Name"
            lblSchool.isHidden = true
        }
        else if textField == txtSchool {
            txtSchool.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtSchool.layer.borderWidth = 1
            txtSchool.layer.cornerRadius = 5
            txtSchool.placeholder = ""
            lblSchool.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = true
            lblMob.isHidden = true
            lblPassword.isHidden = true
            lblEmail.isHidden = true
            lblUsername.isHidden = true
            lblSchool.isHidden = false
            txtUserName.layer.borderColor = UIColor.lightText.cgColor
            txtUserName.placeholder = "UserName"
            txtname.layer.borderColor = UIColor.lightText.cgColor
            txtname.placeholder = "Name"
            txtMob.layer.borderColor = UIColor.lightText.cgColor
            txtMob.placeholder = "Mobile Number"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtpassword.layer.borderColor = UIColor.lightText.cgColor
            txtpassword.placeholder = "Password"
        }
        else if textField == txtpassword {
            txtpassword.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtpassword.layer.borderWidth = 1
            txtpassword.layer.cornerRadius = 5
            txtpassword.placeholder = ""
            lblPassword.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = true
            lblMob.isHidden = true
            lblPassword.isHidden = false
            lblEmail.isHidden = true
            lblUsername.isHidden = true
            txtUserName.layer.borderColor = UIColor.lightText.cgColor
            txtUserName.placeholder = "UserName"
            txtname.layer.borderColor = UIColor.lightText.cgColor
            txtname.placeholder = "Name"
            txtMob.layer.borderColor = UIColor.lightText.cgColor
            txtMob.placeholder = "Mobile Number"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtSchool.layer.borderColor = UIColor.lightText.cgColor
            txtSchool.placeholder = "School / Collage Name"
            lblSchool.isHidden = true
        }
        else {
            registervalidatorAPI(type: "email", check_values: txtEmail.text ?? "")
            txtEmail.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            txtEmail.placeholder = ""
            lblEmail.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblName.isHidden = true
            lblMob.isHidden = true
            lblPassword.isHidden = true
            lblEmail.isHidden = false
            lblUsername.isHidden = true
            txtUserName.layer.borderColor = UIColor.lightText.cgColor
            txtUserName.placeholder = "UserName"
            txtname.layer.borderColor = UIColor.lightText.cgColor
            txtname.placeholder = "Name"
            txtMob.layer.borderColor = UIColor.lightText.cgColor
            txtMob.placeholder = "Mobile Number"
            txtpassword.layer.borderColor = UIColor.lightText.cgColor
            txtpassword.placeholder = "Password"
            txtSchool.layer.borderColor = UIColor.lightText.cgColor
            txtSchool.placeholder = "School / Collage Name"
            lblSchool.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtUserName {
            registervalidatorAPI(type: "username", check_values: txtUserName.text ?? "")
        }
        else if textField == txtEmail{
            registervalidatorAPI(type: "email", check_values: txtEmail.text ?? "")
        }
        else if textField == txtMob{
            registervalidatorAPI(type: "phone_no", check_values: txtMob.text ?? "")
        }
    }
    

}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
