//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Alok Kulkarni on 02/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UserNotifications
import MobileCoreServices
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
//    var downloadTask: URLSessionDownloadTask?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//        var urlString:String?
//        var video : Bool = false
        
        
        if let bestAttemptContent = bestAttemptContent {
            
//            if let video_url = bestAttemptContent.userInfo["video"]  {
//                urlString = video_url as? String
//                video = true
//            } else if let image_url = bestAttemptContent.userInfo["image"] {
//                urlString = image_url as? String
//            }
            
//            let imageOptions : [AnyHashable: Any] = [
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeJPEG,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeGIF
//            ]
            
//            let videoOptions : [AnyHashable: Any] = [
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeMovie,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeMPEG,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeMPEG4,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeMPEG2Video,
//                UNNotificationAttachmentOptionsTypeHintKey : kUTTypeAVIMovie
//            ]
            
            let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            if let attachmentString = bestAttemptContent.userInfo["image"] as? String,
                let attachmentURL = URL(string: attachmentString) {
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let downloadTask = session.downloadTask(with: attachmentURL, completionHandler :  { (url, _, error) in
                        if let error = error {
                            print("error Downloading attachment: \(error.localizedDescription)")
                        } else {
                            let attachment = try! UNNotificationAttachment(identifier: attachmentString, url: url!,options: [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG,
                               UNNotificationAttachmentOptionsThumbnailClippingRectKey: rect])
                            
                            bestAttemptContent.attachments = [attachment]
                        }
                        contentHandler(bestAttemptContent)
                    })
                downloadTask.resume()
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//        self.downloadTask?.cancel()
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
