//
//  AppDelegate.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import Fabric
import Reachability
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setNotification(application)
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self
        Thread.sleep(forTimeInterval: 0.1)
        IQKeyboardManager.shared.enable = true
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        let parentLogin = loggdenUser.bool(forKey: PARENT_ISLOGIN)
        let studentLogin = loggdenUser.bool(forKey: STUDENT_ISLOGIN)
        let isLogin = loggdenUser.bool(forKey: ISLOGIN)
        if isLogin{
            gotoTabbar()
        } else {
            if parentLogin {
                gotoParent()
            }
            else if studentLogin {
                gotoStudent()
            }
            else {
                self.extendSplashScreenPresentation()
            }
        }
        setupIAP()
        return true
    }
    
    func setupIAP() {

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in

            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in

            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - SplashScreen
    private func extendSplashScreenPresentation(){
        // Get a refernce to LaunchScreen.storyboard
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get the splash screen controller
        let splashController = launchStoryBoard.instantiateViewController(withIdentifier: "splashController")
        // Assign it to rootViewController
        self.window?.rootViewController = splashController
        self.window?.makeKeyAndVisible()
        // Setup a timer to remove it after n seconds
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissSplashController() {
        // Get a refernce to Main.storyboard
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "Navigation1")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoLogin() {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "Navigation1")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }

    func gotoTabbar() {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "NavigateTabbar")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoStudent() {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "navigateStudentZoneTab")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoParent() {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "NavigationParent")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - Setup Notification
    func setNotification(_ application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard error == nil else {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            else {
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification : \(userInfo)")
        //let data = userInfo["data"] as! NSDictionary
        //print("Dictionary : %@",data)
        completionHandler(UIBackgroundFetchResult.newData)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           print("user notification : \(response.notification)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present : \(notification.request.content.userInfo)")
        completionHandler(.alert)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token : \(fcmToken)")
        loggdenUser.set(fcmToken, forKey: FCM)
    }
}

