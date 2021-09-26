//
//  SearchQueryCard.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/25/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class SearchQueryCard: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var url: String!
    var expiryDate: Date!
    var dateSearched: Date!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, urlLabel_horizontalMargin: CGFloat, search: [String:Any]) {
        super.init(frame: CGRect(x: x+20, y: y, width: width-40, height: height))
        //layer.borderWidth = 1
        layer.backgroundColor = UIColor.systemGray3.cgColor
        //layer.backgroundColor = UIColor(displayP3Red: 30, green: 30, blue: 30, alpha: 0.2).cgColor
        layer.cornerRadius = 20
        
        /*
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = CGRect(x: x, y: y-20, width: width, height: height)
        visualEffectView.alpha = 0.8
        visualEffectView.layer.cornerRadius = 20
        addSubview(visualEffectView)
        */
        
        //DispatchQueue.main.asyncAfter(deadline: .now()+2)
        
        //let urlLabel_horizontalMargin = CGFloat(5)
        let urlLabel = UILabel(frame: CGRect(x: urlLabel_horizontalMargin, y: 15, width: frame.width - 2*urlLabel_horizontalMargin, height: 34))
        urlLabel.font = UIFont(name: "Futura", size: 26)
        urlLabel.text = (search["url"] as! String)
        urlLabel.textColor = UIColor.systemBackground
        url = urlLabel.text
        addSubview(urlLabel)
        let dateLabelHeight = CGFloat(12)
        let dateLabel_verticalMargin = CGFloat(8)
        let datesView = UIView(frame: CGRect(x: urlLabel.frame.minX, y: frame.height - dateLabelHeight - dateLabel_verticalMargin, width: urlLabel.frame.width, height: dateLabelHeight))
        addSubview(datesView)
        let calendar = Calendar.current
        dateSearched = (search["dateSearched"] as? Date)
        expiryDate = (search["expiryDate"] as? Date)
        
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
        
        if dateSearched == nil
        {
            let dateSearchedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: datesView.frame.width, height: datesView.frame.height))
            dateSearchedLabel.font = UIFont(name: "Futura", size: dateLabelHeight-2)
            let dateTimeComponents = calendar.dateComponents(requestedComponents, from: expiryDate!)
            
            if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
                dateSearchedLabel.text = "Datum isteka: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            else {
                dateSearchedLabel.text = "Датум истека: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            
            dateSearchedLabel.textColor = UIColor.systemGray6
            datesView.addSubview(dateSearchedLabel)
        }
        else
        {
            var dateTimeComponents = calendar.dateComponents(requestedComponents, from: dateSearched!)
            
            if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
               dateSearchedLabel.text = "Datum pretrage: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            else {
                dateSearchedLabel.text = "Датум претраге: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            
            dateSearchedLabel.textColor = UIColor.systemGray6
            datesView.addSubview(dateSearchedLabel)
            
            dateTimeComponents = calendar.dateComponents(requestedComponents, from: expiryDate!)
            let expiryDateLabel = UILabel(frame: CGRect(x: datesView.frame.width/2, y: 0, width: datesView.frame.width/2, height: datesView.frame.height))
            expiryDateLabel.font = UIFont(name: "Futura", size: dateLabelHeight-2)
            
            if UserDefaults.standard.integer(forKey: "alphabet") == 0 {
                expiryDateLabel.text = "Datum isteka: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            else {
                expiryDateLabel.text = "Датум истека: \(dateTimeComponents.day!).\(dateTimeComponents.month!).\(dateTimeComponents.year!)"
            }
            
            expiryDateLabel.textColor = UIColor.systemGray6
            expiryDateLabel.textAlignment = .right
            datesView.addSubview(expiryDateLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
