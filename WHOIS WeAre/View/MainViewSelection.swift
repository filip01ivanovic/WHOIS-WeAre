//
//  MainViewSelection.swift
//  WHOIS WeAre
//
//  Created by Aleksa on 9/25/21.
//  Copyright © 2021 Filip Ivanovic. All rights reserved.
//

import UIKit

@IBDesignable
class MainViewSelection: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var imageName = ""
    func customize()
    {
        backgroundColor = #colorLiteral(red: 0.9312936231, green: 0.9312936231, blue: 0.9312936231, alpha: 1)
        let marginHorizontal = CGFloat(10.0)
        let marginVertical = CGFloat(10.0)
        let width = frame.width - 2*marginHorizontal
        let height = frame.height - 2*marginVertical
        let imageView = UIImageView(frame: CGRect(x: marginHorizontal, y: marginVertical, width: width, height: height))
        if imageName == "" {
            return
        }
        imageView.image = UIImage(named: imageName)
        addSubview(imageView)
    }
    
    override func prepareForInterfaceBuilder() {
        customize()
    }
    /*
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        self.imageName = imageName
    }*/
    /*
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        customize()
    }

}
