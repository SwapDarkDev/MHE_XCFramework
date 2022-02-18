//
//  TeacherReviewClassListTableViewCell.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 16/06/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

class TeacherReviewClassListTableViewCell: UITableViewCell {

    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak public var classNameLabel: UILabel!
    @IBOutlet weak public var studentSubmitProgressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainContentView.layer.masksToBounds = true
        mainContentView.layer.cornerRadius = isIpad() ? 10 : 5
        mainContentView.layer.borderColor = UIColor.lightGray.cgColor
        mainContentView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
