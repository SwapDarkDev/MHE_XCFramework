//
//  HighLightToolView.swift
//  kitaboo
//
//  Created by Priyanka Singh on 07/06/18.
//  Copyright © 2018 Priyanka Singh. All rights reserved.
//

import UIKit

@objc public class HighLightToolView: UIView {

   @objc @IBOutlet weak public var iconLabel: UILabel!
    @objc @IBOutlet weak public var contentView: UIView!

    @IBOutlet weak public var widthConstraintOfIcon: NSLayoutConstraint!
    @IBOutlet weak public var heightConstraintOfIcon: NSLayoutConstraint!
    @IBOutlet weak public var widthConstraintOfBorderView: NSLayoutConstraint!
    @IBOutlet weak public var heightConstraintOfBorderView: NSLayoutConstraint!
    @objc @IBOutlet weak public var borderView: UIView!
    @objc public override init(frame: CGRect) {
        
        super.init(frame: frame);
        Bundle(for: HighLightToolView.self).loadNibNamed("HighLightToolView", owner: self, options: nil);
        addSubview(contentView);
        self.contentView.frame = frame;
        
    }
    @objc public func resetViewForColorPallet(colorHeight:CGFloat){
        self.widthConstraintOfIcon.constant = colorHeight
        self.heightConstraintOfIcon.constant = colorHeight
        
        self.widthConstraintOfBorderView.constant = colorHeight + 14
        self.heightConstraintOfBorderView.constant = colorHeight + 14
        self.iconLabel.layer.cornerRadius = colorHeight/2
        self.borderView.layer.cornerRadius = self.widthConstraintOfBorderView.constant/2
        self.borderView.clipsToBounds = true
        self.iconLabel.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.clear
        self .layoutIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
