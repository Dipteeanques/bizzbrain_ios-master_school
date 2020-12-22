//
//  DocumentlistViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class DocumentlistViewController: UIViewController {

    @IBOutlet weak var foundView: UIView!
    @IBOutlet weak var tblDocumentlist: UITableView!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblTitleName: UILabel!
    
    var wc = Webservice.init()
    var arrDocList = [DatumDocument]()
    var arrTestList = [testModelset]()
    var url: URL?
    var subcategory_id = Int()
    var strnavi = String()
    var strTitle = String()
    var topic_id = Int()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var testSelected = String()
    var videoSet = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

         getDocumentlist(strpage: "1")
                   pageCount = 1
        lblNavi.text = strnavi
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
        
    
    func getDocumentlist(strpage: String) {
        let parem = ["subcategory_id": subcategory_id,
                     "topic_id":topic_id,
                     "page":strpage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        
            wc.callSimplewebservice(url: DOCUMENT, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: DocListResponsModel?) in
                if sucess {
                    let sucessMy = response?.success
                    if sucessMy! {
                        let data = response?.data
                        let arr_dict = data?.data
                        for i in 0..<arr_dict!.count
                        {
                            self.arrDocList.append(arr_dict![i])
                            self.tblDocumentlist.reloadData()
                            self.spinner.stopAnimating()
                            self.tblDocumentlist.tableFooterView?.isHidden = true
                            if self.arrDocList.count == 0 {
                                self.foundView.isHidden = false
                            }
                            else {
                                self.foundView.isHidden = true
                            }
                        }
                    }
                    else {
                        if self.arrDocList.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                if self.arrDocList.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
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

extension DocumentlistViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrDocList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = arrDocList[indexPath.row]
        let cell = tblDocumentlist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblDocumentlistCell
        cell.Document = document
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document = arrDocList[indexPath.row]
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PDFviewcontroller")as! PDFviewcontroller
        obj.strTitle = document.title
        obj.strPdf = document.pdf 
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblDocumentlist {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblDocumentlist.bounds.width, height: CGFloat(44))
                pageCount += 1
                getDocumentlist(strpage: "\(pageCount)")
                self.tblDocumentlist.tableFooterView = spinner
                self.tblDocumentlist.tableFooterView?.isHidden = false
            }
        }
    }
}
