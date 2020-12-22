//
//  ParentViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 28/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ParentViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var collectionSelected: UICollectionView!
    
    @IBOutlet var parentview: UIView!
    @IBOutlet var imgprofile: UIImageView!
    @IBOutlet var lbl_username: UILabel!
    @IBOutlet weak var img_curve: UIImageView!
//    @IBOutlet weak var coll_height: NSLayoutConstraint!
    @IBOutlet weak var btnlogout: UIButton!{
        didSet{
            btnlogout.layer.cornerRadius = 5.0
            btnlogout.clipsToBounds = true
        }
    }
    
    var arrCategory1 = [["icon":#imageLiteral(resourceName: "attendce"),"name":"Attendances","color":redcolor,"index":0],["icon":#imageLiteral(resourceName: "datasheet"),"name":"Date sheet","color":bluecolor,"index":1],["icon":#imageLiteral(resourceName: "notification"),"name":"Notification","color":orangecolor,"index":2],["icon":#imageLiteral(resourceName: "assign"),"name":"Assignments","color":purplecolor,"index":3],["icon":#imageLiteral(resourceName: "assign"),"name":"Exam Result","color":redcolor,"index":4],["icon":#imageLiteral(resourceName: "help_desk"),"name":"Help desk","color":bluecolor,"index":5],["icon":#imageLiteral(resourceName: "event"),"name":"Events","color":orangecolor,"index":6],["icon":#imageLiteral(resourceName: "calendar"),"name":"Timetable","color":purplecolor,"index":7],["icon":#imageLiteral(resourceName: "image"),"name":"Student info","color":redcolor,"index":8],["icon":#imageLiteral(resourceName: "fashion"),"name":"Dress vendors","color":bluecolor,"index":9],["icon":#imageLiteral(resourceName: "ic_transport"),"name":"Transport details","color":orangecolor,"index":10],["icon":#imageLiteral(resourceName: "VideoLecture"),"name":"Video Lecture","color":purplecolor,"index":11],["icon":#imageLiteral(resourceName: "documents-symbol"),"name":"Note/Exam Paper","color":redcolor,"index":12],["icon":#imageLiteral(resourceName: "Fee"),"name":"Fee Payment","color":bluecolor,"index":13],["icon":#imageLiteral(resourceName: "history1"),"name":"Payment History","color":orangecolor,"index":14]]//,["icon":#imageLiteral(resourceName: "message"),"name":"Logout","color":bluecolor]
    
    
    var arrCategory = [["icon":#imageLiteral(resourceName: "image"),"name":"Student Profile","color":redcolor,"index":0],["icon":#imageLiteral(resourceName: "event"),"name":"Upcoming Events","color":bluecolor,"index":1],["icon":#imageLiteral(resourceName: "assign"),"name":"Assignments","color":orangecolor,"index":2],["icon":#imageLiteral(resourceName: "calendar"),"name":"Timetable","color":purplecolor,"index":3],["icon":#imageLiteral(resourceName: "datasheet"),"name":"Data Sheet","color":redcolor,"index":4],["icon":#imageLiteral(resourceName: "assign"),"name":"Exam Results","color":bluecolor,"index":5],["icon":#imageLiteral(resourceName: "attendce"),"name":"Attendences","color":redcolor,"index":6],["icon":#imageLiteral(resourceName: "documents-symbol"),"name":"Note/Exam Papers","color":bluecolor,"index":7],["icon":#imageLiteral(resourceName: "fashion"),"name":"Dress Vendors","color":orangecolor,"index":8],["icon":#imageLiteral(resourceName: "ic_transport"),"name":"Transport Details","color":purplecolor,"index":9],["icon":#imageLiteral(resourceName: "VideoLecture"),"name":"Video Lecture","color":redcolor,"index":10],["icon":#imageLiteral(resourceName: "Fee"),"name":"Fee Payment","color":bluecolor,"index":11],["icon":#imageLiteral(resourceName: "history1"),"name":"Payment History","color":bluecolor,"index":12],["icon":#imageLiteral(resourceName: "help_desk"),"name":"Help desk","color":purplecolor,"index":13],["icon":#imageLiteral(resourceName: "notification"),"name":"Notification","color":orangecolor,"index":14],["icon":#imageLiteral(resourceName: "videocon"),"name":"Video Conference","color":purplecolor,"index":15],["icon":#imageLiteral(resourceName: "chat"),"name":"Chat","color":redcolor,"index":16]]
    
    var url: URL?
    var wc = Webservice.init()
    var mobile = String()
    var arrFilterSearchDatum = [FilterSearchDatum]()
    var id = Int()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var selectedProfile = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_curve.image = img_curve.image?.withRenderingMode(.alwaysTemplate)
        img_curve.tintColor = UIColor(red: 0.18, green: 0.68, blue: 0.02, alpha: 1.00)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StudentSelection), name: NSNotification.Name(rawValue: "StudentSelection"), object: nil)
        setdefault()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // collectionSelected.reloadData()
    }
    
    @objc func StudentSelection(notification: NSNotification) {
        setdefault()
    }
    
    
    func setdefault() {
        if #available(iOS 13, *){
            
        }
        else{
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
        }
        
      
        lbl_username.text = loggdenUser.string(forKey: NAME)
        imgprofile.sd_setImage(with: URL(string: loggdenUser.string(forKey: PROFILE_IMAGE) ?? ""), completed: nil)
        
        let schoolLogo = loggdenUser.value(forKey: SCHOOL_LOGO)as! String
        url = URL(string: schoolLogo)
        logoImg.sd_setImage(with: url, completed: nil)
        
        lblName.text = loggdenUser.value(forKey: NAME)as? String
        
        let proimage = loggdenUser.value(forKey: PROFILE_IMAGE)as! String
        url = URL(string: proimage)
        imgProfile.sd_setImage(with: url, completed: nil)
        
        mobile = loggdenUser.value(forKey: PHONE_NUMBER) as! String
        id = loggdenUser.value(forKey: STUDENT_ID)as! Int
        getstudent()
    }
    
    func getstudent() {
        let param = ["mobile_number": mobile]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        wc.callSimplewebservice(url: STUDENT_GET, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: FilterSearchStudentGetResponseModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    self.arrFilterSearchDatum = response!.data
                    //self.collectionSelected.reloadData()
                }
                else {
                    print("jekil")
                }
            }
        }
    }
    
    @IBAction func btnStudentAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSelectionViewController")as! StudentSelectionViewController
        obj.arrFilterSearchDatum = arrFilterSearchDatum
        self.navigationController?.pushViewController(obj, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btn_LogoutAction(_ sender: Any) {
        let uiAlert = UIAlertController(title: "Bizzbrains", message: "Are you sure! Do you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            loggdenUser.set(false, forKey: PARENT_ISLOGIN)
            loggdenUser.removeObject(forKey: PHONE_NUMBER)
            loggdenUser.removeObject(forKey: PROFILE_IMAGE)
            loggdenUser.removeObject(forKey: SCHOOL_LOGO)
            loggdenUser.removeObject(forKey: NAME)
            loggdenUser.removeObject(forKey: TOKEN)
            loggdenUser.removeObject(forKey: STUDENT_ID)
            self.appDel.gotoLogin()
        }))
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
    }
    
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        let height = collectionview.collectionViewLayout.collectionViewContentSize.height
//        coll_height.constant = height
//        self.view.setNeedsLayout()
//    }
}

extension ParentViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionview {
            return arrCategory.count
        }
        return arrFilterSearchDatum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionview {
            let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! IconCollectionViewCell
            cell.img.image = (self.arrCategory[indexPath.row]as AnyObject).value(forKey: "icon") as? UIImage
            cell.lblName.text = (self.arrCategory[indexPath.row]as AnyObject).value(forKey: "name")as? String
            cell.colorview.backgroundColor = (arrCategory[indexPath.row]as AnyObject).value(forKey: "color") as? UIColor
            cell.img.image = cell.img.image?.withRenderingMode(.alwaysTemplate)
            cell.img.tintColor = UIColor.white
            return cell
        }
        else {
            let cell = collectionSelected.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! SelectedStudentCollectionViewCell
            if arrFilterSearchDatum[indexPath.row].name == lblName.text {
                cell.imgProfile.layer.borderWidth = 5
                cell.imgProfile.layer.borderColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1).cgColor
            }
            else {
                cell.imgProfile.layer.borderWidth = 0
                cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
            }
            cell.lblName.text = arrFilterSearchDatum[indexPath.row].name
            let strImage = arrFilterSearchDatum[indexPath.row].profile
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.imgProfile.layer.cornerRadius = 35
            cell.imgProfile.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionview {
             if indexPath.row == 0 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentInfoViewController")as! StudentInfoViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
             else if indexPath.row == 1 {
                 let obj = self.storyboard?.instantiateViewController(withIdentifier: "UpcommingEventViewController")as! UpcommingEventViewController
                 obj.arrFilterSearchDatum = arrFilterSearchDatum
                 self.navigationController?.pushViewController(obj, animated: true)
             }
             else if indexPath.row == 2 {
                 let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
                  obj.assignment = "assignment"
                 self.navigationController?.pushViewController(obj, animated: true)
             }
             else if indexPath.row == 3 {
                 let obj = self.storyboard?.instantiateViewController(withIdentifier: "TimetableViewController")as! TimetableViewController
                 obj.arrFilterSearchDatum = arrFilterSearchDatum
                 self.navigationController?.pushViewController(obj, animated: true)
             }
             else if indexPath.row == 4 {
                 let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
                 obj.arrFilterSearchDatum = arrFilterSearchDatum
                 self.navigationController?.pushViewController(obj, animated: true)
             }
             else if indexPath.row == 5 {
                 let obj = self.storyboard?.instantiateViewController(withIdentifier: "ExamResultListViewController")as! ExamResultListViewController
                 obj.arrFilterSearchDatum = arrFilterSearchDatum
                 self.navigationController?.pushViewController(obj, animated: true)
             }
            else if indexPath.row == 6 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController")as! AttendanceViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 7 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubjectViewController")as! SubjectViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 8 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DressVendorViewController")as! DressVendorViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 9 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TransportdetailsViewController")as! TransportdetailsViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 10 {
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
            else if indexPath.row == 13 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "HelpDeskViewController")as! HelpDeskViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if indexPath.row == 14 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "NoticeViewController")as! NoticeViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DateSheetViewController")as! DateSheetViewController
                obj.arrFilterSearchDatum = arrFilterSearchDatum
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
        else {
            selectedProfile = indexPath.row
            let selected = arrFilterSearchDatum[indexPath.row]
            loggdenUser.set(selected.profile, forKey: PROFILE_IMAGE)
            loggdenUser.set(selected.name, forKey: NAME)
            loggdenUser.set(selected.id, forKey: STUDENT_ID)
            setdefault()
            //collectionSelected.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 3.0
        return CGSize(width: width, height: width)
    }
}


