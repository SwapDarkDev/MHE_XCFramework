//
//  HDReadToMeViewController.swift
//  Kitaboo
//
//  Created by amol shelke on 20/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit

@objc public protocol HDReadToMeViewControllerDelegates{
    @objc func didCloseReadToMeView()
    @objc func didTapOnReadToMeForReadAloud()
    @objc func didTapOnAutoPlayForReadAloud()
    @objc func didTapOnLetMeReadForReadAloud()
}
@objc public enum ReadAloudMode:Int {
    case LetMeRead = 1
    case ReadToMe = 2
    case AutoPlay = 3
}

struct HDReadToMeConstants
{
    static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: HDReadToMeViewController.self)
}

let readToMeOptionsViewHeight:CGFloat = isIpad() ? 340 : 388
let readToMeOptionsViewWidth:CGFloat = isIpad() ? 666 : 280
let readToMeTopViewHeight:CGFloat = isIpad() ? 80 : 70
let readAloudButtonsStackViewHeight:CGFloat = isIpad() ? 90 : 0
let readAloudButtonsStackViewWidth:CGFloat = isIpad() ? 0 : 70
let readAloudButtonsStackViewLeft:CGFloat = isIpad() ? 80 : 20
let readAloudButtonsStackViewRight:CGFloat = isIpad() ? 80 : 0
let readAloudButtonsStackViewBottom:CGFloat = isIpad() ? 0 : -30
let readAloudButtonsStackViewTop:CGFloat = isIpad() ? 10 : 10
let readAloudButtonsWidth:CGFloat =  isIpad() ? readAloudButtonsStackViewHeight : readAloudButtonsStackViewWidth
let readAloudButtonsHeight:CGFloat = readAloudButtonsWidth
let readAloudDetailsStackViewRight:CGFloat = isIpad() ? -(readAloudButtonsStackViewRight - 20) : -14
let readToMeDetailsStackViewBottom:CGFloat = isIpad() ? 0 : -25
let readAloudMessageTop:CGFloat = isIpad() ? 10 : 0
let closeToMeViewButtonRight:CGFloat = isIpad() ? -25 : -14
let chooseYourModeLabelFontSize:CGFloat = isIpad() ? 24 : 18
let closeReadToMeViewButtonFontSize:CGFloat = isIpad() ? 24 : 18

let readAloudDetailsViewWidth:CGFloat = isIpad() ? 120 : 0
let readAloudDetailsViewHeight:CGFloat = isIpad() ? 0 : 83
let kitabooFont:String = HDKitabooFontManager.getFontName()

@objc open class HDReadToMeViewController: UIViewController,UIGestureRecognizerDelegate {

    var readAloudMode:ReadAloudMode?
    @inline(__always)static func isIpad() -> Bool
    {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    let readToMeOptionsView:UIView = {
        let readToMeView:UIView = UIView()
        readToMeView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        //readToMeView.layer.backgroundColor = UIColor.blue.cgColor
        return readToMeView
    }()
    let readToMeTopView:UIView = {
        let readToMeTopBarView : UIView = UIView()
        readToMeTopBarView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        return readToMeTopBarView
    }()
    let chooseYourModeLabel:UILabel = {
        let chooseModeLabel : UILabel = UILabel()
        chooseModeLabel.text = LocalizationHelper.localizedString(key: "READALOUD_CHOOSE_YOUR_MODE_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        chooseModeLabel.textColor = UIColor.black
        chooseModeLabel.font = getCustomFont(chooseYourModeLabelFontSize)
        return chooseModeLabel
    }()
    let closeReadToMeViewButton:UIButton = {
        let closeReadToMeButton : UIButton = UIButton()
        closeReadToMeButton.setTitle(ICON_CLOSE, for: UIControl.State.normal)
        closeReadToMeButton.titleLabel?.font = UIFont(name:kitabooFont, size:closeReadToMeViewButtonFontSize)!
        closeReadToMeButton.setTitleColor(UIColor.black, for: .normal)
        return closeReadToMeButton
    }()
    
    let letMeReadButton:UIButton = {
        let letMeReadButton:UIButton = UIButton()
        letMeReadButton.setTitle(READ_TO_ME_LET_ME_READ, for: .normal)
        letMeReadButton.titleLabel?.font = UIFont(name:kitabooFont, size:38)!
        letMeReadButton.setTitleColor(UIColor.blue, for: .normal)
        letMeReadButton.layer.masksToBounds = true
        letMeReadButton.layer.borderColor = UIColor.blue.cgColor
        letMeReadButton.layer.borderWidth = 1.0
        letMeReadButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return letMeReadButton
    }()
    
    let autoPlayButton:UIButton = {
        let autoPlayButton:UIButton = UIButton()
        autoPlayButton.setTitle(READ_TO_ME_AUTOPLAY, for: .normal)
        autoPlayButton.titleLabel?.font = UIFont(name:kitabooFont, size:38)!
        autoPlayButton.setTitleColor(UIColor.blue, for: .normal)
        autoPlayButton.layer.masksToBounds = true
        autoPlayButton.layer.borderColor = UIColor.blue.cgColor
        autoPlayButton.layer.borderWidth = 1.0
        autoPlayButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return autoPlayButton
    }()
    
    let readToMeButton:UIButton = {
        let readToMeButton:UIButton = UIButton()
        readToMeButton.setTitle(READ_TO_ME_READ_TO_ME, for: .normal)
        readToMeButton.titleLabel?.font = UIFont(name:kitabooFont, size:38)!
        readToMeButton.setTitleColor(UIColor.blue, for: .normal)
        readToMeButton.layer.masksToBounds = true
        readToMeButton.layer.borderColor = UIColor.blue.cgColor
        readToMeButton.layer.borderWidth = 1.0
        readToMeButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return readToMeButton
    }()
    
    lazy var readToMeButtonsStackView:UIStackView = {
        let stackView:UIStackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = HDReadToMeViewController.isIpad() ? .horizontal : .vertical
        //stackView.spacing = readAloudButtonsWidth
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let letMeReadDetailsView:UIButton = {
        let letMeReadTitleView:UIButton = UIButton()
        return letMeReadTitleView
    }()
    let letMeReadTitleLabel:UILabel = {
        let letMeReadLabel:UILabel = UILabel()
        letMeReadLabel.text = LocalizationHelper.localizedString(key: "READALOUD_LET_ME_READ_BUTTON_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        letMeReadLabel.font = getCustomFont(18)
        letMeReadLabel.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        return letMeReadLabel
    }()
    let letMeReadMessage:UILabel = {
        let letMeReadMessage:UILabel = UILabel()
        letMeReadMessage.text = LocalizationHelper.localizedString(key: "READALOUD_LET_ME_READ_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        letMeReadMessage.font = getCustomFont(14)
        letMeReadMessage.numberOfLines = 0
        letMeReadMessage.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        return letMeReadMessage
    }()
    
    let autoPlayDetailsView:UIButton = {
        let autoPlayTitleView:UIButton = UIButton()
        return autoPlayTitleView
    }()
    let autoPlayTitleLabel:UILabel = {
        let autoPlayLabel:UILabel = UILabel()
        autoPlayLabel.text = LocalizationHelper.localizedString(key: "READALOUD_AUTOPLAY_BUTTON_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        autoPlayLabel.font = getCustomFont(18)
        autoPlayLabel.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        return autoPlayLabel
    }()
    let autoPlayMessage:UILabel = {
        let autoPlayMessage:UILabel = UILabel()
        autoPlayMessage.text = LocalizationHelper.localizedString(key: "READALOUD_AUTOPLAY_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        autoPlayMessage.numberOfLines = 0
        autoPlayMessage.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        autoPlayMessage.font = getCustomFont(14)
        return autoPlayMessage
    }()
    
    let readToMeDetailsView:UIButton = {
        let readToMeDetailsView:UIButton = UIButton()
        return readToMeDetailsView
    }()
    let readToMeTitleLabel:UILabel = {
        let readToMeLabel:UILabel = UILabel()
        readToMeLabel.text = LocalizationHelper.localizedString(key: "READALOUD_READ_TO_ME_BUTTON_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        readToMeLabel.font = getCustomFont(18)
        readToMeLabel.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        return readToMeLabel
    }()
    let readToMeMessage:UILabel = {
        let readToMeMessage:UILabel = UILabel()
        readToMeMessage.text = LocalizationHelper.localizedString(key: "READALOUD_READ_TO_ME_TEXT", tableName: READER_LOCALIZABLE_TABLE, bundle: HDReadToMeConstants.bundle!)
        readToMeMessage.numberOfLines = 0
        readToMeMessage.font = getCustomFont(14)
        readToMeMessage.textAlignment = isIpad() ? NSTextAlignment.center : NSTextAlignment.left
        return readToMeMessage
    }()
    
    lazy var readAloudDetailsStackView:UIStackView = {
        let stackView:UIStackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = HDReadToMeViewController.isIpad() ? .horizontal : .vertical
        //stackView.spacing = readAloudButtonsWidth
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    @objc public var delegate:HDReadToMeViewControllerDelegates?
    @objc public init(ReadAloudMode mode:ReadAloudMode)
    {
        super.init(nibName: nil, bundle: nil)
        readAloudMode = mode
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()

        let singleTapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(gesture:)))
        singleTapGesture.delegate = self
        self.view.addGestureRecognizer(singleTapGesture)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubviews()
        self.addTargets()
    }
    func addSubviews()
    {
        self.view.addSubview(readToMeOptionsView)
        readToMeOptionsView.translatesAutoresizingMaskIntoConstraints = false
        readToMeOptionsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        readToMeOptionsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        readToMeOptionsView.widthAnchor.constraint(equalToConstant: readToMeOptionsViewWidth).isActive = true
        readToMeOptionsView.heightAnchor.constraint(equalToConstant: readToMeOptionsViewHeight).isActive = true
        
        readToMeOptionsView.addSubview(readToMeTopView)
        readToMeTopView.translatesAutoresizingMaskIntoConstraints = false
        readToMeTopView.leadingAnchor.constraint(equalTo: readToMeOptionsView.leadingAnchor, constant: 0).isActive = true
        readToMeTopView.topAnchor.constraint(equalTo: readToMeOptionsView.topAnchor, constant: 0).isActive = true
        readToMeTopView.trailingAnchor.constraint(equalTo: readToMeOptionsView.trailingAnchor, constant: 0).isActive = true
        readToMeTopView.heightAnchor.constraint(equalToConstant: readToMeTopViewHeight).isActive = true
        
        readToMeTopView.addSubview(chooseYourModeLabel)
        chooseYourModeLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseYourModeLabel.topAnchor.constraint(equalTo: readToMeTopView.topAnchor, constant: 0).isActive = true
        chooseYourModeLabel.leadingAnchor.constraint(equalTo: readToMeTopView.leadingAnchor, constant: 25).isActive = true
        chooseYourModeLabel.bottomAnchor.constraint(equalTo: readToMeTopView.bottomAnchor, constant: 0).isActive = true
        chooseYourModeLabel.sizeToFit()
        
        readToMeTopView.addSubview(closeReadToMeViewButton)
        closeReadToMeViewButton.translatesAutoresizingMaskIntoConstraints = false
        closeReadToMeViewButton.trailingAnchor.constraint(equalTo: readToMeTopView.trailingAnchor, constant: closeToMeViewButtonRight).isActive = true
        closeReadToMeViewButton.topAnchor.constraint(equalTo: readToMeTopView.topAnchor, constant: 0).isActive = true
        closeReadToMeViewButton.bottomAnchor.constraint(equalTo: readToMeTopView.bottomAnchor, constant: 0).isActive = true
        closeReadToMeViewButton.sizeToFit()
        
        self.addReadToMeButtonsStackView()
        self.addReadToMeDetailsStackView()
        self.addConstraints()
        self.setCornerRadiusToReadToMeButtons()
    }
    func addReadToMeButtonsStackView()
    {
        readToMeOptionsView.addSubview(readToMeButtonsStackView)
        readToMeButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        letMeReadButton.isEnabled = readAloudMode != ReadAloudMode.LetMeRead ? true : false
        letMeReadButton.alpha = readAloudMode != ReadAloudMode.LetMeRead ? 1.0 : 0.5
        readToMeButtonsStackView.addArrangedSubview(letMeReadButton)
        letMeReadButton.translatesAutoresizingMaskIntoConstraints = false
        letMeReadButton.widthAnchor.constraint(equalToConstant: readAloudButtonsWidth).isActive = true
        letMeReadButton.heightAnchor.constraint(equalToConstant: readAloudButtonsHeight).isActive = true
        
        autoPlayButton.isEnabled = readAloudMode != ReadAloudMode.AutoPlay ? true : false
        autoPlayButton.alpha = readAloudMode != ReadAloudMode.AutoPlay ? 1.0 : 0.5
        readToMeButtonsStackView.addArrangedSubview(autoPlayButton)
        autoPlayButton.translatesAutoresizingMaskIntoConstraints = false
        autoPlayButton.widthAnchor.constraint(equalToConstant: readAloudButtonsWidth).isActive = true
        autoPlayButton.heightAnchor.constraint(equalToConstant: readAloudButtonsHeight).isActive = true
        
        readToMeButton.isEnabled = readAloudMode != ReadAloudMode.ReadToMe ? true : false
        readToMeButton.alpha = readAloudMode != ReadAloudMode.ReadToMe ? 1.0 : 0.5
        readToMeButtonsStackView.addArrangedSubview(readToMeButton)
        readToMeButton.translatesAutoresizingMaskIntoConstraints = false
        readToMeButton.widthAnchor.constraint(equalToConstant: readAloudButtonsWidth).isActive = true
        readToMeButton.heightAnchor.constraint(equalToConstant: readAloudButtonsHeight).isActive = true
    }
    func addReadToMeDetailsStackView()
    {
        readToMeOptionsView.addSubview(readAloudDetailsStackView)
        readAloudDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        readAloudDetailsStackView.addArrangedSubview(letMeReadDetailsView)
        letMeReadDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        readAloudDetailsStackView.addArrangedSubview(autoPlayDetailsView)
        autoPlayDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        readAloudDetailsStackView.addArrangedSubview(readToMeDetailsView)
        readToMeDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        
        letMeReadTitleLabel.alpha = readAloudMode != ReadAloudMode.LetMeRead ? 1.0 : 0.5
        letMeReadDetailsView.addSubview(letMeReadTitleLabel)
        letMeReadTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        letMeReadMessage.alpha = readAloudMode != ReadAloudMode.LetMeRead ? 1.0 : 0.5
        letMeReadDetailsView.addSubview(letMeReadMessage)
        letMeReadMessage.translatesAutoresizingMaskIntoConstraints = false
        
        
        autoPlayTitleLabel.alpha = readAloudMode != ReadAloudMode.AutoPlay ? 1.0 : 0.5
        autoPlayDetailsView.addSubview(autoPlayTitleLabel)
        autoPlayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        autoPlayMessage.alpha = readAloudMode != ReadAloudMode.AutoPlay ? 1.0 : 0.5
        autoPlayDetailsView.addSubview(autoPlayMessage)
        autoPlayMessage.translatesAutoresizingMaskIntoConstraints = false
        
        
        readToMeTitleLabel.alpha = readAloudMode != ReadAloudMode.ReadToMe ? 1.0 : 0.5
        readToMeDetailsView.addSubview(readToMeTitleLabel)
        readToMeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        readToMeMessage.alpha = readAloudMode != ReadAloudMode.ReadToMe ? 1.0 : 0.5
        readToMeDetailsView.addSubview(readToMeMessage)
        readToMeMessage.translatesAutoresizingMaskIntoConstraints = false
        
        letMeReadDetailsView.isEnabled = readAloudMode != ReadAloudMode.LetMeRead ? true : false
        autoPlayDetailsView.isEnabled = readAloudMode != ReadAloudMode.AutoPlay ? true : false
        readToMeDetailsView.isEnabled = readAloudMode != ReadAloudMode.ReadToMe ? true : false
        
        self.addReadAloudDetailsStackViewConstraints()
    }
    
    func addReadAloudDetailsStackViewConstraints()
    {
        if(HDReadToMeViewController.isIpad())
        {
            letMeReadDetailsView.widthAnchor.constraint(equalToConstant: readAloudDetailsViewWidth).isActive = true
            autoPlayDetailsView.widthAnchor.constraint(equalToConstant: readAloudDetailsViewWidth).isActive = true
            readToMeDetailsView.widthAnchor.constraint(equalToConstant: readAloudDetailsViewWidth).isActive = true
        }
        else
        {
            letMeReadDetailsView.heightAnchor.constraint(equalToConstant: readAloudDetailsViewHeight).isActive = true
            autoPlayDetailsView.heightAnchor.constraint(equalToConstant: readAloudDetailsViewHeight + 25).isActive = true
            readToMeDetailsView.heightAnchor.constraint(equalToConstant: readAloudDetailsViewHeight + 5).isActive = true
        }
        
        letMeReadTitleLabel.leadingAnchor.constraint(equalTo:letMeReadDetailsView.leadingAnchor , constant: 0).isActive = true
        letMeReadTitleLabel.topAnchor.constraint(equalTo:letMeReadDetailsView.topAnchor , constant: 0).isActive = true
        letMeReadTitleLabel.trailingAnchor.constraint(equalTo:letMeReadDetailsView.trailingAnchor , constant: 0).isActive = true
        letMeReadTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        letMeReadMessage.leadingAnchor.constraint(equalTo:letMeReadDetailsView.leadingAnchor , constant: 0).isActive = true
        letMeReadMessage.topAnchor.constraint(equalTo:letMeReadTitleLabel.bottomAnchor , constant: readAloudMessageTop).isActive = true
        letMeReadMessage.trailingAnchor.constraint(equalTo:letMeReadDetailsView.trailingAnchor , constant: 0).isActive = true
        letMeReadMessage.bottomAnchor.constraint(equalTo:letMeReadDetailsView.bottomAnchor , constant: 0).isActive = true
        letMeReadMessage.sizeToFit()
        
        autoPlayTitleLabel.leadingAnchor.constraint(equalTo:autoPlayDetailsView.leadingAnchor , constant: 0).isActive = true
        autoPlayTitleLabel.topAnchor.constraint(equalTo:autoPlayDetailsView.topAnchor , constant: 0).isActive = true
        autoPlayTitleLabel.trailingAnchor.constraint(equalTo:autoPlayDetailsView.trailingAnchor , constant: 0).isActive = true
        autoPlayTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        autoPlayMessage.leadingAnchor.constraint(equalTo:autoPlayDetailsView.leadingAnchor , constant: 0).isActive = true
        autoPlayMessage.topAnchor.constraint(equalTo:autoPlayTitleLabel.bottomAnchor , constant: readAloudMessageTop).isActive = true
        autoPlayMessage.trailingAnchor.constraint(equalTo:autoPlayDetailsView.trailingAnchor , constant: 0).isActive = true
        autoPlayMessage.bottomAnchor.constraint(equalTo:autoPlayDetailsView.bottomAnchor , constant: 0).isActive = true
        autoPlayMessage.sizeToFit()
        
        readToMeTitleLabel.leadingAnchor.constraint(equalTo:readToMeDetailsView.leadingAnchor , constant: 0).isActive = true
        readToMeTitleLabel.topAnchor.constraint(equalTo:readToMeDetailsView.topAnchor , constant: 0).isActive = true
        readToMeTitleLabel.trailingAnchor.constraint(equalTo:readToMeDetailsView.trailingAnchor , constant: 0).isActive = true
        readToMeTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        readToMeMessage.leadingAnchor.constraint(equalTo:readToMeDetailsView.leadingAnchor , constant: 0).isActive = true
        readToMeMessage.topAnchor.constraint(equalTo:readToMeTitleLabel.bottomAnchor , constant: readAloudMessageTop).isActive = true
        readToMeMessage.trailingAnchor.constraint(equalTo:readToMeDetailsView.trailingAnchor , constant: 0).isActive = true
        readToMeMessage.bottomAnchor.constraint(equalTo:readToMeDetailsView.bottomAnchor , constant: 0).isActive = true
        readToMeMessage.sizeToFit()
        
    }
    func addConstraints()
    {
        readToMeButtonsStackView.leadingAnchor.constraint(equalTo: readToMeOptionsView.leadingAnchor, constant: readAloudButtonsStackViewLeft).isActive = true
        readToMeButtonsStackView.topAnchor.constraint(equalTo: readToMeTopView.bottomAnchor, constant: readAloudButtonsStackViewTop).isActive = true
        
        readAloudDetailsStackView.bottomAnchor.constraint(equalTo: readToMeOptionsView.bottomAnchor, constant: readToMeDetailsStackViewBottom).isActive = true
        readAloudDetailsStackView.trailingAnchor.constraint(equalTo: readToMeOptionsView.trailingAnchor, constant: readAloudDetailsStackViewRight).isActive = true
        
        if HDReadToMeViewController.isIpad()
        {
            readToMeButtonsStackView.trailingAnchor.constraint(equalTo: readToMeOptionsView.trailingAnchor, constant: -readAloudButtonsStackViewRight).isActive = true
            readToMeButtonsStackView.heightAnchor.constraint(equalToConstant:readAloudButtonsStackViewHeight).isActive = true
            
            readAloudDetailsStackView.topAnchor.constraint(equalTo: readToMeButtonsStackView.bottomAnchor, constant: 20).isActive = true
            readAloudDetailsStackView.leadingAnchor.constraint(equalTo: readToMeOptionsView.leadingAnchor, constant: readAloudButtonsStackViewLeft - 10).isActive = true
        }
        else
        {
            readToMeButtonsStackView.bottomAnchor.constraint(equalTo: readToMeOptionsView.bottomAnchor, constant: readAloudButtonsStackViewBottom).isActive = true
            readToMeButtonsStackView.widthAnchor.constraint(equalToConstant:readAloudButtonsStackViewWidth).isActive = true
            
            readAloudDetailsStackView.topAnchor.constraint(equalTo: readToMeTopView.bottomAnchor, constant: 10).isActive = true
            readAloudDetailsStackView.leadingAnchor.constraint(equalTo: readToMeButtonsStackView.trailingAnchor, constant: 20).isActive = true
        }
        
    }
    func setCornerRadiusToReadToMeButtons()
    {
        letMeReadButton.layer.cornerRadius = readAloudButtonsHeight/2;
        readToMeButton.layer.cornerRadius = readAloudButtonsHeight/2;
        autoPlayButton.layer.cornerRadius = readAloudButtonsHeight/2;
    }
    func addTargets()
    {
        closeReadToMeViewButton.addTarget(self, action: #selector(didTapOnCloseReadToMeView(_:)), for: .touchUpInside)
        letMeReadButton.addTarget(self, action: #selector(didTapOnLetMeRead(_:)), for: .touchUpInside)
        autoPlayButton.addTarget(self, action: #selector(didTapOnAutoPlay(_:)), for: .touchUpInside)
        readToMeButton.addTarget(self, action: #selector(didTapOnReadToMe(_:)), for: .touchUpInside)
        
        letMeReadDetailsView.addTarget(self, action:#selector(didTapOnLetMeRead(_:)), for: .touchUpInside)
        autoPlayDetailsView.addTarget(self, action:#selector(didTapOnAutoPlay(_:)), for: .touchUpInside)
        readToMeDetailsView.addTarget(self, action:#selector(didTapOnReadToMe(_:)), for: .touchUpInside)
    }
    @objc func handleSingleTap(gesture:UITapGestureRecognizer){
        delegate?.didCloseReadToMeView()
        self.dismiss(animated: false) {
        }
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: readToMeOptionsView)) ?? false
        {
            return false
        }
        return true
    }
    
    @objc func didTapOnCloseReadToMeView(_ sender:UIButton)
    {
        delegate?.didCloseReadToMeView()
        self.dismiss(animated: false) {
        }
    }
    @objc func didTapOnLetMeRead(_ sender:UIButton){
        delegate?.didTapOnLetMeReadForReadAloud()
    }
    @objc func didTapOnAutoPlay(_ sender:UIButton){
        delegate?.didTapOnAutoPlayForReadAloud()
    }
    @objc func didTapOnReadToMe(_ sender:UIButton){
        delegate?.didTapOnReadToMeForReadAloud()
    }
    @objc open func setTheme(_ themeVO:KBHDThemeVO)
    {
//        chooseYourModeLabel.textColor = UIColor.black
//        closeReadToMeViewButton.setTitleColor(UIColor.black, for: .normal)
        
        letMeReadButton.setTitleColor(themeVO.pen_tool_toolbar_icons_color, for: .normal)
        autoPlayButton.setTitleColor(themeVO.pen_tool_toolbar_icons_color, for: .normal)
        readToMeButton.setTitleColor(themeVO.pen_tool_toolbar_icons_color, for: .normal)
        letMeReadButton.layer.borderColor = themeVO.pen_tool_toolbar_icons_color.cgColor
        autoPlayButton.layer.borderColor = themeVO.pen_tool_toolbar_icons_color.cgColor
        readToMeButton.layer.borderColor = themeVO.pen_tool_toolbar_icons_color.cgColor
        
//        letMeReadTitleLabel.textColor = UIColor.black
//        autoPlayTitleLabel.textColor = UIColor.black
//        readToMeTitleLabel.textColor = UIColor.black
//
//        letMeReadMessage.textColor = UIColor.black
//        autoPlayMessage.textColor = UIColor.black
//        readToMeMessage.textColor = UIColor.black
    }

}
