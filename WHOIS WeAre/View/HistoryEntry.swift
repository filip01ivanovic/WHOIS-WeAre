//
//  HistoryEntry.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/25/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class HistoryEntry
{
    var view: UIView!
    let urlLabel: UILabel!
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, urlLabel_horizontalMargin: CGFloat, search: [String:Any]) {
        view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        let urlLabel_horizontalMargin = CGFloat(5)
        urlLabel = UILabel(frame: CGRect(x: urlLabel_horizontalMargin, y: 10, width: view.frame.width - 2*urlLabel_horizontalMargin, height: 32))
        urlLabel.font = UIFont(name: "Futura", size: 30)
        urlLabel.text = (search["url"] as! String)
        view.addSubview(urlLabel)
        let dateLabelHeight = CGFloat(16)
        let dateLabel_verticalMargin = CGFloat(8)
        let datesView = UIView(frame: CGRect(x: urlLabel.frame.minX, y: view.frame.height - dateLabelHeight - dateLabel_verticalMargin, width: urlLabel.frame.width, height: dateLabelHeight))
        view.addSubview(datesView)
        let calendar = Calendar.current
        let dateSearched = search["dateSearched"]
        let expiryDate = search["expiryDate"]
        
        let dateSearchedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: datesView.frame.width/2, height: datesView.frame.height))
        dateSearchedLabel.font = UIFont(name: "Futura", size: dateLabelHeight-2)
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        var dateTimeComponents = calendar.dateComponents(requestedComponents, from: dateSearched as! Date)
        
        dateSearchedLabel.text = "Datum pretrage: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
        dateSearchedLabel.textColor = UIColor.gray
        datesView.addSubview(dateSearchedLabel)
        
        dateTimeComponents = calendar.dateComponents(requestedComponents, from: expiryDate as! Date)
        let expiryDateLabel = UILabel(frame: CGRect(x: datesView.frame.width/2, y: 0, width: datesView.frame.width/2, height: datesView.frame.height))
        expiryDateLabel.font = UIFont(name: "Futura", size: dateLabelHeight-2)
        expiryDateLabel.text = "Datum isteka: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
        expiryDateLabel.textColor = UIColor.gray
        expiryDateLabel.textAlignment = .right
        datesView.addSubview(expiryDateLabel)
    }
}
