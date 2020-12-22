//
//  tblhomeXibcell.swift
//  bizzbrains
//
//  Created by Kalu's mac on 19/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

protocol selectedIndexDelegete {
    func selectedDel(index: Int,Maincategoryarr: NSArray)
}

class tblhomeXibcell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrMainCategory = NSArray()
    var url: URL?
    var delegete: selectedIndexDelegete?
    var arr2 = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrMainCategory.count
//        let arr = arrMainCategory[collectionView.tag]
        arr2 = (arrMainCategory[collectionView.tag]as AnyObject).value(forKey: "main_category")as! NSArray
        return arr2.count//.listFlowStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath)as! CollectionlistCell
//        if indexPath.row >= self.arrMainCategory.count
//        {
//            return cell
//        }
        let positionNow = (arrMainCategory[collectionView.tag]as AnyObject).value(forKey: "main_category")as! NSArray
        print("tag:",collectionView.tag)
        print("indexPath:",indexPath.row)
        print("positionNow:",positionNow)
        cell.imageView?.backgroundColor = UIColor.red
//        print("arrMainCategory",self.arrMainCategory[indexPath.row])
        cell.lblname?.text = (positionNow[indexPath.row]as AnyObject).value(forKey: "title") as? String
        let strimage = (positionNow[indexPath.row]as AnyObject).value(forKey: "image")as! String
        url = URL(string: strimage)
        cell.imageView?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
        cell.imageView?.hideSkeleton()
        cell.imageView?.layer.cornerRadius = 15
        cell.imageView?.clipsToBounds = true
        return cell
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
        let width = collectionView.bounds.size.width / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegete?.selectedDel(index: indexPath.row, Maincategoryarr: self.arr2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
