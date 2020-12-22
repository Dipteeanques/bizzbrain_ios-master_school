//
//  ResultHistoryViewcontroller.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 17/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ResultHistoryViewcontroller: UIViewController {

    @IBOutlet weak var tblResult: UITableView!
    @IBOutlet weak var foundView: UIView!
    
    var arrResults = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func getResult() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(RESULT, method: .post, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.arrResults = data.value(forKey: "data")as! NSArray
                    if self.arrResults.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tblResult.reloadData()
                    }
                }
                else{
                    self.foundView.isHidden = false
                }
           }
      }

    @IBAction func btnbackAction(_ sender: UIButton) {
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

extension ResultHistoryViewcontroller: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrResults.count == 0 {
            return 10
        }
        else {
            return arrResults.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrResults.count == 0 {
            let cell = tblResult.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblResulthistoryCell
            return cell
        }
        else {
            
            let results = (self.arrResults[indexPath.row]as AnyObject)
            let cell = tblResult.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblResulthistoryCell
            let title = results.value(forKey: "main_category_name")as! String
            cell.lblTitle.text = title
            let created_at = results.value(forKey: "created_at")as! String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let yourDate = formatter.date(from: created_at)
            formatter.dateFormat = "HH:mm dd MMM yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            cell.lblTime.text = myStringafd
            let total_question = results.value(forKey: "total_question")as! Int
            cell.lblQuestion.text = String(total_question)
            let right_answer = results.value(forKey: "right_answer")as! Int
            cell.lblAnswer.text = String(right_answer)
            let total_marks = results.value(forKey: "total_marks")as! Int
            cell.lblTotal.text = String(total_marks)
            
            cell.imgStaticWatch.hideSkeleton()
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}



