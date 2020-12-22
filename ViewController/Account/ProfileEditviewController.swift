//
//  ProfileEditviewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ProfileEditviewController: UIViewController {
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMob: UILabel!
    @IBOutlet weak var txtMob: UITextField!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var lblCollege: UILabel!
    @IBOutlet weak var txtCollege: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtGender: UITextField!
    
    
    @IBOutlet weak var nameview: UIView!
    
    var strName = String()
    var strEmail = String()
    var strMob = String()
    var strSchool = String()
    var strCollegename = String()
    var strmobile = String()
    let datePicker = UIDatePicker()
    
    var strNamereload = String()
    var strSchoolReload = String()
    var strCollegeReload = String()
    var strMobileReload = String()
    var strDOB = String()
    var strState = String()
    var strCity = String()
    var strGender = String()
    
//    let scrollView: UIScrollView = {
//        let v = UIScrollView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .cyan
//        return v
//    }()
    
    var myPickerView : UIPickerView!
    var pickerData = ["Male" , "Female" , "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add the scroll view to self.view
//                self.view.addSubview(scrollView)
//
//                // constrain the scroll view to 8-pts on each side
//                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//                scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
//                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
//
//        scrollView.addSubview(nameview)
        
        setDefault()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchState), name: NSNotification.Name(rawValue: "SearchingState"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.SearchingCity), name: NSNotification.Name(rawValue: "SearchingCity"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func SearchState(notification: NSNotification) {
        let state = notification.object
        txtState.text = state as? String
    }
    
    @objc func SearchingCity(notification: NSNotification) {
        let city = notification.object
        txtCity.text = city as? String
    }
    
    func pickUp(){

        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        txtGender.inputView = self.myPickerView

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtGender.inputAccessoryView = toolBar

    }
    
    //MARK:- Button
    @objc func doneClick() {
        txtGender.resignFirstResponder()
    }
    @objc func cancelClick() {
        txtGender.resignFirstResponder()
    }
    
    func setDefault() {
        activity.isHidden = true
        btnSave.layer.cornerRadius = 5
        btnSave.clipsToBounds = true
        strName = loggdenUser.value(forKey: NAME)as! String
        strEmail = loggdenUser.value(forKey: EMAIL)as! String
        
        lblName.text = strName
        txtName.text = strName
        lblEmail.text = strEmail
        if loggdenUser.value(forKey: PHONE_NUMBER) != nil {
            strMob = loggdenUser.value(forKey: PHONE_NUMBER)as! String
            lblMob.text = strMob
            txtMob.text = strMob
        }
        else {
            print("jekil")
        }
        
        if loggdenUser.value(forKey: DOB) != nil {
            strDOB = loggdenUser.value(forKey: DOB)as! String
            txtDOB.text = strDOB
            lblDOB.text = strDOB
        }
        else {
            print("jekil")
        }
        
        if loggdenUser.value(forKey: GENDER) != nil {
            strGender = loggdenUser.value(forKey: GENDER)as! String
            txtGender.text = strGender
            lblGender.text = strGender
        }
        else {
            print("jekil")
        }
        
        if loggdenUser.value(forKey: STATELog) != nil {
            strState = loggdenUser.value(forKey: STATELog)as! String
            txtState.text = strState
            lblState.text = strState
        }
        else {
            print("jekil")
        }
        
        if loggdenUser.value(forKey: CITYLog) != nil {
            strCity = loggdenUser.value(forKey: CITYLog)as! String
            txtCity.text = strCity
            lblCity.text = strCity
        }
        else {
            print("jekil")
        }
        
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

          //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

         txtDOB.inputAccessoryView = toolbar
         txtDOB.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDOB.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func saveEdit() {
        activity.isHidden = false
        activity.startAnimating()
        btnSave.setTitle(" ", for: .normal)
        
        let parameters = ["name":txtName.text!,
                          "dob":txtDOB.text!,
                          "gender":txtGender.text!,
                          "phone_number":txtMob.text!,
                          "city": txtCity.text!,
                          "state": txtState.text!]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(PROFILE, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnSave.setTitle("Save", for: .normal)
                    }))
                    let data = json.value(forKey: "data")as! NSDictionary
                    let name = data.value(forKey: "name")as! String
                     loggdenUser.set(name, forKey: NAME)
                    if data.value(forKey: "dob") is NSNull {
                        print("jekil")
                    }
                    else {
                        let dob = data.value(forKey: "dob")as! String
                        loggdenUser.set(dob, forKey: DOB)
                    }
                    
                    if data.value(forKey: "gender")is NSNull {
                        print("jekil")
                    }
                    else {
                        let gender = data.value(forKey: "gender")as! String
                        loggdenUser.set(gender, forKey: GENDER)
                    }
                    
                    if data.value(forKey: "phone_number")is NSNull {
                        print("jekil")
                    }
                    else {
                        let phone_number = data.value(forKey: "phone_number")as! String
                        loggdenUser.set(phone_number, forKey: PHONE_NUMBER)
                    }
                    
                    if data.value(forKey: "city")is NSNull {
                        print("jekil")
                    }
                    else {
                        let city = data.value(forKey: "city")as! String
                        loggdenUser.set(city, forKey: CITYLog)
                    }
                    
                    if data.value(forKey: "state")is NSNull {
                        print("jekil")
                    }
                    else {
                        let state = data.value(forKey: "state")as! String
                        loggdenUser.set(state, forKey: STATELog)
                    }
                    
                    self.setDefault()
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnSave.setTitle("Save", for: .normal)
                    }))
                }
        }
    }
    @IBAction func btnCityAction(_ sender: UIButton) {
        if txtState.text?.isEmpty == true {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Please Selecte State", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
        }
        else {
            txtCity.isHidden = false
            lblCity.isHidden = true
            txtCity.delegate = self
            txtCity.becomeFirstResponder()
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchingViewController")as! SearchingViewController
            obj.strTitle = "Select City"
            obj.strCity = txtState.text!
            self.present(obj, animated: true, completion: nil)
        }
    }
    @IBAction func btnStateAction(_ sender: UIButton) {
        txtState.isHidden = false
        lblState.isHidden = true
        txtState.delegate = self
        txtState.becomeFirstResponder()
       let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchingViewController")as! SearchingViewController
        obj.strTitle = "Select State"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnGenderAction(_ sender: UIButton) {
        pickUp()
        txtGender.isHidden = false
        lblGender.isHidden = true
        txtGender.delegate = self
        txtGender.becomeFirstResponder()
    }
    @IBAction func btnDobAction(_ sender: UIButton) {
        showDatePicker()
        txtDOB.isHidden = false
        lblDOB.isHidden = true
        txtDOB.delegate = self
        txtDOB.becomeFirstResponder()
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        saveEdit()
    }
    @IBAction func btnNameAction(_ sender: UIButton) {
        txtName.isHidden = false
        lblName.isHidden = true
        txtName.delegate = self
        txtName.becomeFirstResponder()
    }
    @IBAction func btnnumberAction(_ sender: UIButton) {
        txtMob.isHidden = false
        lblMob.isHidden = true
        txtMob.delegate = self
        txtMob.becomeFirstResponder()
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


extension ProfileEditviewController: UITextFieldDelegate {
     func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtName {
            strName = txtName.text!
        }
        else if textField == txtMob {
            strMob = txtMob.text!
        }
//        else if textField == txtSchool {
//            strSchool = txtSchool.text!
//        }
//        else {
//            strCollegename = txtCollege.text!
//        }
    }
}


extension ProfileEditviewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtGender.text = pickerData[row]
    }
}
