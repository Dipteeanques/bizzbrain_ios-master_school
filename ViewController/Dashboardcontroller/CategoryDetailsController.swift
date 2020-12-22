//
//  CategoryDetailsController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 30/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

struct FreePayment: Codable {
    let maincaregory_id: String
    let subcategory_id: String
    let price: String
    let type: String
    let membership_period_id: String
}

class CategoryDetailsController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblPlan: UITableView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderVire: UIView!
    @IBOutlet weak var lblPlese: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tblCatDetails: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var cate_id = Int()
    var url: URL?
    var strLondescription = String()
    var addCart = [addcategory]()
    var encodeData = [Data]()
    var decodedData = [Data]()
    var strCount = String()
    var add_category = NSDictionary()
    var arrsetCart = [addcategory]()
    var badgeCount = Int()
    var strImage = String()
    var subcategory_type = String()
    var strNumber = String()
    var strMonthset = String()
    var GrossTotal = Int()
    var jsonString = String()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var arrPayment: [paymentCat] = []
    var freePaymentCat: [FreePayment] = []
    
    fileprivate var wkWebViewHeight: CGFloat = 100
    var mainCate = Int()
    var arrMain_id = [Int]()
    var arrSub_id = [Int]()
    var matchsubscribe = String()
    var priceCheck = String()
    var arrPricecodeList = NSArray()
    var arrPriceCodeSKU = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(strMonthset)
        setDefault()
//        getCall()
//        Getplan()
   //     getSubscribe()
//        if matchsubscribe == "Already Subscribe" {
//            btnSubscribe.setTitle("Already Subscribe", for: .normal)
//        }
//        else {
//            btnSubscribe.setTitle("Subscribe", for: .normal)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getmaincategorydetails() {
        let parem = ["id": cate_id,
                     "category_type":"subcategory"] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(GETMAINCATEGORYDETAILS, method: .post, parameters: parem, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
                    print(response)
            let json = response.value as! NSDictionary
            let sucess = json.value(forKey: "success")as! Bool
            if sucess == true {
                let jsondata = json.value(forKey: "data")as! NSDictionary
                let title = jsondata.value(forKey: "title")as! String
                self.lblTitle.text = title
                let description = jsondata.value(forKey: "description")as! String
                self.lblDescription.text = description
                self.strLondescription = jsondata.value(forKey: "long_description")as! String
                let maincaregory_id = jsondata.value(forKey: "maincategory_id")as! Int
                let subcategory_id = jsondata.value(forKey: "id")as! Int
                let price = "0"
                let type = jsondata.value(forKey: "type")as! String
                let membership_period_id = "0"
                let pCat = FreePayment.init(maincaregory_id: String(maincaregory_id), subcategory_id: String(subcategory_id), price: price, type: type, membership_period_id: membership_period_id)
                self.freePaymentCat.append(pCat)
                self.loaderVire.isHidden = true
                self.loadActivity.stopAnimating()
                self.tblCatDetails.reloadData()
            }
        }
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
            self.arrSub_id = dic.value(forKey: "subcategory_ids") as! [Int]
            self.arrMain_id = dic.value(forKey: "maincategory_ids") as! [Int]
            }
            else {
                print("jekil")
            }
        }
    }
    
    func getCall() {
       let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(CallSetting, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.strNumber = data.value(forKey: "contact_us_phone_number")as! String
                }
          }
    }
    
    func setDefault() {
        activity.isHidden = true
        loadActivity.startAnimating()
    
//        if (loggdenUser.value(forKey: CARTVALUE) != nil) {
//            decodedData = loggdenUser.value(forKey: CARTVALUE) as! [Data]
//            for i in 0..<decodedData.count
//            {
//                let decoder = JSONDecoder()
//                let decoded = try? decoder.decode(addcategory.self, from: decodedData[i])
//                addCart.append(decoded!)
//                for i in 0..<addCart.count {
//                    let same_id = addCart[i].id
//                    if same_id == cate_id {
//                        btnAddCart.setTitle("Goto Cart", for: .normal)
//                    }
//                }
//            }
//        }
//        else {
//            print("jekil")
//        }
//
//        if loggdenUser.value(forKey: CARTCOUNT) != nil {
//            let strCounter = loggdenUser.value(forKey: CARTCOUNT)as! String
//            DispatchQueue.main.async {
//                self.strCount = strCounter
//            }
//        }
//        else {
//             print("jekil")
//        }
        
        lblOnline.isHidden = true
        lblPlese.isHidden = true
        btnAddCart.isHidden = true
        btnSubscribe.isHidden = false
        
        btnAddCart.layer.cornerRadius = 5
        btnAddCart.clipsToBounds = true
        btnSubscribe.layer.cornerRadius = 5
        btnSubscribe.clipsToBounds = true
        //getDetails()
        getmaincategorydetails()
        self.url = URL(string: strImage)
        self.img.sd_setImage(with: self.url, placeholderImage: UIImage(named: "BizzbrainPlaceHolder.jpg"), options: [], completed: nil)
    }
    
    func Getplan() {
        let parem = ["id": cate_id,
                     "type":subcategory_type] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
        AF.request(GET_PRICE_CATEGORY, method: .post, parameters: parem, encoding: JSONEncoding.default,headers: headers)
                   .responseJSON { response in
                    print(response)
            let json = response.value as! NSDictionary
            let sucess = json.value(forKey: "success")as! Bool
            if sucess == true {
                let jsondata = json.value(forKey: "data")as! NSDictionary
                self.arrPricecodeList = jsondata.value(forKey: "price_list") as! NSArray
                print(self.arrPricecodeList)
                for i in 0..<self.arrPricecodeList.count {
                    let price = (self.arrPricecodeList[i] as AnyObject).value(forKey: "price")as! String
                    self.arrPriceCodeSKU.append(price)
                    print(self.arrPriceCodeSKU)
                }
            
               // self.tblPlan.reloadData()
            }
            else {
                
            }
        }
    }
    
    func getDetails() {
        
        let param = ["id":cate_id,
                     "type":subcategory_type] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(VERSIONCATDETAILS, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                self.loaderVire.isHidden = true
                self.loadActivity.stopAnimating()
                let json = response.value as! NSDictionary
                let data = json.value(forKey: "data")as! NSDictionary
                let description = data.value(forKey: "description")as! String
                let title = data.value(forKey: "title")as! String
                self.lblTitle.text = title
                self.lblDescription.text = description
                self.strLondescription = data.value(forKey: "long_description")as! String
                self.add_category = data.value(forKey: "add_category")as! NSDictionary
                let day_type = self.add_category.value(forKey: "month_labal")as! String
                let id = self.add_category.value(forKey: "id")as! Int
                let price = self.add_category.value(forKey: "price")as! String
                self.priceCheck = self.add_category.value(forKey: "price")as! String
                if self.strMonthset == "Free" {
                    if self.subcategory_type == "maincategory" {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.cate_id)", price: price,type:self.subcategory_type,subcategory_id:"0")
                        self.arrPayment.append(pCat)
                    }
                    else {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.mainCate)", price: price,type:self.subcategory_type,subcategory_id:"\(id)")
                        self.arrPayment.append(pCat)
                    }
                }
                else if self.strMonthset == "for 1 Month trial" {
                    if self.subcategory_type == "maincategory" {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.cate_id)", price: price,type:self.subcategory_type,subcategory_id:"0")
                        self.arrPayment.append(pCat)
                    }
                    else {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.mainCate)", price: price,type:self.subcategory_type,subcategory_id:"\(id)")
                        self.arrPayment.append(pCat)
                    }
                }
                else {
                    if self.subcategory_type == "maincategory" {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.cate_id)", price: price,type:self.subcategory_type,subcategory_id:"0")
                        self.arrPayment.append(pCat)
                    }
                    else {
                        let pCat = paymentCat(day_type: day_type, maincaregory_id: "\(self.mainCate)", price: price,type:self.subcategory_type,subcategory_id:"\(id)")
                        self.arrPayment.append(pCat)
                    }
                }
                self.tblCatDetails.reloadData()
        }
    }
    
    func PriceZire() {
           activity.isHidden = false
           activity.startAnimating()
           btnSubscribe.setTitle(" ", for: .normal)
           
           let jsonEncoder = JSONEncoder()
           do {
               let jsonData = try jsonEncoder.encode(freePaymentCat)
               jsonString = String(data: jsonData, encoding: .utf8)!
               print("JSON String : " + jsonString)
           }
           catch {
               print("jekil")
           }
           let param = ["coupon_code":"",
                        "amount":0,
                        "discount": 0,
                        "total_amount":0,
                        "payment_txnid":"",
                        "payment_status":"",
                        "payment_response":"",
                        "cart_data":jsonString] as [String : Any]
           
           print(param)
           
           let token = loggdenUser.value(forKey: TOKEN)as! String
           let headers: HTTPHeaders = ["Xapi": Xapi,
                                       "Authorization":token]
                   
           AF.request(PAYMENT, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
               .responseJSON { response in
                   print(response)
                   let json = response.value as! NSDictionary
                   let sucess = json.value(forKey: "success")as! Bool
                   let message = json.value(forKey: "message")as! String
                   if sucess == true {
                    
                    if (loggdenUser.value(forKey: ROLE_ID) != nil) {
                        let role_id = loggdenUser.value(forKey: ROLE_ID)as! Int
                        if role_id == 6 {
                            self.appDel.gotoStudent()
                        }
                        else if role_id == 2{
                            self.appDel.gotoTabbar()
                        }
                        else{
                            
                            self.appDel.gotoParent()
                            self.tabBarController?.selectedIndex = 2
                        }
                    }
                    else {
                        
                    }
                    
                      //gotoTabbar()
                       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoTabbar"), object: nil)
                       loggdenUser.removeObject(forKey: CARTCOUNT)
                       loggdenUser.removeObject(forKey: CARTVALUE)
                       self.activity.isHidden = true
                       self.activity.stopAnimating()
                       self.btnSubscribe.setTitle("Free to Subscribe", for: .normal)
                   }
                   else {
                       let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                       self.present(uiAlert, animated: true, completion: nil)
                       uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                           self.activity.isHidden = true
                           self.activity.stopAnimating()
                           self.btnSubscribe.setTitle("Free to Subscribe", for: .normal)
                       }))
                   }
           }
       }
    
    @IBAction func btnSubscribeAction(_ sender: UIButton) {
        PriceZire()
        return;
            if self.strMonthset == "Free" {
                PriceZire()
            }
            else {
                if priceCheck == "0" {
                     PriceZire()
                }
                else {
                    if self.subcategory_type == "maincategory" {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "IAPurchaceViewController")as! IAPurchaceViewController
                        obj.cat_id = cate_id
                        obj.TypeCate = self.subcategory_type
                        obj.arrCodeSKU = arrPriceCodeSKU
                        obj.arrPayment = arrPayment
                        self.navigationController?.pushViewController(obj, animated: false)
                    }
                    else {let obj = self.storyboard?.instantiateViewController(withIdentifier: "IAPurchaceViewController")as! IAPurchaceViewController
                        obj.cat_id = cate_id
                        obj.TypeCate = "subcategory"
                        obj.arrCodeSKU = arrPriceCodeSKU
                        obj.arrPayment = arrPayment
                        self.navigationController?.pushViewController(obj, animated: false)
                    }
                }
            }
       // }
    }
    
    @IBAction func btnAddtocartAction(_ sender: UIButton) {
        
        strNumber.makeAColl()
//        if btnAddCart.titleLabel?.text == "Goto Cart" {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "cartSummeryViewController")as! cartSummeryViewController
//            self.navigationController?.pushViewController(obj, animated: true)
//        }
//        else {
//            addCart.append(addcategory.init(id: self.add_category.value(forKey: "id") as! Int, title: self.add_category.value(forKey: "title") as! String, description: self.add_category.value(forKey: "description") as! String, image: self.add_category.value(forKey: "image") as! String, type: self.add_category.value(forKey: "type") as! String, month_labal: self.add_category.value(forKey: "month_labal") as! String, price: self.add_category.value(forKey: "price") as! String, month_list: self.add_category.value(forKey: "month_list") as! [String], photo300x300: self.add_category.value(forKey: "photo300x300") as! String))
//
//            encodeData.removeAll()
//            for i in 0..<addCart.count {
//                let jsonstring = addcategory.init(id: addCart[i].id, title: addCart[i].title, description: addCart[i].description, image: addCart[i].image, type: addCart[i].type, month_labal: addCart[i].month_labal, price: addCart[i].price, month_list: addCart[i].month_list, photo300x300: addCart[i].photo300x300)
//                let encoder = JSONEncoder()
//                if let data = try? encoder.encode(jsonstring) {
//                    encodeData.append(data)
//                    loggdenUser.set(encodeData, forKey: CARTVALUE)
//                }
//            }
//            if loggdenUser.value(forKey: CARTCOUNT) != nil {
//                let strCounter = loggdenUser.value(forKey: CARTCOUNT)as! String
//                DispatchQueue.main.async {
//                    self.badgeCount = Int(strCounter)!
//                    self.badgeCount += 1
//                    self.strCount = String(self.badgeCount)
//                    DispatchQueue.main.async {
//                        loggdenUser.set(self.strCount, forKey: CARTCOUNT)
//                    }
//                }
//            }
//            else {
//                badgeCount += 1
//                self.strCount = String(badgeCount)
//                DispatchQueue.main.async {
//                    loggdenUser.set(self.strCount, forKey: CARTCOUNT)
//                }
//            }
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "cartSummeryViewController")as! cartSummeryViewController
//            self.navigationController?.pushViewController(obj, animated: true)
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnCancelAction(_ sender: UIButton) {
        bottomConstraint.constant = -240
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CategoryDetailsController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblPlan {
            return arrPricecodeList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblPlan {
            let cell = tblPlan.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblplanCell
            let product = arrPricecodeList[indexPath.row]
            cell.lblTitle.text = (product as AnyObject).value(forKey: "name")as? String
            let price = (product as AnyObject).value(forKey: "price")as! String
            cell.lblPrice.text = rupee + price
            return cell
        }
        else {
            let cell = tblCatDetails.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblPlan {
            let product = arrPricecodeList[indexPath.row]
            let price = (product as AnyObject).value(forKey: "price")as! String
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "IAPurchaceViewController")as! IAPurchaceViewController
            obj.selectedPriceCode = price
           // obj.TypeCate = self.subcategory_type
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblPlan {
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            return webView
        }
        else {
            let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.wkWebViewHeight))
            webView.navigationDelegate = self
            webView.backgroundColor = UIColor.white
            webView.loadHTMLString(strLondescription, baseURL: nil)
            return webView
        }
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tblPlan {
            return 0
        }
        return self.wkWebViewHeight
    }
}


extension CategoryDetailsController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.scrollView.isScrollEnabled = false
        
        webView.documentHeight { (height) in
            self.wkWebViewHeight = height
            self.tblCatDetails.beginUpdates()
            self.tblCatDetails.endUpdates()
        }
    }
}





extension String {

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeAColl() {
        guard   isValid(regex: .phone),
                let url = URL(string: "tel://\(self.onlyDigits())"),
                UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

class tblplanCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
}
