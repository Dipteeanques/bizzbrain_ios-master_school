//
//  AttendanceViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class AttendanceViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var btnapply: UIButton!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var btnproImage: UIButton!
    @IBOutlet weak var tblMain: UITableView!
    
    var wc = Webservice.init()
    var selectedRow = 0;
    var month_selecte = Int()
    var year_Select = String()
    var student_id = Int()
    var arrAttendance = [Datum]()
    var url: URL?
    var arrFilterSearchDatum = [FilterSearchDatum]()
    //Picker View Object
    let picker = UIPickerView()
    let pickerArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let pickerYear = ["2011","2012","2013","2014","2015","2016","2017","2018","2019","2020"]
    
    let datePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date as Date)
        
        let year = components.year
        txtYear.text = String(year!)
        month_selecte = components.month!

        setdefault()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSelection), name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func StudentSelection(notification: NSNotification) {
        setdefault()
    }
    func setdefault() {
        
        if (loggdenUser.value(forKey: STUDENT_ID) != nil) {
            student_id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        }
        getAttendance()
        txtMonth.placeholder = "Select Month"
        txtYear.placeholder = "Select year"
        picker.delegate = self
        picker.dataSource = self
        txtMonth.inputView = picker
        showDatePicker()
        //Done Button function called
        doneButton();
        btnapply.layer.cornerRadius = 5
        btnapply.clipsToBounds = true
        if loggdenUser.value(forKey: PROFILE_IMAGE) != nil {
            let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
            url = URL(string: proimage)
            imageProfile.sd_setImage(with: url, completed: nil)
        }
    }
    
    func getAttendance() {
        
        
        
        if month_selecte == 0 {
            month_selecte = 1
        }
        
        let param = ["student_id": student_id,
                     "month":month_selecte,
                     "year":txtYear.text!] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: ATTENDANCE, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: AttendanceModel?) in
            if success {
                let suc = response?.success
                let message = response?.message
                if suc == true {
                    self.arrAttendance = response!.data
                    self.tblMain.reloadData()
                }
                else {
                   let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblMain.bounds.size.width, height: self.tblMain.bounds.size.height))
                    noDataLabel.text          = message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tblMain.backgroundView  = noDataLabel
                    self.tblMain.separatorStyle  = .none
                }
            }
            
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

         txtYear.inputAccessoryView = toolbar
         txtYear.inputView = datePicker

    }
    
   @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy"
      txtYear.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
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
        txtMonth.text = pickerArray[row]
        //self.view.endEditing(false)
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
        
        txtMonth.inputView = pickerView
        txtMonth.inputAccessoryView = toolBar
    }
    
    
    @objc func donePicker() {
        self.txtMonth.text = pickerArray[selectedRow]
        txtMonth.resignFirstResponder()
    }
    @objc func canclePicker() {
        txtMonth.resignFirstResponder()
    }

    @IBAction func btnProImageAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnapplyAction(_ sender: UIButton) {
        getAttendance()
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

extension AttendanceViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendance = arrAttendance[indexPath.row]
        let cell = tblMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! AttendanceTableViewCell
        cell.lblDate.text = attendance.date
        if attendance.status == "present" {
            cell.btnAbsent.setTitle("   \(attendance.status)   ", for: .normal)
            cell.btnAbsent.backgroundColor = UIColor.green
        }
        else {
            cell.btnAbsent.setTitle("   \(attendance.status)   ", for: .normal)
        }
        
        cell.btnAbsent.layer.cornerRadius = 5
        cell.btnAbsent.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
