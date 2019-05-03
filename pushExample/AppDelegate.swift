//
//  AppDelegate.swift
//  pushExample
//
//  Created by Alok Kulkarni on 25/08/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import Intents
import CoreTelephony
import DeviceCheck

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    

    var window: UIWindow?
    var manager : CLLocationManager = CLLocationManager()
    var notificationToken: String = String.init()
    var physicalDeviceID: String = String.init()
    var latestDeviceDetials = Dictionary<AnyHashable, Any>.init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        latestDeviceDetials = getDeviceDetails()
        physicalDeviceID = getPhysicalDeviceToken()
        registerForPushNotifications()
        requestAuthorization()
        validateSIMDetails()
        print(latestDeviceDetials)
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        checkForLocationServices()
        
        
        
        return true
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
             
            return String(format: "%02.2hhx", data)
        }
        
        let token: String = tokenParts.joined()
        print("Device Token: \(token)")
        latestDeviceDetials.updateValue(physicalDeviceID, forKey: "physicalDeviceID")
        latestDeviceDetials.updateValue(token, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let aps = userInfo["aps"] as AnyObject? else {
            completionHandler(.noData)
            print("its a normal push")
            return
        }
        
        print("Content Available: \(String(describing: aps["content-available"]))")
        if aps["content-available"] as? Int == 1 {
            print("Silent Notification arrived")
            self.getNotificationSettings()
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        if response.notification.request.identifier == "TestIdentifier" {
//            print("handling notifications with the TestIdentifier Identifier")
//        }
        
        if response.notification.request.content.categoryIdentifier == "Generic" {
            switch(response.notification.request.content.categoryIdentifier) {
            case "General":
                break;
            case "Generic":
                switch response.actionIdentifier {
                case "remindLater":
                    print("remind me later clicked")
                    break;
                case "accept":
                    print("accept clicked")
                    break;
                case "decline":
                    print("decline clicked")
                    break;
                case "comment":
                    let textResponse = response as! UNTextInputNotificationResponse
                    print(textResponse.userText)
                    print("comment clicked")
                    break;
                default:
                    break;
                }
                break;
            default:
                break;
            }
        }
        
        completionHandler()
        
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Notification permission Granted : \(granted)")
            
            guard granted else { return }
            
            
//            // 1
//            let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
//                                                  title: "View",
//                                                  options: [.foreground])
//
//            // 2
//            let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
//                                                      actions: [viewAction],
//                                                      intentIdentifiers: [],
//                                                      options: [])
//            // 3
//            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            
            let remindLaterAction = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: UNNotificationActionOptions(rawValue: 0))
            let acceptAction = UNNotificationAction(identifier: "accept", title: "Accept", options: .foreground)
            let declineAction = UNNotificationAction(identifier: "decline", title: "Decline", options: .destructive)
            let commentAction = UNTextInputNotificationAction(identifier: "comment", title: "Comment", options: .authenticationRequired, textInputButtonTitle: "Send", textInputPlaceholder: "Share your thoughts..")
            
            //Category
            let invitationCategory = UNNotificationCategory(identifier: "Generic", actions: [remindLaterAction, acceptAction, declineAction, commentAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
            
            UNUserNotificationCenter.current().setNotificationCategories([invitationCategory])
            
            
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func requestAuthorization() {
        INPreferences.requestSiriAuthorization { (status) in
            if status == .authorized {
                print("Hey Siri")
            } else {
                print("Nay Siri")
            }
        }
    }
    
    func checkForLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            print("location services available")
            // Location services are available, so query the user’s location.
        } else {
            print("location services are disabled")
            // Update your app’s UI to show that the location is unavailable.
        }
    }
    
    func validateSIMDetails() {
            let telephony = CTTelephonyNetworkInfo.init()
            let subscriberCarrierInfo : CTCarrier = telephony.subscriberCellularProvider!
        
            print("CTCarrier Detials \(String(describing: subscriberCarrierInfo.carrierName))  \(String(describing: subscriberCarrierInfo.isoCountryCode)) \(String(describing: subscriberCarrierInfo.mobileCountryCode)) \(String(describing: subscriberCarrierInfo.mobileNetworkCode)) \(String(describing: subscriberCarrierInfo.allowsVOIP))")
        
            latestDeviceDetials.updateValue(subscriberCarrierInfo.carrierName as Any, forKey: "carrierName")
            latestDeviceDetials.updateValue(subscriberCarrierInfo.isoCountryCode as Any, forKey: "isoCountryCode")
            latestDeviceDetials.updateValue(subscriberCarrierInfo.mobileCountryCode as Any, forKey: "mobileCountryCode")
            latestDeviceDetials.updateValue(subscriberCarrierInfo.mobileNetworkCode as Any, forKey: "mobileNetworkCode")
            latestDeviceDetials.updateValue(subscriberCarrierInfo.allowsVOIP as Any, forKey: "allowsVOIP")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location Status : - \(status.rawValue)")
        if (status != .authorizedAlways) {  
            manager.requestAlwaysAuthorization()
        }
    }
    
    func getPhysicalDeviceToken() -> String {
        let device = DCDevice.current
        var tokenData: String = String.init()
        
        print("Supported Device \(device.isSupported)")
        
        if (device.isSupported)
        {
            device.generateToken(completionHandler: { (data, error) in
                print("************************************************")
                print(String(format: "%02.2hhx", data! as CVarArg))
                print("************************************************")
                tokenData = String(format: "%02.2hhx", data! as CVarArg)
            })
        }
        return tokenData
    }
    
    func getDeviceDetails() -> Dictionary<AnyHashable, Any> {
        var deviceDetials = Dictionary<AnyHashable, Any>.init()
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        print(__IPHONE_OS_VERSION_MIN_REQUIRED)
        
        let deploymentTarget: String = String(__IPHONE_OS_VERSION_MIN_REQUIRED)
        
        deviceDetials.updateValue("321456897", forKey: "customerId")
        deviceDetials.updateValue(UIDevice.current.identifierForVendor ?? UUID.init(), forKey: "deviceSerialNumber")
        deviceDetials.updateValue(UIDevice.current.model, forKey: "deviceType")
        deviceDetials.updateValue(UIDevice.current.name, forKey: "deviceName")
        deviceDetials.updateValue(UIDevice.current.systemName, forKey: "deviceOS")
        deviceDetials.updateValue(UIDevice.current.systemVersion, forKey: "deviceOS")
        deviceDetials.updateValue(UUID.init(), forKey: "aid")
        deviceDetials.updateValue("com.alok.pushExample", forKey: "deviceBundleIdentifier")
        deviceDetials.updateValue(UIDevice.current.identifierForVendor ?? UUID.init(), forKey: "deviceIMEINumber")
        deviceDetials.updateValue("active", forKey: "status")
        deviceDetials.updateValue("true", forKey: "isMaster")
        deviceDetials.updateValue(appVersionString, forKey: "deviceApplicationVersion")
        deviceDetials.updateValue(buildNumber, forKey: "deviceBuild")
        deviceDetials.updateValue(deploymentTarget, forKey: "devicedeploymentTarget")
//        latestDeviceDetials.updateValue(physicalDeviceID, forKey: "physicalDeviceID")
//        latestDeviceDetials.updateValue(token, forKey: "deviceToken")
//        deviceDetials.updateValue(subscriberCarrierInfo.carrierName as Any, forKey: "carrierName")
//        deviceDetials.updateValue(subscriberCarrierInfo.isoCountryCode as Any, forKey: "isoCountryCode")
//        deviceDetials.updateValue(subscriberCarrierInfo.mobileCountryCode as Any, forKey: "mobileCountryCode")
//        deviceDetials.updateValue(subscriberCarrierInfo.mobileNetworkCode as Any, forKey: "mobileNetworkCode")
//        deviceDetials.updateValue(subscriberCarrierInfo.allowsVOIP as Any, forKey: "allowsVOIP")
//        deviceDetials.updateValue(NSLocale.autoupdatingCurrent.languageCode!, forKey: "languageCode")
//        deviceDetials.updateValue(NSLocale.autoupdatingCurrent.usesMetricSystem, forKey: "metricSystem")

        return deviceDetials
    }
    
    
//    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
//        
//    }
//    
//    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        
//    }
}

