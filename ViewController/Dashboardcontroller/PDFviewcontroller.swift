//
//  PDFviewcontroller.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit

class PDFviewcontroller: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var webview: WKWebView!
    var url: URL?
    var loadCount = 0
    var strTitle = String()
    var strPdf = String()
    
    @IBOutlet weak var img_display: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setDefault() {
        loaderView.isHidden = false
        activity.startAnimating()
        url = URL(string: strPdf)
        if url?.pathExtension == "pdf" {
            let urlRequest = URLRequest(url:url!)
            webview.load(urlRequest)
            webview.navigationDelegate = self
        }
        else if url?.pathExtension == "jpeg" || url?.pathExtension == "png" || url?.pathExtension == "jpg" {
            loaderView.isHidden = true
            webview.isHidden = true
            img_display.isHidden = false
            img_display.sd_setImage(with: url, completed: nil)
        }
        else {
            loaderView.isHidden = true
            activity.stopAnimating()
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Can not open file?", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
        }
        scrollDown()
        lblTitleName.text = strTitle
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadCount += 1
        print(loadCount)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderView.isHidden = true
        activity.stopAnimating()
        loadCount -= 1
        print(loadCount)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if (self.loadCount == 0) {
                // self.stopLoading()
            }
        }
    }
    
    func scrollDown() {
        let scrollView = webview.scrollView
        let contentSize = scrollView.contentSize
        let contentOffset = scrollView.contentOffset
        let frameSize = webview.frame.size
        let frameHeight = frameSize.height
        
        // Next view's height
        let heightOffset = frameSize.height + contentOffset.y
        let offsetToBottom = contentSize.height - frameSize.height
        
        if contentOffset.y + frameHeight > contentSize.height - frameHeight {
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetToBottom), animated: true)
            print("Should be scrolling to bottom")
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: heightOffset), animated: true)
            print("Should be scrolling by one page")
        }
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

extension URL    {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
