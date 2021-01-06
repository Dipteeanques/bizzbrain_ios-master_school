//
//  OlderMeetingsVC.swift
//  bizzbrains
//
//  Created by Anques on 30/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SJSegmentedScrollView

class OlderMeetingsVC: UIViewController {

    var wc = Webservice.init()
    var arrOlderMeeting : UpcomingMeetingData?
    let segmentController = SJSegmentedViewController()
    var arrFilter = [String]()
    var arrDateType = [String]()
    var arrDateType1 = [String]()
    var arrTitle = [String]()
    var arrTime = [String]()
    var arrUrl = [String]()
    var arrSummary = [String]()
    
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var tblMeetings: UITableView!
    
    @IBOutlet weak var btn_Filter: UIButton!{
        didSet{
            btn_Filter.layer.cornerRadius = 5.0
            btn_Filter.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tblFilter: UITableView!
    @IBOutlet weak var tblFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var transparentview: UIView!{
        didSet{
            transparentview.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        }
    }
    
    
    @IBOutlet weak var viewFilter: UIView!{
        didSet{
            viewFilter.layer.cornerRadius = 5.0
            viewFilter.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblMeetings.rowHeight = UITableView.automaticDimension
        tblMeetings.estimatedRowHeight = 100

        arrFilter.append("View All")
        
        self.Getupcomingmeeting()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblFilterHeight?.constant = self.tblFilter.contentSize.height
    }
    
    @IBAction func btnHideView(_ sender: Any) {
        transparentview.isHidden = true
    }
    @IBAction func btn_filter_Action(_ sender: Any) {
        tblFilter.reloadData()
        transparentview.isHidden = false
    }
    
    func Getupcomingmeeting() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        print(token)
        
        wc.callSimplewebservice(url: getOlderMeeting, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response:UpcomingMeetingRoot?) in
            if success {
//                print("response:",response)
                let suc = response?.success
                if suc == true {
                    self.arrOlderMeeting = response!.data
                    self.arrDateType.removeAll()
                    self.arrDateType1.removeAll()
                    self.arrTime.removeAll()
                    self.arrTitle.removeAll()
                    self.arrUrl.removeAll()
                    self.arrSummary.removeAll()
                    for i in (0..<(self.arrOlderMeeting?.data.count ?? 0))
                    {
 
                        if self.arrFilter.contains((self.arrOlderMeeting?.data[i].date_type ?? "")) {
                            print("yes")
                        }
                        else{
                            self.arrFilter.append(self.arrOlderMeeting?.data[i].date_type ?? "")
                        }
                        self.arrDateType1.append(self.arrOlderMeeting?.data[i].date_type ?? "")
                        self.arrDateType.append(self.arrOlderMeeting?.data[i].date_type ?? "")
                        self.arrTitle.append(self.arrOlderMeeting?.data[i].title ?? "")
                        self.arrTime.append(self.arrOlderMeeting?.data[i].date_time ?? "")
                        self.arrUrl.append(self.arrOlderMeeting?.data[i].url ?? "")
                        self.arrSummary.append(self.arrOlderMeeting?.data[i].summary ?? "")
                        
                    }
                    if self.arrOlderMeeting?.data.count ?? 0 >= 8{
                        self.tblFilterHeight?.constant = 340
                    }
                    else{
                        self.tblFilterHeight?.constant = 180
                    }
                    self.tblMeetings.reloadData()
                }
                else {
                    print("jekil")
                }
            }
            else{
                self.tblMeetings.isHidden = true
                self.lbl_info.isHidden = false
            }
        }
    }

}

extension OlderMeetingsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblFilter{
            return arrFilter.count
        }
        else{
            return arrDateType.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MeteetingCell
        if tableView == tblMeetings{
            cell.lblDateOlder.text = arrDateType[indexPath.row]//arrUpcomingMeeting?.data[indexPath.row].date_type
            cell.lblTitleOlder.text = arrTitle[indexPath.row]//arrUpcomingMeeting?.data[indexPath.row].title
            cell.lblTimeOlder.text = arrTime[indexPath.row]//arrUpcomingMeeting?.data[indexPath.row].date_time
            cell.lblUrlOlder.text = arrUrl[indexPath.row]//arrUpcomingMeeting?.data[indexPath.row].url
            cell.lblSummaryOlder.text = arrSummary[indexPath.row]//arrUpcomingMeeting?.data[indexPath.row].summary
            
            cell.btnStartOlder.tag = indexPath.row
            cell.btnStartOlder.addTarget(self, action: #selector(startAction(sender:)), for: .allTouchEvents)
        }
        else{
            cell.lbl_filtertitleOlder.text = arrFilter[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblFilter{
            
            
            let filter1 = arrFilter[indexPath.row]
            print("filter:",filter1)
            print(arrDateType)
            let indexArray = arrDateType1.indices.filter { arrDateType1[$0].localizedCaseInsensitiveContains(filter1) }
            
            print("subarray:",indexArray)
            
            if indexPath.row == 0{
                Getupcomingmeeting()
                transparentview.isHidden = true
            }
            else{
                arrDateType.removeAll()
                arrTime.removeAll()
                arrTitle.removeAll()
                arrUrl.removeAll()
                arrSummary.removeAll()
                for i in  (0..<(indexArray.count )) {
                    let ival = indexArray[i]
                    self.arrDateType.append(self.arrOlderMeeting?.data[ival].date_type ?? "")
                    self.arrTitle.append(self.arrOlderMeeting?.data[ival].title ?? "")
                    self.arrTime.append(self.arrOlderMeeting?.data[ival].date_time ?? "")
                    self.arrUrl.append(self.arrOlderMeeting?.data[ival].url ?? "")
                    self.arrSummary.append(self.arrOlderMeeting?.data[ival].summary ?? "")
                    
                }
                transparentview.isHidden = true
                tblMeetings.reloadData()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func startAction(sender: UIButton)  {
        if let url = URL(string: arrUrl[sender.tag]) {//arrUpcomingMeeting?.data[sender.tag].url ?? ""
            UIApplication.shared.open(url)
        }
    }
    
}
