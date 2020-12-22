//
//  cartSummeryViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//


import UIKit
import Alamofire


struct paymentCat: Codable {
    let day_type: String
    let maincaregory_id: String
    let price: String
    let type: String
    let subcategory_id: String
    
}

class cartSummeryViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblCoupons: UILabel!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var btnPaynow: UIButton!
    @IBOutlet weak var tblCartSummery: UITableView!
    @IBOutlet weak var lblGross: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var addCart = [addcategory]()
    var url:URL?
    var wc = Webservice.init()
    var strSelected = String()
    var decodedData = [Data]()
    var selected_id = Int()
    var index = IndexPath()
    var encodeData = [Data]()
    var GrossTotal = Int()
    var strPrice = [String]()
    var str_payment = String()
//    var serv = PGServerEnvironment()
//    var txnController = PGTransactionViewController()
    let prodArray = NSMutableArray()
    var mobile_no = String()
    var strPricePass = String()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    struct ChecksumData {
        var CALLBACK_URL: String
        var CHANNEL_ID: String
        var CHECKSUMHASH: String
        var CUST_ID: String
        var EMAIL: String
        var INDUSTRY_TYPE_ID: String
        var MID: String
        var MOBILE_NO: String
        var ORDER_ID: NSNumber
        var REQUEST_TYPE: String
        var TXN_AMOUNT: String
        var WEBSITE: String
    }

    struct passCart {
        var maincaregory_id: String
        var day_type: String
        var price: String
    }
    
    var arrpassCart = [passCart]()
    var arrChecksum = [ChecksumData]()
    var arrPriceData = NSMutableArray()
    var strdiscount_amount = String()
    var prod = NSMutableDictionary()
    var jsonString = String()
    var DiscountValue = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        if (loggdenUser.value(forKey: CARTVALUE) != nil) {
            decodedData = loggdenUser.value(forKey: CARTVALUE) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(addcategory.self, from: decodedData[i])
                addCart.append(decoded!)
                reloadData()
            }
        }
        else {
           
        }
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setDefault() {
        btnPaynow.layer.cornerRadius = 5
        btnPaynow.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(cartSummeryViewController.Discount), name: NSNotification.Name(rawValue: "Discount"), object: nil)
    }
    
    
    @objc func Discount(_ notification: NSNotification) {
        couponView.isHidden = false
        if let object = notification.object as? [String: Any] {
            if let sub_total = object["sub_total"] as? String {
               lblGross.text = rupee + sub_total
            }
            if let discount_amount = object["discount_amount"] as? String {
                strdiscount_amount = discount_amount
               lblDiscount.text = rupee + discount_amount
            }
            
            if let total_amount = object["total_amount"] as? String {
                lblTotal.text = rupee + total_amount
            }
            
            if let CouponCode = object["CouponCode"] as? String {
                lblCoupons.text = CouponCode
            }
        }
      }
    
    func PriceTransection() {
        activity.isHidden = false
        activity.startAnimating()
        btnPaynow.setTitle(" ", for: .normal)
        var arrPayment: [paymentCat] = []
        for product in addCart
        {
            let pCat = paymentCat(day_type: product.month_labal, maincaregory_id: "\(product.id)", price: product.price, type: "",subcategory_id:"")
            arrPayment.append(pCat)
        }
        print(arrPayment)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(arrPayment)
            jsonString = String(data: jsonData, encoding: .utf8)!
            print("JSON String : " + jsonString)
        }
        catch {
            print("jekil")
        }
        
        if strdiscount_amount.count == 0 {
            DiscountValue = 0
        }
        else {
            DiscountValue = Int(strdiscount_amount)!
        }
        
        let param = ["coupon_code":lblCoupons.text!,
                     "amount":GrossTotal,
                     "discount": DiscountValue,
                     "total_amount":GrossTotal,
                     "payment_txnid":"",
                     "payment_status":"",
                     "payment_response":"",
                     "cart_data":jsonString,
                     "type":"ios"] as [String : Any]
        
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
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.appDel.gotoTabbar()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoTabbar"), object: nil)
                        loggdenUser.removeObject(forKey: CARTCOUNT)
                        loggdenUser.removeObject(forKey: CARTVALUE)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnPaynow.setTitle("Submit", for: .normal)
                    }))
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnPaynow.setTitle("Submit", for: .normal)
                    }))
                }
        }
    }
    
    func NumberEdit(strNumber: String) {
        let parameters = ["name":"",
                          "school_name":" ",
                          "college_name":" ",
                          "phone_number":strNumber]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(PROFILE, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                let message = json.value(forKey: "message")as! String
                if sucess == true {
                    self.PriceTransection()
                    let data = json.value(forKey: "data")as! NSDictionary
                    if data.value(forKey: "phone_number")is NSNull {
                        print("jekil")
                    }
                    else {
                        let phone_number = data.value(forKey: "phone_number")as! String
                        loggdenUser.set(phone_number, forKey: PHONE_NUMBER)
                    }
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                }
        }
    }
    
   
    func AmountLinkMail() {
        if loggdenUser.value(forKey: PHONE_NUMBER) != nil {
            let strmob = loggdenUser.value(forKey: PHONE_NUMBER)as! String
            print(strmob)
            if strmob.count == 0 {
                let alertController = UIAlertController(title: "Bizzbrains", message: "Enter Mobile Number", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Enter Mobile Number"
                    textField.isSecureTextEntry = true
                    let firstTextField = alertController.textFields![0] as UITextField
                    let heightConstraint = NSLayoutConstraint(item: firstTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                    firstTextField.addConstraint(heightConstraint)
                }
                
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                    let currunt = alertController.textFields![0]
                    self.NumberEdit(strNumber: currunt.text!)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                PriceTransection()
            }
        }
        else {
            let alertController = UIAlertController(title: "Bizzbrains", message: "Enter Mobile Number", preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Mobile Number"
                textField.isSecureTextEntry = true
                let firstTextField = alertController.textFields![0] as UITextField
                let heightConstraint = NSLayoutConstraint(item: firstTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                firstTextField.addConstraint(heightConstraint)
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let currunt = alertController.textFields![0]
                self.NumberEdit(strNumber: currunt.text!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func PriceZire() {
        activity.isHidden = false
        activity.startAnimating()
        btnPaynow.setTitle(" ", for: .normal)
        var arrPayment: [paymentCat] = []
        for product in addCart
        {
            let pCat = paymentCat(day_type: product.month_labal, maincaregory_id: "\(product.id)", price: product.price,type:"",subcategory_id:"")
            arrPayment.append(pCat)
        }
        print(arrPayment)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(arrPayment)
            jsonString = String(data: jsonData, encoding: .utf8)!
            print("JSON String : " + jsonString)
        }
        catch {
            print("jekil")
        }
        let param = ["coupon_code":lblCoupons.text!,
                     "amount":GrossTotal,
                     "discount": 0,
                     "total_amount":GrossTotal,
                     "payment_txnid":"",
                     "payment_status":"",
                     "payment_response":"",
                     "cart_data":jsonString,
                     "type":""] as [String : Any]
        
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
                    self.appDel.gotoTabbar()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotoTabbar"), object: nil)
                    loggdenUser.removeObject(forKey: CARTCOUNT)
                    loggdenUser.removeObject(forKey: CARTVALUE)
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.btnPaynow.setTitle("Submit", for: .normal)
                }
                else {
                    let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnPaynow.setTitle("Submit", for: .normal)
                    }))
                }
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        loggdenUser.removeObject(forKey: CARTVALUE)
        for i in 0..<self.addCart.count {
        let jsonstring = addcategory.init(id: self.addCart[i].id, title: self.addCart[i].title, description: self.addCart[i].description, image: self.addCart[i].image, type: self.addCart[i].type, month_labal: self.addCart[i].month_labal, price: self.addCart[i].price, month_list: self.addCart[i].month_list, photo300x300: self.addCart[i].photo300x300)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(jsonstring) {
            self.encodeData.append(data)
            loggdenUser.set(self.encodeData, forKey: CARTVALUE)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartValueRemove"), object: addCart.count)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnPaynowAction(_ sender: UIButton) {
        if lblTotal.text == rupee + "0" {
            PriceZire()
        }
        else {
            AmountLinkMail()
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        couponView.isHidden = true
        lblGross.text = rupee + String(GrossTotal)
        lblTotal.text = rupee + String(GrossTotal)
        lblDiscount.text = rupee + "0"
        strdiscount_amount = " "
    }
    
    @IBAction func btnCouponsAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CouponslistViewController")as! CouponslistViewController
        obj.sub_total = String(GrossTotal)
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

extension cartSummeryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = addCart[indexPath.row]
        let cell = tblCartSummery.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblCartsummeryCell
        cell.lblTitle.text = data.title
        let rupee = "\u{20B9}"
        let month = data.month_labal
        let price = data.price
        cell.lblPriceFor.text = rupee + " " + String(price) + " for " + month
        let strImage = data.photo300x300
        url = URL(string: strImage)
        cell.img.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
        cell.img.layer.cornerRadius = 5
        cell.img.clipsToBounds = true
        cell.lblPrice.text = rupee + String(data.price)
        cell.viewSelect.isHidden = true
        cell.btnDelete.addTarget(self, action: #selector(cartSummeryViewController.btnDeleteAction), for: UIControl.Event.touchUpInside)
        let monthlist = data.month_list
        if monthlist.count == 0 {
            cell.viewSelect.isHidden = true
        }
        else {
            let strmonth = month.replacingOccurrences(of: "for", with: "")
            cell.lblSelectedValue.text = strmonth
            cell.viewSelect.isHidden = false
            cell.viewSelect.layer.borderWidth = 0.5
            cell.viewSelect.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewSelect.layer.cornerRadius = 5
            cell.viewSelect.clipsToBounds = true
            cell.btnDropdown.addTarget(self, action: #selector(cartSummeryViewController.btnDropdownAction), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let strprice = addCart[indexPath.row].price
        let Priceing = Int(strprice)
        GrossTotal = GrossTotal + Priceing!
        lblGross.text = rupee + String(GrossTotal)
        lblTotal.text = rupee + String(GrossTotal)
        lblDiscount.text = rupee + "0"
        couponView.isHidden = true
    }
    
    func reloadData(){
        tblCartSummery.reloadData()
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(row: self.addCart.count - 1, section: 0)
            self.tblCartSummery.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func btnDropdownAction(_ sender: UIButton) {
        if let indexPath = self.tblCartSummery.indexPathForView(sender) {
            index = indexPath
            let monthlist = addCart[indexPath.row].month_list
            selected_id = addCart[indexPath.row].id
            let alert = UIAlertController(title: "Bizzbrains", message: "Choose any one month", preferredStyle: .actionSheet)
            for i in monthlist {
                alert.addAction(UIAlertAction(title: i, style: .default, handler: doSomething))
            }
            let dismiss = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func doSomething(action: UIAlertAction) {
        strSelected = action.title!
        let parem = ["maincategory_id": selected_id,
                     "days":strSelected] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        wc.callSimplewebservice(url: CARTSUMMARY, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: monthPriceresponsModel?) in
            if sucess {
                let data = response?.data
                let price = data?.price
                self.addCart = self.addCart.map{
                    var mutableBook = $0
                    if $0.id == self.selected_id {
                        mutableBook.month_labal = self.strSelected
                        mutableBook.price = price!
                        print(mutableBook)
                        self.reloadData()
                        self.GrossTotal = 0
                    }
                    return mutableBook
                }
            }
        }
    }
    
    @objc func btnDeleteAction(_ sender: UIButton) {
        if let indexPath = self.tblCartSummery.indexPathForView(sender) {
            self.addCart.remove(at: indexPath.row)
            self.tblCartSummery.deleteRows(at: [indexPath], with: .fade)
            self.tblCartSummery.reloadData()
            self.GrossTotal = 0
        }
    }
}


extension CGFloat{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)//
    }
}


//func genrate_Checksum() {
//
//    if (loggdenUser.value(forKey: PHONE_NUMBER) != nil) {
//        mobile_no = loggdenUser.value(forKey: PHONE_NUMBER)as! String
//    }
//    else {
//        mobile_no = "7494887484"
//    }
//
//    let token = loggdenUser.value(forKey: TOKEN)as! String
//    let email = loggdenUser.value(forKey: EMAIL)as! String
//    strPricePass = String(GrossTotal)
//    let headers: HTTPHeaders = ["Xapi": Xapi,
//                                "Authorization":token]
//    let ID = generateCustomerID()
//
//    let FinalTotal = "\(GrossTotal)"
//
//    let param = ["cust_id":ID,
//                 "mobile_no":mobile_no,
//                 "email":email,
//                 "txn_amount": FinalTotal] as [String : Any]
//
//    AF.request(GENERATE_CHECKSUM, method: .post, parameters: param, encoding: JSONEncoding.default,headers: headers)
//        .responseJSON { response in
//            print(response)
//
//            let json = response.value as! NSDictionary
//            self.arrChecksum = [ChecksumData.init(CALLBACK_URL: json.value(forKey: "CALLBACK_URL") as! String, CHANNEL_ID: json.value(forKey: "CHANNEL_ID") as! String, CHECKSUMHASH: json.value(forKey: "CHECKSUMHASH") as! String, CUST_ID: json.value(forKey: "CUST_ID") as! String, EMAIL: json.value(forKey: "EMAIL") as! String, INDUSTRY_TYPE_ID: json.value(forKey: "INDUSTRY_TYPE_ID") as! String, MID: json.value(forKey: "MID") as! String, MOBILE_NO: json.value(forKey: "MOBILE_NO") as! String, ORDER_ID: json.value(forKey: "ORDER_ID") as! NSNumber, REQUEST_TYPE: json.value(forKey: "REQUEST_TYPE") as! String, TXN_AMOUNT: json.value(forKey: "TXN_AMOUNT") as! String, WEBSITE: json.value(forKey: "WEBSITE") as! String)]
//            print(self.arrChecksum)
//            self.beginPayment()
//    }
//}


//func beginPayment() {
//    serv = serv.createProductionEnvironment()
//    let type :ServerType = .eServerTypeProduction
//    let orderID = arrChecksum[0].ORDER_ID.stringValue
//
//    let order = PGOrder(orderID: orderID, customerID: arrChecksum[0].CUST_ID, amount: arrChecksum[0].TXN_AMOUNT, eMail: arrChecksum[0].EMAIL, mobile: arrChecksum[0].MOBILE_NO)
//    print(order)
//    order.params = ["MID": arrChecksum[0].MID,
//                    "ORDER_ID": arrChecksum[0].ORDER_ID.stringValue,
//                    "CUST_ID": arrChecksum[0].CUST_ID,
//                    "MOBILE_NO": arrChecksum[0].MOBILE_NO,
//                    "EMAIL": arrChecksum[0].EMAIL,
//                    "CHANNEL_ID": arrChecksum[0].CHANNEL_ID,
//                    "WEBSITE": arrChecksum[0].WEBSITE,
//                    "TXN_AMOUNT": arrChecksum[0].TXN_AMOUNT,
//                    "INDUSTRY_TYPE_ID": arrChecksum[0].INDUSTRY_TYPE_ID,
//                    "CHECKSUMHASH":arrChecksum[0].CHECKSUMHASH,
//                    "CALLBACK_URL":arrChecksum[0].CALLBACK_URL,
//                    "REQUEST_TYPE":arrChecksum[0].REQUEST_TYPE]
//
//    print(order.params)
//    let merchantConfig = PGMerchantConfiguration.defaultConfiguration()
//    merchantConfig.merchantID = arrChecksum[0].MID
//    merchantConfig.industryID = arrChecksum[0].INDUSTRY_TYPE_ID
//    merchantConfig.website = arrChecksum[0].WEBSITE
//    merchantConfig.channelID = arrChecksum[0].CHANNEL_ID
//    merchantConfig.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
//    merchantConfig.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
//
//    txnController =  txnController.initTransaction(for: order) as! PGTransactionViewController
//    txnController.title = "Paytm Payments"
//    txnController.setLoggingEnabled(true)
//    if(type != ServerType.eServerTypeNone) {
//        txnController.serverType = type;
//    } else {
//        return
//    }
//    txnController.merchant = merchantConfig
//    txnController.delegate = self
//    navigationController?.isNavigationBarHidden = false
//    navigationController?.pushViewController(txnController, animated: true)
//}


//this function triggers when transaction gets finished
//func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
//    navigationController?.navigationBar.isHidden = true
//    let msg : String = responseString
//    print(msg)
//    str_payment = responseString
//    var titlemsg : String = ""
//    if let data = responseString.data(using: String.Encoding.utf8) {
//        do {
//            if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] , jsonresponse.count > 0{
//                titlemsg = jsonresponse["STATUS"] as? String ?? ""
//                if titlemsg == "TXN_SUCCESS" {
//                    let payment_txnid = jsonresponse["TXNID"]as! String
//                    PriceTransection(strStatus: titlemsg, strTXNID: payment_txnid, strJson: msg)
//                }
//            }
//        } catch {
//            print("Something went wrong")
//        }
//    }
//    controller.navigationController?.popViewController(animated: true)
//    //        let actionSheetController: UIAlertController = UIAlertController(title: titlemsg , message: msg, preferredStyle: .alert)
//    //        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
//    //            action -> Void in
//    //
//    //        }
//    //        actionSheetController.addAction(cancelAction)
//    //        self.present(actionSheetController, animated: true, completion: nil)
//}
////this function triggers when transaction gets cancelled
//func didCancelTrasaction(_ controller : PGTransactionViewController) {
//    controller.navigationController?.popViewController(animated: true)
//    navigationController?.navigationBar.isHidden = true
//}
////Called when a required parameter is missing.
//func errorMisssingParameter(_ controller : PGTransactionViewController, error : NSError?) {
//    controller.navigationController?.popViewController(animated: true)
//    navigationController?.navigationBar.isHidden = true
//}
//
