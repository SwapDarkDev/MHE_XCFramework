//
//  HelpScreenViewController.swift
//  Kitaboo 5.0
//
//  Created by Manoranjan on 15/07/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit

struct HelpScreenConstants
{
     static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: HelpScreen.self)
    
}

@objc public class HelpDescriptor: NSObject {
    var icon: UILabel
    var helpTitle: String = ""
    var helpText: String = ""
    var frameUsed: CGRect?
    var combinedTagName: String = ""
    @objc public var onSecondScreen: Bool = false
    
    @objc public init (icon: UILabel,helpTitle:String, helpText: String, tagName: String) {
        self.icon = icon
        self.helpText = helpText
        self.helpTitle = helpTitle
        self.combinedTagName = tagName
    }
}

@objc public protocol HelpDelegate {
    func swipeAtIndex(_ index: Int)
    func didRemovedHelpScreen()
}

@objc open class HelpScreen: UIViewController {
    @objc public var helpDescriptors: [HelpDescriptor] = []
    @objc public var showSecondScreen: Bool = false
    @objc public var isForTeacherReview: Bool = false
    @objc public var isForBookShelf: Bool = false
    @objc public var isOnSecondScreenOnHelpScreen: Bool = false
    @objc weak public var delegate: HelpDelegate?
    var combLineDecrementVal:CGFloat = 0.0
    var combLineIncrementVal:CGFloat = 0.0
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 2
        pc.isUserInteractionEnabled = false
        return pc
    }()
    var labels: [UILabel] = []
    var layers: [CALayer] = []
    var images: [UIButton] = []
    public var button: UIButton =  {
        var b = UIButton()
        var titleString : NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It"))
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It").count))
        b.setAttributedTitle(titleString, for: UIControl.State())
        b.titleLabel?.adjustsFontSizeToFitWidth=true
        return b
    }()
    
    private var backgroundColor: String? = "#000000"
    private var lineColor: String? = "#FFFFFF"
    var ellipseColor: String? = "#00d9fa"
    var iconColor: String? = "#FFFFFF"
    var titleTextColor: String? = "#00d9fa"
    var descriptionTextColor: String? = "#FFFFFF"
    var gotItButtonBackgroundColor: String? = "#095e8e"
    var gotItButtonTextColor: String? = "#FFFFFF"
    var skipButtonBackgroundColor: String? = "#FFFFFF"
    var skipButtonTextColor: String? = "#000000"
    
    @objc public func setBackGroundColor(color:String)
    {
        backgroundColor = color
        self.view.backgroundColor = UIColor.init(hexString: backgroundColor).withAlphaComponent(0.7)
    }
    
    @objc public func setLineColor(color:String)
    {
        lineColor = color
    }
    
    @objc public func setEllipseColor(color:String)
    {
        ellipseColor = color
    }
    
    @objc public func setIconColor(color:String)
    {
        iconColor = color
    }
    
    @objc public func setTitleTextColor(color:String)
    {
        titleTextColor = color
    }
    
    @objc public func setDescriptionTextColor(color:String)
    {
        descriptionTextColor = color
    }
    
    @objc public func setGotItButtonBackgroundColor(color:String)
    {
        gotItButtonBackgroundColor = color
    }
    
    @objc public func setGotItButtonTextColor(color:String)
    {
        gotItButtonTextColor = color
    }
    
    @objc public func setSkipButtonBackgroundColor(color:String)
    {
        skipButtonBackgroundColor = color
    }
    
    @objc public func setSkipButtonTextColor(color:String)
    {
        skipButtonTextColor = color
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()        
        self.view.backgroundColor = UIColor.init(hexString: backgroundColor).withAlphaComponent(0.7)
        
    }
    
    
    override open func viewWillAppear(_ animated: Bool){
        button.addTarget(self, action: #selector(removeMyself), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        button.setRoundedCornerWithRadius( isIpad() ? 20:15)
        button.titleLabel?.font = getCustomFontForWeight(isIpad() ? 16:12,.bold)
        setUpViews()
        if showSecondScreen {
            var gesture = UISwipeGestureRecognizer(target: self, action: #selector(HelpScreen.swipeLeft(_:)))
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(gesture)
            gesture = UISwipeGestureRecognizer(target: self, action: #selector(HelpScreen.swipeRight(_:)))
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(gesture)
            self.view.setNeedsDisplay()
            button.backgroundColor = UIColor.init(hexString: skipButtonBackgroundColor)
            let titleString : NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("HELP_SKIP_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Skip"))
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: skipButtonTextColor)!, range: NSMakeRange(0, NSLocalizedString("HELP_SKIP_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Skip").count))
            button.setAttributedTitle(titleString, for: UIControl.State())
        }
        else
        {
            let titleString : NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It"))
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: gotItButtonTextColor)!, range: NSMakeRange(0, NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It").count))
            button.setAttributedTitle(titleString, for: UIControl.State())
            button.backgroundColor = UIColor.init(hexString: gotItButtonBackgroundColor)
        }
    }
    
    
    //Set all buttons,arrows,title & description on help screen view
    @objc public func setUpViews()
    {
        self.removeViews()
        if(isForTeacherReview && isIpad())
        {
            button.frame = CGRect(x: isRTL() ? 30 : self.view.frame.size.width  - 130,y: self.view.frame.size.height - 70, width: 100.0, height: 40.0)
            if(!isForBookShelf)
            {
                pageControl.frame = CGRect(x: ((self.view.frame.size.width / 2.0) - 50),y: self.view.frame.size.height-150, width: 100, height: 50)
                self.view.addSubview(pageControl)
            }
        }
        else
        {
            if(isForBookShelf)
            {
                button.frame = CGRect(x: self.view.frame.size.width  - (isIpad() ? 130:90),y: 30, width: isIpad() ? 100:70, height: isIpad() ? 40:30)
            }
            else
            {
                button.frame = CGRect(x: (self.view.frame.size.width / 2.0) - (isIpad() ? 50:35),y: 30, width: isIpad() ? 100.0:80, height: isIpad() ? 40:30)
                pageControl.frame = CGRect(x: ((self.view.frame.size.width / 2.0) - 100),y: button.frame.size.height + 40, width: 200, height: 50)
                self.view.addSubview(pageControl)
            }
        }
        var lineDecrementVal:CGFloat = -1
        var lineIncrementVal=CGFloat()
        var topLineDecrementVal=CGFloat()
        var topLineIncrementVal:CGFloat = -2
        var topPadding:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if(isForBookShelf)
            {
                topPadding = (window?.safeAreaInsets.bottom)! + (window?.safeAreaInsets.top)!
            }
            else
            {
                topPadding = (window?.safeAreaInsets.top)!
            }
        }
        var desc = (showSecondScreen && self.pageControl.currentPage == 1) ?  helpDescriptors.filter({ $0.onSecondScreen == true}) :  helpDescriptors.filter({ $0.onSecondScreen == false})
        for helpDescriptor in desc{
            helpDescriptor.frameUsed = (UIApplication.shared.keyWindow?.convert(helpDescriptor.icon.frame, from: helpDescriptor.icon.superview))!
            
            helpDescriptor.frameUsed = CGRect(x: (helpDescriptor.frameUsed?.origin.x)!, y: ((helpDescriptor.frameUsed?.origin.y)! - topPadding), width: (helpDescriptor.frameUsed?.size.width)!, height: (helpDescriptor.frameUsed?.size.height)!)
        }
        desc.sort {
            $0.frameUsed!.origin.x < $1.frameUsed!.origin.x
        }
        let eachDescr =   desc.filter({ $0.combinedTagName == "" && ($0.frameUsed?.origin.y)!>(self.view.frame.size.height/2)})
        if(eachDescr.count>1)
        {
            lineIncrementVal = ((5.0/CGFloat(eachDescr.count))*CGFloat(eachDescr.count-1))
        }
        else
        {
            lineIncrementVal = 0.0
        }
        
        for helpDescriptor in isRTL() ? desc.reversed() : desc {
            if(helpDescriptor.frameUsed?.size.width == 0 || helpDescriptor.frameUsed?.size.height == 0)
            {
                helpDescriptor.frameUsed = CGRect(x: helpDescriptor.frameUsed!.origin.x, y: helpDescriptor.frameUsed!.origin.y, width: 23, height: 58)
            }
            if(helpDescriptor.combinedTagName=="PenColor" || helpDescriptor.combinedTagName=="Arrow")
            {
                
            }
            else
            {
                var startYPoint:CGFloat = 0.0
                if((helpDescriptor.frameUsed?.origin.y)!<(self.view.frame.size.height/2))
                {
                    if(helpDescriptor.onSecondScreen)
                    {
                        startYPoint = ((self.view.frame.size.height/2)*(5+topLineDecrementVal))/10;
                        topLineDecrementVal=topLineDecrementVal+CGFloat((5.0/CGFloat(desc.count)))
                    }
                    else
                    {
                        startYPoint = (self.view.frame.size.height*(5+topLineIncrementVal))/10;
                        topLineIncrementVal=topLineIncrementVal-CGFloat((5.0/CGFloat(desc.count)))
                    }
                    if startYPoint < 70 {
                        startYPoint = 70
                    }
                }
                else
                {
                    if(helpDescriptor.onSecondScreen)
                    {
                        startYPoint = ((helpDescriptor.frameUsed?.origin.y)! * (5+lineIncrementVal))/10;
                        lineIncrementVal=lineIncrementVal-CGFloat((5.0/CGFloat(desc.count)))
                    }
                    else
                    {
                        
                        let title = NSLocalizedString("SEARCH", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Search")
                        if !isIpad() && UIDevice.current.orientation.isLandscape && (helpDescriptor.helpTitle == title) {
                            //Add 16 value for search to avoid overlapping
                            startYPoint = ((self.view.frame.size.height*(5+lineDecrementVal))/10) + 16;
                        } else {
                            startYPoint = (self.view.frame.size.height*(5+lineDecrementVal))/10;
                        }
                        lineDecrementVal=lineDecrementVal+CGFloat((5.0/CGFloat(desc.count)))
                    }
                }
                
                //add btn icon
                if(helpDescriptor.icon.isKind(of: UILabel.self))
                {
                    let eachBtn = UIButton.init()
                    eachBtn.setTitleColor(UIColor.init(hexString: iconColor), for: .normal)
                    eachBtn.titleLabel?.font = helpDescriptor.icon.font
                    eachBtn.setTitleForAllState(helpDescriptor.icon.text)
                    eachBtn.frame = helpDescriptor.frameUsed!
                    self.view.addSubview(eachBtn)
                    images.append(eachBtn)
                }
                else
                {
                    
                }
                
                //add vertical line
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x:helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2), y:startYPoint))
                if((helpDescriptor.frameUsed?.origin.y)!<(self.view.frame.size.height/2))
                {
                    linePath.addLine(to: CGPoint(x:helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2), y:helpDescriptor.frameUsed!.origin.y+(helpDescriptor.frameUsed?.size.height)!+5))
                }
                else
                {
                    linePath.addLine(to: CGPoint(x:helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2), y:helpDescriptor.frameUsed!.origin.y-3))
                }
                linePath.close()
                linePath.lineWidth = 10
                linePath.stroke()
                linePath.fill()
                let linelayer = CAShapeLayer()
                linelayer.path = linePath.cgPath
                linelayer.strokeColor = UIColor.init(hexString: lineColor)?.cgColor
                linelayer.fillColor = UIColor.init(hexString: lineColor)?.cgColor
                linelayer.lineWidth=2
                self.view.layer.addSublayer(linelayer)
                layers.append(linelayer)
                
                //add circle
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2),y: startYPoint), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                let circleLayer = CAShapeLayer()
                circleLayer.path = circlePath.cgPath
                circleLayer.fillColor = UIColor.init(hexString: ellipseColor)?.cgColor
                circleLayer.strokeColor = UIColor.init(hexString: ellipseColor)?.cgColor
                circleLayer.lineWidth = 3.0
                self.view.layer.addSublayer(circleLayer)
                layers.append(circleLayer)
                
                //add title text label
                let helpTitleTextlabel = UILabel()
                helpTitleTextlabel.text = helpDescriptor.helpTitle
                helpTitleTextlabel.textColor = UIColor.init(hexString: titleTextColor)
                helpTitleTextlabel.numberOfLines = 0
                helpTitleTextlabel.font = getCustomFontForWeight(isIpad() ? 16:12,.bold)
                helpTitleTextlabel.textAlignment = NSTextAlignment.center
                helpTitleTextlabel.lineBreakMode = .byWordWrapping
                let titleSize = helpTitleTextlabel.intrinsicContentSize
                if(isRTL())
                {
                    if(helpDescriptor.onSecondScreen || ((helpDescriptor.frameUsed!.origin.x-titleSize.width)<0))
                    {
                        helpTitleTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)+10, y: startYPoint-5, width: helpTitleTextlabel.frame.width, height: helpTitleTextlabel.frame.height)
                    }
                    else
                    {
                            helpTitleTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)-titleSize.width-10, y: startYPoint-5, width: helpTitleTextlabel.frame.width, height: helpTitleTextlabel.frame.height)
                    }
                }
                else
                {
                    if(helpDescriptor.onSecondScreen || ((helpDescriptor.frameUsed!.origin.x+helpDescriptor.frameUsed!.size.width+titleSize.width+40)>self.view.frame.size.width))
                    {
                        helpTitleTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)-titleSize.width-10, y: startYPoint-5, width: helpTitleTextlabel.frame.width, height: helpTitleTextlabel.frame.height)
                    }
                    else
                    {
                        helpTitleTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)+10, y: startYPoint-5, width: helpTitleTextlabel.frame.width, height: helpTitleTextlabel.frame.height)
                    }
                }
                helpTitleTextlabel.sizeToFit()
                self.view.addSubview(helpTitleTextlabel)
                labels.append(helpTitleTextlabel)
                
                //add detail text label
                let helpTextlabel = UILabel()
                helpTextlabel.text = helpDescriptor.helpText
                helpTextlabel.textColor = UIColor.init(hexString: descriptionTextColor)
                helpTextlabel.numberOfLines = 0
                helpTextlabel.font = getCustomFont(isIpad() ? 12:9)
                helpTextlabel.textAlignment = NSTextAlignment.left
                helpTextlabel.lineBreakMode = .byWordWrapping
                var size = helpTextlabel.intrinsicContentSize
                if(isRTL())
                {
                    //CPI-2721
                    size = CGSize.init(width: isIpad() ? 150:100, height: size.height)
                    if(helpDescriptor.onSecondScreen || ((helpDescriptor.frameUsed!.origin.x-size.width)<0))
                    {
                        helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)+10, y: startYPoint+helpTitleTextlabel.frame.height-5, width: (isIpad() ? 150:100), height: size.height)
                    }
                    else
                    {
                            helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)-size.width-10, y: startYPoint+helpTitleTextlabel.frame.height-5, width: (isIpad() ? 150:100), height: size.height)
                            helpTextlabel.sizeToFit()
                            helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x + (helpDescriptor.frameUsed!.size.width / 2) - helpTextlabel.frame.size.width - 10, y: startYPoint + helpTitleTextlabel.frame.height - 5, width: helpTextlabel.frame.size.width, height: helpTextlabel.frame.size.height)
                            helpTextlabel.textAlignment = NSTextAlignment.right
                    }
                }
                else
                {
                    if(helpDescriptor.onSecondScreen || (((helpDescriptor.frameUsed!.origin.x+helpDescriptor.frameUsed!.size.width+size.width)>self.view.frame.size.width) && (helpDescriptor.frameUsed!.origin.y<(self.view.frame.size.height/2))))
                    {
                        helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)-size.width-10, y: startYPoint+helpTitleTextlabel.frame.height-5, width: (isIpad() ? 150:100), height: size.height)
                        helpTextlabel.sizeToFit()
                        helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x + (helpDescriptor.frameUsed!.size.width / 2) - helpTextlabel.frame.size.width - 10, y: startYPoint + helpTitleTextlabel.frame.height - 5, width: helpTextlabel.frame.size.width, height: helpTextlabel.frame.size.height)
                        helpTextlabel.textAlignment = NSTextAlignment.right
                    }
                    else
                    {
                        helpTextlabel.frame = CGRect(x: helpDescriptor.frameUsed!.origin.x+(helpDescriptor.frameUsed!.size.width/2)+10, y: startYPoint+helpTitleTextlabel.frame.height-5, width: (isIpad() ? 150:100), height: size.height)
                    }
                }
                helpTextlabel.sizeToFit()
                self.view.addSubview(helpTextlabel)
                labels.append(helpTextlabel)
            }
        }
        combLineDecrementVal=4
        combLineIncrementVal=1
        let fstDescrs =   desc.filter({ $0.combinedTagName == "PenColor"})
        if (fstDescrs.count>1) {
            drawCombinedLineForObjs(fstDescriptor: fstDescrs[0], scndDescriptor: fstDescrs[1])
        }
        let scndDescrs =   desc.filter({ $0.combinedTagName == "Arrow"})
        if (scndDescrs.count>1) {
            drawCombinedLineForObjs(fstDescriptor: scndDescrs[0], scndDescriptor: scndDescrs[1])
        }
    }
    
    //Draw combined line,title & description for two grouped button
    func drawCombinedLineForObjs(fstDescriptor: HelpDescriptor,scndDescriptor: HelpDescriptor) {
        var startYPoint:CGFloat = 0.0
        var endYPoint:CGFloat = 0.0
        var combXVal:CGFloat = 0.0
        
        
        if((fstDescriptor.frameUsed?.origin.y)!<(self.view.frame.size.height/2))
        {
            startYPoint = (self.view.frame.size.height*(combLineDecrementVal))/10;
            endYPoint = (scndDescriptor.frameUsed?.origin.y)! + (scndDescriptor.frameUsed?.size.height)!+15
            combLineDecrementVal-=1
        }
        else
        {
            startYPoint = (self.view.frame.size.height*(5+combLineIncrementVal))/10;
            endYPoint = (scndDescriptor.frameUsed?.origin.y)! - 15
            combLineIncrementVal+=1
        }
        combXVal = ((fstDescriptor.frameUsed?.origin.x)! + ((scndDescriptor.frameUsed?.origin.x)! + (scndDescriptor.frameUsed?.size.width)!))/2 ;
        
        
        //add halfRectLine
        let recPath = UIBezierPath()
        if((fstDescriptor.frameUsed?.origin.y)!<(self.view.frame.size.height/2))
        {
            recPath.move(to: CGPoint(x:((fstDescriptor.frameUsed?.origin.x)! + ((fstDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! + (fstDescriptor.frameUsed?.size.height)! - 3))
            recPath.addLine(to: CGPoint(x:((fstDescriptor.frameUsed?.origin.x)! + ((fstDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! + (fstDescriptor.frameUsed?.size.height)!+13))
            recPath.addLine(to: CGPoint(x:((scndDescriptor.frameUsed?.origin.x)! + ((scndDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! + (fstDescriptor.frameUsed?.size.height)!+13))
            recPath.addLine(to: CGPoint(x:((scndDescriptor.frameUsed?.origin.x)! + ((scndDescriptor.frameUsed?.size.width)!/2)), y:(scndDescriptor.frameUsed?.origin.y)! + (scndDescriptor.frameUsed?.size.height)! - 3))
        }
        else
        {
            recPath.move(to: CGPoint(x:((fstDescriptor.frameUsed?.origin.x)! + ((fstDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! + 3))
            recPath.addLine(to: CGPoint(x:((fstDescriptor.frameUsed?.origin.x)! + ((fstDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! - 13))
            recPath.addLine(to: CGPoint(x:((scndDescriptor.frameUsed?.origin.x)! + ((scndDescriptor.frameUsed?.size.width)!/2)), y:(fstDescriptor.frameUsed?.origin.y)! - 13))
            recPath.addLine(to: CGPoint(x:((scndDescriptor.frameUsed?.origin.x)! + ((scndDescriptor.frameUsed?.size.width)!/2)), y:(scndDescriptor.frameUsed?.origin.y)! + 3))
        }
        recPath.lineWidth = 10
        recPath.stroke()
        let reclayer = CAShapeLayer()
        reclayer.path = recPath.cgPath
        reclayer.strokeColor = UIColor.init(hexString: lineColor)?.cgColor
        reclayer.fillColor = UIColor.clear.cgColor
        reclayer.lineWidth=2
        self.view.layer.addSublayer(reclayer)
        layers.append(reclayer)
        
        //add btn icon
        if(fstDescriptor.icon.isKind(of: UILabel.self))
        {
            let eachBtn = UIButton.init()
            eachBtn.setTitleColor(UIColor.init(hexString: iconColor), for: .normal)
            eachBtn.titleLabel?.font = fstDescriptor.icon.font
            eachBtn.setTitleForAllState(fstDescriptor.icon.text)
            eachBtn.frame = fstDescriptor.frameUsed!
            self.view.addSubview(eachBtn)
            images.append(eachBtn)
        }
        
        if(scndDescriptor.icon.isKind(of: UILabel.self))
        {
            let eachBtn = UIButton.init()
            eachBtn.setTitleColor(UIColor.init(hexString: iconColor), for: .normal)
            eachBtn.titleLabel?.font = scndDescriptor.icon.font
            eachBtn.setTitleForAllState(scndDescriptor.icon.text)
            eachBtn.frame = scndDescriptor.frameUsed!
            self.view.addSubview(eachBtn)
            images.append(eachBtn)
        }
        
        
        //add vertical line
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x:combXVal, y:startYPoint))
        linePath.addLine(to: CGPoint(x:combXVal, y:endYPoint))
        linePath.close()
        linePath.lineWidth = 10
        linePath.stroke()
        linePath.fill()
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.init(hexString: lineColor)?.cgColor
        lineLayer.fillColor = UIColor.init(hexString: lineColor)?.cgColor
        lineLayer.lineWidth=2
        self.view.layer.addSublayer(lineLayer)
        layers.append(lineLayer)
        
        //add circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: combXVal,y: startYPoint), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.init(hexString: ellipseColor)?.cgColor
        circleLayer.strokeColor = UIColor.init(hexString: ellipseColor)?.cgColor
        circleLayer.lineWidth = 3.0
        self.view.layer.addSublayer(circleLayer)
        layers.append(circleLayer)
        
        //add title text label
        let helpTitleTextlabel = UILabel()
        helpTitleTextlabel.text = fstDescriptor.helpTitle
        helpTitleTextlabel.textColor = UIColor.init(hexString: titleTextColor)
        helpTitleTextlabel.numberOfLines = 0
        helpTitleTextlabel.font = getCustomFontForWeight(isIpad() ? 16:12,.bold)
        helpTitleTextlabel.textAlignment = NSTextAlignment.center
        helpTitleTextlabel.lineBreakMode = .byWordWrapping
        helpTitleTextlabel.frame = CGRect(x: combXVal+10, y: startYPoint-22, width: helpTitleTextlabel.frame.width, height: helpTitleTextlabel.frame.height)
        helpTitleTextlabel.sizeToFit()
        self.view.addSubview(helpTitleTextlabel)
        if(isRTL())
        {
            helpTitleTextlabel.frame.origin.x = combXVal - helpTitleTextlabel.frame.width - 10
        }
        labels.append(helpTitleTextlabel)
        
        //add detail text label
        let helpTextlabel = UILabel()
        helpTextlabel.text = fstDescriptor.helpText
        helpTextlabel.textColor = UIColor.init(hexString: descriptionTextColor)
        helpTextlabel.numberOfLines = 0
        helpTextlabel.font = getCustomFont(isIpad() ? 12:9)
        helpTextlabel.textAlignment = NSTextAlignment.left
        helpTextlabel.lineBreakMode = .byWordWrapping
        let size = helpTextlabel.intrinsicContentSize
        helpTextlabel.frame = CGRect(x: combXVal+10, y: startYPoint+helpTitleTextlabel.frame.height-22, width: (isIpad() ? 150:80), height: size.height)
        helpTextlabel.sizeToFit()
        self.view.addSubview(helpTextlabel)
        if(isRTL())
        {
            helpTextlabel.frame.origin.x = combXVal - helpTextlabel.frame.width - 10
        }
        labels.append(helpTextlabel)
    }
    
    @objc func swipeLeft (_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.ended && (isRTL() ? self.pageControl.currentPage == 1 : self.pageControl.currentPage == 0) {
            swipeToLeft()
        }
    }
    
    @objc public func swipeToLeft() {
        self.removeViews()
        self.pageControl.currentPage = isRTL() ? 0 : 1
        if let delegate = self.delegate {
            delegate.swipeAtIndex(self.pageControl.currentPage)
        }
        setUpViews()
        if(isRTL()) {
            self.setSkipButtonTitleString()
        }else {
            self.setGotItButtonTitleString()
        }
        self.view.bringSubviewToFront(self.view)
    }
    
    @objc func swipeRight (_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.ended && (isRTL() ? self.pageControl.currentPage == 0 : self.pageControl.currentPage == 1) {
            swipeToRight()
        }
    }
    
    @objc public func swipeToRight() {
        self.removeViews()
        self.pageControl.currentPage = isRTL() ? 1 : 0
        if let delegate = self.delegate {
            delegate.swipeAtIndex(self.pageControl.currentPage)
        }
        setUpViews()
        if(isRTL()) {
            self.setGotItButtonTitleString()
        }else {
            self.setSkipButtonTitleString()
        }
    }
   
    func setSkipButtonTitleString()
    {
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("HELP_SKIP_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Skip"))
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: skipButtonTextColor)!, range: NSMakeRange(0, NSLocalizedString("HELP_SKIP_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Skip").count))
        button.setAttributedTitle(titleString, for: UIControl.State())
        button.backgroundColor = UIColor.init(hexString: skipButtonBackgroundColor)
    }
    
    func setGotItButtonTitleString()
    {
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It"))
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: gotItButtonTextColor)!, range: NSMakeRange(0, NSLocalizedString("HELP_GOT_IT_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: HelpScreenConstants.bundle!, value: "", comment: "Got It").count))
        button.setAttributedTitle(titleString, for: UIControl.State())
        button.backgroundColor = UIColor.init(hexString: gotItButtonBackgroundColor)
    }
    
    //remove views from parent
    @objc public func removeViews() {
        for label in labels {
            label.removeFromSuperview()
        }
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        for label in images {
            label.removeFromSuperview()
        }
        
        labels =  []
        layers = []
        images = []
        
    }
    
    //close help screen button action
    @objc func removeMyself() {
        self.view.removeFromSuperview()
        self.removeFromParent()
        if let delegate = self.delegate
        {
            delegate.didRemovedHelpScreen()
        }
        
    }
    
    override open func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.removeViews()
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setUpViews()
    }
    
}

extension UIView {
    func imageFromView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView
{
    func copyView() -> UIView?
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}
