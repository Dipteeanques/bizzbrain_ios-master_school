//
//  VideoConferenceVC.swift
//  bizzbrains
//
//  Created by Anques on 28/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class VideoConferenceVC: UIViewController,SJSegmentedViewControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}


extension UIViewController{
    func NavigateVideoConference()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "VideoConferenceVC")
            

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "upcomingMeetingsVC")
            firstViewController.title = "UPCOMING MEETINGS"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "OlderMeetingsVC")
            secondViewController.title = "OLDER MEETINGS"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 90
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = .red
            segmentController.selectedSegmentViewHeight = 3
            segmentController.selectedSegmentViewColor = .red
            
            navigationController?.pushViewController(segmentController, animated: true)
        }
    }
}
