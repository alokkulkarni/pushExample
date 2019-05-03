//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Alok Kulkarni on 02/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var lbltitle: UILabel?
    @IBOutlet var lblsubtitle: UILabel?
    @IBOutlet var lblbody: UILabel?
    @IBOutlet var imgvImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.lblbody?.text = notification.request.content.body
        self.lbltitle?.text = notification.request.content.title
        self.lblsubtitle?.text = notification.request.content.subtitle
        
        if let attachmentString = notification.request.content.userInfo["image"] as? String,
            let attachmentURL = URL(string: attachmentString) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let downloadTask = session.downloadTask(with: attachmentURL, completionHandler :  { (url, _, error) in
                if let error = error {
                    print("error Downloading attachment: \(error.localizedDescription)")
                } else {
                    let image = try! UIImage.init(data: NSData.init(contentsOf: url!) as Data)
                    self.imgvImage?.image = image
                }
            })
            downloadTask.resume()
        }
        
        
    }

}
