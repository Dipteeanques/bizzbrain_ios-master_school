//
//  TermsSupporPrivacyController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class TermsSupporPrivacyController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var wc = Webservice.init()
    var Common = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoader.isHidden = false
        activity.startAnimating()
        
        getLink()
        webView.navigationDelegate = self
        if Common == "privacy-policy" {
            lblTitle.text = "Privacy Policy"
        }
        else if Common == "terms" {
            lblTitle.text = "Terms and Condition"
        }else {
            lblTitle.text = "Support"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getLink() {
        let parameters = ["slug":Common]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                               "Authorization":token]
        wc.callSimplewebservice(url: PAGESLINK, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: Htmlresponsmodel?) in
            if sucess {
                let data = response?.data
                let strHtml = data?.content
                self.webView.loadHTMLString(strHtml!, baseURL: Bundle.main.bundleURL)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finish to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewLoader.isHidden = true
        activity.stopAnimating()
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
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
