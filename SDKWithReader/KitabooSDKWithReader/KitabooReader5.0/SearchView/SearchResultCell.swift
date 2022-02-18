//
//  SearchResultCell.swift
//  Kitaboo
//
//  Created by Priyanka Singh on 18/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var pageNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//333333,2ba0e2
    @objc public func setData(seachResult:TextSearchResult,selectedTextColor:UIColor,textColor:UIColor){
        self.contentLabel.font = getCustomFont(17)
        self.contentLabel.attributedText = IconFontConstants.getNSAttributedCoreTextString(fromDisplay: seachResult.searchResultAttributedString.string, andSearch: seachResult.searchedWord, searchTextColor:selectedTextColor,withTextColor: textColor)
        self.contentLabel.sizeToFit()
//        if let pageNum:String = seachResult.pageIndex as String?{
//            self.pageNumberLabel.text = String(format:"Page %@", pageNum)
//
//        }
//        if(seachResult.pageIndex.length > 0){
//        self.pageNumberLabel.text = String(format:"Page %@", seachResult.pageIndex)
//        }
//        else {
//            self.pageNumberLabel.text = ""
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
