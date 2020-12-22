//
//  SearchingViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 13/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SearchingViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tblSearching: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    //MARK: - Variables
    var arrStateCity = [String]()
    var arrSearch = [String]()
    let wc = Webservice.init()
    var strCity = String()
    var strTitle = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefualtProperties()
    }
    
    //MARK: - Set Defualt
    func setDefualtProperties() {
        lblTitle.text = strTitle
//        tblSearching.tableFooterView = UIView()
//        searchbar.searchBarStyle = .prominent
//        searchbar.isTranslucent = true
        searchbar.placeholder = "Search"
        searchbar.delegate = self
//        searchbar.sizeToFit()
//        searchbar.showsCancelButton = true
//        searchbar.tintColor = UIColor.darkGray
        if strCity.isEmpty == true {
             Getstate()
        }
        else {
            getCity()
        }
    }
    
    func Getstate() {
        let headers: HTTPHeaders = ["Xapi": Xapi]
        wc.callGETSimplewebservice(url: STATE, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: StateResponseModel?) in
            self.arrStateCity = response!.data
            self.arrSearch = response!.data
            self.tblSearching.reloadData()
        }
    }
    
    func getCity() {
        let parem = ["state":strCity]
        let headers: HTTPHeaders = ["Xapi": Xapi]
        wc.callSimplewebservice(url: CITY, parameters: parem, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: StateResponseModel?) in
            self.arrStateCity = response!.data
            self.arrSearch = response!.data
            self.tblSearching.reloadData()
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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


extension SearchingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStateCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrStateCity[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strname = arrStateCity[indexPath.row]
        if strCity.isEmpty == true {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchingState"), object: strname)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchingCity"), object: strname)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchingViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrStateCity = searchText.isEmpty ? arrSearch : arrSearch.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        tblSearching.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
