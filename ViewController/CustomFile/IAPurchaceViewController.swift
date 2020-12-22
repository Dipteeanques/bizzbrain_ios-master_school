//
//  IAPurchaceViewController.swift
//  IAPDemo
//
//  Created by Gabriel Theodoropoulos on 5/25/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire

protocol IAPurchaceViewControllerDelegate {
    
    func didBuyColorsCollection(collectionIndex: Int)
    
}

struct arrPlan {
    let title: String
    let description: String
    let price: String
}


class IAPurchaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tblProducts: UITableView!
    
    var delegate: IAPurchaceViewControllerDelegate!
    
//    let productIdentifiers = Set([
//    "79",
//    "159",
//    "249",
//    "299",
//    "399",
//    "499",
//    "549",
//    "599",
//    "699",
//    "799",
//    "849",
//    "899",
//    "999",
//    "1099",
//    "1199",
//    "1249",
//    "1299",
//    "1399",
//    "1499",
//    "1599",
//    "1649",
//    "1699",
//    "1799",
//    "1899",
//    "1949",
//    "1999"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var selectedProductIndex: Int!
    var transactionInProgress = false
    var alert = UIAlertController()
    
    var arrPricecodeList = NSArray()
    var cat_id = Int()
    var TypeCate = String()
    var selectedPriceCode = String()
    var arrCodeSKU = [String]()
    
    var arrAllPlane = [arrPlan]()
    var arrPayment: [paymentCat] = []
    var jsonString = String()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        Getplan()
        tblProducts.delegate = self
        tblProducts.dataSource = self
        requestProductInfo()
        SKPaymentQueue.default().add(self)
    }
    
    func Getplan() {
        let parem = ["id": cat_id,
                     "type":TypeCate] as [String : Any]
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
                for i in 0..<self.arrPricecodeList.count {
                    let title = (self.arrPricecodeList[i] as AnyObject).value(forKey: "name")as! String
                    let price = (self.arrPricecodeList[i] as AnyObject).value(forKey: "price")as! String
                    if title == "1 Month" {
                        self.arrAllPlane.append(arrPlan.init(title: title, description: "30 Day Subscribe", price: price))
                    }
                    else if title == "6 Month" {
                        self.arrAllPlane.append(arrPlan.init(title: title, description: "180 Day Subscribe", price: price))
                    }
                    else {
                        self.arrAllPlane.append(arrPlan.init(title: title, description: "365 Day Subscribe", price: price))
                        }
                    self.tblProducts.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    }
            }
            else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.tabBar.isHidden = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.tabBarController?.tabBar.isHidden = false
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

   // GET_PRICE_CATEGORY
    
    // MARK: IBAction method implementation
    
    @IBAction func dismiss(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: UITableView method implementation
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellProduct", for: indexPath as IndexPath)as! planCell
        let product = arrAllPlane[indexPath.row]
        cell.lblTitle.text = product.title
        let price = product.price
        cell.lblPrice.text = rupee + price
        cell.lblDescription.text = product.description
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return productsArray.count
       // return arrPricecodeList.count
        return arrAllPlane.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProductIndex = indexPath.row
        showActions()
        tableView.cellForRow(at: indexPath as IndexPath)?.isSelected = false
    }
    
    
    // MARK: Custom method implementation
    
    func requestProductInfo() {
        let strSKU = arrCodeSKU.joined(separator: ",")
        let productIdentifiers = Set([strSKU])
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func dismissAlert(){
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func PopUpLoader() {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Bizzbrains", message: "What do you want to do?", preferredStyle: UIAlertController.Style.actionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertAction.Style.default) { (action) -> Void in
            self.PopUpLoader()
            
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex])
            print(payment)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) -> Void in
            self.dismissAlert()
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // MARK: SKProductsRequestDelegate method implementation
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response)
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
                DispatchQueue.main.async {
                    self.tblProducts.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func TransectionSucess(strstatus: String,strTxtid: String,strJson: String) {
        let jsonEncoder = JSONEncoder()
                  do {
                      let jsonData = try jsonEncoder.encode(arrPayment)
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
                              //self.btnSubscribe.setTitle("Subscribe", for: .normal)
                          }
                          else {
                              let uiAlert = UIAlertController(title: "Bizzbrains", message: message, preferredStyle: UIAlertController.Style.alert)
                              self.present(uiAlert, animated: true, completion: nil)
                              uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                  self.activity.isHidden = true
                                  self.activity.stopAnimating()
                                //  self.btnSubscribe.setTitle("Subscribe", for: .normal)
                              }))
                          }
                  }
    }
    
  //  [productId: 549, transactionId: 1000000585837535, state: purchased, date: Optional(2019-10-30 07:17:28 +0000)]
    
    // MARK: SKPaymentTransactionObserver method implementation
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(transactions)
        for transaction in transactions {
               switch transaction.transactionState {
               case SKPaymentTransactionState.purchased:
                   print("Transaction completed successfully.")
                   SKPaymentQueue.default().finishTransaction(transaction)
                   transactionInProgress = false
                   dismissAlert()
                  // TransectionSucess(strstatus: SKPaymentTransactionState.purchased, strTxtid: transaction.t, strJson: <#T##String#>)
                   self.navigationController?.popViewController(animated: true)
                  // delegate.didBuyColorsCollection(collectionIndex: selectedProductIndex)
                   
               case SKPaymentTransactionState.failed:
                   print("Transaction Failed");
                   SKPaymentQueue.default().finishTransaction(transaction)
                   transactionInProgress = false
                   dismissAlert()
                   
               default:
                   print(transaction.transactionState.rawValue)
               }
           }
       }
}


class planCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}


extension SKProduct {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }

}
