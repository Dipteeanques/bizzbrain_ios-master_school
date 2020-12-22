//
//  SubcategoryController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import StoreKit

class SubcategoryController: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var btnMoreSubscribe: UIButton!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var viewFound: UIView!
    @IBOutlet weak var collectiobSubcat: UICollectionView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var wc = Webservice.init()
    var arrSubcategory = NSArray()
    var url: URL?
    var category_id = Int()
    var strTitle = String()
    var strImage = String()
    var FreeCategory = String()
    var image = [#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder")]
    var mainCat_Ids = [Int]()
    var subCat_Ids = [Int]()
    
    var productIDs: Array<String?> = []
    
    var productsArray: Array<SKProduct?> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    
    var encodeData = [Data]()
    var decodedData = [Data]()
    var all = ""
    
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
        lblNavi.text = strTitle
        url = URL(string: strImage)
        imgProfile.sd_setImage(with: url, completed: nil)
        imgProfile.layer.cornerRadius = 5
        imgProfile.clipsToBounds = true
        if all == "all" {
            getMainCategory()
        }
        else {
            getSubcategory()
        }
        
        btnSubscribe.layer.cornerRadius = 5
        btnSubscribe.clipsToBounds = true
        
        productIDs.append("1Month")
       // productIDs.append("iapdemo_extra_colors_col2")
        
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
               if sucess == true {
                   let data = json.value(forKey: "data")as! NSDictionary
                   self.arrSubcategory = data.value(forKey: "data") as! NSArray
                   self.collectiobSubcat.reloadData()
               }
               else {
                   print("jekil")
               }
           }
       }
    
    func getSubcategory() {
        let parem = ["maincategory_id": category_id] as [String : Any]
        print("param",parem)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(SUBCATEGORY, method: .post, parameters: parem, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
                    print(response)
            let json = response.value as! NSDictionary
            let sucess = json.value(forKey: "success")as! Bool
            if sucess == true {
                self.arrSubcategory = json.value(forKey: "data") as! NSArray
                self.collectiobSubcat.reloadData()
                self.viewFound.isHidden = true
                self.btnMoreSubscribe.isHidden = false
            }
            else {
                self.viewFound.isHidden = false
            }
        }
    }

    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubscraibAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
        obj.category_id = category_id
        obj.strTitle = strTitle
        obj.strImage = strImage
        obj.FreeCategory = "FreeCategory"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnSubscribeMoreAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
        obj.category_id = category_id
        obj.strTitle = strTitle
        obj.strImage = strImage
        obj.FreeCategory = "FreeCategory"
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
    
    // MARK: Custom method implementation
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs as [Any])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject> as Set<NSObject> as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "IAPDemo", message: "What do you want to do?", preferredStyle: UIAlertController.Style.actionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertAction.Style.default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex]!)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // MARK: SKProductsRequestDelegate method implementation
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            
            //tblProducts.reloadData()
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    
    // MARK: SKPaymentTransactionObserver method implementation
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
                for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
               // delegate.didBuyColorsCollection(collectionIndex: selectedProductIndex)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
}


extension SubcategoryController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSubcategory.count == 0 {
            return image.count
        }
        return arrSubcategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrSubcategory.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionCategoriesCell
            cell.image.image = image[indexPath.row]
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            return cell
        }
        else {
            let SubCategory = arrSubcategory[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionCategoriesCell
            cell.lblTitle.text = (SubCategory as AnyObject).value(forKey: "title") as? String
            cell.lblDescription.text = (SubCategory as AnyObject).value(forKey: "description") as? String
            let strimage = (SubCategory as AnyObject).value(forKey: "image") as! String
            url = URL(string: strimage)
            cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
            if all == "all" {
                for i in 0..<mainCat_Ids.count {
                    let id = (SubCategory as AnyObject).value(forKey: "id") as? Int
                    let Store_id = mainCat_Ids[i]
                    if Store_id == id {
                        cell.lblSubscribe.isHidden = false
                        cell.lblSubscribe.text = "  Subscribed  "
                        break;
                    }
                    else {
                        cell.lblSubscribe.isHidden = true
                    }
                }
            }
            else {
                for i in 0..<subCat_Ids.count {
                    let id = (SubCategory as AnyObject).value(forKey: "id") as? Int
                    let Store_id = subCat_Ids[i]
                    if Store_id == id {
                        cell.lblSubscribe.isHidden = false
                        cell.lblSubscribe.text = "  Subscribed  "
                        break;
                    }
                    else {
                        cell.lblSubscribe.isHidden = true
                    }
                }
            }

            cell.image.hideSkeleton()
            cell.image.layer.cornerRadius = 15
            cell.image.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strimage = (self.arrSubcategory[indexPath.row]as AnyObject).value(forKey: "image")as? String
        let cat_id = (self.arrSubcategory[indexPath.row]as AnyObject).value(forKey: "id") as? Int
        let Title = (self.arrSubcategory[indexPath.row]as AnyObject).value(forKey: "title") as? String
        var topic_count = (self.arrSubcategory[indexPath.row]as AnyObject).value(forKey: "topic_count") as? Int
        if topic_count == nil{
            topic_count = (self.arrSubcategory[indexPath.row]as AnyObject).value(forKey: "is_topic") as? Int
        }
        let cell = collectionView.cellForItem(at: indexPath)as! CollectionCategoriesCell
        let lable = cell.lblSubscribe.text
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
//        obj.category_id = cat_id!
//        obj.strTitle = Title!
//        obj.strImage = strimage!
//        self.navigationController?.pushViewController(obj, animated: true)
        
        if lable == "  Subscribed  " {
            if topic_count == 1{
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TopicViewController")as! TopicViewController
                obj.subcategory_id = cat_id!
                obj.strimage = strimage!
                obj.strTitle = Title!
                obj.strnavi = lblNavi.text! + " >> " + Title!
                self.navigationController?.pushViewController(obj, animated: true)
            }
            if topic_count == 0{
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "SelectedTypeViewController")as! SelectedTypeViewController
                obj.strTitle = Title!
                obj.strimage = strimage!
                obj.strnavi = lblNavi.text! + " >> " + Title!
                obj.is_video = 1
                obj.is_test = 1
                obj.is_document = 1
                self.navigationController?.pushViewController(obj, animated: true)
            }
//            else{
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TopicViewController")as! TopicViewController
//                obj.subcategory_id = cat_id!
//                obj.strimage = strimage!
//                obj.strTitle = Title!
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsController")as! CategoryDetailsController
            obj.cate_id = cat_id!
            obj.strImage = strimage!
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
