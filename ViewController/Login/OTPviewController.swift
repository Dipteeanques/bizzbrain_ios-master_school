//
//  OTPviewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 19/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class OTPviewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtSix: UITextField!
    @IBOutlet weak var txtFive: UITextField!
    @IBOutlet weak var txtFour: UITextField!
    @IBOutlet weak var txtThree: UITextField!
    @IBOutlet weak var txtTwo: UITextField!
    @IBOutlet weak var txtOne: UITextField!
    
    
    var strOtp = String()
    var strEmail = String()
    var strOTP = String()
    var Mobile_Number = String()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var otpWithParent = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.isHidden = true
        setDefault()
    }
    
    func setDefault() {
        txtOne.delegate = self
        txtTwo.delegate = self
        txtThree.delegate = self
        txtFour.delegate = self
        txtFive.delegate = self
        txtSix.delegate = self
        btnSave.layer.cornerRadius = 5
        btnSave.clipsToBounds = true
        txtOne.isSecureTextEntry = true
        txtTwo.isSecureTextEntry = true
        txtThree.isSecureTextEntry = true
        txtFour.isSecureTextEntry = true
        txtFive.isSecureTextEntry = true
        txtSix.isSecureTextEntry = true
        
        txtOne.keyboardType = .numberPad
        txtTwo.keyboardType = .numberPad
        txtThree.keyboardType = .numberPad
        txtFour.keyboardType = .numberPad
        txtFive.keyboardType = .numberPad
        txtSix.keyboardType = .numberPad
    }
    
    func OtpVerify() {
        activity.isHidden = false
        activity.startAnimating()
        btnSave.setTitle(" ", for: .normal)
        let strOtpValue = txtOne.text! + txtTwo.text! + txtThree.text!
        strOTP = strOtpValue + txtFour.text! + txtFive.text! + txtSix.text!
        
        if txtOne.text!.isEmpty || txtTwo.text!.isEmpty || txtThree.text!.isEmpty || txtFour.text!.isEmpty || txtFive.text!.isEmpty || txtSix.text!.isEmpty {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "message", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.btnSave.setTitle("  Next  ", for: .normal)
            }))
        }
        else if strOtp == strOTP {
            if Mobile_Number.count == 0 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotChangePwdController")as! ForgotChangePwdController
                obj.strEmail = strEmail
                self.navigationController?.pushViewController(obj, animated: true)
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.btnSave.setTitle("  Next  ", for: .normal)
            }
            else {
                let FCMToken = loggdenUser.value(forKey: FCM)as! String
                let param = ["mobile_number":Mobile_Number,
                             "otp":strOtp,
                             "device_token":FCMToken,
                             "device_type":"iOS"]
                let headers: HTTPHeaders = ["Xapi": Xapi]
                
                AF.request(PARENT_VERIFY_OTP, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
                    .responseJSON { response in
                        print(response)
                        let json = response.value as! NSDictionary
                        let sucess = json.value(forKey: "success")as! Bool
                        let message = json.value(forKey: "message")as! String
                        if sucess == true {
                            let data = json.value(forKey: "data")as! NSDictionary
                            let id = data.value(forKey: "id")as! Int
                            let phone_number = data.value(forKey: "phone_number")as! String
                            let profile = data.value(forKey: "profile")as! String
                            let school_logo = data.value(forKey: "school_logo")as! String
                            loggdenUser.set(phone_number, forKey: PHONE_NUMBER)
                            let name = data.value(forKey: "name")as! String
                            let token = data.value(forKey: "token")as! String
                            let FinalToken = "Bearer " + token
                            loggdenUser.set(profile, forKey: PROFILE_IMAGE)
                            loggdenUser.set(school_logo, forKey: SCHOOL_LOGO)
                            loggdenUser.set(true, forKey: PARENT_ISLOGIN)
                            loggdenUser.set(name, forKey: NAME)
                            loggdenUser.set(FinalToken, forKey: TOKEN)
                            loggdenUser.set(id, forKey: STUDENT_ID)
                            loggdenUser.set(0, forKey: ROLE_ID)
                            self.appDel.gotoParent()
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnSave.setTitle("  Next  ", for: .normal)
                        }
                        else {
                            let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                            self.present(uiAlert, animated: true, completion: nil)
                            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                self.dismiss(animated: true, completion: nil)
                                self.activity.isHidden = true
                                self.activity.stopAnimating()
                                self.btnSave.setTitle("  Next  ", for: .normal)
                            }))
                        }
                }
            }
        }
        else {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "OTP Dose not match.", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.btnSave.setTitle("  Next  ", for: .normal)
            }))
        }
    }
    @IBAction func btnNextAction(_ sender: UIButton) {
        OtpVerify()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnResendOtpAction(_ sender: UIButton) {
        let param = ["mobile_number":Mobile_Number]
        let headers: HTTPHeaders = ["Xapi": Xapi]
        AF.request(LOGIN_WITH_OTP, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.strOtp = data.value(forKey: "otp")as! String
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                }
        }
    }
    
}

extension OTPviewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        // Range.length == 1 means,clicking backspace
        if (range.length == 0){
            if textField == txtOne {
                txtTwo?.becomeFirstResponder()
            }
            if textField == txtTwo {
                txtThree?.becomeFirstResponder()
            }
            if textField == txtThree {
                txtFour?.becomeFirstResponder()
            }
            if textField == txtFour {
                txtFive?.becomeFirstResponder()
            }
            if textField == txtFive {
                txtSix?.becomeFirstResponder()
            }
            if textField == txtSix {
                txtSix?.resignFirstResponder()
            }
            textField.text? = string
            return false
        }else if (range.length == 1) {
            if textField == txtSix {
                txtFive?.becomeFirstResponder()
            }
            if textField == txtFive {
                txtFour?.becomeFirstResponder()
            }
            if textField == txtFour {
                txtThree?.becomeFirstResponder()
            }
            if textField == txtThree {
                txtTwo?.becomeFirstResponder()
            }
            if textField == txtTwo {
                txtOne?.becomeFirstResponder()
            }
            if textField == txtOne {
                txtOne?.resignFirstResponder()
            }
            textField.text? = ""
            return false
        }
        return true
    }
}
