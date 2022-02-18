//
//  ResetAllViewController.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 29/06/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

public struct ResetAllViewControllerConstants
{
   static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: ResetAllViewController.self)
}

@objc public class ResetAllViewController: UIViewController, UIGestureRecognizerDelegate {
    let mainView = UIView.init()
    var currentPageRadioIcon : UILabel?
    var allPageRadioIcon : UILabel?
    var isEnableCurrentPage = true
    @objc public var OkButtonAction :((Bool) -> Void)?
    @objc public var CancelButtonAction :(() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.constructUI()
        self.enableCurrentPageButton(true)
        // Do any additional setup after loading the view.
    }
    
    func constructUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(mainView)
        mainView.backgroundColor = UIColor.white
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = isIpad() ? 8 : 5
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: isIpad() ? 400 : 300).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: isIpad() ? 300 : 220).isActive = true
        mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let resetAllLabel = UILabel.init()
        mainView.addSubview(resetAllLabel)
        resetAllLabel.textAlignment = .center
        resetAllLabel.font = getCustomFontForWeight(isIpad() ? 22 : 18, .semibold)
        resetAllLabel.text = NSLocalizedString("RESET_ALL", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: "")
        resetAllLabel.translatesAutoresizingMaskIntoConstraints = false
        resetAllLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        resetAllLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20).isActive = true
        resetAllLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: isIpad() ? 20 : 17).isActive = true
        resetAllLabel.heightAnchor.constraint(equalToConstant: isIpad() ? 50 : 40).isActive = true
        
        let cancelButton = UIButton.init()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.gray.cgColor
        cancelButton.titleLabel?.font = getCustomFont(isIpad() ? 20 : 17)
        cancelButton.setTitle(NSLocalizedString("CANCEL", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: ""), for: .normal)
        cancelButton.setTitleColor(UIColor(hexString: "#123595"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapAction), for: .touchUpInside)
        mainView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant:isIpad() ? 70 : 50).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.5).isActive = true
        
        let okButton = UIButton.init()
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.gray.cgColor
        okButton.titleLabel?.font = getCustomFont(isIpad() ? 20 : 17)
        okButton.addTarget(self, action: #selector(okButtonTapAction), for: .touchUpInside)
        mainView.addSubview(okButton)
        okButton.setTitle(NSLocalizedString("OK_BUTTON", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: ""), for: .normal)
        okButton.setTitleColor(UIColor(hexString: "#123595"), for: .normal)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: isIpad() ? 70 : 50).isActive = true
        okButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        okButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.5).isActive = true
        
        let selectView = UIView.init()
        mainView.addSubview(selectView)
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        selectView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20).isActive = true
        selectView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: isIpad() ? 50 : 40).isActive = true
        
        let currentPageView = UIView.init()
        selectView.addSubview(currentPageView)
        currentPageView.translatesAutoresizingMaskIntoConstraints = false
        currentPageView.leadingAnchor.constraint(equalTo: selectView.leadingAnchor).isActive = true
        currentPageView.widthAnchor.constraint(equalTo: selectView.widthAnchor, multiplier: 0.5).isActive = true
        currentPageView.topAnchor.constraint(equalTo: selectView.topAnchor).isActive = true
        currentPageView.bottomAnchor.constraint(equalTo: selectView.bottomAnchor).isActive = true
        
        let currentPageTapGesture = UITapGestureRecognizer(target: self, action: #selector(currentPageButtonTapAction))
        currentPageTapGesture.delegate = self
        currentPageView.addGestureRecognizer(currentPageTapGesture)
        
        currentPageRadioIcon = UILabel.init()
        currentPageRadioIcon!.textColor = UIColor(hexString: "#123595")
        currentPageView.addSubview(currentPageRadioIcon!)
        currentPageRadioIcon!.text = RADIO_SELECT
        currentPageRadioIcon!.font = UIFont(name: HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 17)
        currentPageRadioIcon!.translatesAutoresizingMaskIntoConstraints = false
        currentPageRadioIcon!.leadingAnchor.constraint(equalTo: currentPageView.leadingAnchor).isActive = true
        currentPageRadioIcon!.topAnchor.constraint(equalTo: currentPageView.topAnchor).isActive = true
        currentPageRadioIcon!.bottomAnchor.constraint(equalTo: currentPageView.bottomAnchor).isActive = true
        currentPageRadioIcon!.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 25).isActive = true
        
        let currentPageLabel = UILabel.init()
        currentPageLabel.font = getCustomFont(isIpad() ? 18 : 15)
        currentPageView.addSubview(currentPageLabel)
        currentPageLabel.text = NSLocalizedString("CURRENT_PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: "")
        currentPageLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPageLabel.leadingAnchor.constraint(equalTo: currentPageRadioIcon!.trailingAnchor).isActive = true
        currentPageLabel.trailingAnchor.constraint(equalTo: currentPageView.trailingAnchor).isActive = true
        currentPageLabel.topAnchor.constraint(equalTo: currentPageView.topAnchor).isActive = true
        currentPageLabel.bottomAnchor.constraint(equalTo: currentPageView.bottomAnchor).isActive = true
        
        let allPageView = UIView.init()
        selectView.addSubview(allPageView)
        allPageView.translatesAutoresizingMaskIntoConstraints = false
        allPageView.trailingAnchor.constraint(equalTo: selectView.trailingAnchor).isActive = true
        allPageView.widthAnchor.constraint(equalTo: selectView.widthAnchor, multiplier: 0.5).isActive = true
        allPageView.topAnchor.constraint(equalTo: selectView.topAnchor).isActive = true
        allPageView.bottomAnchor.constraint(equalTo: selectView.bottomAnchor).isActive = true
        
        let allPageTapGesture = UITapGestureRecognizer(target: self, action: #selector(allPageButtonTapAction))
        allPageTapGesture.delegate = self
        allPageView.addGestureRecognizer(allPageTapGesture)
        
        allPageRadioIcon = UILabel.init()
        allPageRadioIcon!.textColor = UIColor(hexString: "#123595")
        allPageView.addSubview(allPageRadioIcon!)
        allPageRadioIcon!.text = RADIO_UNSELECT
        allPageRadioIcon!.font = UIFont(name: HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 17)
        allPageRadioIcon!.translatesAutoresizingMaskIntoConstraints = false
        allPageRadioIcon!.leadingAnchor.constraint(equalTo: allPageView.leadingAnchor).isActive = true
        allPageRadioIcon!.topAnchor.constraint(equalTo: allPageView.topAnchor).isActive = true
        allPageRadioIcon!.bottomAnchor.constraint(equalTo: allPageView.bottomAnchor).isActive = true
        allPageRadioIcon!.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 25).isActive = true
        
        let allPageLabel = UILabel.init()
        allPageLabel.font = getCustomFont(isIpad() ? 18 : 15)
        allPageView.addSubview(allPageLabel)
        allPageLabel.text = NSLocalizedString("ALL_PAGES", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: "")
        allPageLabel.translatesAutoresizingMaskIntoConstraints = false
        allPageLabel.leadingAnchor.constraint(equalTo: allPageRadioIcon!.trailingAnchor).isActive = true
        allPageLabel.topAnchor.constraint(equalTo: allPageView.topAnchor).isActive = true
        allPageLabel.bottomAnchor.constraint(equalTo: allPageView.bottomAnchor).isActive = true
        allPageLabel.trailingAnchor.constraint(equalTo: allPageView.trailingAnchor).isActive = true
        
        let descriptionLabel = UILabel.init()
        mainView.addSubview(descriptionLabel)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 4
        descriptionLabel.font = getCustomFont(isIpad() ? 18 : 15)
        descriptionLabel.text = NSLocalizedString("RESET_DETAIL", tableName: READER_LOCALIZABLE_TABLE, bundle: ResetAllViewControllerConstants.bundle!, value: "", comment: "")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: resetAllLabel.bottomAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: selectView.topAnchor).isActive = true
    }
    
    func enableCurrentPageButton(_ isEnable:Bool) {
        isEnableCurrentPage = isEnable
        if isEnableCurrentPage {
            currentPageRadioIcon?.text = RADIO_SELECT
            allPageRadioIcon?.text = RADIO_UNSELECT
        } else {
            currentPageRadioIcon?.text = RADIO_UNSELECT
            allPageRadioIcon?.text = RADIO_SELECT
        }
    }
    
    @objc func currentPageButtonTapAction() {
        self.enableCurrentPageButton(true)
    }
    
    @objc func allPageButtonTapAction() {
        self.enableCurrentPageButton(false)
    }
    
    @objc func cancelButtonTapAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if (CancelButtonAction != nil) {
            CancelButtonAction!()
        }
    }
    
    @objc func okButtonTapAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if (OkButtonAction != nil) {
            OkButtonAction!(isEnableCurrentPage)
        }
    }
}
