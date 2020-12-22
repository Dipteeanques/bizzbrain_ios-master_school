//
//  SearchEleraningController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class StudentSearchViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tblSearching: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var strSearchTxt = String()
    var arrResults = [MainCatSearch]()
    var wc = Webservice.init()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.gray
            }
        }
        tblSearching.reloadData()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getMaincateSearch()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func getMaincateSearch() {
        loaderView.isHidden = false
        activity.startAnimating()
        let trimmed = strSearchTxt.trimmingCharacters(in: .whitespacesAndNewlines)
        let parameters = ["search":trimmed]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        wc.callSimplewebservice(url: SEARCH, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: MainCategoriesSearchResponsModel?) in
            if sucess {
                let sucess = response?.success
                if sucess == true {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    self.arrResults = response!.data
                    self.tblSearching.reloadData()
                }
                else {
                    print("jekil")
                }
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

extension StudentSearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrResults[indexPath.row]
        let cell = tblSearching.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblSearchCell
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.description
        let strimage = data.image
        url = URL(string: strimage)
        cell.img.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
        cell.img.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrResults[indexPath.row]
        let cat_id = data.id
        let strTitle = data.title
        let strImage = data.image
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubcategoryController")as! SubcategoryController
        obj.category_id = cat_id
        obj.strTitle = strTitle
        obj.strImage = strImage
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}




