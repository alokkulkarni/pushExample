//
//  ViewController.swift
//  pushExample
//
//  Created by Alok Kulkarni on 25/08/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications
import MessageUI
import Messages

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    
    @IBOutlet weak var lbl_home: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    

    
    let cache = GlobalCache.sharedCache as! NSCache<NSString, Config>
    
    
    var configData : [Config] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_home.text = NSLocalizedString("LBL_HOME", comment: " ")
        lbl_name.text = NSLocalizedString("LBL_NAME", comment: " ")
        // Do any additional setup after loading the view, typically from a nib.
//        self.displayMessageInterface()
        self.setupConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshConfigs(_ sender: Any) {
        var configsRetrieved:Bool = false
        RemoteConfig.init().fetchRemoteConfig { (bool) in
            if bool! {
                configsRetrieved = true
                print(configsRetrieved)
            }
        }
        self.setupConfig()
    }
    
    @IBAction func TestABController(_ sender: Any) {
        
        let viewControllerA = storyboard?.instantiateViewController(withIdentifier: "PricingANavController")
        let viewControllerB = storyboard?.instantiateViewController(withIdentifier: "PricingBNavController")
        if (cache.object(forKey: "Genericfalse") != nil) {
            let config : Config = (cache.object(forKey: "Genericfalse"))!
            if (config.isConditional == true) {
                if (config.conditionParam == "customerId") {
                    self.present(viewControllerB!, animated: true, completion: nil)
                } else {
                    self.present(viewControllerA!, animated: true, completion: nil)
                }
            }
        } else {
            self.present(viewControllerA!, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendLocalNotification(_ sender: Any) {
        
        OpenVideoApp()
//        let content = UNMutableNotificationContent()
//        content.title = "Local Notification"
//        content.body = "this is a local notification"
//        content.sound = UNNotificationSound.default()
//        content.categoryIdentifier = "Generic"
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func OpenVideoApp() {
        let urlString: URL = URL.init(string: "https://invinciblenotify.co.uk/bpf/onboard")!
        
        if UIApplication.shared.canOpenURL(urlString) {
            openUrl(urlString)
        }
    }
    
    func openUrl(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
        
        
    func setupConfig() {
        print("in setup config")
        if (cache.object(forKey: "Generictrue") != nil) {
            let config : Config = (cache.object(forKey: "Generictrue"))!
            print("generic true to show alert");
            if config.isPopUp == true {
                let now = Date()
                let finalDate = stringToDate.sharedInstance.StringToDateFormat(dateString: config.expiration)
                print(now)
                print(finalDate)
                if (finalDate > now) {
                    if config.isPopUp == true {
                        let alert = UIAlertController.init(title: "Hello", message: (config.customParams["BUTTON_TITLE"] as! String), preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if let tLabel =  config.customParams["STRING_TEXT"] {
                        lbl_name.text = (tLabel as! String)
                    } else {
                        lbl_name.text = NSLocalizedString("LBL_NAME", comment: " ")
                    }
                    
                    if let tLabel =  config.customParams["BUTTON_TITLE"] {
                        lbl_home.text = (tLabel as! String)
                    } else {
                        lbl_home.text = NSLocalizedString("LBL_HOME", comment: " ")
                    }
                } else {
                    lbl_home.text = NSLocalizedString("LBL_HOME", comment: " ")
                    lbl_name.text = NSLocalizedString("LBL_NAME", comment: " ")
                }
            }
        }
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["+447733584659"]
        composeVC.body = "Message Me!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: false, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }

}






//    func getconfigs() {
//
//        let headers : HTTPHeaders = [
//            "Accept" : "application/json"
//        ]
//
//        var _ : NSInteger = 0
//
//        let url = URL(string: "http://localhost:8080/configs/321456897/configs/active")
//        let update_url = URL(string: "http://localhost:8080/configs/5b8a3372ea7b78caaa2bb56f/updateStatus?status=read")
//
//        var dict : [[String : AnyObject]]? = nil
//
//        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
//                 .validate()
//            .responseJSON { (response) in
//                print(response)
//                dict = (response.result.value as? [[String : AnyObject]])!
//                print(dict ?? nil ?? 0 )
//
//                for conf in dict! {
//                    print(conf["contentAvailable"] ?? 0)
//                    if (conf["contentAvailable"]?.int64Value == 1 && (conf["category"]?.isEqual("Generic"))! ) {
//                        let alert = UIAlertController(title: conf["customParams"]?["BUTTON_TITLE"] as? String, message: conf["customParams"]?["IMAGE"] as? String, preferredStyle: .alert)
//
//                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { actions in
//                             print("Yes button clicked !!")
//                             Alamofire.request(update_url!, method: .post, parameters: ["status" : "read"], encoding: JSONEncoding.default, headers: headers)
//                                    .validate()
//                                .responseJSON(completionHandler: { (response) in
//                                    print(response as Any)
//                                })
//                            }))
//                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {actions in
//                            print("No button clicked !!")
//                        }))
//
//                        self.present(alert, animated: true)
//                    }
//                }
//        }
//    }
