//
//  HighlightView.swift
//  kitaboo
//
//  Created by Priyanka Singh on 04/06/18.
//  Copyright © 2018 Priyanka Singh. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

@objc public class HighlightView: HighlightActionView{
    
    @objc public var highLightToolActions:((HighLightToolView,String) -> Void)?
    @objc public var highlightTextAction:((HighLightToolView,String) -> Void)?
    @objc public var selectedColorStr:String!
    @objc public var highlighColorsArray : NSMutableArray! = NSMutableArray.init()
    var colorsHeight : CGFloat = 0
    var selectedViewBorderColor:UIColor = UIColor.black
    var highlighToolsArray : NSMutableArray! = NSMutableArray.init()
    var addHighLightButton :Bool = false
    var showHighLightColors:Bool = false
    
    @IBOutlet weak public var horizontalColorsStackConstraint: NSLayoutConstraint!
    @IBOutlet weak public var horizontalStackForHighLightTools: UIStackView!
    @IBOutlet weak public var horizontalStackForColors: UIStackView!
    @IBOutlet public var contentView: UIView!

    /* init method
     @param1 frame
     @param2 selectedColor
     @param3 selectedColor already selected color
     @param4 selectedBorderColor selection
     */
    @objc public init(frame: CGRect,selectedColor:String,selectedBorderColor:UIColor) {
        super.init(frame: frame);
        highLightView_init(selectedColor:selectedColor,frame: frame,selectedBorderColor:selectedBorderColor);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func highLightView_init(selectedColor:String,frame: CGRect,selectedBorderColor:UIColor){
        
        Bundle(for: HighlightView.self).loadNibNamed("HighlightView", owner: self, options: nil);
        addSubview(contentView);
        self.contentView.frame = frame;
        selectedViewBorderColor = selectedBorderColor;
//        contentView.backgroundColor = UIColor.clear;
        contentView.layer.masksToBounds = false;
        contentView.layer.shadowOffset = CGSize(width:0.0,height:4.0);
        contentView.layer.shadowRadius = 4.0;
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowColor = UIColor.black.cgColor
        highlighColorsArray.removeAllObjects()
        self.layoutIfNeeded()
        horizontalColorsStackConstraint.constant = 0;
        self.backgroundColor = UIColor.white
        
    }
    
    /* call this method to addHighlight button to highlight view
     @param1 highLightTool view that needs to be added
     */
    @objc public func addHighLightToolbutton(highLightTool:UIView){
        let highlightToolButton = UIButton(frame: CGRect(x: 0, y: 0, width: highLightTool.frame.width, height: highLightTool.frame.height))
        let highLightTool:HighLightToolView = highLightTool as! HighLightToolView
        highlightToolButton.addTarget(self, action: #selector(HighlightView.hightLightButtonAction(button:)),
                                      for: UIControl.Event.touchUpInside)
        highLightTool.widthAnchor.constraint(equalToConstant:highLightTool.frame.width).isActive = true;
        highLightTool.isUserInteractionEnabled = true;
        highLightTool.addSubview(highlightToolButton)
        highlightToolButton.backgroundColor = UIColor.clear
        if(highLightTool.iconLabel != nil){
        if(highLightTool.iconLabel.text == ICON_DELETE_OUTLINE){
            highLightTool.iconLabel.alpha = 0.6;
            highLightTool.isUserInteractionEnabled = false;

        }
        else{
            highLightTool.iconLabel.alpha = 1;
            highLightTool.isUserInteractionEnabled = true;
            }
        }
        horizontalStackForHighLightTools.addArrangedSubview(highLightTool)
        highlightToolButton.tag = horizontalStackForHighLightTools.subviews.firstIndex(of: highLightTool)! + 100
        highlightToolButton.accessibilityIdentifier = "highlight_\(highLightTool.accessibilityIdentifier!)"
    }
    
    /* call this method to reset highlight view
     @param1 highLightTool view that needs to be added
     */
    @objc public func resetHighlightView(){
        showHighLightColors = false;
        if(self.highlightVO != nil){
            selectedColorStr = self.highlightVO.backgroundColor;
        }
        else{
            selectedColorStr = nil;
        }
        for view in horizontalStackForHighLightTools.subviews {
            let highlightView:HighLightToolView = view as! HighLightToolView
            highlightView.borderView.layer.borderColor = UIColor.clear.cgColor;
//            highlightView.contentView.backgroundColor = UIColor(hexString: "F7F7F7");
//            highlightView.iconLabel.textColor = UIColor(hexString: "3B799D");
            if(selectedColorStr != nil){
                if(horizontalStackForHighLightTools.subviews.firstIndex(of: view) == highlighColorsArray.index(of: selectedColorStr as Any)){
                    highlightView.borderView.layer.borderColor = UIColor.blue.cgColor
                }
                highlightView.iconLabel.alpha = 1;
                if(highlightView.iconLabel.text == ICON_DELETE_OUTLINE){
                    highlightView.iconLabel.alpha = 1;
                    highlightView.isUserInteractionEnabled = true;
                }
            }
            else{
                    if(highlightView.iconLabel.text == ICON_DELETE_OUTLINE){
                        highlightView.iconLabel.alpha = 0.6;
                        highlightView.isUserInteractionEnabled = false;
                    }
                
            }
        }
        horizontalColorsStackConstraint.constant = 0;
    }
    
    //Mark button actions
    func showHighLightAction(showHighLightColors: Bool) {
        if(showHighLightColors){
            horizontalStackForColors.isHidden = false
            horizontalColorsStackConstraint.constant = colorsHeight;
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }
        else{
            horizontalStackForColors.isHidden = true
            horizontalColorsStackConstraint.constant = 0;
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - colorsHeight)
        }
    }
    
    @objc func hightLightButtonAction(button:UIButton){
        if(selectedColorStr == nil){
            selectedColorStr = (highlighColorsArray.object(at: 0) as! String)
        }
        if(button.tag == 2323){
            self.showHighLightColors = !self.showHighLightColors
            self.showHighLightAction(showHighLightColors: self.showHighLightColors)
        }
        else {
            let hightLightToolView:HighLightToolView = horizontalStackForHighLightTools.subviews[button.tag - 100] as! HighLightToolView
//            hightLightToolView.contentView.backgroundColor = UIColor(hexString: "3B799D");
//            hightLightToolView.iconLabel.textColor = UIColor.white;

            if let highLightAction = self.highLightToolActions{
                highLightAction(hightLightToolView,selectedColorStr)
            }
        }
        
    }
    
  @objc  func hightLightColorAction(button:UIButton){
        
        for view in horizontalStackForHighLightTools.subviews {
            let highlightView:HighLightToolView = view as! HighLightToolView
            highlightView.borderView.layer.borderColor = UIColor.clear.cgColor;
            if(highlightView.iconLabel.text == ICON_DELETE_OUTLINE){
                highlightView.iconLabel.alpha = 1;
                highlightView.isUserInteractionEnabled = true;
            }
        }
        
    selectedColorStr = (self.highlighColorsArray .object(at: button.tag - 100) as! String)
        let hightLightToolView:UIView
        if(addHighLightButton){
            hightLightToolView = horizontalStackForColors.subviews[button.tag - 100]
        }else{
            hightLightToolView = horizontalStackForHighLightTools.subviews[button.tag - 100]
        }
        if let highlightTextAction = self.highlightTextAction{
            let hightLightview = (hightLightToolView as! HighLightToolView)
            hightLightview.borderView.layer.borderColor = selectedViewBorderColor.cgColor
            highlightTextAction(hightLightToolView as! HighLightToolView,self.selectedColorStr)
        }
    AnalyticsManager.getInstance()?.notifyEvent(KitabooReaderEventConstant.highlightEventName, withEventInfo: [KitabooReaderEventConstant.highlightEventParameterNoteColor:selectedColorStr!])
    }
    
    @objc public func addColorView(hightlighColorView:UIView,color:String){
    
        let highlightToolButton = UIButton(frame: CGRect(x: 0, y: 0, width: hightlighColorView.frame.width, height:  hightlighColorView.frame.height))
        highlightToolButton.addTarget(self, action: #selector(HighlightView.hightLightColorAction(button:)),
                                      for: UIControl.Event.touchUpInside)
        hightlighColorView.widthAnchor.constraint(equalToConstant:hightlighColorView.frame.width).isActive = true;
        hightlighColorView.heightAnchor.constraint(equalToConstant:hightlighColorView.frame.height).isActive = true;
        hightlighColorView.isUserInteractionEnabled = true;
        hightlighColorView.addSubview(highlightToolButton)
        highlightToolButton.backgroundColor = UIColor.clear
        colorsHeight = hightlighColorView.frame.size.height
        horizontalColorsStackConstraint.constant = colorsHeight;
        highlighColorsArray.add(color)
        
        if(addHighLightButton){
            horizontalStackForColors.addArrangedSubview(hightlighColorView)
            highlightToolButton.tag = horizontalStackForColors.subviews.firstIndex(of: hightlighColorView)! + 100
            
        }else{
            horizontalStackForHighLightTools.addArrangedSubview(hightlighColorView)
            highlightToolButton.tag = horizontalStackForHighLightTools.subviews.firstIndex(of: hightlighColorView)! + 100
        }
            highlightToolButton.accessibilityIdentifier = "highlight_\(color)"
    }
    
    @objc public func addShowHideHightLightsView(highLightTool:UIView){
        let highlightToolButton = UIButton(frame: CGRect(x: 0, y: 0, width: highLightTool.frame.width, height:  highLightTool.frame.height))
        highlightToolButton.addTarget(self, action: #selector(HighlightView.hightLightButtonAction(button:)),
                                      for: UIControl.Event.touchUpInside)
        highLightTool.widthAnchor.constraint(equalToConstant:highLightTool.frame.width).isActive = true;
        highLightTool.heightAnchor.constraint(equalToConstant:highLightTool.frame.height).isActive = true;
        addHighLightButton = true;
        highLightTool.isUserInteractionEnabled = true;
        highLightTool.addSubview(highlightToolButton)
        highlightToolButton.backgroundColor = UIColor.clear
        horizontalStackForHighLightTools.addArrangedSubview(highLightTool)
        highlightToolButton.tag = 2323
    }
    
    @objc public func changeHighLightToolButtonIcon(iconText: String, highlightItemType: HighlightItemType) {
        for view in horizontalStackForHighLightTools.subviews {
            if view.tag == highlightItemType.rawValue {
                if let highLightToolView = view as? HighLightToolView {
                    highLightToolView.iconLabel.text = iconText
                }
            }
        }
    }
}
