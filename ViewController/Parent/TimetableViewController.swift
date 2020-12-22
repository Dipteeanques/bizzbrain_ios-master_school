//
//  TimetableViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 07/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class TimetableViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var txtDay: UITextField!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var selectedRow = 0;
    var month_selecte = Int()
    //Picker View Object
    let picker = UIPickerView()
    let pickerArray = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var student_id = Int()
    var arrTimeTable = NSArray()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        txtDay.text = Date().dayOfWeek()
        setdefault()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSelection), name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func StudentSelection(notification: NSNotification) {
        setdefault()
    }
    func setdefault() {
        activityIndicator.style = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        if (loggdenUser.value(forKey: STUDENT_ID) != nil) {
            student_id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        }
        txtDay.placeholder = "Select Day"
        picker.delegate = self
        picker.dataSource = self
        txtDay.inputView = picker
        doneButton()
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
        timeTableAPI()
    }
    
    //begin  Doen Button function
    func doneButton(){
        
        let pickerView = picker
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
    
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.canclePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtDay.inputView = pickerView
        txtDay.inputAccessoryView = toolBar
    }
    
    
    @objc func donePicker() {
        self.txtDay.text = pickerArray[selectedRow]
        txtDay.resignFirstResponder()
        timeTableAPI()
    }
    @objc func canclePicker() {
        txtDay.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    public func pickerView(_pickerView:UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        month_selecte = row + 1
        txtDay.text = pickerArray[row]
        //self.view.endEditing(false)
    }
    
    func timeTableAPI() {
        
        let parameters = ["student_id": student_id,
                          "day_name":txtDay.text!] as [String : Any]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(TIME_TABLES, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    self.arrTimeTable = json.value(forKey: "data")as! NSArray
                    self.tblView.reloadData()
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblView.bounds.size.width, height: self.tblView.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblView.backgroundView  = noDataLabel
                    self.tblView.separatorStyle  = .none
                }
        }
    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnProImageAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
}


extension TimetableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblTimetableCell
        cell.lblDay.text = (self.arrTimeTable[indexPath.row]as AnyObject).value(forKey: "day_name")as? String
        cell.lbltitle.text = (self.arrTimeTable[indexPath.row]as AnyObject).value(forKey: "subject_name")as? String
        let start_time = (self.arrTimeTable[indexPath.row]as AnyObject).value(forKey: "start_time")as? String
        let end_time = (self.arrTimeTable[indexPath.row]as AnyObject).value(forKey: "end_time")as? String
        let final = start_time! + " - " + end_time!
        cell.lblDate.text = final
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


class tblTimetableCell: UITableViewCell {
    
    @IBOutlet weak var lbltitle: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = backView.frame.size.width / 2
        }
    }
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imageSubject: UIImageView! {
        didSet {
            imageSubject.layer.cornerRadius = imageSubject.frame.size.width / 2
            imageSubject.clipsToBounds = true
        }
    }
    
    
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
