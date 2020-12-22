//
//  CategoriesViewcontroller.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CategoriesViewcontroller: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    
    
    var wc = Webservice.init()
    var arrFree = [AllcategoryResponse]()
    var arrPaid = [AllcategoryResponse]()
    var url: URL?
    var arrAllCategories = [FreePaidrespons]()
    var arrHeader = [String]()
    var strName = String()
    var strMob = String()
    var strState = String()
    var strCity = String()
    var strSchoolName = String()
    var strCollegename = String()
    var strPassword = String()
    var strEmail = String()
    var arrSelected_id = [AllcategoryResponse]()
    var all_id = [String]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var fb_id = String()
    var FCMToken = String()
    
    // Create collection view layout
    lazy var layout: UICollectionViewFlowLayout = {
        let l: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        l.minimumInteritemSpacing = 5 // horizontal space between cells
        l.minimumLineSpacing = 5 // vertical space between cells
        
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.isHidden = true
        collectionCategories.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.id)
        collectionCategories.allowsMultipleSelection = true
       getCategories()
    }
    
    func getCategories() {
        let headers: HTTPHeaders = ["Xapi": Xapi]
        wc.callSimplewebservice(url: CATEGORIES, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: CategoriesResponsModel?) in
            let data = response?.data
            self.arrFree = data!.Free
            self.arrPaid = data!.Paid
           
            if self.arrFree.count == 0 && self.arrPaid.count == 0 {
                
            }
            else if self.arrFree.count == 0 {
                self.arrHeader = ["Paid"]
            }
            else if self.arrPaid.count == 0 {
                self.arrHeader = ["Free"]
            }
            else {
                 self.arrHeader = ["Free","Paid"]
            }
            self.collectionCategories.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionCategories.frame = view.bounds
    }
    
    func registration() {
        activity.isHidden = false
        activity.startAnimating()
        btnDone.setTitle(" ", for: .normal)
        for i in 0..<arrSelected_id.count  {
            let str = String(arrSelected_id[i].id)
            all_id.append(str)
        }
        
        if loggdenUser.value(forKey: FCM) != nil {
           FCMToken = loggdenUser.value(forKey: FCM)as! String
        }
        else {
            print("jekil")
        }
        
        let strCat_id = all_id.joined(separator: ",")
        let param = ["name":strName,
                     "password":strPassword,
                     "username":strEmail,
                     "phone_number":strMob,
                     "maincategory_id":strCat_id,
                     "city":strCity,
                     "state":strState,
                     "school_name":strSchoolName,
                     "college_name":strCollegename,
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
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.btnDone.setTitle(" Done ", for: .normal)
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnDone.setTitle(" Done ", for: .normal)
                    }))
                }
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDoneAction(_ sender: UIButton) {
        registration()
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

extension CategoriesViewcontroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrHeader.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if arrFree.count == 0 {
                return 6
            }
            else {
                return arrFree.count
            }
        default:
            if arrPaid.count == 0 {
                return 6
            }
            else {
                return arrPaid.count
            }
        }
//        if arrFree.count == 0 {
//            return 6
//        }
//        else {
//            return arrFree.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if arrFree.count == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
//            return cell
//        }
//        else {
//            let free = arrFree[indexPath.row]
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
//            cell.lblName.text = free.title
//            let strImage = free.photo300x300
//            url = URL(string: strImage)
//            cell.imgCategory.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
//            cell.imgCategory.hideSkeleton()
//            cell.imgSelected.hideSkeleton()
//            cell.lblName.hideSkeleton()
//            cell.imgSelected.layer.cornerRadius = 5
//            cell.imgSelected.clipsToBounds = true
//            cell.imgCategory.layer.cornerRadius = 5
//            cell.imgCategory.clipsToBounds = true
//            return cell
//        }
        
        switch indexPath.section {
        case 0:
            if arrFree.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
                return cell
            }
            else {
                let free = arrFree[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
                cell.lblName.text = free.title
                let strImage = free.photo300x300
                url = URL(string: strImage)
                cell.imgCategory.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.imgCategory.hideSkeleton()
                cell.imgSelected.hideSkeleton()
                cell.imgSelected.layer.cornerRadius = 5
                cell.imgSelected.clipsToBounds = true
                cell.imgCategory.layer.cornerRadius = 5
                cell.imgCategory.clipsToBounds = true
                return cell
            }
        default:
            if arrPaid.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
                return cell
            }
            else {
                let paid = arrPaid[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! FreeCollectionCell
                cell.lblName.text = paid.title
                let strImage = paid.photo300x300
                url = URL(string: strImage)
                cell.imgCategory.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.imgCategory.hideSkeleton()
                cell.imgSelected.hideSkeleton()
                cell.imgSelected.layer.cornerRadius = 5
                cell.imgSelected.clipsToBounds = true
                cell.imgCategory.layer.cornerRadius = 5
                cell.imgCategory.clipsToBounds = true
                return cell
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionCategories.cellForItem(at: indexPath)as! FreeCollectionCell
//        arrSelected_id.append(arrFree[indexPath.row])
//        print("selected:",arrSelected_id)
//        cell.imgSelected.isHidden = false
        switch indexPath.section {
        case 0:
            arrSelected_id.append(arrFree[indexPath.row])
            print("selected:",arrSelected_id)
            cell.imgSelected.isHidden = false
        default:
            arrSelected_id.append(arrPaid[indexPath.row])
            print("selected:",arrSelected_id)
            cell.imgSelected.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionCategories.cellForItem(at: indexPath)as! FreeCollectionCell
//        arrSelected_id.remove(at: indexPath.row)
//        cell.imgSelected.isHidden = true
        switch indexPath.section {
        case 0:
            arrSelected_id.remove(at: indexPath.row)
            cell.imgSelected.isHidden = true
        default:
            arrSelected_id.remove(at: indexPath.row)
            cell.imgSelected.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.id, for: indexPath) as! Header
//        header.textLable.text = "  Free"
//        return header
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.id, for: indexPath) as! Header
            header.textLable.text = "  Free"
            return header
        }
        else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.id, for: indexPath) as! Header
            header.textLable.text = "  Paid"
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 1
        let collectionViewSize = collectionCategories.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: 165)
    }
}


// Header
final class Header: UICollectionReusableView {
    static let id: String = "headerId"
    
    let textLable: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLable.textAlignment = .left
        addSubview(textLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLable.frame = bounds
    }
}
