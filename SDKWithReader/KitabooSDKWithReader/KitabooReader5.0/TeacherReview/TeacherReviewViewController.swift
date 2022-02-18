//
//  TeacherReviewViewController.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 21/06/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

public struct TeacherReviewStudentListConstants
{
   static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: TeacherReviewViewController.self)
}

@objc public class TeacherReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate {
    @objc public var selectedLearnerImageUrl : String?
    @objc public var selectedLearnerName : String?
    @objc public var selectedLearnerID : String?
    @objc public var SelectedPageIdentifier : String?
    @objc public var studentPageUGCDictionary : [String:Any]?
    @objc public var selectedClassName : String?
    @objc public var isAnnotationEnabled = true
    @objc public var studentSubmittedPageArray : NSArray?
    @objc public var themeVo : KBHDThemeVO?
    var studentListArray : NSArray?
    var filteredStudentListArray : NSArray?
    @objc public var selectedFibArray : NSArray?
    @objc public var studentDataDict = [String:Any]()
    let searchBar = UITextField.init()
    let studentListTableView = UITableView.init()
    let noStudentLabel = UILabel.init()
    var studentIdArray = [String:String]()
    @objc public var RemoveAnnotataionController :(() -> Void)?
    @objc public var DidTapOnChangeClassButton :(() -> Void)?
    @objc public var FetchEachLearnerData :((String, String) -> Void)?
    @objc public var LearnerSelectionAction : (([Any], String) -> Void)?
    var blackOverLay : UIView?
    var activityIndicator: UIActivityIndicatorView?
    var scheduledTimer = Timer()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        constructUI()
        configureTableView()
        getStudentData()
        scheduledTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func constructUI() {
        let backButtonView = UIView.init()
        backButtonView.backgroundColor = UIColor(hexString: "#e3e3e3")
        self.view.addSubview(backButtonView)
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        backButtonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backButtonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButtonView.heightAnchor.constraint(equalToConstant: isIpad() ? 50 : 40).isActive = true
        
        let backButtonIcon = UILabel.init()
        backButtonIcon.isUserInteractionEnabled = true
        let icontapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        icontapGesture.delegate = self
        backButtonIcon.addGestureRecognizer(icontapGesture)
        backButtonIcon.textColor = UIColor(hexString: "#095e8e")
        backButtonIcon.textAlignment = .center
        backButtonView.addSubview(backButtonIcon)
        backButtonIcon.text = ICON_BACK
        backButtonIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 20)
        backButtonIcon.translatesAutoresizingMaskIntoConstraints = false
        backButtonIcon.leadingAnchor.constraint(equalTo: backButtonView.leadingAnchor).isActive = true
        backButtonIcon.topAnchor.constraint(equalTo: backButtonView.topAnchor).isActive = true
        backButtonIcon.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        backButtonIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let backButtonLabel = UILabel.init()
        backButtonLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        tapGesture.delegate = self
        backButtonLabel.addGestureRecognizer(tapGesture)
        backButtonLabel.textColor = UIColor(hexString: "#095e8e")
        backButtonView.addSubview(backButtonLabel)
        backButtonLabel.text = NSLocalizedString("SELECT_STUDENT", tableName: READER_LOCALIZABLE_TABLE, bundle: TeacherReviewStudentListConstants.bundle!, value: "", comment: "")
        backButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        backButtonLabel.leadingAnchor.constraint(equalTo: backButtonIcon.trailingAnchor).isActive = true
        backButtonLabel.topAnchor.constraint(equalTo: backButtonView.topAnchor).isActive = true
        backButtonLabel.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        backButtonLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.backgroundColor = themeVo!.teacherSettings_popup_background
        let classNameView = UIView.init()
        self.view.addSubview(classNameView)
        classNameView.translatesAutoresizingMaskIntoConstraints = false
        classNameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: isIpad() ? 60 : 20).isActive = true
        classNameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: isIpad() ? -50 : -20).isActive = true
        classNameView.topAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        classNameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let classNameLabel = UILabel.init()
        classNameLabel.textColor = themeVo!.teacher_studentlist_class_text_color
        classNameView.addSubview(classNameLabel)
        classNameLabel.text = selectedClassName
        classNameLabel.translatesAutoresizingMaskIntoConstraints = false
        classNameLabel.leadingAnchor.constraint(equalTo: classNameView.leadingAnchor).isActive = true
        classNameLabel.topAnchor.constraint(equalTo: classNameView.topAnchor).isActive = true
        classNameLabel.bottomAnchor.constraint(equalTo: classNameView.bottomAnchor).isActive = true
        classNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let changeClassIcon = UILabel.init()
        changeClassIcon.isUserInteractionEnabled = true
        changeClassIcon.textColor = themeVo!.teacher_studentlist_change_text_color
        classNameView.addSubview(changeClassIcon)
        let changeClassIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeClassButtonTapped))
        changeClassIconTapGesture.delegate = self
        changeClassIcon.addGestureRecognizer(changeClassIconTapGesture)
        changeClassIcon.text = ICON_NEXT
        changeClassIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 18)
        changeClassIcon.translatesAutoresizingMaskIntoConstraints = false
        changeClassIcon.trailingAnchor.constraint(equalTo: classNameView.trailingAnchor, constant: -10).isActive = true
        changeClassIcon.centerYAnchor.constraint(equalTo: classNameView.centerYAnchor).isActive = true
        changeClassIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        changeClassIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let changeClassLabel = UILabel.init()
        changeClassLabel.isUserInteractionEnabled = true
        let changeClassTapGesture = UITapGestureRecognizer(target: self, action: #selector(changeClassButtonTapped))
        changeClassTapGesture.delegate = self
        changeClassLabel.addGestureRecognizer(changeClassTapGesture)
        changeClassLabel.textColor = themeVo!.teacher_studentlist_change_text_color
        changeClassLabel.textAlignment = .right
        classNameView.addSubview(changeClassLabel)
        changeClassLabel.text = NSLocalizedString("CHANGE_CLASS", tableName: READER_LOCALIZABLE_TABLE, bundle: TeacherReviewStudentListConstants.bundle!, value: "", comment: "")
        changeClassLabel.translatesAutoresizingMaskIntoConstraints = false
        changeClassLabel.trailingAnchor.constraint(equalTo: changeClassIcon.leadingAnchor, constant: -10).isActive = true
        changeClassLabel.centerYAnchor.constraint(equalTo: classNameView.centerYAnchor).isActive = true
        changeClassLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        changeClassLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let classNameAnnotationSeparationView = UIView.init()
        classNameAnnotationSeparationView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(classNameAnnotationSeparationView)
        classNameAnnotationSeparationView.translatesAutoresizingMaskIntoConstraints = false
        classNameAnnotationSeparationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: isIpad() ? 60 : 20).isActive = true
        classNameAnnotationSeparationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: isIpad() ? -50 : 0).isActive = true
        classNameAnnotationSeparationView.topAnchor.constraint(equalTo: classNameView.bottomAnchor).isActive = true
        classNameAnnotationSeparationView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let annotationView = UIView.init()
        self.view.addSubview(annotationView)
        annotationView.translatesAutoresizingMaskIntoConstraints = false
        annotationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: isIpad() ? 60 : 20).isActive = true
        annotationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: isIpad() ? -50 : -20).isActive = true
        annotationView.topAnchor.constraint(equalTo: classNameAnnotationSeparationView.bottomAnchor).isActive = true
        annotationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let annotationLabel = UILabel.init()
        annotationView.addSubview(annotationLabel)
        annotationLabel.text = NSLocalizedString("ANNOTATIONS", tableName: READER_LOCALIZABLE_TABLE, bundle: TeacherReviewStudentListConstants.bundle!, value: "", comment: "")
        annotationLabel.translatesAutoresizingMaskIntoConstraints = false
        annotationLabel.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor).isActive = true
        annotationLabel.topAnchor.constraint(equalTo: annotationView.topAnchor).isActive = true
        annotationLabel.bottomAnchor.constraint(equalTo: annotationView.bottomAnchor).isActive = true
        annotationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let annotationSwitch = UISwitch.init()
        annotationSwitch.isOn = true
        annotationSwitch.addTarget(self, action: #selector(annotationSwitchChanged(_:)), for: UIControl.Event.valueChanged)
        annotationView.addSubview(annotationSwitch)
        annotationSwitch.translatesAutoresizingMaskIntoConstraints = false
        annotationSwitch.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: -10).isActive = true
        annotationSwitch.centerYAnchor.constraint(equalTo: annotationView.centerYAnchor).isActive = true
        annotationSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        annotationSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let annotationSearchSeparationView = UIView.init()
        annotationSearchSeparationView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(annotationSearchSeparationView)
        annotationSearchSeparationView.translatesAutoresizingMaskIntoConstraints = false
        annotationSearchSeparationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: isIpad() ? 50 : 0).isActive = true
        annotationSearchSeparationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: isIpad() ? -50 : 0).isActive = true
        annotationSearchSeparationView.topAnchor.constraint(equalTo: annotationView.bottomAnchor).isActive = true
        annotationSearchSeparationView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let searchTextFieldContainerView = UIView.init()
        searchTextFieldContainerView.layer.cornerRadius = 20
        searchTextFieldContainerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2) //themeVo!.teacher_studentlist_search_input_panel_color
        self.view.addSubview(searchTextFieldContainerView)
        searchTextFieldContainerView.translatesAutoresizingMaskIntoConstraints = false;
        searchTextFieldContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchTextFieldContainerView.topAnchor.constraint(equalTo: annotationSearchSeparationView.bottomAnchor, constant: 10).isActive = true
        searchTextFieldContainerView.widthAnchor.constraint(equalToConstant: isIpad() ? 400 : 300).isActive = true
        searchTextFieldContainerView.heightAnchor.constraint(equalToConstant: isIpad() ? 40 : 35).isActive = true
        
        let searchIcon: UILabel = UILabel.init()
        searchIcon.text = ICON_SEARCH
        searchIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 16)
        searchIcon.textAlignment = .left
        searchTextFieldContainerView.addSubview(searchIcon)
        searchIcon.textColor = UIColor.gray //themeVo!.teacher_studentlist_search_main_icon_color
        searchIcon.translatesAutoresizingMaskIntoConstraints = false;
        searchIcon.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.leadingAnchor, constant: isIpad() ? 18 : 16).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        searchIcon.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchIcon.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
        
        searchBar.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        //searchBar.textColor = themeVo!.teacher_studentlist_search_text_color
        searchBar.delegate = self
        searchBar.text = ""
        searchBar.backgroundColor = UIColor.clear
        searchBar.font = getCustomFont(isIpad() ? 17 : 14)
        searchBar.textAlignment = isRTL() ? .right : .left
        searchTextFieldContainerView.addSubview(searchBar)
        searchBar.layer.borderColor = UIColor.white.cgColor;
        searchBar.returnKeyType = .search
        searchBar.clearButtonMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false;
        searchBar.leadingAnchor.constraint(equalTo:searchIcon.trailingAnchor, constant:isIpad() ? 12 : 16).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: searchTextFieldContainerView.trailingAnchor, constant: -6).isActive = true
        let placeholder = NSAttributedString(string:NSLocalizedString("SEARCH", tableName: READER_LOCALIZABLE_TABLE, bundle: TeacherReviewStudentListConstants.bundle!, value: "", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        searchBar.attributedPlaceholder = placeholder
        
        self.view.addSubview(studentListTableView)
        studentListTableView.translatesAutoresizingMaskIntoConstraints = false
        studentListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: isIpad() ? 40 : 20).isActive = true
        studentListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: isIpad() ? -40 : -20).isActive = true
        studentListTableView.topAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant: isIpad() ? 30 : 20).isActive = true
        studentListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        self.view.addSubview(noStudentLabel)
        noStudentLabel.textAlignment = .center
        noStudentLabel.text = "No student found"
        noStudentLabel.translatesAutoresizingMaskIntoConstraints = false
        noStudentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        noStudentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noStudentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noStudentLabel.topAnchor.constraint(equalTo: studentListTableView.topAnchor, constant: isIpad() ? 100 : 50).isActive = true
        noStudentLabel.isHidden = true
    }
    
    func configureTableView() {
        studentListTableView.bounces = false
        studentListTableView.delegate = self
        studentListTableView.dataSource = self
        studentListTableView.tableHeaderView = nil
        studentListTableView.reloadData()
    }
    
//    - (void)switchChanged:(UISwitch *)sender {
//       // Do something
//       BOOL value = sender.on;
//    }
    @objc public func annotationSwitchChanged(_ sender:UISwitch) {
        isAnnotationEnabled = sender.isOn
    }
    
    @objc public func mainViewTapped() {
        //self.view.endEditing(true)
        //searchBar.resignFirstResponder()
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField) {
        if textField.text!.count == 0 {
            self.filteredStudentListArray = self.studentListArray
            updateTableViewStatus(self.filteredStudentListArray!.count > 0)
            studentListTableView.reloadData()
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.filteredStudentListArray = self.studentListArray
        updateTableViewStatus(self.filteredStudentListArray!.count > 0)
        studentListTableView.reloadData()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count > 0 {
            let filteredArray = NSMutableArray.init()
            for studentDict in self.studentListArray! {
                let sdic = studentDict as! [String:Any]
                let user = sdic["user"] as! [String:Any]
                let fullName:String = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
                if (fullName.contains(textField.text)) {
                    filteredArray.add(studentDict)
                }
            }
            self.filteredStudentListArray = filteredArray
        } else {
            self.filteredStudentListArray = self.studentListArray
        }
        updateTableViewStatus(self.filteredStudentListArray!.count > 0)
        studentListTableView.reloadData()
        self.view.endEditing(true)
        return true
    }
    
    func updateTableViewStatus(_ isStudentAvailable:Bool) {
        if isStudentAvailable {
            studentListTableView.isHidden = false
            noStudentLabel.isHidden = true
        } else {
            studentListTableView.isHidden = true
            noStudentLabel.isHidden = false
        }
    }
    
    @objc public func doesCurrentPageHaveActiveUGC() -> Bool {
        if SelectedPageIdentifier != nil {
            if let loadedUgc = studentPageUGCDictionary![SelectedPageIdentifier!] as? [Any] {
                for ugc in loadedUgc {
                    if ugc is SDKPentoolVO {
                        let pentoolVo = ugc as! SDKPentoolVO
                        if pentoolVo.status != DELETE {
                            return true
                        }
                    } else if ugc is SDKFIBVO {
                        let fibVo = ugc as! SDKFIBVO
                        if fibVo.status != DELETE {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    @objc public func getPenToolUGCForPageIdentifier(_ pageIdentifier:String) -> [Any] {
        SelectedPageIdentifier = pageIdentifier
        var penToolArray = [Any]()
        if let ugcArray = studentPageUGCDictionary![SelectedPageIdentifier!] as? [Any] {
            if ugcArray.count > 0 {
                for ugc in ugcArray {
                    if ugc is SDKPentoolVO {
                        penToolArray.append(ugc)
                    }
                }
            }
        }
        return penToolArray
    }
    
    @objc public func getFIBUGCForPageIdentifier(_ pageIdentifier:String) -> [Any] {
        SelectedPageIdentifier = pageIdentifier
        var fibArray = [Any]()
        if let ugcArray = studentPageUGCDictionary![SelectedPageIdentifier!] as? [Any] {
            if ugcArray.count > 0 {
                for ugc in ugcArray {
                    if ugc is SDKFIBVO {
                        let fib = ugc as! SDKFIBVO
                        if fib.status != DELETE {
                            fibArray.append(ugc)
                        }
                    }
                }
            }
        }
        return fibArray
    }
    
    @objc public func updatePenDrawing(_ penDrawing:SDKPentoolVO) {
        if let ugcArray = studentPageUGCDictionary![SelectedPageIdentifier!] as? NSMutableArray {
            if let currentPenUgc = self.getSDKPentoolVOWithLocalID(penDrawing.localID) {
                if ugcArray.contains(currentPenUgc) {
                    ugcArray.remove(currentPenUgc)
                }
            }
            if penDrawing.ugcID != "-1", penDrawing.ugcID != "" {
                ugcArray.add(penDrawing)
            }
            studentPageUGCDictionary?.removeValue(forKey: SelectedPageIdentifier!)
            studentPageUGCDictionary![SelectedPageIdentifier!] = ugcArray as! [Any]
        }
    }
    
    @objc public func updateFIBData(_ fibVO:SDKFIBVO) {
        if let ugcArray = studentPageUGCDictionary![SelectedPageIdentifier!] as? NSMutableArray {
            if let currentPenUgc = self.getSDKFIBVOWithLocalID(fibVO.localID) {
                if ugcArray.contains(currentPenUgc) {
                    ugcArray.remove(currentPenUgc)
                }
            }
            if fibVO.ugcID != "-1", fibVO.ugcID != "" {
                fibVO.status = UPDATE
                ugcArray.add(fibVO)
            }
            studentPageUGCDictionary?.removeValue(forKey: SelectedPageIdentifier!)
            studentPageUGCDictionary![SelectedPageIdentifier!] = ugcArray
        }
    }
    
    @objc public func addPenDrawing(_ penDrawing:SDKPentoolVO) {
        if let loadedUgc = studentPageUGCDictionary![SelectedPageIdentifier!] as? NSMutableArray {
            loadedUgc.add(penDrawing)
            studentPageUGCDictionary?.removeValue(forKey: SelectedPageIdentifier!)
            studentPageUGCDictionary![SelectedPageIdentifier!] = loadedUgc
        }
    }
    
    func getSDKPentoolVOWithLocalID(_ localId:String) -> SDKPentoolVO? {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKPentoolVO {
                    let penUGC = ugc as! SDKPentoolVO
                    if penUGC.localID == localId {
                        return penUGC
                    }
                }
            }
        }
        return nil
    }
    
    func getSDKFIBVOWithLocalID(_ localId:String) -> SDKFIBVO? {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKFIBVO {
                    let penUGC = ugc as! SDKFIBVO
                    if penUGC.localID == localId {
                        return penUGC
                    }
                }
            }
        }
        return nil
    }
    
    @objc public func getSDKFIBVOWithUgcId(_ ugcId:String) -> SDKFIBVO? {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKFIBVO {
                    let penUGC = ugc as! SDKFIBVO
                    if penUGC.ugcID == ugcId {
                        return penUGC
                    }
                }
            }
        }
        return nil
    }
    
    @objc public func getAnotationToSave() -> [Any] {
        var ugctosave = [Any]()
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKPentoolVO {
                    let penToolVO = ugc as! SDKPentoolVO
                    if penToolVO.ugcID == "-1" || penToolVO.ugcID == "" {
                        if penToolVO.status == NEW || penToolVO.status == UPDATE {
                            ugctosave.append(penToolVO)
                        }
                    } else {
                        if penToolVO.status == DELETE {
                            ugctosave.append(penToolVO)
                        }
                    }
                } else if ugc is SDKFIBVO {
                    let fibVO = ugc as! SDKFIBVO
                    if fibVO.status == UPDATE || fibVO.status == DELETE {
                        ugctosave.append(fibVO)
                    }
                }
            }
        }
        return ugctosave
    }
    
    @objc public func isEditingAllowedForLinkID(_ linkId:Int) -> Bool {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKFIBVO {
                    let penUGC = ugc as! SDKFIBVO
                    if penUGC.linkID.intValue == linkId {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @objc public func getSDKFIBVOForLinkID(_ linkId:Int) -> SDKFIBVO? {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKFIBVO {
                    let penUGC = ugc as! SDKFIBVO
                    if penUGC.linkID.intValue == linkId {
                        return penUGC
                    }
                }
            }
        }
        return nil
    }
    
    @objc public func clearAllFIBsForPageID(_ pageId:String) {
        let ugcArray = studentPageUGCDictionary![pageId] as! [Any]
        if ugcArray.count > 0 {
            for ugc in ugcArray {
                if ugc is SDKFIBVO {
                    let fib = ugc as! SDKFIBVO
                    fib.teacherComment = ""
                    fib.text = ""
                    fib.status = DELETE
                }
            }
        }
    }
    
    @objc public func clearAllPenDrawingsForPageID(_ pageId:String) {
        let ugcArray = studentPageUGCDictionary![pageId] as! [Any]
        if ugcArray.count > 0 {
            for ugc in ugcArray {
                if ugc is SDKPentoolVO {
                    let penUgc = ugc as! SDKPentoolVO
                    penUgc.status = DELETE
                }
            }
        }
    }
    
    @objc public func clearAllFIBs() {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKFIBVO {
                    let fib = ugc as! SDKFIBVO
                    fib.teacherComment = ""
                    fib.text = ""
                    fib.status = DELETE
                }
            }
        }
    }
    
    @objc public func clearAllPenDrawings() {
        for ugcArray in studentPageUGCDictionary!.values {
            let pageUgcArray = ugcArray as! [Any]
            for ugc in pageUgcArray {
                if ugc is SDKPentoolVO {
                    let penUgc = ugc as! SDKPentoolVO
                    penUgc.status = DELETE
                }
            }
        }
    }
    
    @objc public func isFIBsAndPentoolAvailableOnPageID(_ pageId:String) -> Bool {
        if studentPageUGCDictionary != nil {
            let ugcArray = studentPageUGCDictionary![pageId] as! [Any]
            if ugcArray.count > 0 {
                for ugc in ugcArray {
                    if ugc is SDKFIBVO {
                        let fib = ugc as! SDKFIBVO
                        if fib.text != "", fib.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                            return true
                        }
                    } else if ugc is SDKPentoolVO {
                        let penVo = ugc as! SDKPentoolVO
                        if penVo.status != DELETE {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    @objc public func isFIBsAndPentoolAvailable() -> Bool {
        if studentPageUGCDictionary != nil {
            for ugcArray in studentPageUGCDictionary!.values {
                let pageUgcArray = ugcArray as! [Any]
                for ugc in pageUgcArray {
                    if ugc is SDKFIBVO {
                        let fib = ugc as! SDKFIBVO
                        if fib.text != "", fib.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                            return true
                        }
                    } else if ugc is SDKPentoolVO {
                        let penVo = ugc as! SDKPentoolVO
                        if penVo.status != DELETE {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    @objc public func startActivityIndicator() {
        blackOverLay = UIView.init()
        blackOverLay!.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.view.addSubview(blackOverLay!)
        blackOverLay!.translatesAutoresizingMaskIntoConstraints = false
        blackOverLay!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        blackOverLay!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        blackOverLay!.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blackOverLay!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.color = .lightGray
        blackOverLay!.addSubview(activityIndicator!)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator!.centerXAnchor.constraint(equalTo: blackOverLay!.centerXAnchor).isActive = true
        activityIndicator!.centerYAnchor.constraint(equalTo: blackOverLay!.centerYAnchor).isActive = true
        activityIndicator!.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator!.heightAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator!.startAnimating()
    }
    
    @objc public func stopActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator!.stopAnimating()
            activityIndicator!.removeFromSuperview()
            activityIndicator = nil
        }
        if blackOverLay != nil {
            blackOverLay!.removeFromSuperview()
            blackOverLay = nil
        }
    }
    
    @objc public func setDataWith(className:String, studentList:NSArray) {
        self.selectedClassName = className
        self.studentListArray = studentList
        self.filteredStudentListArray = self.studentListArray
        updateTableViewStatus(self.filteredStudentListArray!.count > 0)
        if self.studentListArray!.count > 0 {
            for student in self.studentListArray! {
                let studentDict = student as! [String:Any]
                let user = studentDict["user"] as! [String:Any]
                let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
                let studentId = "\(user["id"]!)"
                studentIdArray[studentId] = studentName;
            }
        }
    }
    
    public func getStudentData() {
        if studentIdArray.count > 0 {
            let studentId = studentIdArray.keys.first
            let studentName = studentIdArray[studentId!];
            studentIdArray.removeValue(forKey: studentId!)
            if (FetchEachLearnerData != nil) {
                DispatchQueue.global(qos: .default).async { [self] in
                    FetchEachLearnerData!(studentName!, studentId!)
                }
            }
        } else {
            scheduledTimer.invalidate()
            DispatchQueue.main.async { [self] in
                studentListTableView.reloadData()
            }
        }
    }
    
    @objc func timerAction(){
        DispatchQueue.main.async { [self] in
            studentListTableView.reloadData()
        }
    }
    
    @objc public func serviceFailedWithLearnerID(_ learnerId:String) {
        DispatchQueue.main.async { [self] in
            self.getStudentData()
        }
    }
    
    @objc public func setSubmittedStudentUGCArray(_ studentDataDictionary:[String:Any]) {
        let stdId = studentDataDictionary.keys.first
        DispatchQueue.main.async { [self] in
            self.getStudentData()
        }
        if let studentUgcData = studentDataDictionary[stdId!] as? [String:Any]{
            if let pageUgc = studentUgcData["pageUgc"] as? [Any] {
                if pageUgc.count > 0  {
                    self.studentDataDict[stdId!] = pageUgc
//                    DispatchQueue.main.async { [self] in
//                        for cell in studentListTableView.visibleCells {
//                            let studentCell = cell as! TeacherReviewStudentListTableViewCell
//                            if studentCell.studentId == stdId, studentCell.indexPath!.row < studentListTableView.visibleCells.count {
//                                studentListTableView.reloadRows(at: [studentCell.indexPath! as IndexPath], with: .none)
//                            }
//                        }
//                    }
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStudentListArray!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentDict = self.filteredStudentListArray![(indexPath.row)] as! [String:Any]
        let user = studentDict["user"] as! [String:Any]
        let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
        let studentImageUrl = (user["profilePicURL"] as! String)
        let studentId = "\(user["id"]!)"
        var cell = tableView.dequeueReusableCell(withIdentifier: studentId) as? TeacherReviewStudentListTableViewCell
        if (cell == nil || !cell!.isDataAvailable) {
            if cell == nil {
                cell = TeacherReviewStudentListTableViewCell.init(style: .default, reuseIdentifier: "\(studentId)")
                cell?.userNameLabel.textColor = themeVo!.teacher_studentlist_name_color
                cell?.userNameLabel.text = studentName
                cell?.setProfileImageUrl(studentImageUrl)
                cell?.studentId = studentId
                cell?.indexPath = indexPath
            }
            var isSubmitDataAvailable = false
            if (studentDataDict[studentId] != nil) {
                let pageUgcDict = studentDataDict[studentId] as! [Any]
                if pageUgcDict.count > 0 {
                    isSubmitDataAvailable = true
                    cell?.isDataAvailable = true
                    cell?.showSubmitStatus(isTrue: false)
                } else {
                    cell?.showSubmitStatus(isTrue: true)
                }
            } else {
                cell?.showSubmitStatus(isTrue: true)
            }
            
            if !isSubmitDataAvailable {
                if (FetchEachLearnerData != nil && studentIdArray[studentId] != nil) {
                    studentIdArray.removeValue(forKey: studentId)
                    DispatchQueue.global(qos: .default).async { [self] in
                        FetchEachLearnerData!(studentName, studentId)
                    }
                }
            }
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isIpad() ? 60 : 55
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TeacherReviewStudentListTableViewCell
        cell.selectionStyle = .none
        let studentDict = self.filteredStudentListArray![(indexPath.row)] as! [String:Any]
        let user = studentDict["user"] as! [String:Any]
        let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
        self.selectedLearnerName = studentName
        let studentImageUrl = (user["profilePicURL"] as! String)
        self.selectedLearnerImageUrl = studentImageUrl
        let studentId = "\(user["id"]!)"
        selectedLearnerID = studentId
        if (studentDataDict[cell.studentId!] != nil) {
            let pageUgcDict = studentDataDict[cell.studentId!] as! [Any]
            if pageUgcDict.count > 0 {
                if LearnerSelectionAction != nil {
                    LearnerSelectionAction!(pageUgcDict, studentId)
                }
            }
        } else {
            //Show alert for no submitted data available.
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    @objc public func backButtonTapped() {
        closeViewController()
    }
    
    @objc public func jumpToNextStudent() {
        var isNextStudent = false
        for student in self.studentListArray! {
            let studentDict = student as! [String:Any]
            let user = studentDict["user"] as! [String:Any]
            let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
            self.selectedLearnerName = studentName
            let studentImageUrl = (user["profilePicURL"] as! String)
            self.selectedLearnerImageUrl = studentImageUrl
            let studentId = "\(user["id"]!)"
            if isNextStudent {
                if (studentDataDict[studentId] != nil) {
                    let pageUgcDict = studentDataDict[studentId] as! [Any]
                    if pageUgcDict.count > 0 {
                        let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
                        self.selectedLearnerName = studentName
                        let studentImageUrl = (user["profilePicURL"] as! String)
                        self.selectedLearnerImageUrl = studentImageUrl
                        self.selectedLearnerID = studentId
                        if LearnerSelectionAction != nil {
                            LearnerSelectionAction!(pageUgcDict, studentId)
                        }
                        break
                    }
                }
            }
            if studentId == selectedLearnerID {
                isNextStudent = true
            }
        }
    }
    
    @objc public func jumpToPreviousStudent() {
        let reversedArray = (self.studentListArray?.reversed())! as NSArray
        var isNextStudent = false
        for student in reversedArray {
            let studentDict = student as! [String:Any]
            let user = studentDict["user"] as! [String:Any]
            let studentId = "\(user["id"]!)"
            if isNextStudent {
                if (studentDataDict[studentId] != nil) {
                    let pageUgcDict = studentDataDict[studentId] as! [Any]
                    if pageUgcDict.count > 0 {
                        let studentName = (user["firstName"] as! String) + " " + (user["lastName"] as! String)
                        self.selectedLearnerName = studentName
                        let studentImageUrl = (user["profilePicURL"] as! String)
                        self.selectedLearnerImageUrl = studentImageUrl
                        selectedLearnerID = studentId
                        if LearnerSelectionAction != nil {
                            LearnerSelectionAction!(pageUgcDict, studentId)
                        }
                        break
                    }
                }
            }
            if studentId == selectedLearnerID {
                isNextStudent = true
            }
        }
    }
    
    @objc public func isAvailableNextStudent() -> Bool {
        var isNextStudent = false
        for student in self.studentListArray! {
            let studentDict = student as! [String:Any]
            let user = studentDict["user"] as! [String:Any]
            let studentId = "\(user["id"]!)"
            if isNextStudent {
                if (studentDataDict[studentId] != nil) {
                    let pageUgcDict = studentDataDict[studentId] as! [Any]
                    if pageUgcDict.count > 0 {
                        return true
                    }
                }
            }
            if studentId == selectedLearnerID {
                isNextStudent = true
            }
        }
        return false
    }
    
    @objc public func isAvailablePreviousStudent() -> Bool {
        let reversedArray = (self.studentListArray?.reversed())! as NSArray
        var isNextStudent = false
        for student in reversedArray {
            let studentDict = student as! [String:Any]
            let user = studentDict["user"] as! [String:Any]
            let studentId = "\(user["id"]!)"
            if isNextStudent {
                if (studentDataDict[studentId] != nil) {
                    let pageUgcDict = studentDataDict[studentId] as! [Any]
                    if pageUgcDict.count > 0 {
                        return true
                    }
                }
            }
            if studentId == selectedLearnerID {
                isNextStudent = true
            }
        }
        return false
    }
    
    @objc public func getStudentCount() -> Int {
        if (self.studentListArray != nil && self.studentListArray!.count > 0) {
            return self.studentListArray!.count
        }
        return -1
    }
    
    @objc public func getStudentIndex() -> Int {
        var index = 0
        for student in self.studentListArray! {
            index = index + 1;
            let studentDict = student as! [String:Any]
            let user = studentDict["user"] as! [String:Any]
            let studentId = "\(user["id"]!)"
            if studentId == self.selectedLearnerID {
                return index
            }
        }
        return -1
    }
    
    @objc public func changeClassButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if (DidTapOnChangeClassButton != nil) {
            DidTapOnChangeClassButton!()
        }
    }
    
    @objc public func closeViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if (RemoveAnnotataionController != nil) {
            RemoveAnnotataionController!()
        }
    }

}
