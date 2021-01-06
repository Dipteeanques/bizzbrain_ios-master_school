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
import Firebase
import FirebaseCore


class ConverstationsVC: UIViewController {

    var wc = Webservice.init()
    var arrTeacherListData : TeacherListRoot?
    var conversationList = [String:String]()
    var arrConversationList = [[String:String]]()
    var filteredTeacherListData : [TeacherListData]?
    
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
        

        searchBar.delegate = self
//        self.navigationController?.isNavigationBarHidden = true
        actionButton.buttonColor = .red
        actionButton.addItem(title: "Heart", image: UIImage(named: "plus")) { item in
            self.transperentView.isHidden = false
        }
        actionButton.display(inViewController: self)
        
        GetTeacherList()
        getConversationsList()
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Show the navigation bar on other view controllers
//        self.navigationController?.isNavigationBarHidden = true
//    }
        
    func getConversationsList(){
        
        let  ref: DatabaseReference?
        let handle: DatabaseHandle?
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        ref = Database.database().reference()

        let firebaseId = loggdenUser.value(forKey:SENDER_ID)
        print(firebaseId)

       let handle1 = ref?.child("Inbox").child(firebaseId as! String).observe(.childAdded, with: { (snapshot) in
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

            print("snapshot:",snapshot.value)
            if  let data        = snapshot.value as? [String: Any]
            {
//                print("snapshotdata:",data)
                let chatdata = data as? [String:String]
                print("date:",chatdata)
                print(chatdata?["date"])
                self.conversationList = ["date":(chatdata?["date"] ?? ""), "msg":(chatdata?["msg"] ?? ""), "name":(chatdata?["name"] ?? ""), "rid":(chatdata?["rid"] ?? ""), "status":(chatdata?["status"] ?? ""), "timestamp":(chatdata?["timestamp"] ?? "")]
                self.arrConversationList.append(self.conversationList)
                self.tblConversations.reloadData()
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
        })
        
        
        
        
        
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
        }

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
                    self.filteredTeacherListData = self.arrTeacherListData?.data
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
            return self.filteredTeacherListData?.count ?? 0
        }
        else{
            return self.arrConversationList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationsCell
        if tableView == self.tblTeacher{
            cell.lblName.text = self.filteredTeacherListData?[indexPath.row].name
        }
        else{
            print(self.conversationList)
//            cell.lblTimeInfo.text = "test"//self.conversationList["timestamp"]
            cell.lblTimeInfo.isHidden = true
            cell.lblUserName.text = self.arrConversationList[indexPath.row]["name"]//self.conversationList["name"]
            cell.lblType.text = self.arrConversationList[indexPath.row]["msg"]//self.conversationList["msg"]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblTeacher{
            let loadVC = ChatVC()
            loggdenUser.setValue(self.filteredTeacherListData?[indexPath.row].firebase_id, forKey: RECIEVER_ID)
            loadVC.strChatId = ((loggdenUser.value(forKey:SENDER_ID) as! String) + "-" + (self.filteredTeacherListData?[indexPath.row].firebase_id)!)
            loadVC.userName = self.filteredTeacherListData?[indexPath.row].name ?? ""
            navigationController?.pushViewController(loadVC, animated: false)
        }
        else{
            let loadVC = ChatVC()
            loggdenUser.setValue(self.arrConversationList[indexPath.row]["rid"], forKey: RECIEVER_ID)
            loadVC.strChatId = ((loggdenUser.value(forKey:SENDER_ID) as! String) + "-" + (self.arrConversationList[indexPath.row]["rid"]!))
            loadVC.userName = self.arrConversationList[indexPath.row]["name"] ?? ""
            navigationController?.pushViewController(loadVC, animated: false)
//            let loadVC = ChatVC()
//            loadVC.strChatId = ((loggdenUser.value(forKey:SENDER_ID) as! String) + "-t6TyVEi4rbOQjsgoBVd77JrIoOu2")
//            loggdenUser.setValue("t6TyVEi4rbOQjsgoBVd77JrIoOu2", forKey: RECIEVER_ID)
//            loadVC.userName = self.conversationList["name"] ?? ""
//            navigationController?.pushViewController(loadVC, animated: false)
        }
    }
    
    func returnMsgTime(){
        var dateParse = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "fr_FR")

        let dateString = dateFormatter.string(from: Date())
        let dateNSDate = dateFormatter.date(from: dateParse) //date = "14:05"
        let currentDate = dateFormatter.date(from: dateString)
        let timeInterval = currentDate?.timeIntervalSince(dateNSDate!)
        
//        print(String((seconds / 86400)) + " days")
//        print(String((seconds % 86400) / 3600) + " hours")
//        print(String((seconds % 3600) / 60) + " minutes")
//        print(String((seconds % 3600) % 60) + " seconds")
    }
    
}

extension ConverstationsVC: UISearchBarDelegate{
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty  else { filteredTeacherListData = arrTeacherListData?.data
            tblTeacher.reloadData(); return }
        
        filteredTeacherListData = arrTeacherListData?.data.filter({ user -> Bool in
            return user.name.lowercased().contains(searchText.lowercased())
        })
        tblTeacher.reloadData()
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
