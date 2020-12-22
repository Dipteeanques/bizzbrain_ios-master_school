//
//  NoteExamPaperViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 22/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class NoteExamPaperViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentViewController: UISegmentedControl!
    @IBOutlet weak var segmentViewSet: UIView!
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }

    var currentViewController: UIViewController?
    var Subject_id = Int()
    
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "StudentNoteViewController")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "StudentExampaperViewController")
        
        return secondChildTabVC
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Subject_id)
        
        segmentViewController.setBlackFont()
        segmentViewController.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubjectNoteExam"), object: Subject_id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
        
    }
    
    func displayCurrentTab(_ tabIndex: Int){
           if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
               
               self.addChild(vc)
               vc.didMove(toParent: self)
               
               vc.view.frame = self.contentView.bounds
               self.contentView.addSubview(vc.view)
               self.currentViewController = vc
           }
       }
       
       func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
           var vc: UIViewController?
           switch index {
           case TabIndex.firstChildTab.rawValue :
               vc = firstChildTabVC
           case TabIndex.secondChildTab.rawValue :
               vc = secondChildTabVC
           default:
               return nil
           }
           
           return vc
       }
    @IBAction func btnBAckAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()

        displayCurrentTab(sender.selectedSegmentIndex)
        
        switch segmentViewController.selectedSegmentIndex
        {
        case 0:
            break;
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubjectNoteExam"), object: Subject_id)
            break;
        default:
            break;
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


extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor(red: 31/255, green: 102/255, blue: 163/255, alpha: 1).cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .selected)
    }
    
    func setFont() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    func setBlackFont() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    func selectedColor() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    func addUnderlineForSelectedSegment(){
       // removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.white
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
