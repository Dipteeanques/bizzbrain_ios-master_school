//
//  StudentZoneViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 14/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import DKImagePickerController
import Alamofire
import FirebaseAuth
import Firebase


class StudentZoneViewController: UIViewController {
    
    var arrFirebaseSave : getFirebaseSaveRoot?
    var wc = Webservice.init()
    var arrgetFirebaseDetailsRoot : getFirebaseDetailsRoot?
    @IBOutlet weak var img_schoolLogo: UIImageView!
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var viewimage: UIView!{
        didSet{
            viewimage.layer.cornerRadius = viewimage.frame.size.height/2
            viewimage.clipsToBounds = true
        }
    }
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_class: UILabel!
    @IBOutlet weak var cameraview: UIView!{
        didSet{
            cameraview.layer.cornerRadius = cameraview.frame.size.height/2
            cameraview.clipsToBounds = true
        }
    }
    
//    @IBOutlet weak var coll_height: NSLayoutConstraint!
    
    var arrCategory = [["icon":#imageLiteral(resourceName: "image"),"name":"Student Profile","color":redcolor],["icon":#imageLiteral(resourceName: "event"),"name":"Upcoming Events","color":bluecolor],["icon":#imageLiteral(resourceName: "assign"),"name":"Assignments","color":orangecolor],["icon":#imageLiteral(resourceName: "calendar"),"name":"Timetable","color":purplecolor],["icon":#imageLiteral(resourceName: "datasheet"),"name":"Data Sheet","color":redcolor],["icon":#imageLiteral(resourceName: "assign"),"name":"Exam Results","color":bluecolor],["icon":#imageLiteral(resourceName: "attendce"),"name":"Attendences","color":redcolor],["icon":#imageLiteral(resourceName: "documents-symbol"),"name":"Note/Exam Papers","color":bluecolor],["icon":#imageLiteral(resourceName: "fashion"),"name":"Dress Vendors","color":orangecolor],["icon":#imageLiteral(resourceName: "ic_transport"),"name":"Transport Details","color":purplecolor],["icon":#imageLiteral(resourceName: "VideoLecture"),"name":"Video Lecture","color":redcolor],["icon":#imageLiteral(resourceName: "Fee"),"name":"Fee Payment","color":bluecolor],["icon":#imageLiteral(resourceName: "history1"),"name":"Payment History","color":orangecolor],["icon":#imageLiteral(resourceName: "notification"),"name":"Notification","color":purplecolor,"index":14],["icon":#imageLiteral(resourceName: "videocon"),"name":"Video Conference","color":bluecolor],["icon":#imageLiteral(resourceName: "chat"),"name":"Chat","color":redcolor]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let width = collectionview.bounds.size.width / 3
//        coll_height.constant = width * CGFloat(arrCategory.count)
        
        let firebaseId = loggdenUser.string(forKey: SENDER_ID)
        print(firebaseId)
        if firebaseId == ""{
            GetFirebaseDetails()
            print("empty")
        }
        else{
            print("not empty")
        }
        setDefault()
       
    }
    
    func GetFirebaseDetails() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        var type = String()
        if  ((loggdenUser.value(forKey: ROLE_ID) as! Int) == 6){
            type = "Student"
        }
        let params = ["user_id":loggdenUser.value(forKey: USER_ID),"type":type]
        
        wc.callSimplewebservice(url: getFirebaseDetails, parameters: params as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response:getFirebaseDetailsRoot?) in
            if success {
                print("response:",response)
                let suc = response?.success
                if suc == true {
                    self.arrgetFirebaseDetailsRoot = response!
                    loggdenUser.setValue(self.arrgetFirebaseDetailsRoot?.data.firebase_id, forKey: SENDER_ID)
                    loggdenUser.setValue(self.arrgetFirebaseDetailsRoot?.data.firebase_email, forKey: FIREBASE_EMAIL)
                    loggdenUser.setValue(self.arrgetFirebaseDetailsRoot?.data.firebase_password, forKey: FIREBASE_PASSWORD)
                    let email = self.arrgetFirebaseDetailsRoot?.data.firebase_email
                    let password = self.arrgetFirebaseDetailsRoot?.data.firebase_password
                    
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        // guard against errors and optionals
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return }
                        guard let user = user else {
                            print(error?.localizedDescription)
                            return }
                        //                        print("id:",user.user.uid)
                        
                        
                        Messaging.messaging().token { token, error in
                            if let error = error {
                                print("Error fetching FCM registration token: \(error)")
                                return
                            } else if let token = token {
                                let ref2 = Constants.refs2.databaseChats.childByAutoId()
                                let senderName = ((loggdenUser.string(forKey: NAME) ?? "") + "(\((loggdenUser.string(forKey: EMAIL) ?? "")))")
                                let message1 = ["device_token":token,"id":ref2.key,"username":senderName]
                                print("message1",message1)
                                ref2.setValue(message1)
                                print("FCM registration token: \(token)")
                                let token = "Remote FCM registration token: \(token)"
                                print(token)
                                self.GetFirebaseSave(firebase_id:ref2.key! , firebase_email: email!)
                                
                            }
                        }
                        
                    }
                }
                else {
                    print("jekil")
                }
            }
            else{
                
            }
        }
    }
    
    func GetFirebaseSave(firebase_id:String,firebase_email:String) {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
       
        wc.callSimplewebservice(url: FirebaseSave, parameters: ["firebase_id":firebase_id,"firebase_email":firebase_email], headers: headers, fromView: self.view, isLoading: true) { (success, response:getFirebaseSaveRoot?) in
            if success {
                print("response:",response)
                let suc = response?.success
                if suc == true {
                    self.arrFirebaseSave = response!
                    loggdenUser.setValue(self.arrFirebaseSave?.data.firebase_id, forKey: SENDER_ID)
                    loggdenUser.setValue(self.arrFirebaseSave?.data.firebase_email, forKey: FIREBASE_EMAIL)
                    loggdenUser.setValue(self.arrFirebaseSave?.data.firebase_password, forKey: FIREBASE_PASSWORD)
                }
                else {
                    print("jekil")
                }
            }
            else{

            }
        }
    }
    
    func setDefault(){
        img_schoolLogo.sd_setImage(with: URL(string: loggdenUser.string(forKey: SCHOOL_LOGO) ?? ""), completed: nil)
        lblName.text = loggdenUser.string(forKey: NAME)
        lbl_class.text = (loggdenUser.string(forKey: STANDARD) ?? "") + " - " + (loggdenUser.string(forKey: CLASS) ?? "")
        img_profile.sd_setImage(with: URL(string: loggdenUser.string(forKey: PROFILEMAIN) ?? ""), completed: nil)
    }

    @IBAction func btn_CameraAction(_ sender: Any) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                
                self.img_profile.image = image
                self.IMAGE(parameters: [:])
                
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            
        }
    }
    
    func IMAGE(parameters: [String : Any])  {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.upload(
            multipartFormData: { multiPart in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key )
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                let imagedata = self.img_profile.image?.jpegData(compressionQuality: 1)
                multiPart.append(imagedata!, withName: "profile", fileName:(String(NSDate().timeIntervalSince1970) + ".png") , mimeType: "image/png")
            },
            to: CHANGEPROFILE, usingThreshold: UInt64.init(), method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                let dic = response.value as! NSDictionary
                let success = dic.value(forKey: "success")as! Bool
                if success == true{
                    let data = dic.value(forKey: "data")as! String
                    print("data:",data)
                    loggdenUser.setValue(data, forKey: PROFILEMAIN)
                }
            })
        
    }
    

}

extension StudentZoneViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblstudentZoneCell
        cell.icon.image = (arrCategory[indexPath.row]as AnyObject).value(forKey: "icon") as? UIImage
        cell.lblTitle.text = (arrCategory[indexPath.row]as AnyObject).value(forKey: "name") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentInfoViewController")as! StudentInfoViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingEventViewController")as! UpcommingEventViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "assignment"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TimetableViewController")as! TimetableViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 4 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultListViewController")as! ExamResultListViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController")as! AttendanceViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 7 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 8 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DressVendorViewController")as! DressVendorViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 9 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TransportdetailsViewController")as! TransportdetailsViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 10{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "VideoSubject"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 11{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FeesDetailsVC")as! FeesDetailsVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
}

extension StudentZoneViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StudentZoneCell
        cell.img_icon.image = (arrCategory[indexPath.row]as AnyObject).value(forKey: "icon") as? UIImage
        cell.lbl_title.text = (arrCategory[indexPath.row]as AnyObject).value(forKey: "name") as? String
        cell.colorview.backgroundColor = (arrCategory[indexPath.row]as AnyObject).value(forKey: "color") as? UIColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentInfoViewController")as! StudentInfoViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingEventViewController")as! UpcommingEventViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "assignment"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TimetableViewController")as! TimetableViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 4 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultListViewController")as! ExamResultListViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController")as! AttendanceViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 7 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 8 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DressVendorViewController")as! DressVendorViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 9 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TransportdetailsViewController")as! TransportdetailsViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 10{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
            obj.assignment = "VideoSubject"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 11{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FeesDetailsVC")as! FeesDetailsVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 12{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryVC")as! PaymentHistoryVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 13{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NoticeViewController")as! NoticeViewController
//            obj.arrFilterSearchDatum = arrFilterSearchDatum
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 14{
            NavigateVideoConference()
        }
        else if indexPath.row == 15{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ConverstationsVC")as! ConverstationsVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.size.width / 3
       
            return CGSize(width: width, height: width)
    }
}

class tblstudentZoneCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
}

//color
let redcolor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
let bluecolor = UIColor(red: 0.00, green: 0.40, blue: 1.00, alpha: 1.00)
let orangecolor = UIColor(red: 1.00, green: 0.53, blue: 0.00, alpha: 1.00)
let purplecolor = UIColor(red: 0.60, green: 0.00, blue: 1.00, alpha: 1.00)



