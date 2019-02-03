//
//  dogCell.swift
//  Dog Breeds
//
//  Created by Jaden Banson on 2019-02-02.
//  Copyright © 2019 Jaden Banson. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper

class ExampleCardCell: CardCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    /**
     We use this function to calculate and set a random backgroundcolor.
     */
    public func setRandomBackgroundColor() {
        
        let randomRed: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 12
        
        super.layoutSubviews()
    }
}
