//
//  HomeViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 13/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView

class HomeViewController: UIViewController,selectedIndexDelegete {
    

    @IBOutlet weak var collectionViewInstruct: UICollectionView!
    @IBOutlet weak var lblInstructName: UILabel!
    @IBOutlet weak var imgInstructor: UIImageView! {
        didSet {
            imgInstructor.layer.cornerRadius = imgInstructor.frame.size.height / 2
            imgInstructor.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnInstruct: UIButton!
    @IBOutlet weak var lblInstruct: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var subscriptionCollectionView: UICollectionView!
    @IBOutlet weak var viewNewarrival: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var collectionNewArrival: UICollectionView!
    @IBOutlet weak var collectionBanner: UICollectionView!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var lblCate: UILabel!
    @IBOutlet weak var lblNew: UILabel!
    var wc = Webservice.init()
    var arrBanners = [String]()
    var arrMainCategory = NSArray()
    var arrNewArival = NSArray()
    var arrSchool = NSArray()
    var base_category = NSArray()
    var encodeData = [Data]()
    var is_new_main_category_show = Int()
    var url: URL?
    var begin = false
    var counter = 0
    var arrSubscription = NSArray()
    var instruct_id = Int()
    var arrInstruct = NSArray()
    
        
    var image = [#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder"),#imageLiteral(resourceName: "placeholder")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getId()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        //updateUserInterface()
        getMainCategory()
        getSubscribe()
        startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.gotoTabbar), name: NSNotification.Name(rawValue: "gotoTabbar"), object: nil)
        
        self.tblMain.register(UINib(nibName: "tblhomeXibcell", bundle: nil), forCellReuseIdentifier: "tblhomeXibcell")
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            let alert = UIAlertController(title: "Bizzbrains", message: "No internet access! There may be a problem in your internet connection. Please try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .wwan:
             getMainCategory()
        case .wifi:
             getMainCategory()
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    @objc func gotoTabbar(_ notification: NSNotification) {
        getMainCategory()
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeViewController.scrollToNextCell), userInfo: nil, repeats: true);
    }
    
   @objc func scrollToNextCell(){
    if counter < arrBanners.count {
        let index = IndexPath.init(item: counter, section: 0)
        self.collectionBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = counter
        counter += 1
    }
    else {
        counter = 0
        let index = IndexPath.init(item: counter, section: 0)
        self.collectionBanner.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = counter
    }
}
    
    func getId() {
        let deviceToken = loggdenUser.value(forKey: FCM)as! String
        let param = ["device_token": deviceToken]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        wc.callSimplewebservice(url: update_device_token, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response:SubscribeIDResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    let jsonstring = Data_IdClass.init(maincategoryIDS: data!.maincategoryIDS, subcategoryIDS: data!.subcategoryIDS, expiryMaincategoryIDS: data!.expiryMaincategoryIDS, expirySubcategoryIDS: data!.expirySubcategoryIDS)
                    let encoder = JSONEncoder()
                    if let data = try? encoder.encode(jsonstring) {
                        self.encodeData.append(data)
                        loggdenUser.set(self.encodeData, forKey: all_Ids)
                    }
                }
            }
        }
    }
    
    func getMainCategory() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        print("headers:",headers)
        AF.request(DASHBOARDS, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                print(json)
                let sucess = json.value(forKey: "success")as! Bool
                if sucess == true {
                    let data = json.value(forKey: "data")as! NSDictionary
                    self.arrBanners = data.value(forKey: "banners") as! [String]
                    
                    self.arrNewArival = data.value(forKey: "new_main_category") as! NSArray
                    self.arrInstruct = data.value(forKey: "instructor") as? NSArray ?? []
                    
                    self.collectionNewArrival.reloadData()
                   
                    self.base_category = data.value(forKey: "base_category")as! NSArray
                    self.collectionBanner.reloadData()
                    self.pageControl.numberOfPages = self.arrBanners.count
                    self.pageControl.currentPage = 0
                    self.tblMain.reloadData()
                     self.collectionViewInstruct.reloadData()
                }
                else {
                    self.tblMain.reloadData()
                }
        }
    }
    
    func getSubscribe() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
        AF.request(MAINCATEGORY, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let sucess = json.value(forKey: "success")as! Bool
                if sucess == true {
                    self.arrSubscription = json.value(forKey: "data")as! NSArray
                    self.subscriptionCollectionView.reloadData()
                }
                else {
                    self.footerView.frame.size.height = 0
                }
        }
    }
    func selectedDel(index: Int, Maincategoryarr: NSArray) {
        let strimage = (Maincategoryarr[index]as AnyObject).value(forKey: "image")as? String
        let cat_id = (Maincategoryarr[index]as AnyObject).value(forKey: "id") as? Int
        let Title = (Maincategoryarr[index]as AnyObject).value(forKey: "title") as? String
        let type = (Maincategoryarr[index]as AnyObject).value(forKey: "type") as? String
        if type == "Paid"{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsController")as! CategoryDetailsController
            obj.strMonthset = type ?? ""
            obj.cate_id = cat_id!
            obj.strImage = strimage!
//            obj.subcategory_type = "subcategory"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
            obj.category_id = cat_id!
            obj.strTitle = Title!
            obj.strImage = strimage!
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    @IBAction func btnInstructAll(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "InstructorViewController")as! InstructorViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    @IBAction func Btn_RightAction(_ sender: Any)
    {
        if arrNewArival.count >= 4 {
            let visibleItems: NSArray = self.collectionNewArrival.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < image.count {
                self.collectionNewArrival.scrollToItem(at: nextItem, at: .left, animated: true)
            }
        }
    }
    
    @IBAction func Btn_LeftAction(_ sender: Any)
    {
        if arrNewArival.count >= 4 {
            let visibleItems: NSArray = self.collectionNewArrival.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            if nextItem.row < image.count && nextItem.row >= 0{
                self.collectionNewArrival.scrollToItem(at: nextItem, at: .right, animated: true)
            }
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
    @IBAction func btnMysubscripAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func btnSearchAction(_ sender: UIButton) {
        if (loggdenUser.value(forKey: ROLE_ID) != nil) {
            let role_id = loggdenUser.value(forKey: ROLE_ID)as! Int
            if role_id == 6 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "StudentSearchViewController")as! StudentSearchViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else {
                self.tabBarController?.selectedIndex = 2
            }
        }
        else {
            self.tabBarController?.selectedIndex = 2
        }
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return base_category.count
//    }

     func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return base_category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "tblhomeXibcell", for: indexPath) as! tblhomeXibcell

        cell.collectionView.register(UINib(nibName: "CollectionlistCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")
        cell.lblTitle.text = (self.base_category[indexPath.row]as AnyObject).value(forKey: "title")as? String
        cell.btnAll.addTarget(self, action: #selector(btnAllAction), for: .touchUpInside)
        print("base_category:",self.base_category[indexPath.row])
        cell.collectionView.tag = indexPath.row
        cell.arrMainCategory = base_category
        cell.delegete = self
        cell.collectionView.reloadData()
//        cell.arrMainCategory = (self.base_category[indexPath.row]as AnyObject).value(forKey: "main_category")as! NSArray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 200
    }
    
    @objc func btnAllAction(_ sender: UIButton){
        let index = tblMain.indexPathForView(sender)
        let id = (base_category[index!.row] as AnyObject).value(forKey: "id")as! Int
        let title = (base_category[index!.row] as AnyObject).value(forKey: "title")as! String
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubcategoryController")as! SubcategoryController
         obj.category_id = id
         obj.strTitle = title
         obj.all = "all"
         self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionNewArrival {
            if arrNewArival.count == 0 {
                return image.count
            }
            else {
                return arrNewArival.count
            }
        }
        else if collectionView == collectionViewInstruct {
            if arrInstruct.count == 0{
                btnInstruct.isHidden = true
                lblInstruct.isHidden = true
                collectionViewInstruct.isHidden = true
            }
                return arrInstruct.count
        }
        else if collectionView == collectionBanner {
            if self.arrBanners.count == 0 {
                return image.count
            }
            else if self.arrBanners.count == 1 {
                pageControl.isHidden = true
                return arrBanners.count
            }
            else {
                return arrBanners.count
            }
        }
        else  {
            if arrSubscription.count == 0 {
                return image.count
            }
            else {
                return arrSubscription.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionNewArrival {
            if arrNewArival.count == 0 {
                let cell = collectionNewArrival.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionNewarrivalCell
                cell.image.image = image[indexPath.row]
                return cell
            }
            else {
                let cell = collectionNewArrival.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionNewarrivalCell
                let strimage = (self.arrNewArival[indexPath.row]as AnyObject).value(forKey: "photo300x300")as! String
                url = URL(string: strimage)
                cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.lblTitle.text = (self.arrNewArival[indexPath.row]as AnyObject).value(forKey: "title") as? String
                cell.image.hideSkeleton()
                cell.image.layer.cornerRadius = 8
                cell.image.clipsToBounds = true
                return cell
            }
        }
        else if collectionView == collectionBanner {
            if arrBanners.count == 0 {
                let cell = collectionBanner.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! bannerCollectionCell
                cell.imageBanner.image = image[indexPath.row]
                return cell
            }
            else {
                let cell = collectionBanner.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! bannerCollectionCell
                let strImage = arrBanners[indexPath.row]
                url = URL(string: strImage)
                cell.imageBanner.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.imageBanner.hideSkeleton()
                return cell
            }
        }
        else if collectionView == subscriptionCollectionView {
            if arrSubscription.count == 0 {
                let cell = subscriptionCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionSubscriberCell
                cell.image.image = image[indexPath.row]
                return cell
            }
            else {
                let cell = subscriptionCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionSubscriberCell
                let strimage = (self.arrSubscription[indexPath.row]as AnyObject).value(forKey: "photo300x300")as! String
                url = URL(string: strimage)
                cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.lblTitle.text = (self.arrSubscription[indexPath.row]as AnyObject).value(forKey: "title") as? String
                cell.image.hideSkeleton()
                cell.image.layer.cornerRadius = 8
                cell.image.clipsToBounds = true
                cell.viewSubSribe.isHidden = false
                return cell
            }
        }
        else {
                let cell = collectionViewInstruct.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionSubscriberCell
                let strimage = (self.arrInstruct[indexPath.row]as AnyObject).value(forKey: "profile")as! String
                url = URL(string: strimage)
                cell.image.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
                cell.lblTitle.text = (self.arrInstruct[indexPath.row]as AnyObject).value(forKey: "name") as? String
                cell.image.hideSkeleton()
                cell.image.layer.cornerRadius = 8
                cell.image.clipsToBounds = true
                cell.viewSubSribe.isHidden = true
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionBanner {
            return CGSize(width: collectionBanner.bounds.width, height: collectionBanner.bounds.height)
        }
        else if collectionView == collectionViewInstruct {
            if arrInstruct.count == 0 {
                 return CGSize(width: 0, height: 0)
            }
            else {
                let width = collectionView.bounds.size.width / 3
                return CGSize(width: width, height: width)
            }
        }
        else {
            let width = collectionView.bounds.size.width / 3
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionBanner {
            print("jekil")
        }
        else if collectionView == collectionNewArrival {
            let cate_id = (self.arrNewArival[indexPath.row]as AnyObject).value(forKey: "id")as! Int
            let strImg = (self.arrNewArival[indexPath.row]as AnyObject).value(forKey: "photo300x300")as! String
            let type = (self.arrNewArival[indexPath.row]as AnyObject).value(forKey: "title")as! String
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
            obj.category_id = cate_id
            obj.strImage = strImg
            obj.strTitle = type
            obj.subcategory_type = "maincategory"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if collectionView == subscriptionCollectionView {
            let cate_id = (self.arrSubscription[indexPath.row]as AnyObject).value(forKey: "id")as! Int
             let strImg = (self.arrSubscription[indexPath.row]as AnyObject).value(forKey: "photo300x300")as! String
             let type = (self.arrSubscription[indexPath.row]as AnyObject).value(forKey: "title")as! String
             let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubcategoryController")as! SubcategoryController
             obj.category_id = cate_id
             obj.strImage = strImg
             obj.strTitle = type
             //obj.subcategory_type = "maincategory"
             self.navigationController?.pushViewController(obj, animated: true)
        }
        else if collectionView == collectionViewInstruct {
            let selected = arrInstruct[indexPath.item]
            let id = (selected as AnyObject).value(forKey: "id")as! Int
            let title = (selected as AnyObject).value(forKey: "name")as! String
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MainInstructorViewController")as! MainInstructorViewController
            obj.instruc_id = id
            obj.strTitle = title
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            let strimage = (self.arrMainCategory[indexPath.row]as AnyObject).value(forKey: "image")as? String
            let cat_id = (self.arrMainCategory[indexPath.row]as AnyObject).value(forKey: "id") as? Int
            let Title = (self.arrMainCategory[indexPath.row]as AnyObject).value(forKey: "title") as? String
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddCatSubcategorycontroller")as! AddCatSubcategorycontroller
            obj.category_id = cat_id!
            obj.strTitle = Title!
            obj.strImage = strimage!
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}

extension HomeViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
}


//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector("statusBar")) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}



class bannerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBanner: UIImageView!{
        didSet {
            imageBanner.isSkeletonable = true
            imageBanner.showAnimatedSkeleton()
        }
    }
}
