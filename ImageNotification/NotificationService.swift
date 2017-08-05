//
//  NotificationService.swift
//  ImageNotification
//
//  Created by amirhossein on 5/14/1396 AP.
//  Copyright © 1396 amirhossein. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        print("bestAttemptContent: \(String(describing: bestAttemptContent))")
        print("request.content.userInfo: \(request.content.userInfo)")
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            var urlString:String? = nil
            if let userInfo = request.content.userInfo as NSDictionary as? [String: Any], let imageURL = userInfo["imageURL"] as? String {
                urlString = imageURL
            }
            
            if urlString != nil, let fileUrl = URL(string: urlString!) {
                print("fileUrl: \(fileUrl)")
                
                guard let imageData = NSData(contentsOf: fileUrl) else {
                    contentHandler(bestAttemptContent)
                    return
                }
                guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else {
                    print("error in UNNotificationAttachment.create()")
                    contentHandler(bestAttemptContent)
                    return
                }
                
                bestAttemptContent.attachments = [ attachment ]
            }
            
            contentHandler(bestAttemptContent)
        }
    }
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        self.contentHandler = contentHandler
//        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//        
//        if let bestAttemptContent = bestAttemptContent {
//            
//            if let urlString = bestAttemptContent.userInfo["imageURL"] as? String,
//                let data = NSData(contentsOf: URL(string:urlString)!) as Data? {
//                let path = NSTemporaryDirectory() + "attachment"
//                _ = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
//                
//                do {
//                    let file = URL(fileURLWithPath: path)
//                    let attachment = try UNNotificationAttachment(identifier: "attachment", url: file,options:[UNNotificationAttachmentOptionsTypeHintKey : "public.jpeg"])
//                    bestAttemptContent.attachments = [attachment]
//                    
//                } catch {
//                    print(error)
//                    
//                }
//            }
//            contentHandler(bestAttemptContent)
//        }
//    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        guard let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true) else { return nil }
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
    
}
