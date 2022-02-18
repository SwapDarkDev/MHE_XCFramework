//
//  TOCTableViewCell.swift
//  Kitaboo
//
//  Created by Hurix System on 20/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import UIKit

open class TOCTableViewCell: UITableViewCell {
    @IBOutlet open var pageLabel: UILabel!
    @IBOutlet open var dataLabel: UILabel!
    @IBOutlet open var timeLabel: UILabel!
    @IBOutlet open var bookmarkLabel: UILabel!
    @IBOutlet open var barLabel: UILabel!
    @IBOutlet open var cellLeadConstraint: NSLayoutConstraint!
    @IBOutlet open var timeLabelBottomConstarint: NSLayoutConstraint!
    @IBOutlet open var verticalCenterConstarint: NSLayoutConstraint!

    @IBOutlet weak open var bookmarkTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak open var seperatorViewForHeaderView: UIView!
    var dataDict : (NSMutableDictionary)!
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
