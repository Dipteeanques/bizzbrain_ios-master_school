//
//  Webservice.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class Webservice: NSObject {

    func webservice(name: String) -> String {
        return name
    }
    
    //MARK: - Simple webservice Method
    func callSimplewebservice<T: Decodable>(url: String, parameters:[String: Any],headers:HTTPHeaders, fromView: UIView, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .gray
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters as [String : Any])
        print(mutable)
        var header = HTTPHeaders()
        header = headers
//        AF.request(url, method: .post, parameters: mutable as? Parameters, encoding: URLEncoding.default, headers: header).responseDecodable { (response: DataResponse<T>) in
            
            AF.request(url, method: .post, parameters: mutable as? Parameters, encoding: URLEncoding.default, headers: header).responseDecodable { (response: AFDataResponse<T>) in
            
            print(response)
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, try? response.result.get())
                break
            case .failure(_):
                complition(false, try? response.result.get())
                break
            }
        }
    }
    
    //MARK: - Simple GET webservice Method
    func callGETSimplewebservice<T: Decodable>(url: String,parameters:[String: Any],headers: HTTPHeaders, fromView: UIView, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .gray
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters)
        AF.request(url, method: .get, parameters:mutable as? Parameters, encoding: URLEncoding.default, headers: headers).responseDecodable { (response: AFDataResponse<T>) in
            print(response)
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, try? response.result.get())
            case .failure(_):
                complition(false, try? response.result.get())
            }
        }
    }
}
