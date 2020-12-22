//
//  ResultsViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 25/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ResultsViewController: UIViewController {

    @IBOutlet weak var btngoto: UIButton!
    @IBOutlet weak var viewCardType: UIView!
    @IBOutlet weak var lblTotalmarks: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    @IBOutlet weak var lblTotalQuestion: UILabel!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var test_id = Int()
    var total_question = Int()
    var right_answer = Int()
    var total_marks = Int()
    var wc = Webservice.init()
    
    
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
        btngoto.layer.cornerRadius = 5
        btngoto.clipsToBounds = true
        viewCardType.layer.borderWidth = 1
        viewCardType.layer.borderColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        viewCardType.layer.cornerRadius = 5
        viewCardType.clipsToBounds = true
        lblTotalQuestion.text = String(total_question)
        lblRight.text = String(right_answer)
        lblTotalmarks.text = String(total_marks)
        results()
    }
    
    func results() {
        let parem = ["test_id": test_id,
                     "total_question":total_question,
                     "right_answer":right_answer,
                     "total_marks":total_marks]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        wc.callSimplewebservice(url: RESULTSQ_A, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AnswerQuestionResultsRespons?) in
        }
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    @IBAction func btnGotoAction(_ sender: UIButton) {
        backTwo()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        appDel.gotoTabbar()
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
