//
//  CategoryAddSubMainController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 15/10/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class CategoryAddSubMainController: UIViewController {

    @IBOutlet weak var collectioncategory: UICollectionView!
    
    @IBOutlet weak var foundview: UIView!
    var arrSubscribe = NSArray()
    var wc = Webservice.init()
    var url: URL?
    var image = [#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder")]
    var arrMain_id = [Int]()
    var passSubscribe = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMySubscribe()
//        getSubscribe()
//        getAddcategory()
//      
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
                         self.arrMain_id = dic.value(forKey: "maincategory_ids") as! [Int]
                        self.collectioncategory.reloadData()
                     }
                     else {
                        self.foundview.isHidden = false
                         print("jekil")
                     }
            
         }
     }
    
    
    func getMySubscribe() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(MAINCATEGORY, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                print(json)
                let sucess = json.value(forKey: "success")as! Bool
                if sucess == true {
                    self.arrSubscribe = json.value(forKey: "data")as! NSArray
                    self.collectioncategory.reloadData()
                }
                else {
                   self.foundview.isHidden = false
                    print("jekil")
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

}

extension CategoryAddSubMainController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSubscribe.count == 0 {
            return image.count
        }
        return arrSubscribe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrSubscribe.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! catSubcatCollectionCell
            cell.image.image = image[indexPath.row]
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! catSubcatCollectionCell
            cell.lblTitle.text = (self.arrSubscribe[indexPath.row]as AnyObject).value(forKey: "title") as? String
            cell.lblDescription.text = (self.arrSubscribe[indexPath.row]as AnyObject).value(forKey: "description") as? String
            let strimage = (self.arrSubscribe[indexPath.row]as AnyObject).value(forKey: "photo300x300") as? String
            url = URL(string: strimage!)
            cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
            cell.lblSubscribe.isHidden = false
            cell.image.hideSkeleton()
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            if arrMain_id.count == 0 {
                print("jekil")
            }
            else {
                for i in 0..<arrMain_id.count {
                    let id = (self.arrSubscribe[indexPath.row]as AnyObject).value(forKey: "id") as? Int
                    let Store_id = arrMain_id[i]
                    if Store_id == id {
                        cell.lblSubscribe.isHidden = false
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
        let selected = arrSubscribe[indexPath.item]
        let id = (selected as AnyObject).value(forKey: "id")as! Int
        let title = (selected as AnyObject).value(forKey: "title")as! String
        let image = (selected as AnyObject).value(forKey: "photo300x300")as! String
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubcategoryController")as! SubcategoryController
        obj.category_id = id
        obj.strTitle = title
        obj.strImage = image
        self.navigationController?.pushViewController(obj, animated: true)

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
