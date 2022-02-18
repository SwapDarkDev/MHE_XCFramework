//
//  TextSearchView.swift
//  Kitaboo
//
//  Created by Priyanka Singh on 18/06/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

public struct TextSearchConstants
{
   static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: TextSearchView.self)
}

@objc(TextSearchViewDelegate) public protocol TextSearchViewDelegate {
    func fetchNextSearchResultForText(_ searchText:String, WithStartOffset startOffset:Int, WithBatchSize batchSize:Int) -> NSArray?
}

//#define EstimatedHeightOfTableView 1

@objc public class TextSearchView: UIView,UITableViewDelegate,UITableViewDataSource {
 @objc public var searchBar: UITextField = UITextField.init()
    @objc public var delegate:TextSearchViewDelegate?
    var searchBottomConstraint: NSLayoutConstraint!
    var tableView : UITableView = UITableView.init()
    var tableViewHeightConstraint: NSLayoutConstraint!
    var searchResultArray = NSMutableArray.init()
    var globalsearchResultArray = NSMutableArray.init()
    var searchBarHeight:CGFloat = isIpad() ? 66 : 50
    var tableHeaderViewHeight:CGFloat = isIpad() ? 196 : 160
    
    var estimatedHeightOfTableView:CGFloat = isIpad() ? 120 : 112
    var tableViewMargin:CGFloat = isIpad() ? 22 : 8
    var  currentBook : KitabooBookVO?  = nil
    var tableviewHeaderView : UIView = UIView.init()
    var kbthemeVO :KBHDThemeVO = KBHDThemeVO.init()
    var isElasticSearch:Bool = false
    
    @objc public var cancelBtn = UIButton.init()
    @objc public var openBtn = UIButton.init()
    @objc public var nextBtn = UIButton.init()
    @objc public var PrevBtn = UIButton.init()
    var noResultText = UILabel.init()
    
    @objc public var didClickOnSearchResult :((TextSearchResult) -> Void)?
    @objc public var didClickOnNextResult :((TextSearchResult) -> Void)?
    @objc public var didClickOnPreviousResult :((TextSearchResult) -> Void)?
    @objc public var didClickOnOpenResult :((TextSearchResult) -> Void)?

    @objc public var batchSize : Int = 50;
    @objc public var searchoffset : Int = 0;
    
    /* init textSerach view with
     @param1 frame
     @param2 themeVO
     @param3 currentBookVO
     */
    @objc public func updateSearchDataWithArray(array : Array<Any>)
    {
        searchoffset=searchoffset+batchSize;
        searchResultArray.addObjects(from: array)
        globalsearchResultArray = NSMutableArray.init(array: searchResultArray)
        self.tableView.reloadData();
    }
     
    @objc public init(frame: CGRect,themeVO:KBHDThemeVO,currentBookVO :KitabooBookVO) {
        
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear
        currentBook = currentBookVO;
        kbthemeVO = themeVO
        
        /* initialise search container */
        let searchBarContainerView:UIView = UIView.init(frame: CGRect(x: 0, y: self.frame.height - searchBarHeight, width: self.frame.width, height: searchBarHeight))
        self.addSubview(searchBarContainerView);
        searchBarContainerView.translatesAutoresizingMaskIntoConstraints = false;
        let widthConstraint:NSLayoutConstraint = searchBarContainerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        widthConstraint.priority = UILayoutPriority(rawValue: 750.0)
        widthConstraint.isActive = true
        searchBarContainerView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: 0).isActive = true
        searchBarContainerView.heightAnchor.constraint(equalToConstant:searchBarHeight).isActive = true
        searchBarContainerView.backgroundColor = themeVO.search_separation_background;
            if #available(iOS 11.0, *) {
                searchBarContainerView.leadingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
                searchBarContainerView.trailingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            } else {
                // Fallback on earlier versions
                searchBarContainerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 0).isActive = true
                searchBarContainerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: 0).isActive = true
            }
      //  searchBarContainerView.addSubview(searchBar)
        /* initialise searchTextFieldContainerView */
        let searchTextFieldContainerView = UIView.init()
        searchBarContainerView.addSubview(searchTextFieldContainerView)
        searchTextFieldContainerView.translatesAutoresizingMaskIntoConstraints = false;
        searchTextFieldContainerView.leadingAnchor.constraint(equalTo:searchBarContainerView.leadingAnchor, constant:tableViewMargin).isActive = true
        searchTextFieldContainerView.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 16 : 8).isActive = true
        searchTextFieldContainerView.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? -16 : -8).isActive = true
        searchTextFieldContainerView.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor, constant: -(isIpad() ? 100 : 70)).isActive = true
        searchTextFieldContainerView.backgroundColor = themeVO.search_input_panelBg_color
        searchTextFieldContainerView.layer.cornerRadius = 8;
        searchTextFieldContainerView.clipsToBounds = true
        searchTextFieldContainerView.layer.borderColor = UIColor.white.cgColor;
    
        /* initialise searchIcon */
        let searchIcon: UILabel = UILabel.init()
        searchIcon.text = ICON_SEARCH
        searchIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 16)
        searchIcon.textAlignment = .left
        searchTextFieldContainerView.addSubview(searchIcon)
        searchIcon.backgroundColor = UIColor.white
        searchIcon.textColor = themeVO.search_main_icon_color
        searchIcon.backgroundColor = UIColor.clear
        searchIcon.translatesAutoresizingMaskIntoConstraints = false;
        searchIcon.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.leadingAnchor, constant: isIpad() ? 18 : 16).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        searchIcon.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchIcon.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true

        /* initialise searchBar */
        searchBar.text = ""
        searchBar.textColor = themeVO.search_title_color
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
        let placeholder = NSAttributedString(string:NSLocalizedString("SEARCH", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : themeVO.search_hint_text_color!])
        searchBar.attributedPlaceholder = placeholder

        /* initialise cancel button */
        searchBarContainerView.addSubview(cancelBtn)
        cancelBtn.setTitle(NSLocalizedString("CANCEL", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""), for: .normal)
        cancelBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        cancelBtn.titleLabel?.font = getCustomFont(isIpad() ? 17 : 14)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
        cancelBtn.trailingAnchor.constraint(equalTo:searchBarContainerView.trailingAnchor, constant:  -(tableViewMargin)).isActive = true
       // cancelBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 75 : 60).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor).isActive = true
        cancelBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: 8).isActive = true
        
        self.insertSubview(tableView, belowSubview: searchBarContainerView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
     
        if #available(iOS 11.0, *) {
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        else{
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
            self.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        self.tableView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        let topConstarint:NSLayoutConstraint = self.tableView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10)
        tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0.0)
        tableViewHeightConstraint.isActive = true
        topConstarint.priority = UILayoutPriority(rawValue: 750.0)
        topConstarint.isActive = true
        self.tableView.delegate = self
        self.tableView.backgroundColor = themeVO.search_popup_background
        self.tableView.layer.borderColor = themeVO.search_popup_border.cgColor
        self.tableView.layer.borderWidth = 1;
        self.tableView.tableHeaderView = nil
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = estimatedHeightOfTableView;
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "SearchResultCell", bundle: Bundle(for: TextSearchView.self)), forCellReuseIdentifier:"SearchResultCell")
        //shadow view
        let shadowView: UIView = UIView.init()
        shadowView.backgroundColor = UIColor(hexString:"095E8E")
        self.insertSubview(shadowView, belowSubview: tableView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false;
            if #available(iOS 11.0, *) {
                shadowView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
                self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
            }
            else{
                shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
                self.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
            }
      
        shadowView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        shadowView.heightAnchor.constraint(equalTo:tableView.heightAnchor).isActive = true
        
        tableviewHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableHeaderViewHeight)
        
        /* initialise  noResultIcon */
        let noResultIcon = UILabel.init()
        tableviewHeaderView.addSubview(noResultIcon)
        noResultIcon.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 84 : 80)
        noResultIcon.text = ICON_SEARCH
        noResultIcon.textColor = UIColor(hexString: "#CDCDCD")
        noResultIcon.translatesAutoresizingMaskIntoConstraints = false;
        noResultIcon.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultIcon.centerYAnchor.constraint(equalTo: tableviewHeaderView.centerYAnchor ,constant: -20).isActive = true
        
        /* initialise  noResultText */
        tableviewHeaderView.addSubview(noResultText)
        noResultText.text = NSLocalizedString("search_result_not_found", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: "")
        noResultText.textColor = kbthemeVO.search_subtext_color
        noResultText.font = getCustomFont(isIpad() ? 18 : 14)
        noResultText.translatesAutoresizingMaskIntoConstraints = false;
        noResultText.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultText.topAnchor.constraint(equalTo: noResultIcon.bottomAnchor ,constant: 20).isActive = true

        /* initialise  shadowView */
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false;
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 4.0;
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowColor = UIColor.black.cgColor
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.setAccessibilityForTextSearchView()
    }
    
    /* init with elasticSearch */
    @objc public init(elasticSearch frame: CGRect,themeVO:KBHDThemeVO,currentBookVO :KitabooBookVO) {
        
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear
        isElasticSearch = true
        currentBook = currentBookVO;
        kbthemeVO = themeVO
        let searchBarContainerView:UIView = UIView.init(frame: CGRect(x: 0, y: self.frame.height - searchBarHeight, width: self.frame.width, height: searchBarHeight))
        self.addSubview(searchBarContainerView);
        searchBarContainerView.translatesAutoresizingMaskIntoConstraints = false;
        let widthConstraint:NSLayoutConstraint = searchBarContainerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        widthConstraint.priority = UILayoutPriority(rawValue: 750.0)
        widthConstraint.isActive = true
        
        searchBarContainerView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: 0).isActive = true
        searchBarContainerView.heightAnchor.constraint(equalToConstant:searchBarHeight).isActive = true
        searchBarContainerView.backgroundColor = themeVO.search_separation_background;
        if #available(iOS 11.0, *) {
            searchBarContainerView.leadingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            searchBarContainerView.trailingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        } else {
            // Fallback on earlier versions
            searchBarContainerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 0).isActive = true
            searchBarContainerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: 0).isActive = true
        }
        //  searchBarContainerView.addSubview(searchBar)
        let searchTextFieldContainerView = UIView.init()
        searchBarContainerView.addSubview(searchTextFieldContainerView)
        searchTextFieldContainerView.translatesAutoresizingMaskIntoConstraints = false;
        searchTextFieldContainerView.leadingAnchor.constraint(equalTo:searchBarContainerView.leadingAnchor, constant:tableViewMargin+35).isActive = true
        searchTextFieldContainerView.trailingAnchor.constraint(equalTo:searchBarContainerView.trailingAnchor, constant:-160).isActive = true
        
        searchTextFieldContainerView.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 16 : 8).isActive = true
        searchTextFieldContainerView.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? -16 : -8).isActive = true
        searchTextFieldContainerView.backgroundColor = themeVO.search_input_panelBg_color
        searchTextFieldContainerView.layer.cornerRadius = 8;
        searchTextFieldContainerView.clipsToBounds = true
        searchTextFieldContainerView.layer.borderColor = UIColor.white.cgColor;
        
        let searchIcon: UILabel = UILabel.init()
        searchIcon.text = ICON_SEARCH
        searchIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 16)
        searchIcon.textAlignment = .left
        searchTextFieldContainerView.addSubview(searchIcon)
        searchIcon.backgroundColor = UIColor.white
        searchIcon.textColor = themeVO.search_main_icon_color
        searchIcon.backgroundColor = UIColor.clear
        searchIcon.translatesAutoresizingMaskIntoConstraints = false;
        searchIcon.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.leadingAnchor, constant: isIpad() ? 18 : 16).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        searchIcon.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchIcon.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
       
        searchBar.text = ""
        searchBar.textColor = themeVO.search_title_color
        searchBar.backgroundColor = UIColor.clear
        searchBar.font = getCustomFont( isIpad() ? 17 : 14)
        searchBar.textAlignment = isRTL() ? .right : .left
        searchBar.isUserInteractionEnabled = false
        searchTextFieldContainerView.addSubview(searchBar)
        searchBar.layer.borderColor = UIColor.white.cgColor;
        searchBar.returnKeyType = .search
        searchBar.clearButtonMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false;
        searchBar.leadingAnchor.constraint(equalTo:searchIcon.trailingAnchor, constant:isIpad() ? 12 : 16).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: searchTextFieldContainerView.trailingAnchor, constant: -6).isActive = true
        let placeholder = NSAttributedString(string: NSLocalizedString("SEARCH", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : themeVO.search_hint_text_color!])
        searchBar.attributedPlaceholder = placeholder
        
        searchBarContainerView.addSubview(cancelBtn)
        cancelBtn.setTitle("∞", for: .normal)
        cancelBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
        cancelBtn.leadingAnchor.constraint(equalTo:searchBarContainerView.leadingAnchor, constant:10).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        let searchBarTrailing:NSLayoutConstraint = cancelBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: 12)
        searchBarTrailing.priority = UILayoutPriority(rawValue: 750.0)
        searchBarTrailing.isActive = true
        
        searchBarContainerView.addSubview(PrevBtn)
        PrevBtn.setTitle("G", for: .normal)
        PrevBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        PrevBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        PrevBtn.backgroundColor = UIColor.clear
        PrevBtn.translatesAutoresizingMaskIntoConstraints = false;
        PrevBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (20)).isActive = true
        PrevBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        PrevBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        PrevBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        
        searchBarContainerView.addSubview(nextBtn)
        nextBtn.setTitle("H", for: .normal)
        nextBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        nextBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        nextBtn.backgroundColor = UIColor.clear
        nextBtn.translatesAutoresizingMaskIntoConstraints = false;
        nextBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (70)).isActive = true
        nextBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        nextBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        nextBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        
        searchBarContainerView.addSubview(openBtn)
        openBtn.setTitle("ɺ", for: .normal)
        openBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        openBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        openBtn.backgroundColor = UIColor.clear
        openBtn.translatesAutoresizingMaskIntoConstraints = false;
        openBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (120)).isActive = true
        openBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        openBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        openBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        
        
        
        self.insertSubview(tableView, belowSubview: searchBarContainerView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        
        if #available(iOS 11.0, *) {
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        else{
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
            self.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        self.tableView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        let topConstarint:NSLayoutConstraint = self.tableView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10)
        tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0.0)
        tableViewHeightConstraint.isActive = true
        topConstarint.priority = UILayoutPriority(rawValue: 750.0)
        topConstarint.isActive = true
        self.tableView.delegate = self
        self.tableView.layer.borderColor = themeVO.search_popup_border.cgColor
        self.tableView.layer.borderWidth = 1;
        self.tableView.tableHeaderView = nil
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = estimatedHeightOfTableView;
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "SearchResultCell", bundle: Bundle(for: TextSearchView.self)), forCellReuseIdentifier:"SearchResultCell")
        //shadow view
        let shadowView: UIView = UIView.init()
        shadowView.backgroundColor = UIColor(hexString:"095E8E")
        self.insertSubview(shadowView, belowSubview: tableView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false;
        if #available(iOS 11.0, *) {
            shadowView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        else{
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
            self.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        
        shadowView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        shadowView.heightAnchor.constraint(equalTo:tableView.heightAnchor).isActive = true
        
        tableviewHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableHeaderViewHeight)
        
        let noResultIcon = UILabel.init()
        tableviewHeaderView.addSubview(noResultIcon)
        noResultIcon.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 84 : 80)
        noResultIcon.text = ICON_SEARCH
        noResultIcon.textColor = UIColor(hexString: "#CDCDCD")
        noResultIcon.translatesAutoresizingMaskIntoConstraints = false;
        noResultIcon.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultIcon.centerYAnchor.constraint(equalTo: tableviewHeaderView.centerYAnchor ,constant: -20).isActive = true
        
        tableviewHeaderView.addSubview(noResultText)
        noResultText.text = NSLocalizedString("search_result_not_found", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: "")
        noResultText.textColor = kbthemeVO.search_subtext_color
        noResultText.font = getCustomFont(isIpad() ? 18 : 14)
        noResultText.translatesAutoresizingMaskIntoConstraints = false;
        noResultText.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultText.topAnchor.constraint(equalTo: noResultIcon.bottomAnchor ,constant: 20).isActive = true
        
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false;
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 4.0;
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowColor = UIColor.black.cgColor
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.setAccessibilityForTextSearchView()
    }
    
    @objc public init(ForReaderSearch frame: CGRect,themeVO:KBHDThemeVO,currentBookVO :KitabooBookVO) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        currentBook = currentBookVO
        kbthemeVO = themeVO
        let searchBarContainerView:UIView = UIView.init(frame: CGRect(x: 0, y: self.frame.height - searchBarHeight, width: self.frame.width, height: searchBarHeight))
        self.addSubview(searchBarContainerView)
        searchBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint:NSLayoutConstraint = searchBarContainerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        widthConstraint.priority = UILayoutPriority(rawValue: 750.0)
        widthConstraint.isActive = true
        
        searchBarContainerView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: 0).isActive = true
        searchBarContainerView.heightAnchor.constraint(equalToConstant:searchBarHeight).isActive = true
        searchBarContainerView.backgroundColor = themeVO.search_separation_background;
        if #available(iOS 11.0, *) {
            searchBarContainerView.leadingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            searchBarContainerView.trailingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        } else {
            searchBarContainerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 0).isActive = true
            searchBarContainerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: 0).isActive = true
        }
        
        let searchTextFieldContainerView = UIView.init()
        searchBarContainerView.addSubview(searchTextFieldContainerView)
        searchTextFieldContainerView.translatesAutoresizingMaskIntoConstraints = false;
        searchTextFieldContainerView.leadingAnchor.constraint(equalTo:searchBarContainerView.leadingAnchor, constant:tableViewMargin+35).isActive = true
        searchTextFieldContainerView.trailingAnchor.constraint(equalTo:searchBarContainerView.trailingAnchor, constant:-160).isActive = true
        
        searchTextFieldContainerView.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 16 : 8).isActive = true
        searchTextFieldContainerView.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? -16 : -8).isActive = true
        searchTextFieldContainerView.backgroundColor = themeVO.search_input_panelBg_color
        searchTextFieldContainerView.layer.cornerRadius = 8;
        searchTextFieldContainerView.clipsToBounds = true
        searchTextFieldContainerView.layer.borderColor = UIColor.white.cgColor;
        
        let searchIcon: UILabel = UILabel.init()
        searchIcon.text = ICON_SEARCH
        searchIcon.font = UIFont(name: HDIconFontConstants.getFontName(), size: 16)
        searchIcon.textAlignment = isRTL() ? .right : .left
        searchTextFieldContainerView.addSubview(searchIcon)
        searchIcon.backgroundColor = UIColor.white
        searchIcon.textColor = themeVO.search_main_icon_color
        searchIcon.backgroundColor = UIColor.clear
        searchIcon.translatesAutoresizingMaskIntoConstraints = false;
        searchIcon.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.leadingAnchor, constant: isIpad() ? 18 : 16).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        searchIcon.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchIcon.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
       
        searchBar.text = ""
        searchBar.textColor = themeVO.search_title_color
        searchBar.backgroundColor = UIColor.clear
        searchBar.font = getCustomFont( isIpad() ? 17 : 14)
        searchBar.textAlignment = isRTL() ? .right : .left
        searchBar.isUserInteractionEnabled = true
        searchTextFieldContainerView.addSubview(searchBar)
        searchBar.layer.borderColor = UIColor.white.cgColor;
        searchBar.returnKeyType = .search
        searchBar.clearButtonMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false;
        searchBar.leadingAnchor.constraint(equalTo:searchIcon.trailingAnchor, constant:isIpad() ? 12 : 16).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchTextFieldContainerView.topAnchor, constant: 0).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchTextFieldContainerView.bottomAnchor, constant:0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: searchTextFieldContainerView.trailingAnchor, constant: -6).isActive = true
        let placeholder = NSAttributedString(string: NSLocalizedString("SEARCH", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : themeVO.search_hint_text_color!])
        searchBar.attributedPlaceholder = placeholder
        
        searchBarContainerView.addSubview(cancelBtn)
        cancelBtn.setTitle("∞", for: .normal)
        cancelBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
        cancelBtn.leadingAnchor.constraint(equalTo:searchBarContainerView.leadingAnchor, constant:10).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        let searchBarTrailing:NSLayoutConstraint = cancelBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: 12)
        searchBarTrailing.priority = UILayoutPriority(rawValue: 750.0)
        searchBarTrailing.isActive = true
        
        searchBarContainerView.addSubview(PrevBtn)
        PrevBtn.setTitle("G", for: .normal)
        PrevBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        PrevBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        PrevBtn.backgroundColor = UIColor.clear
        PrevBtn.translatesAutoresizingMaskIntoConstraints = false;
        PrevBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (20)).isActive = true
        PrevBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        PrevBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        PrevBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        
        searchBarContainerView.addSubview(nextBtn)
        nextBtn.setTitle("H", for: .normal)
        nextBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        nextBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        nextBtn.backgroundColor = UIColor.clear
        nextBtn.translatesAutoresizingMaskIntoConstraints = false;
        nextBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (70)).isActive = true
        nextBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        nextBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        nextBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
       
        searchBarContainerView.addSubview(openBtn)
        openBtn.setTitle("ɺ", for: .normal)
        openBtn.setTitleColor(themeVO.search_cross_icon_color,for: .normal)
        openBtn.titleLabel?.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 20 : 14)
        openBtn.backgroundColor = UIColor.clear
        openBtn.translatesAutoresizingMaskIntoConstraints = false;
        openBtn.leadingAnchor.constraint(equalTo:searchTextFieldContainerView.trailingAnchor, constant: (120)).isActive = true
        openBtn.widthAnchor.constraint(equalToConstant: isIpad() ? 30 : 20).isActive = true
        openBtn.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: isIpad() ? 18: 8).isActive = true
        openBtn.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: isIpad() ? (-18) : ( -8)).isActive = true
        
        self.insertSubview(tableView, belowSubview: searchBarContainerView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        if #available(iOS 11.0, *) {
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        else{
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
            self.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        self.tableView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        let topConstarint:NSLayoutConstraint = self.tableView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10)
        tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: 0.0)
        tableViewHeightConstraint.isActive = true
        topConstarint.priority = UILayoutPriority(rawValue: 750.0)
        topConstarint.isActive = true
        self.tableView.delegate = self
        self.tableView.layer.borderColor = themeVO.search_popup_border.cgColor
        self.tableView.layer.borderWidth = 1;
        self.tableView.tableHeaderView = nil
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = estimatedHeightOfTableView;
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "SearchResultCell", bundle: Bundle(for: TextSearchView.self)), forCellReuseIdentifier:"SearchResultCell")
        
        let shadowView: UIView = UIView.init()
        shadowView.backgroundColor = UIColor(hexString:"095E8E")
        self.insertSubview(shadowView, belowSubview: tableView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false;
        if #available(iOS 11.0, *) {
            shadowView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: tableViewMargin).isActive = true
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        else{
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: tableViewMargin).isActive = true
            self.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: tableViewMargin).isActive = true
        }
        
        shadowView.bottomAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 2).isActive = true
        shadowView.heightAnchor.constraint(equalTo:tableView.heightAnchor).isActive = true
        
        tableviewHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableHeaderViewHeight)
        
        let noResultIcon = UILabel.init()
        tableviewHeaderView.addSubview(noResultIcon)
        noResultIcon.font = UIFont(name:HDIconFontConstants.getFontName(), size: isIpad() ? 84 : 80)
        noResultIcon.text = ICON_SEARCH
        noResultIcon.textColor = UIColor(hexString: "#CDCDCD")
        noResultIcon.translatesAutoresizingMaskIntoConstraints = false;
        noResultIcon.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultIcon.centerYAnchor.constraint(equalTo: tableviewHeaderView.centerYAnchor ,constant: -20).isActive = true
        
        tableviewHeaderView.addSubview(noResultText)
        noResultText.text = NSLocalizedString("search_result_not_found", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: "")
        noResultText.textColor = kbthemeVO.search_subtext_color
        noResultText.font = getCustomFont(isIpad() ? 18 : 14)
        noResultText.translatesAutoresizingMaskIntoConstraints = false;
        noResultText.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor).isActive = true
        noResultText.topAnchor.constraint(equalTo: noResultIcon.bottomAnchor ,constant: 20).isActive = true
        
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false;
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 4.0;
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowColor = UIColor.black.cgColor
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.setAccessibilityForTextSearchView()
    }
    
    @objc override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            UIView.animate(withDuration:0.5, animations: {
                if(self.tableView.contentSize.height < (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))){
                    self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
                } else{
                    self.tableViewHeightConstraint.constant = (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))
                }
            }) { (complete) in
                self.layoutIfNeeded()
                
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc public func showGeneratingSearchResultView() {
        self.tableView.tableHeaderView = self.tableviewHeaderView
        self.tableViewHeightConstraint.constant = self.tableHeaderViewHeight
        noResultText.text = NSLocalizedString("GENERATING_SEARCH_RESULT", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: "")
    }
    
    @objc public func renderSearchResult(searchResult:NSArray){
        if isElasticSearch {
            searchoffset = 0
            if(searchResult.count > 0) {
                searchoffset = searchoffset + batchSize;
                self.searchResultArray.removeAllObjects()
                self.globalsearchResultArray.removeAllObjects()
                globalsearchResultArray = NSMutableArray.init(array: searchResult)
            }
        } else {
        DispatchQueue.main.async {
            self.searchResultArray.removeAllObjects()
            self.searchResultArray.addObjects(from: searchResult as! [Any])
            self.globalsearchResultArray = NSMutableArray.init(array: self.searchResultArray)
            /* check if search result count is equal to zero
             if true check if self.searchBar.text?.count is greater or equal to three then  add no result fount heade to tableview
             else render result into tableview
             */
            self.searchoffset = 0;
            if(searchResult.count == 0){
                if((self.searchBar.text?.count)! >= 3){
                self.tableView.tableHeaderView = self.tableviewHeaderView
                    self.tableViewHeightConstraint.constant = self.tableHeaderViewHeight
                }
                else{
                    self.tableView.tableHeaderView = nil;
                    self.tableViewHeightConstraint.constant = 0
                }
                self.tableView.reloadData()
            }
            else{
                self.searchoffset = self.searchoffset+self.batchSize;
            UIView.animate(withDuration:0.5, animations: {
                /* remove no result found header view from table */
                self.tableView.tableHeaderView = nil
                self.tableView.reloadData()
                /* calculate estimated height of table view */
                let estimatedHeight = (self.estimatedHeightOfTableView * CGFloat(searchResult.count - 1))
                
                if(searchResult.count > 1 && estimatedHeight > self.tableViewHeightConstraint.constant){
                    /* check if estimatedHeight is less that height of screen with table margin
                     if yes then self.tableViewHeightConstraint.constant = estimatedHeight;\
                     else self.tableViewHeightConstraint.constant =  (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))
                     */
                    if(estimatedHeight < (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))){
                        self.tableViewHeightConstraint.constant = estimatedHeight;
                    }
                    else{
                        self.tableViewHeightConstraint.constant = (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))
                    }
                }
                else{
                    self.tableViewHeightConstraint.constant = estimatedHeight;
                }
                self.layoutIfNeeded()
            }) { (complete) in
                self.tableView.layoutIfNeeded()
                UIView.animate(withDuration:0.5, animations: {
                    /* check if estimatedHeight is less that height of screen with table margin
                     if yes then set table height self.tableView.contentSize.height\
                     else set table height (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))
                     */
                if(self.tableView.contentSize.height < (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))){
                    self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
                } else{
                        self.tableViewHeightConstraint.constant = (self.frame.size.height - (self.searchBarHeight + self.tableViewMargin))
                }
                }) { (complete) in
                        self.layoutIfNeeded()

                }
            }
        }
        }
        }
    }
    
    // number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultArray.count
    }
    
    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.accessibilityIdentifier = "readerSearchResultCell\(indexPath)"
        let textSearchResult:TextSearchResult = self.searchResultArray.object(at: indexPath.row) as! TextSearchResult
        cell.setData(seachResult: textSearchResult,selectedTextColor: kbthemeVO.search_selected_text_color,textColor:kbthemeVO.search_description_color )
        //cell.chapterNameLabel.font = getCustomFont(isIpad() ? 16:14) //used italic system font
        cell.pageNumberLabel.font = getCustomFont(isIpad() ? 16:14)
        if let bookVo = currentBook as? KFBookVO{
            if let pagenumber : String = textSearchResult.pageIndex as String?{
                let chapter:KFChapterVO = bookVo.getChapterForPageID(pagenumber)
                cell.chapterNameLabel.text = chapter.title
                if isRTL(){
                    cell.pageNumberLabel.text = String(format:"%@ %@",pagenumber,NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""))
                }else{
                cell.pageNumberLabel.text = String(format:"%@ %@",NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TextSearchConstants.bundle!, value: "", comment: ""), pagenumber)
                }
            }
          
        }
        else{
            cell.chapterNameLabel.text = textSearchResult.displayNumber
            if let pagenumber : String = textSearchResult.pageIndex as String?{
                if let range = pagenumber.range(of: "/") {
                    let pageNumwidDot = String(pagenumber[range.upperBound...])
                    if let rangeOfDot = pageNumwidDot.range(of: ".") {
                        let pageNum = String(pageNumwidDot[...rangeOfDot.lowerBound])
                        cell.pageNumberLabel.text = pageNum.replacingOccurrences(of: ".", with: "")
                    }
                }
            }
            else{
            cell.pageNumberLabel.text = ""
            }
        }
        cell.chapterNameLabel.textColor = kbthemeVO.search_subtext_color
        cell.pageNumberLabel.textColor = kbthemeVO.search_subtext_color
        cell.pageNumberLabel.sizeToFit()
        cell.chapterNameLabel.sizeToFit()
        if indexPath.row%2 == 0 {
            cell.backgroundColor = kbthemeVO.search_separation_background
        }
        else{
            cell.backgroundColor = kbthemeVO.search_popup_background
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        if(indexPath.row==searchResultArray.count-2 && (currentBook as? EPUBBookVO) != nil)
        {
            let nextSearchResultArray = delegate?.fetchNextSearchResultForText(searchBar.text!, WithStartOffset: searchoffset, WithBatchSize: batchSize)
            if nextSearchResultArray!.count > 0 {
                self.updateSearchDataWithArray(array: nextSearchResultArray as! Array<Any>)
            }
        }
    }
    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textSearchResult:TextSearchResult = self.searchResultArray.object(at: indexPath.row) as! TextSearchResult
        if(self.didClickOnSearchResult != nil){
            if searchBar.isFirstResponder {
                searchBar.resignFirstResponder()
            }
            self.didClickOnSearchResult!(textSearchResult);
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    @objc public func showSearchResultView() {
        self.searchResultArray.removeAllObjects()
        self.searchResultArray.addObjects(from: globalsearchResultArray as! [Any])
        self.tableView.reloadData()
    }
    
    @objc public func removeSearchResultView(){
        self.tableView.tableHeaderView = nil;
        self.tableViewHeightConstraint.constant = 0
        self.searchResultArray.removeAllObjects()
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (complete) in
        }
    }
    
    func setAccessibilityForTextSearchView(){
        searchBar.accessibilityIdentifier = READER_SEARCH_TEXT_FIELD
        cancelBtn.accessibilityIdentifier = READER_SEARCH_CANCEL_BUTTON
        openBtn.accessibilityIdentifier = READER_SEARCH_OPEN_BUTTON
        nextBtn.accessibilityIdentifier = READER_SEARCH_NEXT_BUTTON
        PrevBtn.accessibilityIdentifier = READER_SEARCH_PREV_BUTTON
    }
    
    @objc public func getNextSearchResult(_ currentSearchResult:TextSearchResult) -> TextSearchResult? {
        if globalsearchResultArray.count > 0 && globalsearchResultArray.contains(currentSearchResult) {
            let currentIndex = globalsearchResultArray.index(of: currentSearchResult)
            if (currentIndex + 1) < globalsearchResultArray.count {
                let nextSearchResult = globalsearchResultArray.object(at: currentIndex + 1) as! TextSearchResult
                return nextSearchResult
            } else if (currentBook as? EPUBBookVO) != nil {
                let nextSearchResultArray = delegate?.fetchNextSearchResultForText(searchBar.text!, WithStartOffset: searchoffset, WithBatchSize: batchSize)
                if nextSearchResultArray!.count > 0 {
                    globalsearchResultArray.addObjects(from: nextSearchResultArray as! Array<Any>)
                    return self.getNextSearchResult(currentSearchResult)
                }
            }
        }
        return nil
    }
    
    @objc public func getPreviousSearchResult(_ currentSearchResult:TextSearchResult) -> TextSearchResult? {
        if globalsearchResultArray.count > 0 && globalsearchResultArray.contains(currentSearchResult) {
            let currentIndex = globalsearchResultArray.index(of: currentSearchResult)
            if (currentIndex - 1) < globalsearchResultArray.count && currentIndex > 0  {
                let nextSearchResult = globalsearchResultArray.object(at: currentIndex - 1) as! TextSearchResult
                return nextSearchResult
            }
        }
        return nil
    }

}
