//
//  Notifications.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/26/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class Notifications
{
    class func sendNotification(expiryDate: Date, url: String, daysBefore: Int)
    {
        let content = UNMutableNotificationContent()
        let expTime = expiryDate.timeIntervalSince(Date())
        if expTime < 0
        {
            return
        }
        var timeBefore = Double(daysBefore)*3600*24
        if timeBefore > expTime
        {
            timeBefore = expTime
        }
        //let expDays = (expTime-timeBefore)/(3600*24)
        let expDays = timeBefore/(3600*24)
        content.title = "Domain expiry alert"
        content.subtitle = "Domain \(url) will expire in \(expDays) days."
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: expTime - timeBefore, repeats: false)
        
        print("Notification will go in %",(expTime-timeBefore)/(3600*24))

        // choose a random identifier
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    class func Alert(title: String, message: String) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        return alert//VC.present(alert, animated: true, completion: nil)
    }
}
