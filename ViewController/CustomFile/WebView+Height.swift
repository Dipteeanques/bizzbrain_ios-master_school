//
//  WebViewHeight
//
//  Created by NSSimpleApps on 07.07.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit
import WebKit




extension WKWebView {
    
    func loadFile(from url: URL) throws {
        
        let string = try String(contentsOf: url, encoding: String.Encoding.utf8)
        
        self.loadHTMLString(string, baseURL: url.deletingLastPathComponent())
    }
    
    func documentHeight(completion: @escaping (_ height: CGFloat) -> ()) {
        
        self.evaluateJavaScript("document.documentElement.offsetHeight") { (result, error) in
            
            let height = result as? CGFloat ?? 0
            
            completion(height)
        }
    }
}
