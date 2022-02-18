//
//  CustomSlider.swift
//  Kitaboo
//
//  Created by Priyanka Singh on 22/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import UIKit

@objc public class CustomSlider: UISlider {
    
        override public func trackRect(forBounds bounds: CGRect) -> CGRect {
            
            //keeps original origin and width, changes height, you get the idea
            let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 4.0))
            super.trackRect(forBounds: customBounds)
            return customBounds
        }

}
