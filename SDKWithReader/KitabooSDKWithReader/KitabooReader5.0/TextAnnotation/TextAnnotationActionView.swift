//
//  TextAnnotationToolView.swift
//  Kitaboo
//
//  Created by Sumanth Myrala on 09/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit

@objc public class TextAnnotationActionView: PlayerActionBar
{
    let playerBottomBar_Height = isIpad() ? 58 : 50
    
    @objc public var textAnnotationBottomMarginConstraint = NSLayoutConstraint()
    @objc public var isTextAnnotationAvailable:Bool = false
    @objc public var isTextAnnotationKeyboardAvailable:Bool = false
    var rendererVC = RendererViewController()
    var activeMode:PlayerActiveMode = kPlayerActiveModeNone
    @objc public var numberOfItems:Int = 0

    func playerBar_itemWidthIphone(_ items: Int) -> Int
    {
        if isIpad()
        {
            return 98
        }
        else if (!isIpad() && UIApplication.shared.statusBarOrientation.isLandscape){
            return 75
        }
        return isIpad() ? 98 : Int(UIScreen.main.bounds.size.width)/items
    }
    func playerBar_itemWidthIphoneColor(_ items: Any) -> Int
    {
        return isIpad() ? 98 : 90
    }
    
    func DefualtFont() -> UIFont? {
        return UIFont(name: HDKitabooFontManager.getFontName(), size: isIpad() ? 23 : 20.8)
    }
    
    
    @objc public func addPlayerBottomBarForTextAnnotation(parentView:UIView, hdThemeVO:KBHDThemeVO,bookType:KitabooBookVO,renderer:RendererViewController)
    {
        rendererVC = renderer
        self.tag = Int(kPlayerActionBarTypeTextAnnotation.rawValue)
        self.backgroundColor = hdThemeVO.textAnnotation_background
        
        addPlayerBottomBar(forTextAnnotation: hdThemeVO)
        
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant:0))
        textAnnotationBottomMarginConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        parentView.addConstraint(textAnnotationBottomMarginConstraint)
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant:CGFloat(playerBottomBar_Height)))
        
//        self.layer.borderColor = hdThemeVO.textAnnotation_lineColor.cgColor
//        self.layer.borderWidth = 1.5
        self.addTopBorder(with: hdThemeVO.textAnnotation_lineColor)
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -0.4, height: 0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.6
    }
    
    fileprivate func addPlayerBottomBar(forTextAnnotation themeVO: KBHDThemeVO?)
    {
        if isIpad()
        {
            numberOfItems = isTextAnnotationAvailable ? 6 : 5
        }
        else
        {
            numberOfItems = isTextAnnotationAvailable ? 7 : 6
        }
        var itemWidth = Double(playerBar_itemWidthIphone(numberOfItems))
        if isIpad() {
        itemWidth  =  Double(playerBar_itemWidthIphone(numberOfItems))/2
        }
        
        
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }
        self.add(getTextAnnotationPlayerItem(withIcon: VIDEO_PLAYER_CLOSE_ICON, withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }
        self.add(getTextAnnotationPlayerItem(withIcon: ICON_LEFT_ALIGN, withActionTag: kTextAnnotationItemTypeAlignment, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }
        self.add(getTextAnnotationPlayerItem(withIcon: ICON_TEXT_COLOR, withActionTag: kTextAnnotationItemTypeTextColor, with: themeVO, numberOfitems: numberOfItems), withItemsWidth:itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }
        self.add(getTextAnnotationPlayerItem(withIcon: ICON_TEXTANNOTATION_ADD, withActionTag: kTextAnnotationItemTypeAdd, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }

        if isTextAnnotationAvailable == true
        {
            self.add(getTextAnnotationPlayerItem(withIcon: ICON_DELETE_OUTLINE, withActionTag: kTextAnnotationItemTypeDelete, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
            if isIpad() {
                self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
            }
        }
        
        
        self.add(getTextAnnotationPlayerItem(withIcon: ICON_CHECK, withActionTag: kTextAnnotationItemTypeSave, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        if isIpad() {
            self.add(getTextAnnotationPlayerItem(withIcon: "", withActionTag: kTextAnnotationBarItemTypeClose, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: false)
        }
        
        if !isIpad()
        {
            self.add(getTextAnnotationPlayerItem(withIcon: ICON_KEYBOARD_DOWN, withActionTag: kTextAnnotationItemTypeKeyboard, with: themeVO, numberOfitems: numberOfItems), withItemsWidth: itemWidth, withItemAlignments: PlayerActionBarAlignmentCenter, isTappable: true)
        }
    }
    
    fileprivate func getTextAnnotationPlayerItem(withIcon iconStr: String?, withActionTag playerActionTag: TextAnnotationBarItemType, with themeVO: KBHDThemeVO?, numberOfitems numberOfItems: Int) -> PlayerActionBarItem?
    {
        let actionBarItem = PlayerActionBarItem(frame: CGRect.zero)
        actionBarItem!.tag = Int(playerActionTag.rawValue)
        let textForAction = UILabel()
        textForAction.text = iconStr
        textForAction.textAlignment = .center
        textForAction.font = DefualtFont()
        textForAction.textColor = themeVO?.textAnnotation_iconsColor
        _ = textForAction.widthAnchor.constraint(equalToConstant: CGFloat(playerBar_itemWidthIphone(numberOfItems)))
        actionBarItem!.addSubview(textForAction)
        textForAction.translatesAutoresizingMaskIntoConstraints = false
        
        actionBarItem!.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .top, relatedBy: .equal, toItem: actionBarItem, attribute: .top, multiplier: 1.0, constant: 0))
        actionBarItem?.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .centerX, relatedBy: .equal, toItem: actionBarItem, attribute: .centerX, multiplier: 1.0, constant: 0))
        actionBarItem!.addConstraint(NSLayoutConstraint(item: textForAction, attribute: .bottom, relatedBy: .equal, toItem: actionBarItem, attribute: .bottom, multiplier: 1.0, constant: 0))
        setAccessibilityForTextAnnotationView(actionBarItem: actionBarItem!)
        
        return actionBarItem
    }
    @objc public func getTextAnnotationViewItem(withTag penToolBarItemType: NSInteger) -> PlayerActionBarItem?
    {
        for playerActionBarItem in self.getTappableItems()
        {
            let item = playerActionBarItem as! PlayerActionBarItem
            if item.tag == penToolBarItemType
            {
                return playerActionBarItem as? PlayerActionBarItem
            }
        }
        return nil
    }
    @objc public func updateSelectedLabelItem(isSelected:Bool,themeVO:KBHDThemeVO,tag:NSInteger)
    {
        for itemView in self.getTextAnnotationViewItem(withTag: tag)!.subviews
        {
            if (itemView is UILabel)
            {
                let itemLabel = itemView as? UILabel
                if isSelected{
                    itemLabel?.textColor = themeVO.textAnnotation_selected_icon_color
                    itemLabel?.backgroundColor = themeVO.textAnnotation_selected_icon_bg
                }
                else{
                    itemLabel?.textColor = themeVO.textAnnotation_iconsColor
                    itemLabel?.backgroundColor = themeVO.textAnnotation_background
                }
            }
        }
    }
    @objc public func updateTextAnnotationSaveItem(isTextAvailable:Bool,themeVO:KBHDThemeVO)
     {
        let item:PlayerActionBarItem = self.getTextAnnotationViewItem(withTag: 5)!
        for itemView in item.subviews
        {
            if (itemView is UILabel)
            {
                let itemLabel = itemView as? UILabel
                if isTextAvailable
                {
                    item.enabled = true
                    itemLabel?.textColor = themeVO.textAnnotation_iconsColor
                }
                else{
                    item.enabled = false
                    itemLabel?.textColor = themeVO.textAnnotation_disabled_iconColor.withAlphaComponent(0.5)
                }
            }
        }
        
       
    }
    
    func addTopBorder(with color: UIColor?) {
        let borderWidth: CGFloat = (isIpad()) ? 1.01 : 0.5
        let topBorderView = UIView()
        topBorderView.backgroundColor = color
        topBorderView.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: borderWidth)
        topBorderView.autoresizingMask = .flexibleWidth
        addSubview(topBorderView)
    }
    
    func setAccessibilityForTextAnnotationView(actionBarItem : PlayerActionBarItem)
    {
       switch actionBarItem.tag
       {
            case Int(kTextAnnotationBarItemTypeClose.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_CLOSE_BUTTON
            break
        
            case Int(kTextAnnotationItemTypeAlignment.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_TEXT_ALIGNMENT
            break
            
            case Int(kTextAnnotationItemTypeTextColor.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_TEXT_COLOR
            break
        
            case Int(kTextAnnotationItemTypeAdd.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_ADD_TEXT
            break
            
            
            case Int(kTextAnnotationItemTypeDelete.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_DELETE_BUTTON
            break
            
            
            case Int(kTextAnnotationItemTypeSave.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_SAVE_BUTTON
            break
            
            
            case Int(kTextAnnotationItemTypeKeyboard.rawValue):
            actionBarItem.accessibilityIdentifier = TEXT_ANNOTATION_KEYBOARD
            break
            
           default:
            break
        }
    }
}
