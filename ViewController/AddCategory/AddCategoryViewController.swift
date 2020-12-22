//
//  AddCategoryViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var lblCount: BadgeLabel!
    @IBOutlet weak var tblAddcategory: UITableView!
    var arrAddcategory = [addcategory]()
    var wc = Webservice.init()
    var url: URL?
    var addTocart = String()
    var badgeCount = Int()
    var addCart = [addcategory]()
    var encodeData = [Data]()
    var decodedData = [Data]()
    var arr_id = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loggdenUser.value(forKey: CARTCOUNT) != nil {
            let strCounter = loggdenUser.value(forKey: CARTCOUNT)as! String
            DispatchQueue.main.async {
                self.lblCount.badge(text: strCounter)
            }
        }
        else {
            self.lblCount.isHidden = true
        }
        
        if (loggdenUser.value(forKey: CARTVALUE) != nil) {
            decodedData = loggdenUser.value(forKey: CARTVALUE) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(addcategory.self, from: decodedData[i])
                addCart.append(decoded!)
            }
        }
        else {
            print("jekil")
        }

        getAddcategory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCategoryViewController.cartValueRemove), name: NSNotification.Name(rawValue: "cartValueRemove"), object: nil)
    }
    
    @objc func cartValueRemove(_ notification: NSNotification) {
        let count = notification.object as! Int
        addTocart = String(count)
        loggdenUser.set(self.addTocart, forKey: CARTCOUNT)
        DispatchQueue.main.async {
            self.lblCount.badge(text: self.addTocart)
            if self.lblCount.text == "0" {
                self.lblCount.isHidden = true
            }
            else {
                self.lblCount.isHidden = false
            }
        }
        addCart.removeAll()
        if (loggdenUser.value(forKey: CARTVALUE) != nil) {
            decodedData = loggdenUser.value(forKey: CARTVALUE) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(addcategory.self, from: decodedData[i])
                addCart.append(decoded!)
            }
        }
        else {
            print("jekil")
        }
    }
    
    func getAddcategory() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        wc.callSimplewebservice(url: ADDCATEGORY, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AddCategoryResponsModel?) in
            if sucess {
                self.arrAddcategory = response!.data
                self.tblAddcategory.reloadData()
            }
        }
    }
    
    

    @IBAction func btnCartAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "cartSummeryViewController")as! cartSummeryViewController
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

}

extension AddCategoryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrAddcategory.count == 0 {
            return 10
        }
        else {
           return arrAddcategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrAddcategory.count == 0 {
            let cell = tblAddcategory.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblAddCatCell
            return cell
        }
        else {
            let data = arrAddcategory[indexPath.row]
            let cell = tblAddcategory.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblAddCatCell
            if addCart.count == 0 {
                print("jekil")
            }
            else {
                for i in 0..<addCart.count {
                    let id = data.id
                    let Store_id = addCart[i].id
                    if Store_id == id {
                        cell.btnCart.isHidden = true
                        break
                    }
                    else {
                        cell.btnCart.isHidden = false
                    }
                }
            }
            
            cell.lblTitle.text = data.title
            cell.lblDescribe.text = data.description
            let month = data.month_labal
            let price = data.price
            if month == "Free" {
                cell.lblPrice.text = rupee + " " + String(price) + " for " + month
            }
            else {
                cell.lblPrice.text = rupee + " " + String(price) + " " + month
            }
            let strImage = data.photo300x300
            url = URL(string: strImage)
            cell.img.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
            cell.img.hideSkeleton()
            cell.img.layer.cornerRadius = 5
            cell.img.clipsToBounds = true
            cell.btnCart.layer.cornerRadius = 5
            cell.btnCart.clipsToBounds = true
            cell.btnCart.addTarget(self, action: #selector(AddCategoryViewController.btnaddcartAction), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func btnaddcartAction(_ sender: UIButton) {
        if let indexPath = self.tblAddcategory.indexPathForView(sender) {
            let data = arrAddcategory[indexPath.row]
            let cell = tblAddcategory.cellForRow(at: indexPath)as! tblAddCatCell
            cell.btnCart.isHidden = true
            addCart.append(data)
            encodeData.removeAll()
            for i in 0..<addCart.count {
                let jsonstring = addcategory.init(id: addCart[i].id, title: addCart[i].title, description: addCart[i].description, image: addCart[i].image, type: addCart[i].type, month_labal: addCart[i].month_labal, price: addCart[i].price, month_list: addCart[i].month_list, photo300x300: addCart[i].photo300x300)
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(jsonstring) {
                    encodeData.append(data)
                    loggdenUser.set(encodeData, forKey: CARTVALUE)
                }
            }
            if loggdenUser.value(forKey: CARTCOUNT) != nil {
                let strCounter = loggdenUser.value(forKey: CARTCOUNT)as! String
                DispatchQueue.main.async {
                    self.badgeCount = Int(strCounter)!
                    self.badgeCount += 1
                    self.addTocart = String(self.badgeCount)
                    DispatchQueue.main.async {
                        self.lblCount.badge(text: self.addTocart)
                        self.lblCount.isHidden = false
                        loggdenUser.set(self.addTocart, forKey: CARTCOUNT)
                    }
                }
            }
            else {
                badgeCount += 1
                addTocart = String(badgeCount)
                DispatchQueue.main.async {
                    self.lblCount.badge(text: self.addTocart)
                    self.lblCount.isHidden = false
                    loggdenUser.set(self.addTocart, forKey: CARTCOUNT)
                }
            }
        }
    }
}

extension UITableView {
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        
        //The center of the view is a better point to use, but we can only use it if the view has a superview
        guard let superview = view.superview else {
            //The view we were passed does not have a valid superview.
            //Use the view's bounds.origin and convert from the view's coordinate system
            let origin = self.convert(view.bounds.origin, from: view)
            let indexPath = self.indexPathForRow(at: origin)
            return indexPath
        }
        let viewCenter = self.convert(center, from: superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}

extension UICollectionView {
    func indexPathforitemView(_ view: UIView) -> IndexPath? {
        let center = view.center
        
        //The center of the view is a better point to use, but we can only use it if the view has a superview
        guard let superview = view.superview else {
            //The view we were passed does not have a valid superview.
            //Use the view's bounds.origin and convert from the view's coordinate system
            let origin = self.convert(view.bounds.origin, from: view)
            let indexPath = self.indexPathForItem(at: origin)
            return indexPath
        }
        let viewCenter = self.convert(center, from: superview)
        let indexPath = self.indexPathForItem(at: viewCenter)
        return indexPath
    }
}
