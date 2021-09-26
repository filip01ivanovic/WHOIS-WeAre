//
//  BackButton.swift
//  WHOIS WeAre
//
//  Created by Filip Ivanovic on 25/09/2021.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        */
        
        self.layer.cornerRadius = 20
    }
    
}
