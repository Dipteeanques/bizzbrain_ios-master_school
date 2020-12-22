//
//  ChangepasswordController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ChangepasswordController: UIViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtOld: UITextField!
    @IBOutlet weak var lblOld: UILabel!
    @IBOutlet weak var txtNew: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setdefault()
    }
    
    func setdefault() {
        txtOld.delegate = self
        txtNew.delegate = self
        txtConfirm.delegate = self
        btnSave.layer.cornerRadius = 5
        btnSave.clipsToBounds = true
        activity.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func changePassword() {
        self.activity.startAnimating()
        self.activity.isHidden = false
        self.btnSave.setTitle("", for: .normal)
        if txtNew.text == txtConfirm.text {
            let parameters = [
                "old_password":txtOld.text!,
                "new_password" : txtNew.text!,
                "repeat_password" : txtConfirm.text!]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let headers: HTTPHeaders = ["Xapi": Xapi,
                                        "Authorization":token]
            
            AF.request(CHANGEPASSWORD, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    let json = response.value as! NSDictionary
                    print(json)
                    let sucess = json.value(forKey: "success")as! Bool
                    let msg = json.value(forKey: "message")as! String
                    if sucess == true {
                        let uiAlert = UIAlertController(title: "Bizzbrains", message: msg, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.activity.stopAnimating()
                            self.activity.isHidden = true
                            self.btnSave.setTitle("Save", for: .normal)
                        }))
                    }
                    else {
                        let uiAlert = UIAlertController(title: "Bizzbrains", message: msg, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.activity.stopAnimating()
                            self.activity.isHidden = true
                            self.btnSave.setTitle("Save", for: .normal)
                        }))
                    }
            }
        }
        else {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Password dose Not match.", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                self.activity.stopAnimating()
                self.activity.isHidden = true
                self.btnSave.setTitle("Save", for: .normal)
            }))
        }
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        changePassword()
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
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

extension ChangepasswordController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtOld {
            txtOld.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtOld.layer.borderWidth = 1
            txtOld.layer.cornerRadius = 5
            txtOld.placeholder = ""
            lblOld.isHidden = false
            lblNew.isHidden = true
            lblConfirm.isHidden = true
            txtNew.layer.borderColor = UIColor.lightText.cgColor
            txtNew.placeholder = "New Password"
            txtConfirm.layer.borderColor = UIColor.lightText.cgColor
            txtConfirm.placeholder = "Confirm Password"
        }
        else if textField == txtNew {
            txtNew.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtNew.layer.borderWidth = 1
            txtNew.layer.cornerRadius = 5
            txtNew.placeholder = ""
            lblNew.isHidden = false
            lblOld.isHidden = true
            lblConfirm.isHidden = true
            txtOld.layer.borderColor = UIColor.lightText.cgColor
            txtOld.placeholder = "Old Password"
            txtConfirm.layer.borderColor = UIColor.lightText.cgColor
            txtConfirm.placeholder = "Confirm Password"
        }
        else {
            txtConfirm.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtConfirm.layer.borderWidth = 1
            txtConfirm.layer.cornerRadius = 5
            txtConfirm.placeholder = ""
            lblConfirm.isHidden = false
            lblOld.isHidden = true
            lblNew.isHidden = true
            txtOld.layer.borderColor = UIColor.lightText.cgColor
            txtOld.placeholder = "Old Password"
            txtNew.layer.borderColor = UIColor.lightText.cgColor
            txtNew.placeholder = "New Password"
        }
    }
}
