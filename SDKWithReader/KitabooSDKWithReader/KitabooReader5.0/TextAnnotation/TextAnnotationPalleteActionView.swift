//
//  TextAnnotationPalleteView.swift
//  Kitaboo
//
//  Created by Sumanth Myrala on 12/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

@objc public class TextAnnotationPalleteActionView: PlayerActionBar
{
    let PenToolBar_ItemWidth = isIpad() ? 62 : 58.4
    let playerBottomBar_Height = isIpad() ? 58 : 50
    @objc public var selectedColor:UIColor = UIColor.clear
    
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
    
    @objc public func addTextAnnotationTextColorView(hdThemeVO:KBHDThemeVO,currentBook:KitabooBookVO,parentView:UIView,onView:UIView)
    {
        self.tag = Int(kPlayerActionBarTypeTextAnnotationColor.rawValue)
        self.backgroundColor = hdThemeVO.textAnnotation_color_popup_background
        
        addPlayerActionBar(forTextAnnotationColor: hdThemeVO)
        
        let numberOfItems = 10
        let actualWidth = Double(playerBar_itemWidthIphone(numberOfItems) * numberOfItems)
        var requiredWidth:CGFloat = CGFloat(actualWidth*0.1);
        if (!isIpad() && UIApplication.shared.statusBarOrientation.isPortrait){
            requiredWidth = 10;
        }
        if UIApplication.shared.statusBarOrientation.isLandscape
        {
            requiredWidth = CGFloat(actualWidth*0.2)
        }
        
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: requiredWidth))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: -requiredWidth))
        parentView.addConstraint(NSLayoutConstraint(item: onView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: CGFloat(playerBottomBar_Height)))
        self.layer.borderColor = hdThemeVO.textAnnotation_color_popup_selected_border_color.cgColor
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -0.4, height: 0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.6
    }
    
    
    fileprivate func addPlayerActionBar(forTextAnnotationColor themeVO: KBHDThemeVO?)
    {
//        let numberOfItems = 10
//        var actualWidth = Double(playerBar_itemWidthIphone(numberOfItems) * numberOfItems)
//        actualWidth = actualWidth - (actualWidth * 0.05)
//        let requiredWidth = (actualWidth / Double(numberOfItems))-3
        
        let numberOfItems = 10
        var actualWidth = Double(playerBar_itemWidthIphone(numberOfItems) * numberOfItems)
        var removeWidth = isIpad() ? CGFloat(actualWidth*0.2) : 20
        if UIApplication.shared.statusBarOrientation.isLandscape
        {
            removeWidth = CGFloat(actualWidth*0.4)
        }
        actualWidth = actualWidth - Double(removeWidth)
        let requiredWidth = actualWidth / Double(numberOfItems)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color1_background, textColor: themeVO!.textAnnotation_color_popup_color1_text_color, itemTag: kTextAnnotationColorTypeColor1,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color2_background, textColor: themeVO!.textAnnotation_color_popup_color2_text_color, itemTag: kTextAnnotationColorTypeColor2,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color3_background, textColor: themeVO!.textAnnotation_color_popup_color3_text_color, itemTag: kTextAnnotationColorTypeColor3,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color4_background, textColor: themeVO!.textAnnotation_color_popup_color4_text_color, itemTag: kTextAnnotationColorTypeColor4,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color5_background, textColor: themeVO!.textAnnotation_color_popup_color5_text_color, itemTag: kTextAnnotationColorTypeColor5,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color6_background, textColor: themeVO!.textAnnotation_color_popup_color6_text_color, itemTag: kTextAnnotationColorTypeColor6,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color7_background, textColor: themeVO!.textAnnotation_color_popup_color7_text_color, itemTag: kTextAnnotationColorTypeColor7,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color8_background, textColor: themeVO!.textAnnotation_color_popup_color8_text_color, itemTag: kTextAnnotationColorTypeColor8,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color9_background, textColor: themeVO!.textAnnotation_color_popup_color9_text_color, itemTag: kTextAnnotationColorTypeColor9,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        
        add(getPenToolColorPalleteItem(bgColor: themeVO!.textAnnotation_color_popup_color10_background, textColor: themeVO!.textAnnotation_color_popup_color10_text_color, itemTag: kTextAnnotationColorTypeColor10,themeVO: themeVO!), withItemsWidth: requiredWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
    }
    
    
    fileprivate func getPenToolColorPalleteItem(bgColor:UIColor,textColor:UIColor,itemTag:TextAnnotationColorType,themeVO:KBHDThemeVO) -> PlayerActionBarItem?
    {
        let numberOfItems = 10
        var actualWidth = Double(playerBar_itemWidthIphone(numberOfItems) * numberOfItems)
        var removeWidth = isIpad() ? CGFloat(actualWidth*0.2) : 20
        
        if UIApplication.shared.statusBarOrientation.isLandscape
        {
            removeWidth = CGFloat(actualWidth*0.4)
        }
        actualWidth = actualWidth - Double(removeWidth)
        let requiredWidth = actualWidth / Double(numberOfItems)-3
        
        let actionBarItem = PlayerActionBarItem(frame: CGRect.zero)
        actionBarItem?.tag = Int(itemTag.rawValue)
        let highlightToolV = HighLightToolView()
        highlightToolV.iconLabel.clipsToBounds = true
        highlightToolV.iconLabel.backgroundColor = bgColor
        highlightToolV.iconLabel.text = "A"
        highlightToolV.iconLabel.font = highlightToolV.iconLabel.font.withSize(15)
        highlightToolV.iconLabel.textColor = textColor
        highlightToolV.contentView.backgroundColor = UIColor.clear
        actionBarItem?.backgroundColor = highlightToolV.contentView.backgroundColor
        highlightToolV.borderView.layer.borderWidth = 1.0
        highlightToolV.iconLabel.layer.borderWidth = 1.0
        highlightToolV.borderView.layer.borderColor = UIColor.clear.cgColor
        highlightToolV.iconLabel.layer.borderColor = UIColor.clear.cgColor
        if UIApplication.shared.statusBarOrientation.isLandscape
        {
            highlightToolV.resetViewForColorPallet(colorHeight: isIpad() ? CGFloat(requiredWidth-(requiredWidth*0.6)) : CGFloat(requiredWidth-(requiredWidth*0.4)))
        }
        else
        {
            highlightToolV.resetViewForColorPallet(colorHeight: isIpad() ? CGFloat(requiredWidth-(requiredWidth*0.6)) : CGFloat(requiredWidth-(requiredWidth*0.35)))
        }
        
        actionBarItem?.addSubview(highlightToolV)
        highlightToolV.translatesAutoresizingMaskIntoConstraints = false
        actionBarItem?.translatesAutoresizingMaskIntoConstraints = false
        actionBarItem?.heightAnchor.constraint(equalToConstant: isIpad() ? 64 : 50).isActive = true
        highlightToolV.leadingAnchor.constraint(equalTo: actionBarItem!.leadingAnchor, constant:0).isActive = true
        highlightToolV.trailingAnchor.constraint(equalTo: actionBarItem!.trailingAnchor, constant: 0).isActive = true
        highlightToolV.topAnchor.constraint(equalTo: actionBarItem!.topAnchor, constant: 0).isActive = true
        highlightToolV.bottomAnchor.constraint(equalTo: actionBarItem!.bottomAnchor, constant: 0).isActive = true
        highlightToolV.layoutIfNeeded()
        if  bgColor == selectedColor
        {
            actionBarItem!.selected=true;
            highlightToolV.borderView.layer.borderColor = themeVO.textAnnotation_color_popup_selected_border_color.cgColor
        }
        setAccessibilityForTextAnnotationPalleteView(actionBarItem: actionBarItem!)
        
        return actionBarItem
    }
    
    func setAccessibilityForTextAnnotationPalleteView(actionBarItem : PlayerActionBarItem)
    {
       switch actionBarItem.tag
       {
            case Int(kTextAnnotationColorTypeColor1.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR1
            break
        
            case Int(kTextAnnotationColorTypeColor2.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR2
            break
            
            case Int(kTextAnnotationColorTypeColor3.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR3
            break
         
            case Int(kTextAnnotationColorTypeColor4.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR4
                       break
            case Int(kTextAnnotationColorTypeColor5.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR5
                   break
            case Int(kTextAnnotationColorTypeColor6.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR6
                   break
            case Int(kTextAnnotationColorTypeColor7.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR7
                   break
            case Int(kTextAnnotationColorTypeColor8.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR8
                   break
            case Int(kTextAnnotationColorTypeColor9.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR9
                   break
            case Int(kTextAnnotationColorTypeColor10.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_PALLETE_COLOR10
                   break
            default:
            break
         }
              
     }
}
