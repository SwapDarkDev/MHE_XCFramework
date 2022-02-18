//
//  TOCContentCell.swift
//  Kitaboo
//
//  Created by Priyanka Singh on 12/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

@objc open class TOCContentCell: UITableViewCell {
    @IBOutlet open var barView: UIView!
    @IBOutlet open var downArrowButton: UIButton!
    @IBOutlet open var cellLeadConstraint: NSLayoutConstraint!
    @IBOutlet open var dataLabel: UILabel!
    @IBOutlet open var levelLabel: UILabel!
    @IBOutlet open var seperatorSuperviewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet open var seperatorConstraintFromLevelLabel: NSLayoutConstraint!
    @IBOutlet open weak var seperatorView: UIView!
    @IBOutlet open var widthConstraintOflevelLabel: NSLayoutConstraint!
    @IBOutlet open var sectionHeaderButton: UIButton!
    var updatedURL:String!
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc open func configureViewForToc(dataDictionary:NSMutableDictionary,themeVO:KBHDThemeVO){
        self.contentView.backgroundColor = themeVO.toc_popup_background
        self.barView.backgroundColor = themeVO.toc_popup_background
        self.seperatorView.backgroundColor = themeVO.toc_selected_toc_section_divider
        self.dataLabel.textColor = themeVO.toc_description_color
        self.levelLabel.textColor = themeVO.toc_description_color
        let levelCount = (dataDictionary.value(forKey: "level") as! String).components(separatedBy: ".").count
        self.seperatorSuperviewLeadingConstraint.constant =  CGFloat(isIpad() ? (26 * levelCount) : (21*levelCount))
        self.cellLeadConstraint.constant = CGFloat(isIpad() ? (26 * levelCount) : (20*levelCount))
        if let subSectionArray = dataDictionary.value(forKey: "subnodes") as? NSArray{
                if(subSectionArray.count <= 0){
                    self.downArrowButton.isHidden = true
                }
                else{
                    self.downArrowButton.isHidden = false
                    if let isExpanded = dataDictionary.value(forKey: "isExpanded") as? Bool{
                    self.downArrowButton.isSelected = isExpanded;
                    }
                }
            
            }
        else{
            self.downArrowButton.isHidden = true
        }
        let dataText = String(format:"%@ ",(dataDictionary.value(forKey: "title") as? String)! )
        self.dataLabel.text = dataText;
        //self.levelLabel.text = String(format:"%@. ",dataDictionary.value(forKey: "level") as! String)
        self.levelLabel.font = getCustomFontForWeight(isIpad() ? 16:14 ,.light)
        if  (dataDictionary.value(forKey:"isCurrentPage") as? Bool ?? false) {
            self.contentView.backgroundColor = themeVO.toc_selected_toc_section_background
            self.barView.backgroundColor = themeVO.toc_selected_toc_side_tab_background
            self.dataLabel.textColor = themeVO.toc_selected_toc_title_color
            self.levelLabel.textColor = themeVO.toc_selected_toc_title_color
            self.downArrowButton.setTitleColor(themeVO.toc_selected_toc_arrow_color, for: UIControl.State.normal)
            self.downArrowButton.setTitleColor(themeVO.toc_selected_toc_arrow_color, for: UIControl.State.selected)
        }else{
            self.barView.backgroundColor = UIColor.clear
            self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.normal)
            self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.selected)
        }
        self.seperatorSuperviewLeadingConstraint.isActive = true

        self.dataLabel.sizeToFit()
        self.contentView.layoutIfNeeded()
        
    }
    
    @objc open func configureViewForStandards(dataDictionary:NSMutableDictionary,themeVO:KBHDThemeVO){
        self.contentView.backgroundColor = themeVO.toc_popup_background
        self.barView.backgroundColor = themeVO.toc_popup_background
        self.seperatorView.backgroundColor = themeVO.toc_selected_toc_section_divider
        self.dataLabel.textColor = themeVO.toc_description_color
        self.levelLabel.textColor = themeVO.toc_description_color
        let levelCount = (dataDictionary.value(forKey: "level") as! String).components(separatedBy: ".").count
        self.seperatorSuperviewLeadingConstraint.constant =  CGFloat(isIpad() ? (26 * levelCount) : (21*levelCount))
        self.cellLeadConstraint.constant = CGFloat(isIpad() ? (26 * levelCount) : (20*levelCount))
        self.dataLabel.font = getCustomFontForWeight(isIpad() ? 16:14 ,.light)
        if let subSectionArray = dataDictionary.value(forKey: "subnodes") as? NSArray{
            if(subSectionArray.count <= 0){
                self.downArrowButton.isHidden = true
            }
            else{
                self.downArrowButton.isHidden = false
                if let isExpanded = dataDictionary.value(forKey: "isExpanded") as? Bool{
                    self.downArrowButton.isSelected = isExpanded;
                }
            }
            
        }
        else{
            self.downArrowButton.isHidden = true
        }
        var dataText = String(format:"%@ ",(dataDictionary.value(forKey: "title") as? String)! )
        
        self.dataLabel.text = dataText;
        self.downArrowButton.isHidden = false
        self.barView.backgroundColor = UIColor.clear
        self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.normal)
        self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.selected)
        self.seperatorSuperviewLeadingConstraint.isActive = true
        if let subnodesArray = dataDictionary.value(forKey: "subnodes") as? NSArray{
            if let subnodesArrayDict: NSDictionary  = subnodesArray[0] as? NSDictionary{
                if let subnodesArrayDictArray = subnodesArrayDict.value(forKey: "subnodes") as? NSArray{
                    print(subnodesArrayDictArray)
                }
                else{
                    let tocText = String(format:"%@ ",(subnodesArrayDict.value(forKey: "title") as? String)!)
                    let pageText = String(format:"%@ ",(subnodesArrayDict.value(forKey: "resourceURL") as? String)!)
                    if tocText == "toc "
                    {
                        dataText = "Narrative: \(dataText)"
                        self.dataLabel.text = dataText

                    }
                    else if tocText == "web links "
                    {
                        let strokeTextAttributes = [
                            NSAttributedString.Key.foregroundColor :themeVO.toc_selected_toc_arrow_color as Any,
                            NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue]
                            as [NSAttributedString.Key : Any]
                        let partTwo = NSMutableAttributedString(string:dataText, attributes: strokeTextAttributes)
                        
                        let secondStrokeTextAttributes = [
                            NSAttributedString.Key.foregroundColor :themeVO.toc_description_color as Any ] as [NSAttributedString.Key : Any]
                        let partOne = NSMutableAttributedString(string:"Activity: ", attributes: secondStrokeTextAttributes)
                        let combination = NSMutableAttributedString()
                        combination.append(partOne)
                        combination.append(partTwo)
                        self.dataLabel.attributedText = combination
                        
                    }
                    
                    self.downArrowButton.isHidden = true
                    self.updatedURL = pageText
                }
            }
        }
        self.dataLabel.sizeToFit()
        self.contentView.layoutIfNeeded()
    }
    
    @objc open func configureViewForExternalResources(dataDictionary:NSMutableDictionary,themeVO:KBHDThemeVO){
        self.contentView.backgroundColor = themeVO.toc_popup_background
        self.barView.backgroundColor = themeVO.toc_popup_background
        self.seperatorView.backgroundColor = themeVO.toc_selected_toc_section_divider
        self.dataLabel.textColor = themeVO.toc_description_color
        self.levelLabel.textColor = themeVO.toc_description_color
        let levelCount = (dataDictionary.value(forKey: "level") as! String).components(separatedBy: ".").count
        self.seperatorSuperviewLeadingConstraint.constant =  CGFloat(isIpad() ? (26 * levelCount) : (21*levelCount))
        self.cellLeadConstraint.constant = CGFloat(isIpad() ? (26 * levelCount) : (20*levelCount))
        if let subSectionArray = dataDictionary.value(forKey: "subnodes") as? NSArray{
            if(subSectionArray.count <= 0){
                self.downArrowButton.isHidden = true
                if let resourceURL = dataDictionary.value(forKey: "resourceURL"){
                    self.updatedURL = resourceURL as? String
                }
            }
            else{
                self.downArrowButton.isHidden = false
                if let isExpanded = dataDictionary.value(forKey: "isExpanded") as? Bool{
                    self.downArrowButton.isSelected = isExpanded;
                }
            }
            
        }
        else{
                let resourceURL = dataDictionary.value(forKey: "resourceURL") as? String
            self.updatedURL = resourceURL
            self.downArrowButton.isHidden = true
        }
        let dataText = String(format:"%@ ",(dataDictionary.value(forKey: "title") as? String)! )
        self.dataLabel.text = dataText;
        self.levelLabel.text = String(format:"%@. ",dataDictionary.value(forKey: "level") as! String)
        self.levelLabel.font = getCustomFontForWeight(isIpad() ? 16:14 ,.light)
        if  (dataDictionary.value(forKey:"isCurrentPage") as? Bool ?? false) {
            self.contentView.backgroundColor = themeVO.toc_selected_toc_section_background
            self.barView.backgroundColor = themeVO.toc_selected_toc_side_tab_background
            self.dataLabel.textColor = themeVO.toc_selected_toc_title_color
            self.levelLabel.textColor = themeVO.toc_selected_toc_title_color
            self.downArrowButton.setTitleColor(themeVO.toc_selected_toc_arrow_color, for: UIControl.State.normal)
            self.downArrowButton.setTitleColor(themeVO.toc_selected_toc_arrow_color, for: UIControl.State.selected)
        }else{
            self.barView.backgroundColor = UIColor.clear
            self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.normal)
            self.downArrowButton.setTitleColor(themeVO.toc_more_icon_color, for: UIControl.State.selected)
        }
        self.seperatorSuperviewLeadingConstraint.isActive = true
        self.levelLabel.isHidden = true
        self.dataLabel.sizeToFit()
        self.contentView.layoutIfNeeded()
        
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
