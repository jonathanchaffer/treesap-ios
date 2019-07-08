//
//  NotificationBadge.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used http://www.stefanovettor.com/2016/04/30/adding-badge-uibarbuttonitem/ as a reference.
//

import UIKit

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor) {
        fillColor = color.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

extension UIViewController {
    func updateNotificationBadge() {
        NotificationCenter.default.addObserver(self, selector: #selector(addBadge), name: NSNotification.Name(StringConstants.unreadNotificationsCountNotification), object: nil)
        DatabaseManager.retrieveNumberOfUnreadNotifications()
    }
    
    @objc private func addBadge(_ notification: Notification) {
        // Initialize the badge
        let button = self.navigationController?.navigationBar.items![0].leftBarButtonItem!
        guard let view = button!.value(forKey: "view") as? UIView else { return }
        let badge = CAShapeLayer()
        let radius = CGFloat(4)
        let offset = CGPoint(x: 32, y: 10)
        let location = CGPoint(x: (radius + offset.x), y: (radius + offset.y))
        let color = UIColor(named: "notificationBadge")!
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color)
        // Add the badge if there are new notifications
        let numNotifications = notification.userInfo!["count"] as! Int
        print(numNotifications)
        if numNotifications != 0 {
            view.layer.addSublayer(badge)
        }
    }
}
