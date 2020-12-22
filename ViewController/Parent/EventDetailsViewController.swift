//
//  EventDetailsViewController.swift
//  bizzbrains
//
//  Created by Kalu's mac on 05/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var imageCover: UIImageView!
    var arrEventList = [DatumEvent]()
    var url: URL?
    var strDescription = String()
    var arrdesc = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
        // Do any additional setup after loading the view.
    }
    
    func setDefault(){
        lblTitle.text = arrEventList[0].name
        lbldate.text = arrEventList[0].dateTime
        let image = arrEventList[0].image
        url = URL(string: image)
        imageCover.sd_setImage(with: url, completed: nil)
        strDescription = arrEventList[0].datumEventDescription
        arrdesc.append(strDescription)
        tblView.reloadData()
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

extension EventDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdesc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! evebtDetailsCell
        cell.lbldetails.text = arrdesc[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


class evebtDetailsCell: UITableViewCell {
    @IBOutlet weak var lbldetails: UILabel!
}
