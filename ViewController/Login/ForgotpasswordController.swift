//
//  LoginwithmobileController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ForgotpasswordController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var txtmob: UITextField!
    @IBOutlet weak var lblmob: UILabel!
    
    var strOTP = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefault()
    }
    
    func setDefault() {
        activity.isHidden = true
        txtmob.delegate = self
        btnsend.layer.cornerRadius = 5
        btnsend.clipsToBounds = true
    }
    
    func forgotPassword() {
        activity.isHidden = false
        activity.startAnimating()
        btnsend.setTitle(" ", for: .normal)
        if txtmob.text?.isValidEmail() == false {
            txtmob.layer.borderColor = UIColor.red.cgColor
            txtmob.layer.borderWidth = 1
            txtmob.layer.cornerRadius = 5
            lblmob.textColor = UIColor.red
            lblmob.isHidden = false
            activity.isHidden = true
            activity.stopAnimating()
            btnsend.setTitle("Send OTP", for: .normal)
        }
        else {
            let param = ["username":txtmob.text!]
            let headers: HTTPHeaders = ["Xapi": Xapi]
            
            AF.request(FORGOT_PASSWORD, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    print(response)
                    let json = response.value as! NSDictionary
                    let sucess = json.value(forKey: "success")as! Bool
                    let message = json.value(forKey: "message")as! String
                    if sucess == true {
                        let data = json.value(forKey: "data")as! NSDictionary
                        self.strOTP = data.value(forKey: "otp")as! String
                        let email = data.value(forKey: "username")as! String
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnsend.setTitle("Send OTP", for: .normal)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OTPviewController")as! OTPviewController
                        obj.strOtp = self.strOTP
                        obj.strEmail = email
                        self.navigationController?.pushViewController(obj, animated: true)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnsend.setTitle("Send OTP", for: .normal)
                        }))
                    }
            }
        }
    }
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        forgotPassword()
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

extension ForgotpasswordController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtmob.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
        txtmob.layer.borderWidth = 1
        txtmob.layer.cornerRadius = 5
        txtmob.placeholder = ""
        lblmob.isHidden = false
    }
}
