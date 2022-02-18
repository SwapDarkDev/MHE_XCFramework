//
//  TextAnnotationAlignmentViewViewController.swift
//  Kitaboo
//
//  Created by Sumanth Myrala on 12/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

@objc public class TextAnnotationAlignmentActionView: PlayerActionBar
{
    
    let PenToolBar_ItemWidth = isIpad() ? 62 : 58.4
    let playerBottomBar_Height = isIpad() ? 58 : 58
    @objc public var selectedAlignment:NSTextAlignment = .left
    @objc public var atPoint = CGPoint()
    @objc public var numberOfItems:Int = 0

    func playerBar_itemWidthIphone(_ items: Int) -> Int
    {
        return (Int(UIScreen.main.bounds.size.width)/items)
    }
    func playerBar_itemWidthIphoneColor(_ items: Any) -> Int
    {
        return isIpad() ? 98 : 90
    }
    
    func DefualtFont() -> UIFont?
    {
        return UIFont(name: HDKitabooFontManager.getFontName(), size: isIpad() ? 23 : 20.8)
    }
    
    @objc public func addTextAnnotationAlignmentView(hdThemeVO:KBHDThemeVO,currentBook:KitabooBookVO,parentView:UIView,onView:UIView) {
        self.tag = Int(kPlayerActionBarTypeTextAnnotationAlignment.rawValue)
        self.backgroundColor = hdThemeVO.textAnnotation_align_popup_background
        
        self.addPlayerActionBar(forTextAnnotationAlignment: hdThemeVO)
        let fullWidth = Int(UIScreen.main.bounds.size.width)
        var remainingLeftSpace = (fullWidth - (98 * numberOfItems))/2
        var requiredWidth = remainingLeftSpace +  58
        if (!isIpad() && UIApplication.shared.statusBarOrientation.isLandscape) {
            remainingLeftSpace = (fullWidth - (75 * numberOfItems))/2
            requiredWidth = remainingLeftSpace +  23
        }
        else if((!isIpad() && UIApplication.shared.statusBarOrientation.isPortrait)){
           let itemWidth  =  playerBar_itemWidthIphone(numberOfItems)
            remainingLeftSpace = (fullWidth - (itemWidth * numberOfItems))/2
            requiredWidth = remainingLeftSpace + itemWidth + itemWidth/2 - 92
            if requiredWidth < 0{   
                requiredWidth = 0
            }
        }

        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: CGFloat(requiredWidth)))
        parentView.addConstraint(NSLayoutConstraint(item: onView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: CGFloat(playerBottomBar_Height)))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 184))
        self.layer.borderColor = hdThemeVO.textAnnotation_align_popup_selected_border_color.cgColor
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -0.4, height: 0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.6
    }
    
    func addPlayerActionBar(forTextAnnotationAlignment themeVO: KBHDThemeVO?)
    {
        let numberOfItems = 3
        add(getTextAnnotationAlignmentPlayerItem(withIcon: ICON_LEFT_ALIGN, withActionTag: kTextAnnotationAlignmentTypeLeft, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: 58, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getTextAnnotationAlignmentPlayerItem(withIcon: ICON_CENTER_ALIGN, withActionTag: kTextAnnotationAlignmentTypeCenter, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: 58, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getTextAnnotationAlignmentPlayerItem(withIcon: ICON_RIGHT_ALIGN, withActionTag: kTextAnnotationAlignmentTypeRight, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: 58, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
    }
    
    fileprivate func getTextAnnotationAlignmentPlayerItem(withIcon iconStr: String?, withActionTag playerActionTag: TextAnnotationAlignmentType, with themeVO: KBHDThemeVO?, numberOfitems numberOfItems: Int) -> PlayerActionBarItem?
    {
        
        let actionBarItem = PlayerActionBarItem(frame: CGRect.zero)
        actionBarItem?.tag = Int(playerActionTag.rawValue)
        let textForAction = UILabel()
        textForAction.text = iconStr
        textForAction.textAlignment = .center
        textForAction.font = DefualtFont()
        textForAction.textColor = themeVO?.textAnnotation_align_popup_icon_color
        _ = textForAction.widthAnchor.constraint(equalToConstant: 45)
        actionBarItem?.addSubview(textForAction)
        textForAction.layer.borderWidth = 1.0
        textForAction.layer.cornerRadius = 24
        textForAction.layer.borderColor = UIColor.clear.cgColor
        textForAction.translatesAutoresizingMaskIntoConstraints = false
        
        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .top, relatedBy: .equal, toItem: actionBarItem, attribute: .top, multiplier: 1.0, constant: 5))
//        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .centerX, relatedBy: .equal, toItem: actionBarItem, attribute: .centerX, multiplier: 1.0, constant: 0))
        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .bottom, relatedBy: .equal, toItem: actionBarItem, attribute: .bottom, multiplier: 1.0, constant: -5))
        
        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .left, relatedBy: .equal, toItem: actionBarItem, attribute: .left, multiplier: 1.0, constant: 5))
        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .right, relatedBy: .equal, toItem: actionBarItem, attribute: .right, multiplier: 1.0, constant: -5))
        if selectedAlignment == .left
        {
            if textForAction.text == ICON_LEFT_ALIGN{
            actionBarItem!.selected=true;
            textForAction.layer.borderColor = themeVO!.textAnnotation_align_popup_selected_border_color.cgColor
            }
        }
        else if selectedAlignment == .right
        {
            if textForAction.text == ICON_RIGHT_ALIGN{
                actionBarItem!.selected=true;
                textForAction.layer.borderColor = themeVO!.textAnnotation_align_popup_selected_border_color.cgColor
            }
        }
        else if selectedAlignment == .center
        {
            if textForAction.text == ICON_CENTER_ALIGN{
                actionBarItem!.selected=true;
                textForAction.layer.borderColor = themeVO!.textAnnotation_align_popup_selected_border_color.cgColor
            }
        }
        setAccessibilityForTextAnnotationAlignmentView(actionBarItem : actionBarItem!)
        
        return actionBarItem
    }
    
    func setAccessibilityForTextAnnotationAlignmentView(actionBarItem : PlayerActionBarItem)
       {
          switch actionBarItem.tag
          {
               case Int(kTextAnnotationAlignmentTypeLeft.rawValue):
               actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_ALIGNMENT_LEFT
               break
           
               case Int(kTextAnnotationAlignmentTypeCenter.rawValue):
               actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_ALIGNMENT_CENTER
               break
               
               case Int(kTextAnnotationAlignmentTypeRight.rawValue):
               actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_ALIGNMENT_RIGHT
               break
            
               default:
               break
            }
                 
        }
}
