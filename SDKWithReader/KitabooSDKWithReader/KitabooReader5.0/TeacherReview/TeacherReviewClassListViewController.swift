//
//  TeacherReviewClassListViewController.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 16/06/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

public struct TeacherReviewClassListConstants
{
   static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: TeacherReviewClassListViewController.self)
}

@objc public class TeacherReviewClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    let mainView = UIView.init()
    let classListTableView = UITableView.init()
    var classesInfoArray:NSMutableArray?
    var learnersDict:NSMutableDictionary?
    @objc public var RemoveAnnotataionController :(() -> Void)?
    @objc public var DidSelectClassName :((String,NSArray) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        constructUI()
        configureTableView()
    }
    
    func constructUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapAction))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(mainView)
        mainView.backgroundColor = UIColor.white
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = isIpad() ? 8 : 5
        mainView.translatesAutoresizingMaskIntoConstraints = false
        if isIpad() {
            mainView.widthAnchor.constraint(equalToConstant: 350).isActive = true
            mainView.heightAnchor.constraint(equalToConstant: 400).isActive = true
            mainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            mainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        } else {
            mainView.heightAnchor.constraint(equalToConstant: 350).isActive = true
            mainView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant:10).isActive = true
            mainView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        }
        
        
        let headerView = UIView.init()
//        headerView.backgroundColor = UIColor.lightGray
        mainView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        headerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20).isActive = true
        headerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let selectClassIcon = UILabel.init()
        headerView.addSubview(selectClassIcon)
        selectClassIcon.text = ICON_SELECT_CLASS
        selectClassIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 20)
        selectClassIcon.translatesAutoresizingMaskIntoConstraints = false
        selectClassIcon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        selectClassIcon.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        selectClassIcon.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        selectClassIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let selectClassLabel = UILabel.init()
        headerView.addSubview(selectClassLabel)
        selectClassLabel.text = NSLocalizedString("SELECT_CLASS", tableName: READER_LOCALIZABLE_TABLE, bundle: TeacherReviewStudentListConstants.bundle!, value: "", comment: "")
        selectClassLabel.translatesAutoresizingMaskIntoConstraints = false
        selectClassLabel.leadingAnchor.constraint(equalTo: selectClassIcon.trailingAnchor).isActive = true
        selectClassLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        selectClassLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        selectClassLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let closeIconButton = UIButton.init()
        headerView.addSubview(closeIconButton)
        closeIconButton.addTarget(self, action: #selector(closeTapAction), for: .touchUpInside)
        closeIconButton.setTitle("2", for: .normal)
        closeIconButton.setTitleColor(UIColor.black, for: .normal)
        closeIconButton.titleLabel!.font = UIFont(name: HDIconFontConstants.getFontName(), size: 16)
        closeIconButton.translatesAutoresizingMaskIntoConstraints = false
        closeIconButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeIconButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        closeIconButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        closeIconButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        let classListContainerView = UIView.init()
        mainView.addSubview(classListContainerView)
        classListContainerView.backgroundColor = UIColor.lightGray
        classListContainerView.translatesAutoresizingMaskIntoConstraints = false
        classListContainerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        classListContainerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20).isActive = true
        classListContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        classListContainerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20).isActive = true
        
        classListContainerView.addSubview(classListTableView)
        classListTableView.translatesAutoresizingMaskIntoConstraints = false
        classListTableView.leadingAnchor.constraint(equalTo: classListContainerView.leadingAnchor).isActive = true
        classListTableView.trailingAnchor.constraint(equalTo: classListContainerView.trailingAnchor).isActive = true
        classListTableView.topAnchor.constraint(equalTo: classListContainerView.topAnchor).isActive = true
        classListTableView.bottomAnchor.constraint(equalTo: classListContainerView.bottomAnchor).isActive = true
    }
    
    func configureTableView() {
        classListTableView.separatorStyle = .none;
        classListTableView.bounces = false
        classListTableView.delegate = self
        classListTableView.dataSource = self
        classListTableView.tableHeaderView = nil
        classListTableView.register(UINib(nibName: "TeacherReviewClassListTableViewCell", bundle: Bundle(for: TeacherReviewClassListViewController.self)), forCellReuseIdentifier: "TeacherReviewClassListTableViewCell")
        classListTableView.reloadData()
    }
    
    @objc public func setClasses(classesInfoArray:NSArray) {
        self.classesInfoArray = NSMutableArray.init()
        learnersDict = NSMutableDictionary.init()
        for classInfo in classesInfoArray {
            let classInfoVo = classInfo as! SDKBookClassInfoVO
            self.classesInfoArray?.add(classInfoVo.classTitle!)
            learnersDict?.setObject(classInfoVo.learners!, forKey: classInfoVo.classTitle as NSString)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classesInfoArray!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherReviewClassListTableViewCell", for: indexPath) as! TeacherReviewClassListTableViewCell
        cell.classNameLabel.text = (learnersDict?.allKeys[indexPath.row] as! String)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = (learnersDict?.allKeys[indexPath.row] as! String)
        let learnerList = learnersDict?.value(forKey: selectedClass)
        if (DidSelectClassName != nil) {
            DidSelectClassName!(selectedClass,learnerList as! NSArray)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func closeTapAction() {
        if (RemoveAnnotataionController != nil) {
            RemoveAnnotataionController!()
        }
        closeViewController()
    }
    
    @objc public func closeViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
