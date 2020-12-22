//
//  ImageViewViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/03/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class ImageViewViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var arrImg = [String]()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension ImageViewViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ImagelistCollectionViewCell
        let image = arrImg[indexPath.row]
        url = URL(string: image)
        cell.imagelist.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    
}


