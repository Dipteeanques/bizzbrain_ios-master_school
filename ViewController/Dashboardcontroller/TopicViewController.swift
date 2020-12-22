//
//  TopicViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 16/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class TopicViewController: UIViewController {

    @IBOutlet weak var tblTopic: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblTitleName: UILabel!
    
    var wc = Webservice.init()
    var arrTopic = [topicModel]()
    var subcategory_id = Int()
    var strnavi = String()
    var strimage = String()
    var strTitle = String()
    var url: URL?
    
    
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
        lblTitleName.text = strTitle
        lblNavi.text = strnavi
        url = URL(string: strimage)
        imgProfile.sd_setImage(with: url, completed: nil)
        imgProfile.layer.cornerRadius = 5
        imgProfile.clipsToBounds = true
        getTopic()
    }
    
    func getTopic() {
        let parem = ["subcategory_id": subcategory_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                               "Authorization":token]
        wc.callSimplewebservice(url: TOPIC, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: topicResponseModel?) in
            if sucess{
                self.arrTopic = response!.data
                self.tblTopic.reloadData()
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

extension TopicViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = arrTopic[indexPath.row]
        let cell = tblTopic.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblTopicCell
        cell.lblTitle.text = topic.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = arrTopic[indexPath.row]
        let id = selected.id
        let title = selected.title
        let subcat_id = selected.subcategory_id
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SelectedTypeViewController")as! SelectedTypeViewController
        obj.topic_id = id
        obj.strnavi = lblNavi.text! + " >> " + title
        obj.strimage = strimage
        obj.strTitle = title
        obj.subcategory_id = subcat_id
        obj.is_test = selected.is_test
        obj.is_document = selected.is_document
        obj.is_video = selected.is_video
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
