//
//  SubcategoryController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class AddCatSubcategorycontroller: UIViewController {
    
    
    @IBOutlet weak var collectiobSubcat: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var wc = Webservice.init()
    var arrSubcategory = NSArray()
    var url: URL?
    var category_id = Int()
    var strTitle = String()
    var strImage = String()
    var FreeCategory = String()
    var image = [#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder")]
    var arrMain_id = [Int]()
    var passSubscribe = String()
    var all = String()
    var encodeData = [Data]()
    var decodedData = [Data]()
    var mainCat_Ids = [Int]()
    var subCat_Ids = [Int]()
    var subcategory_type = String()
    var parem = [String: Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (loggdenUser.value(forKey: all_Ids) != nil) {
            decodedData = loggdenUser.value(forKey: all_Ids) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(Data_IdClass.self, from: decodedData[i])
                self.mainCat_Ids = decoded!.maincategoryIDS
                self.subCat_Ids = decoded!.subcategoryIDS
            }
        }

        lblTitle.text = strTitle
//        getSubscribe()
        getSubcategory()
        
//        if all == "all" {
//            getMainCategory()
//        }
//        else if subcategory_type == "maincategory" {
//            getMainCategory()
//        }
//        else {
//            getSubcategory()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func getSubscribe() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(GETUSERSUBSCRIPTION, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
                       print(response)
            let json = response.value as! NSDictionary
            let sucess = json.value(forKey: "success")as! Bool
            if sucess == true {
            let dic = json.value(forKey: "data")as! NSDictionary
            self.arrMain_id = dic.value(forKey: "subcategory_ids") as! [Int]
                self.collectiobSubcat.reloadData()
            }
            else {
                print("jekil")
            }
        }
    }
    
    func getMainCategory() {
        let parem = ["basecategory_id": category_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(GetMainCategory, method: .post, parameters: parem, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
            print(response)
            let json = response.value as! NSDictionary
            let sucess = json.value(forKey: "success")as! Bool
            let message = json.value(forKey: "message")as! String
                    
            if sucess == true {
                let data = json.value(forKey: "data")as! NSDictionary
                self.arrSubcategory = data.value(forKey: "data") as! NSArray
                self.collectiobSubcat.reloadData()
            }
            else {
                print("jekil")
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectiobSubcat.bounds.size.width, height: self.collectiobSubcat.bounds.size.height))
                noDataLabel.text          = message
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.collectiobSubcat.backgroundView  = noDataLabel
                self.collectiobSubcat.backgroundColor = UIColor.white
            }
        }
    }
    
    
    
    func getSubcategory() {

        parem = ["maincategory_id": category_id] as [String : Any]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(GetSubCategory, method: .post, parameters: parem, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
            print(response)
            let json = response.value as? NSDictionary
                    let sucess = json?.value(forKey: "success")as! Bool
                    let message = json?.value(forKey: "message")as! String
            if sucess == true {
                let data = json?.value(forKey: "data")as! NSDictionary
                self.arrSubcategory = data.value(forKey: "data") as! NSArray
                self.collectiobSubcat.reloadData()
            }
            else {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectiobSubcat.bounds.size.width, height: self.collectiobSubcat.bounds.size.height))
                noDataLabel.text          = message
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.collectiobSubcat.backgroundView  = noDataLabel
                self.image = []
                self.collectiobSubcat.reloadData()
            }
        }        
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


extension AddCatSubcategorycontroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSubcategory.count == 0 {
            return image.count
        }
        return arrSubcategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrSubcategory.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! catSubcatCollectionCell
            cell.image.image = image[indexPath.row]
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            return cell
        }
        else {
            let SubCategory = arrSubcategory[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! catSubcatCollectionCell
            cell.lblTitle.text = (SubCategory as AnyObject).value(forKey: "title") as? String
            cell.lblDescription.text = (SubCategory as AnyObject).value(forKey: "description") as? String
            let strimage = (SubCategory as AnyObject).value(forKey: "image") as? String
            url = URL(string: strimage!)
            cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
            cell.image.hideSkeleton()
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            if mainCat_Ids.count == 0 {
                print("jekil")
            }
            else {
                for i in 0..<subCat_Ids.count {
                    let id = (SubCategory as AnyObject).value(forKey: "id") as? Int
                    let Store_id = subCat_Ids[i]
                    if Store_id == id {
                        cell.lblSubscribe.isHidden = false
                        cell.lblSubscribe.text = "  Subscribed  "
                        break
                    }
                    else {
                        cell.lblSubscribe.isHidden = true
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = arrSubcategory[indexPath.item]
        print(selected)
        let id = (selected as AnyObject).value(forKey: "id") as? Int
        let title = (selected as AnyObject).value(forKey: "title") as? String
        let image = (selected as AnyObject).value(forKey: "image") as? String
//        let topic = (selected as AnyObject).value(forKey: "topic_count") as? Int
        let type = (selected as AnyObject).value(forKey: "type") as? String
        let cell = collectionView.cellForItem(at: indexPath)as! catSubcatCollectionCell
        let lable = cell.lblSubscribe.text
        print(lable)
        if lable == "  Subscribed  " {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TopicViewController")as! TopicViewController
            obj.subcategory_id = id!
            obj.strimage = image!
            obj.strTitle = title!
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsController")as! CategoryDetailsController
            obj.strMonthset = type ?? ""
            obj.cate_id = id!
            obj.strImage = image!
            obj.subcategory_type = "subcategory"
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2
        return CGSize(width: width, height: 210)
    }
}
