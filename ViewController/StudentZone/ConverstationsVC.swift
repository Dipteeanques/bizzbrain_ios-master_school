//
//  ConverstationsVC.swift
//  bizzbrains
//
//  Created by Anques on 24/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import Alamofire

class ConverstationsVC: UIViewController {

    var wc = Webservice.init()
    var arrTeacherListData : TeacherListRoot?

    @IBOutlet weak var transperentView: UIView!{
        didSet{
            transperentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var tblConversations: UITableView!
    
    //MARK: select Teacher
    @IBOutlet weak var viewSub: UIView!{
        didSet{
            viewSub.layer.cornerRadius = 2.0
            viewSub.clipsToBounds = true
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblTeacher: UITableView!
    
    
    let actionButton = JJFloatingActionButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.buttonColor = .red
        actionButton.addItem(title: "Heart", image: UIImage(named: "plus")) { item in
            self.transperentView.isHidden = false
        }
        actionButton.display(inViewController: self)
        
        GetTeacherList()
    }
        
    func getConversationsList(){
        
    }
    
    @IBAction func btnHideTransperentView(_ sender: Any) {
        transperentView.isHidden = true
    }
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetTeacherList() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
       
        wc.callSimplewebservice(url: getTeacherList, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response:TeacherListRoot?) in
            if success {
                print("response:",response)
                let suc = response?.success
                if suc == true {
                    self.arrTeacherListData = response!
                    self.tblTeacher.reloadData()
                }
                else {
                    print("jekil")
                }
            }
            else{

            }
        }
    }
}


extension ConverstationsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblTeacher {
            return self.arrTeacherListData?.data.count ?? 0
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationsCell
        if tableView == self.tblTeacher{
            cell.lblName.text = self.arrTeacherListData?.data[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblTeacher{
            let loadVC = ChatVC()
            navigationController?.pushViewController(loadVC, animated: false)
        }
    }
    
    
}


