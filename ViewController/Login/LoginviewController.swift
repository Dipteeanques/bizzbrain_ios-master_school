//
//  LoginviewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class LoginviewController: UIViewController {

    //MARK: - Top
    @IBOutlet weak var loginwithTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtEmailTop: NSLayoutConstraint!
    @IBOutlet weak var txtPasswordTop: NSLayoutConstraint!
    @IBOutlet weak var forgotTop: NSLayoutConstraint!
    @IBOutlet weak var loginTop: NSLayoutConstraint!
    @IBOutlet weak var logSocialTop: NSLayoutConstraint!
    @IBOutlet weak var facebookTop: NSLayoutConstraint!
    @IBOutlet weak var loginmobileTop: NSLayoutConstraint!
    @IBOutlet weak var cardTop: NSLayoutConstraint!
    
    //MARK: Height
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locnHeight: NSLayoutConstraint!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var fbActivity: UIActivityIndicatorView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var btn_studentlogin: UIButton!{
        didSet{
            btn_studentlogin.layer.cornerRadius = 5
            btn_studentlogin.clipsToBounds = true
        }
    }
    
    @IBOutlet var btn_parentslogin: UIButton!{
        didSet{
            btn_parentslogin.layer.cornerRadius = 5
            btn_parentslogin.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
    }
    
    func setDefault() {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        #imageLiteral(resourceName: "Splash").draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        activity.isHidden = true
        fbActivity.isHidden = true
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPassword.isSecureTextEntry = true
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        if UIScreen.main.bounds.width == 320 {
//            cardHeight.constant = 380
            heightConstraint.constant = 40
            loginwithTopConstraint.constant = 10
            txtEmailTop.constant = 15
        }
        else if UIScreen.main.bounds.height == 667 {
//            cardHeight.constant = 450
            loginwithTopConstraint.constant = 20
            txtPasswordTop.constant = 25
            forgotTop.constant = 12
            loginTop.constant = 12
            logSocialTop.constant = 20
            facebookTop.constant = 20
            cardTop.constant = 30
            locnHeight.constant = 85
        }
        else if UIScreen.main.bounds.width == 414 {
            if UIScreen.main.bounds.height == 896 {
                loginwithTopConstraint.constant = 40
                heightConstraint.constant = 50
//                cardHeight.constant = 500
                locnHeight.constant = 120
                cardTop.constant = 40
            }
            else {
//                cardHeight.constant = 480
                loginwithTopConstraint.constant = 20
                heightConstraint.constant = 50
                txtPasswordTop.constant = 25
                forgotTop.constant = 12
                loginTop.constant = 12
                logSocialTop.constant = 20
                facebookTop.constant = 20
                cardTop.constant = 40
                locnHeight.constant = 95
            }
        }
        
        else if UIScreen.main.bounds.height == 812 {
            loginwithTopConstraint.constant = 40
            heightConstraint.constant = 50
//            cardHeight.constant = 500
            locnHeight.constant = 100
            cardTop.constant = 30
        }
        btnLogin.layer.cornerRadius = 5
        btnLogin.clipsToBounds = true
        btnFaceBook.layer.cornerRadius = 5
        btnFaceBook.clipsToBounds = true
    }
    
    func login() {
        activity.isHidden = false
        activity.startAnimating()
        btnLogin.setTitle(" ", for: .normal)
        if txtEmail.text!.isEmpty {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            lblEmail.textColor = UIColor.red
            lblPassword.isHidden = true
            lblEmail.isHidden = false
            txtPassword.layer.borderColor = UIColor.lightText.cgColor
            txtPassword.placeholder = "Password"
            activity.isHidden = true
            activity.stopAnimating()
            btnLogin.setTitle("Login", for: .normal)
        }
//        else if txtEmail.text?.isValidEmail() == false {
//            txtEmail.layer.borderColor = UIColor.red.cgColor
//            txtEmail.layer.borderWidth = 1
//            txtEmail.layer.cornerRadius = 5
//            lblEmail.textColor = UIColor.red
//            lblPassword.isHidden = true
//            lblEmail.isHidden = false
//            txtPassword.layer.borderColor = UIColor.lightText.cgColor
//            txtPassword.placeholder = "Password"
//            activity.isHidden = true
//            activity.stopAnimating()
//            btnLogin.setTitle("Login", for: .normal)
//        }
        else if txtPassword.text!.isEmpty {
            txtPassword.layer.borderColor = UIColor.red.cgColor
            txtPassword.layer.borderWidth = 1
            txtPassword.layer.cornerRadius = 5
            lblPassword.textColor = UIColor.red
            lblPassword.isHidden = false
            lblEmail.isHidden = true
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Adress"
            activity.isHidden = true
            activity.stopAnimating()
            btnLogin.setTitle("Login", for: .normal)
        }
        else {
            let FCMToken = loggdenUser.value(forKey: FCM)as! String
            let param = ["username":txtEmail.text!,
                         "password":txtPassword.text!,
                         "device_token":FCMToken,
                         "device_type":"ios"]
            let headers: HTTPHeaders = ["Xapi": Xapi]
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
                        let FinalToken = "Bearer " + token
                        loggdenUser.set(role_id, forKey: ROLE_ID)
                        loggdenUser.set(true, forKey: ISLOGIN)
                        loggdenUser.set(name, forKey: NAME)
                        loggdenUser.set(email, forKey: EMAIL)
                        loggdenUser.set(FinalToken, forKey: TOKEN)
                        self.appDel.gotoTabbar()
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnLogin.setTitle("Login", for: .normal)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnLogin.setTitle("Login", for: .normal)
                        }))
                    }
            }
        }
    }
    
    func loginWithFacebook(strFB_id: String,strName: String) {
        fbActivity.isHidden = false
        fbActivity.startAnimating()
        btnFaceBook.setTitle(" ", for: .normal)
        let param = ["facebook_id":strFB_id]
        let headers: HTTPHeaders = ["Xapi": Xapi]
        
        AF.request(LOGIN_FACEBOOK, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    let is_cerated = data.value(forKey: "is_cerated")as! Int
                    if is_cerated == 0 {
                        if data.value(forKey: "college_name") is NSNull {
                            print("jekil")
                        }
                        else {
                            let college_name = data.value(forKey: "college_name")as! String
                            loggdenUser.set(college_name, forKey: COLLEGE_NAME)
                        }
                        
                        if data.value(forKey: "school_name")is NSNull {
                            print("jekil")
                        }
                        else {
                            let school_name = data.value(forKey: "school_name")as! String
                            loggdenUser.set(school_name, forKey: SCHOOL_NAME)
                        }
                        
                        if data.value(forKey: "phone_number")is NSNull {
                            print("jekil")
                        }
                        else {
                            let phone_number = data.value(forKey: "phone_number")as! String
                            loggdenUser.set(phone_number, forKey: PHONE_NUMBER)
                        }
                        
                        let name = data.value(forKey: "name")as! String
                        let email = data.value(forKey: "username")as! String
                        let token = data.value(forKey: "token")as! String
                        let FinalToken = "Bearer " + token
                        loggdenUser.set(true, forKey: ISLOGIN)
                        loggdenUser.set(name, forKey: NAME)
                        loggdenUser.set(email, forKey: EMAIL)
                        loggdenUser.set(FinalToken, forKey: TOKEN)
                        self.appDel.gotoTabbar()
                        self.fbActivity.isHidden = true
                        self.fbActivity.stopAnimating()
                        self.btnFaceBook.setTitle("Facebook", for: .normal)
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController")as! SignupViewController
                        obj.fb_id = strFB_id
                        obj.fb_name = strName
                        self.navigationController?.pushViewController(obj, animated: true)
                        self.fbActivity.isHidden = true
                        self.fbActivity.stopAnimating()
                        self.btnFaceBook.setTitle("Facebook", for: .normal)
                    }
                    
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        self.fbActivity.isHidden = true
                        self.fbActivity.stopAnimating()
                        self.btnFaceBook.setTitle("Facebook", for: .normal)
                    }))
                }
        }
    }
    
    func getFBUserData(){
//        if((AccessToken.current) != nil){
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                print(result)
//                if (error == nil){
//                    if let data = result as? [String : AnyObject] {
//                        let name = data["name"]as! String
//                        let fb_id = data["id"]as! String
//                        self.loginWithFacebook(strFB_id: fb_id, strName: name)
//                    }
//                }
//            })
//        }
    }
    
    //MARK: - Action Method
    @IBAction func btnFacebookLoginAction(_ sender: UIButton) {
//        let fbLoginManager : LoginManager = LoginManager()
//        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
//            if (error == nil){
//                let fbloginresult : LoginManagerLoginResult = result!
//                // if user cancel the login
//                if (result?.isCancelled)!{
//                    return
//                }
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    self.getFBUserData()
//                }
//            }
//        }
    }
    
    @IBAction func btnSignupAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController")as! SignupViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnMobileloginAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "loginWithStudentViewController")as! loginWithStudentViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnForgotAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotpasswordController")as! ForgotpasswordController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLoginForParentAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginwithmobileController")as! LoginwithmobileController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
//        appDel.gotoTabbar()
//        return;
        login()
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


extension LoginviewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEmail {
            txtEmail.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            lblEmail.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            txtEmail.placeholder = ""
            lblEmail.isHidden = false
            lblPassword.isHidden = true
            txtPassword.layer.borderColor = UIColor.lightText.cgColor
            txtPassword.placeholder = "Password"
         }
        else {
            txtPassword.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtPassword.layer.borderWidth = 1
            txtPassword.layer.cornerRadius = 5
            txtPassword.placeholder = ""
            lblPassword.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblPassword.isHidden = false
            lblEmail.isHidden = true
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Adress"
        }
    }
}
