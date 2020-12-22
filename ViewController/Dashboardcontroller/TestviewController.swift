//
//  TestviewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 24/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class TestviewController: UIViewController {

   
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnbackWidth: NSLayoutConstraint!
    @IBOutlet weak var lblTotalQuestion: UILabel!
    @IBOutlet weak var lblQuestionRun: UILabel!
    @IBOutlet weak var collectionTest: UICollectionView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblQuestionanswer: UILabel!
    
    var wc = Webservice.init()
    var test_id = Int()
    var arrQuestion = [answerQuestion]()
    var url: URL?
    var TotalQuestion = Int()
    var Score = Int()
    var Answer = String()
    var Option = String()
    var indexLast = Int()
    var selectedBool = Bool()
    var path = IndexPath()
    
    
    fileprivate var ViewCheckHeight: CGFloat = 100
    fileprivate var oneViewHeight: CGFloat = 100
    fileprivate var TwoViewHeight: CGFloat = 100
    fileprivate var ThreeViewHeight: CGFloat = 100
    fileprivate var FourViewHeight: CGFloat = 100
    fileprivate var FiveViewHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Score = 0
        self.collectionTest.register(UINib(nibName: "QuestionTextcell", bundle: nil), forCellWithReuseIdentifier: "QuestionTextcell")
        self.collectionTest.register(UINib(nibName: "QuestiontextOptionImagecell", bundle: nil), forCellWithReuseIdentifier: "QuestiontextOptionImagecell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeTextImageoptionTxtcell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeTextImageoptionTxtcell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeText_Image_optionType_Imagecell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeText_Image_optionType_Imagecell")
        self.collectionTest.register(UINib(nibName: "QuestionType_image_optionType_textCell", bundle: nil), forCellWithReuseIdentifier: "QuestionType_image_optionType_textCell")
        self.collectionTest.register(UINib(nibName: "QuestionType_Image_optionType_ImageCell", bundle: nil), forCellWithReuseIdentifier: "QuestionType_Image_optionType_ImageCell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeHTMLcell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeHTMLcell")
        self.collectionTest.register(UINib(nibName: "QuestionHTMLAnsTextCell", bundle: nil), forCellWithReuseIdentifier: "QuestionHTMLAnsTextCell")
        self.collectionTest.register(UINib(nibName: "QuestionHTMLansImagecell", bundle: nil), forCellWithReuseIdentifier: "QuestionHTMLansImagecell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeTextAnsWebviewcell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeTextAnsWebviewcell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeText_imageAnsWeboptionCell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeText_imageAnsWeboptionCell")
        self.collectionTest.register(UINib(nibName: "QuestionTypeImageAnsWebCell", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeImageAnsWebCell")
        getTestQuestion()
        lblTotalQuestion.isHidden = true
        btnNext.layer.cornerRadius = 5
        btnNext.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getTestQuestion() {
        let parem = ["test_id": test_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
            wc.callSimplewebservice(url: QUSTIONANSWER, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AnswerQuestionresponsmodel?) in
                if sucess {
                    self.arrQuestion = response!.data
                    self.collectionTest.reloadData()
                    self.TotalQuestion = self.arrQuestion.count
                    self.lblTotalQuestion.text = "/" + String(self.TotalQuestion)
                    self.lblTotalQuestion.isHidden = false
                }
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        let uiAlert = UIAlertController(title: "Bizzbrains", message: "Are you sure do you want to finish?", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if selectedBool == true {
            selectedBool = false
                if Answer == Option {
                    Score += 1
                    print(Score)
                }
                else {
                    print("jekil")
                }
                let visibleItems: NSArray = self.collectionTest.indexPathsForVisibleItems as NSArray
                let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
                lblQuestionRun.text = String(nextItem.row)
                if nextItem.row < arrQuestion.count {
                    self.collectionTest.scrollToItem(at: nextItem, at: .left, animated: false)
                }
                else {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController")as! ResultsViewController
                    obj.test_id = test_id
                    obj.total_question = arrQuestion.count
                    obj.right_answer = Score
                    obj.total_marks = Score
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            }
        else {
            let uiAlert = UIAlertController(title: "Bizzbrains", message: "Please select question answer?", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
        }
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

//MARK: - collectionview method

extension TestviewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrQuestion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = arrQuestion[indexPath.item]
        let questions_type = question.questions_type
        let option_type = question.option_type
        switch questions_type {
        case "text":
            switch option_type {
            case "text":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTextcell", for: indexPath) as! QuestionTextcell
                cell.questionText = question
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionTextRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionTextRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionTextRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionTextRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionTextRadioAction), for: .touchUpInside)
                
                cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextAction), for: .touchUpInside)
                cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextAction), for: .touchUpInside)
                cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextAction), for: .touchUpInside)
                cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextAction), for: .touchUpInside)
                cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextAction), for: .touchUpInside)
                
                return cell
            case "Image":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestiontextOptionImagecell", for: indexPath) as! QuestiontextOptionImagecell
            cell.questionTextOptionImage = question
            cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionTextOptionImageRadioAction), for: .touchUpInside)
            cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionTextOptionImageRadioAction), for: .touchUpInside)
            cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionTextOptionImageRadioAction), for: .touchUpInside)
            cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionTextOptionImageRadioAction), for: .touchUpInside)
            cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionTextOptionImageRadioAction), for: .touchUpInside)
            
            cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextOptionImageAction), for: .touchUpInside)
            cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextOptionImageAction), for: .touchUpInside)
            cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextOptionImageAction), for: .touchUpInside)
            cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextOptionImageAction), for: .touchUpInside)
            cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTextOptionImageAction), for: .touchUpInside)
            return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeTextAnsWebviewcell", for: indexPath) as! QuestionTypeTextAnsWebviewcell
                let questionStr = question.questions_text
                let option_custom = question.option_custom
                cell.lblQuestion.text = questionStr
                if option_custom.count == 4 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    cell.webOne.frame = CGRect(x: 50, y: cell.lblQuestion.frame.size.height + 8, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    let height = oneViewHeight
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + 58
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    cell.webFive.isHidden = true
                    cell.btnFive.isHidden = true
                    
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                }
                else if option_custom.count == 3 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    cell.webOne.frame = CGRect(x: 50, y: cell.lblQuestion.frame.size.height + 8, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    let height = oneViewHeight
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                }
                else if option_custom.count == 2 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let height = oneViewHeight
                    
                    cell.webOne.frame = CGRect(x: 50, y: cell.lblQuestion.frame.size.height + 8, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    cell.webThree.isHidden = true
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnthree.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                }
                else {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    let optionFive = question.option4
                    let height = oneViewHeight
                    cell.webOne.frame = CGRect(x: 50, y: cell.lblQuestion.frame.size.height + 8, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + 58
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    let heightfive = heightfour + 58
                    cell.webFive.frame = CGRect(x: 50, y: heightfive, width: collectionTest.frame.width, height: self.FiveViewHeight)
                    cell.webFive.navigationDelegate = self
                    cell.webFive.loadHTMLString(optionFive, baseURL: nil)
                    cell.webFive.tag = 1006
                    
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                    cell.btnFive.frame = CGRect(x: 10, y: heightfive + 10, width: 30, height: 30)
                }
                
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionTextAnsWebRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionTextAnsWebRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionTextAnsWebRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionTextAnsWebRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionTextAnsWebRadioAction), for: .touchUpInside)
                
                cell.btnwebOne.addTarget(self, action: #selector(TestviewController.BtnQuestiontxtweboptionAction), for: .touchUpInside)
                cell.btnwebTwo.addTarget(self, action: #selector(TestviewController.BtnQuestiontxtweboptionAction), for: .touchUpInside)
                cell.btnwebThree.addTarget(self, action: #selector(TestviewController.BtnQuestiontxtweboptionAction), for: .touchUpInside)
                cell.btnwebFour.addTarget(self, action: #selector(TestviewController.BtnQuestiontxtweboptionAction), for: .touchUpInside)
                cell.btnwebFive.addTarget(self, action: #selector(TestviewController.BtnQuestiontxtweboptionAction), for: .touchUpInside)
                
                return cell
            }
        case "Text_Image":
            switch option_type {
            case "text":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeTextImageoptionTxtcell", for: indexPath) as! QuestionTypeTextImageoptionTxtcell
                cell.questionImageTest = question
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionTextRadioAction), for: .touchUpInside)
                
                cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionTextAction), for: .touchUpInside)
                cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionTextAction), for: .touchUpInside)
                cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionTextAction), for: .touchUpInside)
                cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionTextAction), for: .touchUpInside)
                cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionTextAction), for: .touchUpInside)
                
                return cell
            case "Image":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeText_Image_optionType_Imagecell", for: indexPath) as! QuestionTypeText_Image_optionType_Imagecell
                cell.questionImageTextoptionImage = question
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionTexImagetOptionImageRadioAction), for: .touchUpInside)
                
                
                cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionImageAction), for: .touchUpInside)
                cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionImageAction), for: .touchUpInside)
                cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionImageAction), for: .touchUpInside)
                cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionImageAction), for: .touchUpInside)
                cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionTexImagetOptionImageAction), for: .touchUpInside)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeText_imageAnsWeboptionCell", for: indexPath) as! QuestionTypeText_imageAnsWeboptionCell
                let questionStr = question.questions_text
                let img = question.questions_img
                url = URL(string: img)
                cell.imgQuestion.sd_setImage(with: url, completed: nil)
                let option_custom = question.option_custom
                cell.lblQuestiob.text = questionStr
                if option_custom.count == 4 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    let height = oneViewHeight
                    let y = cell.lblQuestiob.frame.size.height + cell.imgQuestion.frame.size.height
                    cell.webOne.frame = CGRect(x: 50, y: y, width: cell.webOne.frame.width, height: height)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + y - 13
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + self.TwoViewHeight - 50
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + self.ThreeViewHeight - 50
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    cell.webFive.isHidden = true
                    cell.btnFive.isHidden = true
                    
                    cell.btnOne.frame = CGRect(x: 10, y: y + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                    
                }
                else if option_custom.count == 3 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let height = oneViewHeight
                    let y = cell.lblQuestiob.frame.size.height + cell.imgQuestion.frame.size.height
                    cell.webOne.frame = CGRect(x: 50, y: y, width: cell.webOne.frame.width, height: height)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + y - 13
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + self.TwoViewHeight - 50
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: y + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    
                }
                else if option_custom.count == 2 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let height = oneViewHeight
                    let y = cell.lblQuestiob.frame.size.height + cell.imgQuestion.frame.size.height
                    cell.webOne.frame = CGRect(x: 50, y: y, width: cell.webOne.frame.width, height: height)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + y
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    cell.webThree.isHidden = true
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnthree.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: y + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    
                }
                else {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    let optionFive = question.option4
                    let height = oneViewHeight
                    let y = cell.lblQuestiob.frame.size.height + cell.imgQuestion.frame.size.height
                    cell.webOne.frame = CGRect(x: 50, y: y, width: cell.webOne.frame.width, height: height)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + y - 13
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + self.TwoViewHeight - 50
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + self.ThreeViewHeight - 50
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    let heightfive = heightfour + self.FourViewHeight - 50
                    cell.webFive.frame = CGRect(x: 50, y: heightfive, width: collectionTest.frame.width, height: self.FiveViewHeight)
                    cell.webFive.navigationDelegate = self
                    cell.webFive.loadHTMLString(optionFive, baseURL: nil)
                    cell.webFive.tag = 1006
                    
                    cell.btnOne.frame = CGRect(x: 10, y: y + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                    cell.btnFive.frame = CGRect(x: 10, y: heightfive + 10, width: 30, height: 30)
                    
                }
                
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionText_imageAnsWebRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionText_imageAnsWebRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionText_imageAnsWebRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionText_imageAnsWebRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionText_imageAnsWebRadioAction), for: .touchUpInside)
                
                cell.btnwebOne.addTarget(self, action: #selector(TestviewController.BtnQuestiontxt_imageweboptionAction), for: .touchUpInside)
                cell.btnwebTwo.addTarget(self, action: #selector(TestviewController.BtnQuestiontxt_imageweboptionAction), for: .touchUpInside)
                cell.btnwebThree.addTarget(self, action: #selector(TestviewController.BtnQuestiontxt_imageweboptionAction), for: .touchUpInside)
                cell.btnwebFour.addTarget(self, action: #selector(TestviewController.BtnQuestiontxt_imageweboptionAction), for: .touchUpInside)
                cell.btnwebFive.addTarget(self, action: #selector(TestviewController.BtnQuestiontxt_imageweboptionAction), for: .touchUpInside)
                
                return cell
            }
        case "Image":
            switch option_type {
            case "text":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionType_image_optionType_textCell", for: indexPath) as! QuestionType_image_optionType_textCell
                cell.questionImagetoptionText = question
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionTextRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionTextRadioAction), for: .touchUpInside)
                
                cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionTextAction), for: .touchUpInside)
                cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionTextAction), for: .touchUpInside)
                cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionTextAction), for: .touchUpInside)
                cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionTextAction), for: .touchUpInside)
                cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionTextAction), for: .touchUpInside)
                return cell
            case "Image":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionType_Image_optionType_ImageCell", for: indexPath) as! QuestionType_Image_optionType_ImageCell
                cell.questionImageOptionImage = question
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionImageRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionImagetOptionImageRadioAction), for: .touchUpInside)
                
                cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionImageAction), for: .touchUpInside)
                cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionImageAction), for: .touchUpInside)
                cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionImageAction), for: .touchUpInside)
                cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionImageAction), for: .touchUpInside)
                cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionImagetOptionImageAction), for: .touchUpInside)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeImageAnsWebCell", for: indexPath) as! QuestionTypeImageAnsWebCell
                let option_custom = question.option_custom
                let strImage = question.questions_img
                url = URL(string: strImage)
                cell.img.sd_setImage(with: url, completed: nil)
                
                if option_custom.count == 4 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    let height = cell.img.frame.size.height + 8
                    cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + 58
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    cell.webFive.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)

                }
                else if option_custom.count == 3 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let height = cell.img.frame.size.height + 8
                    cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)

                }
                else if option_custom.count == 2 {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let height = cell.img.frame.size.height + 8
                    cell.webOne.frame = CGRect(x: 50, y: height, width: collectionTest.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    cell.webThree.isHidden = true
                    cell.webFour.isHidden = true
                    cell.webFive.isHidden = true
                    cell.btnthree.isHidden = true
                    cell.btnFour.isHidden = true
                    cell.btnFive.isHidden = true
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)

                }
                else {
                    let optionOne = question.option0
                    let optionTwo = question.option1
                    let optionThree = question.option2
                    let optionFour = question.option3
                    let optionFive = question.option4
                    let height = cell.img.frame.size.height + 8
                    cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                    cell.webOne.navigationDelegate = self
                    cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                    cell.webOne.tag = 1002
                    
                    let heighttwo = height + 58
                    cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                    cell.webTwo.navigationDelegate = self
                    cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                    cell.webTwo.tag = 1003
                    
                    let heightthree = heighttwo + 58
                    cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                    cell.webThree.navigationDelegate = self
                    cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                    cell.webThree.tag = 1004
                    
                    let heightfour = heightthree + 58
                    cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                    cell.webFour.navigationDelegate = self
                    cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                    cell.webFour.tag = 1005
                    
                    let heightfive = heightfour + 58
                    cell.webFive.frame = CGRect(x: 50, y: heightfive, width: collectionTest.frame.width, height: self.FiveViewHeight)
                    cell.webFive.navigationDelegate = self
                    cell.webFive.loadHTMLString(optionFive, baseURL: nil)
                    cell.webFive.tag = 1006
                    
                    cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                    cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                    cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                    cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                    cell.btnFive.frame = CGRect(x: 10, y: heightfive + 10, width: 30, height: 30)

                }
                
                cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionImageansWebRadioAction), for: .touchUpInside)
                cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionImageansWebRadioAction), for: .touchUpInside)
                cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionImageansWebRadioAction), for: .touchUpInside)
                cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionImageansWebRadioAction), for: .touchUpInside)
                cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionImageansWebRadioAction), for: .touchUpInside)
                
                cell.btnwebOne.addTarget(self, action: #selector(TestviewController.BtnImagequeweboptionAction), for: .touchUpInside)
                cell.btnwebTwo.addTarget(self, action: #selector(TestviewController.BtnImagequeweboptionAction), for: .touchUpInside)
                cell.btnwebThree.addTarget(self, action: #selector(TestviewController.BtnImagequeweboptionAction), for: .touchUpInside)
                cell.btnwebFour.addTarget(self, action: #selector(TestviewController.BtnImagequeweboptionAction), for: .touchUpInside)
                cell.btnwebFive.addTarget(self, action: #selector(TestviewController.BtnImagequeweboptionAction), for: .touchUpInside)
                
                return cell
            }
            case "HTML":
                switch option_type {
                case "HTML":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionTypeHTMLcell", for: indexPath) as! QuestionTypeHTMLcell
                    let questionHtml = question.questions_text
                    let option_custom = question.option_custom
                    
                    if option_custom.count == 4 {
                        let optionOne = question.option0
                        let optionTwo = question.option1
                        let optionThree = question.option2
                        let optionFour = question.option3
                        cell.webhtml.frame = CGRect(x: 0, y: 0, width: collectionTest.frame.width, height: self.ViewCheckHeight)
                        cell.webhtml.navigationDelegate = self
                        cell.webhtml.loadHTMLString(questionHtml, baseURL: nil)
                        cell.webhtml.tag = 1001
                        
                        let height = self.ViewCheckHeight + 8
                        cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                        cell.webOne.navigationDelegate = self
                        cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                        cell.webOne.tag = 1002
                        
                        let heighttwo = height + 58
                        cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                        cell.webTwo.navigationDelegate = self
                        cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                        cell.webTwo.tag = 1003
                        
                        let heightthree = heighttwo + 58
                        cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                        cell.webThree.navigationDelegate = self
                        cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                        cell.webThree.tag = 1004
                        
                        let heightfour = heightthree + 58
                        cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                        cell.webFour.navigationDelegate = self
                        cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                        cell.webFour.tag = 1005
                        
                        cell.webFive.isHidden = true
                        cell.btnFive.isHidden = true
                        
                        cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                        cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                        cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                        cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                        
                        cell.webOne.addSubview(cell.btnwebOne)
                        cell.webTwo.addSubview(cell.btnwebTwo)
                        cell.webThree.addSubview(cell.btnwebThree)
                        cell.webFour.addSubview(cell.btnwebFour)
                    }
                    else if option_custom.count == 3 {
                        let optionOne = question.option0
                        let optionTwo = question.option1
                        let optionThree = question.option2
                        cell.webhtml.frame = CGRect(x: 0, y: 0, width: collectionTest.frame.width, height: self.ViewCheckHeight)
                        cell.webhtml.navigationDelegate = self
                        cell.webhtml.loadHTMLString(questionHtml, baseURL: nil)
                        cell.webhtml.tag = 1001
                        
                        let height = self.ViewCheckHeight + 8
                        cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                        cell.webOne.navigationDelegate = self
                        cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                        cell.webOne.tag = 1002
                        
                        let heighttwo = height + 58
                        cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                        cell.webTwo.navigationDelegate = self
                        cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                        cell.webTwo.tag = 1003
                        
                        let heightthree = heighttwo + 58
                        cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                        cell.webThree.navigationDelegate = self
                        cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                        cell.webThree.tag = 1004
                        
                        cell.webFour.isHidden = true
                        cell.webFive.isHidden = true
                        cell.btnFour.isHidden = true
                        cell.btnFive.isHidden = true
                        cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                        cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                        cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                        
                        cell.webOne.addSubview(cell.btnwebOne)
                        cell.webTwo.addSubview(cell.btnwebTwo)
                        cell.webThree.addSubview(cell.btnwebThree)
                    }
                    else if option_custom.count == 2 {
                        let optionOne = question.option0
                        let optionTwo = question.option1
                        cell.webhtml.frame = CGRect(x: 0, y: 0, width: collectionTest.frame.width, height: self.ViewCheckHeight)
                        cell.webhtml.navigationDelegate = self
                        cell.webhtml.loadHTMLString(questionHtml, baseURL: nil)
                        cell.webhtml.tag = 1001
                        
                        let height = self.ViewCheckHeight + 8
                        cell.webOne.frame = CGRect(x: 50, y: height, width: collectionTest.frame.width, height: self.oneViewHeight)
                        cell.webOne.navigationDelegate = self
                        cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                        cell.webOne.tag = 1002
                        
                        let heighttwo = height + 58
                        cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                        cell.webTwo.navigationDelegate = self
                        cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                        cell.webTwo.tag = 1003
                        
                        cell.webThree.isHidden = true
                        cell.webFour.isHidden = true
                        cell.webFive.isHidden = true
                        cell.btnthree.isHidden = true
                        cell.btnFour.isHidden = true
                        cell.btnFive.isHidden = true
                        cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                        cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                        
                        cell.webOne.addSubview(cell.btnwebOne)
                        cell.webTwo.addSubview(cell.btnwebTwo)
                    }
                    else {
                        let optionOne = question.option0
                        let optionTwo = question.option1
                        let optionThree = question.option2
                        let optionFour = question.option3
                        let optionFive = question.option4
                        cell.webhtml.frame = CGRect(x: 0, y: 0, width: collectionTest.frame.width, height: self.ViewCheckHeight)
                        cell.webhtml.navigationDelegate = self
                        cell.webhtml.loadHTMLString(questionHtml, baseURL: nil)
                        cell.webhtml.tag = 1001
                        
                        let height = self.ViewCheckHeight + 8
                        cell.webOne.frame = CGRect(x: 50, y: height, width: cell.webOne.frame.width, height: self.oneViewHeight)
                        cell.webOne.navigationDelegate = self
                        cell.webOne.loadHTMLString(optionOne, baseURL: nil)
                        cell.webOne.tag = 1002
                        
                        let heighttwo = height + 58
                        cell.webTwo.frame = CGRect(x: 50, y: heighttwo , width: collectionTest.frame.width, height: self.TwoViewHeight)
                        cell.webTwo.navigationDelegate = self
                        cell.webTwo.loadHTMLString(optionTwo, baseURL: nil)
                        cell.webTwo.tag = 1003
                        
                        let heightthree = heighttwo + 58
                        cell.webThree.frame = CGRect(x: 50, y: heightthree, width: collectionTest.frame.width, height: self.ThreeViewHeight)
                        cell.webThree.navigationDelegate = self
                        cell.webThree.loadHTMLString(optionThree, baseURL: nil)
                        cell.webThree.tag = 1004
                        
                        let heightfour = heightthree + 58
                        cell.webFour.frame = CGRect(x: 50, y: heightfour, width: collectionTest.frame.width, height: self.FourViewHeight)
                        cell.webFour.navigationDelegate = self
                        cell.webFour.loadHTMLString(optionFour, baseURL: nil)
                        cell.webFour.tag = 1005
                        
                        let heightfive = heightfour + 58
                        cell.webFive.frame = CGRect(x: 50, y: heightfive, width: collectionTest.frame.width, height: self.FiveViewHeight)
                        cell.webFive.navigationDelegate = self
                        cell.webFive.loadHTMLString(optionFive, baseURL: nil)
                        cell.webFive.tag = 1006
                        
                        cell.btnOne.frame = CGRect(x: 10, y: height + 10, width: 30, height: 30)
                        cell.btntwo.frame = CGRect(x: 10, y: heighttwo + 10, width: 30, height: 30)
                        cell.btnthree.frame = CGRect(x: 10, y: heightthree + 10, width: 30, height: 30)
                        cell.btnFour.frame = CGRect(x: 10, y: heightfour + 10, width: 30, height: 30)
                        cell.btnFive.frame = CGRect(x: 10, y: heightfive + 10, width: 30, height: 30)
                        
                        cell.webOne.addSubview(cell.btnwebOne)
                        cell.webTwo.addSubview(cell.btnwebTwo)
                        cell.webThree.addSubview(cell.btnwebThree)
                        cell.webFour.addSubview(cell.btnwebFour)
                        cell.webFive.addSubview(cell.btnwebFive)
                    }
                    
                    cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionQuestionTypeHTMLcellRadioAction), for: .touchUpInside)
                    cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionQuestionTypeHTMLcellRadioAction), for: .touchUpInside)
                    cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionQuestionTypeHTMLcellRadioAction), for: .touchUpInside)
                    cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionQuestionTypeHTMLcellRadioAction), for: .touchUpInside)
                    cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionQuestionTypeHTMLcellRadioAction), for: .touchUpInside)
                    
                    cell.btnwebOne.addTarget(self, action: #selector(TestviewController.BtnweboptionAction), for: .touchUpInside)
                    cell.btnwebTwo.addTarget(self, action: #selector(TestviewController.BtnweboptionAction), for: .touchUpInside)
                    cell.btnwebThree.addTarget(self, action: #selector(TestviewController.BtnweboptionAction), for: .touchUpInside)
                    cell.btnwebFour.addTarget(self, action: #selector(TestviewController.BtnweboptionAction), for: .touchUpInside)
                    cell.btnwebFive.addTarget(self, action: #selector(TestviewController.BtnweboptionAction), for: .touchUpInside)
                    
                    return cell
                case "text":
                     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionHTMLAnsTextCell", for: indexPath) as! QuestionHTMLAnsTextCell
                     cell.questionHTMLAnstxt = question
                     let questionHtml = question.questions_text
                     cell.webQuestion.frame = CGRect(x: 0, y: 0, width: cell.webQuestion.frame.size.width, height: self.ViewCheckHeight)
                     cell.webQuestion.navigationDelegate = self
                     cell.webQuestion.loadHTMLString(questionHtml, baseURL: nil)
                     cell.lblTop.constant = self.ViewCheckHeight - 50
                     cell.webQuestion.tag = 1001
                     
                     cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlTxtRadioAction), for: .touchUpInside)
                     cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlTxtRadioAction), for: .touchUpInside)
                     cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlTxtRadioAction), for: .touchUpInside)
                     cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlTxtRadioAction), for: .touchUpInside)
                     cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlTxtRadioAction), for: .touchUpInside)
                     
                     cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansTxtAction), for: .touchUpInside)
                     cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansTxtAction), for: .touchUpInside)
                     cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansTxtAction), for: .touchUpInside)
                     cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansTxtAction), for: .touchUpInside)
                     cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansTxtAction), for: .touchUpInside)
                     return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionHTMLansImagecell", for: indexPath) as! QuestionHTMLansImagecell
                    cell.questionHTMLOptionImage = question
                    let questionHtml = question.questions_text
                    cell.webQuestion.frame = CGRect(x: 0, y: 0, width: cell.webQuestion.frame.size.width, height: self.ViewCheckHeight)
                    cell.webQuestion.navigationDelegate = self
                    cell.webQuestion.loadHTMLString(questionHtml, baseURL: nil)
                    cell.webQuestion.tag = 1001
                    cell.optionTop.constant = self.ViewCheckHeight - 50
                    
                    cell.btnOne.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlAnsImageRadioAction), for: .touchUpInside)
                    cell.btntwo.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlAnsImageRadioAction), for: .touchUpInside)
                    cell.btnthree.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlAnsImageRadioAction), for: .touchUpInside)
                    cell.btnFour.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlAnsImageRadioAction), for: .touchUpInside)
                    cell.btnFive.addTarget(self, action: #selector(TestviewController.btnQuestionHtmlAnsImageRadioAction), for: .touchUpInside)
                    
                    cell.btnA.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansImageAction), for: .touchUpInside)
                    cell.btnB.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansImageAction), for: .touchUpInside)
                    cell.btnC.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansImageAction), for: .touchUpInside)
                    cell.btnD.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansImageAction), for: .touchUpInside)
                    cell.btnE.addTarget(self, action: #selector(TestviewController.BtnlalQuestionHtmlansImageAction), for: .touchUpInside)
                    return cell
            }
        default:
            print("jekil")
        }
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: collectionTest.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexLast = indexPath.item
        path = indexPath
    }
    

    
    //MARK: - LBLAction
    
    @objc func BtnlalQuestionTextAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTextcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionTextOptionImageAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestiontextOptionImagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionTexImagetOptionTextAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeTextImageoptionTxtcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionTexImagetOptionImageAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeText_Image_optionType_Imagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionImagetOptionTextAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionType_image_optionType_textCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionImagetOptionImageAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionType_Image_optionType_ImageCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnweboptionAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeHTMLcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionHtmlansTxtAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionHTMLAnsTextCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnlalQuestionHtmlansImageAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionHTMLansImagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnQuestiontxtweboptionAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeTextAnsWebviewcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnQuestiontxt_imageweboptionAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeText_imageAnsWeboptionCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func BtnImagequeweboptionAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeImageAnsWebCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    //MARK: - BUTTON Action
    
    @objc func btnQuestionTextRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTextcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionTextOptionImageRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestiontextOptionImagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionTexImagetOptionTextRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeTextImageoptionTxtcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionTexImagetOptionImageRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeText_Image_optionType_Imagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionImagetOptionTextRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionType_image_optionType_textCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionImagetOptionImageRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionType_Image_optionType_ImageCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionQuestionTypeHTMLcellRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeHTMLcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionHtmlTxtRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionHTMLAnsTextCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionHtmlAnsImageRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionHTMLansImagecell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    
    @objc func btnQuestionTextAnsWebRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeTextAnsWebviewcell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionText_imageAnsWebRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeText_imageAnsWeboptionCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
    
    @objc func btnQuestionImageansWebRadioAction(_ sender: UIButton) {
        if let indexpath = self.collectionTest.indexPathforitemView(sender) {
            selectedBool = true
            Answer = arrQuestion[indexpath.item].answer
            let cell = collectionTest.cellForItem(at: indexpath)as! QuestionTypeImageAnsWebCell
            print(sender.tag)
            Option = String(sender.tag)
            switch sender.tag {
            case 0:
                cell.btnOne.isSelected = true
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 1:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = true
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 2:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = true
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = false
            case 3:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = true
                cell.btnFive.isSelected = false
            default:
                cell.btnOne.isSelected = false
                cell.btntwo.isSelected = false
                cell.btnthree.isSelected = false
                cell.btnFour.isSelected = false
                cell.btnFive.isSelected = true
            }
        }
    }
}


extension UICollectionView {
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfItems(inSection: section) - 1, 0)
        return IndexPath(row: row, section: section)
    }
}

extension TestviewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
         webView.scrollView.isScrollEnabled = false
        if webView.tag == 1001 {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.ViewCheckHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
        else if webView.tag == 1002 {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.oneViewHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
        else if webView.tag == 1003 {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.TwoViewHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
        else if webView.tag == 1004 {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.ThreeViewHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
        else if webView.tag == 1005 {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.FourViewHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
        else {
            webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (height, error) in
                        self.FiveViewHeight = height as! CGFloat
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.collectionTest.reloadData()
                //self.collectionTest.reloadItems(at: [self.path])
            }
        }
    }
}


