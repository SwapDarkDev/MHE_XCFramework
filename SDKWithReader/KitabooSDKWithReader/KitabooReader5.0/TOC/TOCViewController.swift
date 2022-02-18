  //
  //  TOCViewController.swift
  //  Kitaboo
  //
  //  Created by Hurix System on 20/06/18.
  //  Copyright © 2018 Hurix System. All rights reserved.
  //
  
  import UIKit
  import Kitaboo_Reader_SDK
  
  public struct TOCConstants {
    
    static let bundle = (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : Bundle(for: TOCViewController.self)
    static let font_name = HDKitabooFontManager.getFontName()
  }
  @objc public protocol TOCViewControllerDelegate{
    
    @objc func didSelectActionToCloseTOC() ->(Void)
    @objc func navigateToPage(pageId:NSString) ->(Void)
    @objc func actionForLink(linkVO:KFLinkVO) ->(Void)
    @objc func actionFor(resource:EPUBResource) ->(Void)
    @objc func didSelectTEKSStandard() ->(Void)
    @objc func didSelectELPSStandard() ->(Void)
    @objc func didLoadWebLinkForStandards(webLink:NSString) ->(Void)
    @objc func didSelectInternalResources() ->NSArray
    @objc func didSelectExternalResources() ->(Void)
    @objc func didLoadWebLinkForExternalResources(webLink:NSString) ->(Void)
    @objc func didSelectActionToJumpToBook(bookID:NSString) ->(Void)
    @objc func sessionExpiredOnTOC() ->(Void)
 }
 
 enum SelectedSegment:Int {
    case TOC = 1
    case Bookmark = 2
    case Resources = 3
    
  }
  
  @objc open class TOCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UIGestureRecognizerDelegate{
    
    let segmentView=UIView()
    let lineView2=UIView()
    let lineView3=UIView()
    let teksButton = UIButton()
    let elpsButton = UIButton()
    let standardResourceView = UIView()
    let estimatedRowHeightDict = NSMutableDictionary()
    let estimatedHeaderHeightDict = NSMutableDictionary()
    var lineViewLeftAnchor=NSLayoutConstraint()
    var contentButtonLeadAnchor=NSLayoutConstraint()
    var LineViewTopAnchor=NSLayoutConstraint()
    @objc public var headerHeightConstraint = NSLayoutConstraint()
    var leftConstraintOfContainerView = NSLayoutConstraint()
    var rightConstraintOfContainerView = NSLayoutConstraint()
    var topConstraintOfContainerView = NSLayoutConstraint()
    var topConstraintOfTableView = NSLayoutConstraint()
    var bottomConstraintOfTableView = NSLayoutConstraint()

    open var _dataArray = NSMutableArray()
    open var _resourceArray = NSMutableArray()
    let lineView4=UIView()
    let externalResourceButton = UIButton()
    let internalResourceButton = UIButton()
    let externalResourceView = UIView()
    @objc public var isExternalResourceAvailable:Bool = false
    open var isExternalResourcesSelected:Bool = false
    let noContentAvailableIconColor:String = "#CDCDCD"
    let noContentAvailableTextColor:String = "#6E6E6E"
    var emptyBookMarkContainer: UIView?
    open var _bookMarkArray = NSMutableArray()
    open var _standardResourceArray = NSMutableArray()

    var themeColor=UIColor()
    public let _tableView=UITableView(frame:CGRect.zero, style: .grouped)
    open var selectedButton = TOC
    var segmentWidth = CGFloat()
    var contentButton=UIButton()
    var bookmarkButton=UIButton()
    var resourcesButton=UIButton()
    var standardsButton=UIButton()
    var headerTitle = UILabel()
    open var currentBook=KitabooBookVO()
    open var currentChapter=NSInteger()
    var activePages=NSArray()
    
    var headerDefaultHeight: CGFloat = isIpad() ? 60 : 44
    var tableViewTop:CGFloat = isIpad() ? 1 : 60
    var tableViewBottom:CGFloat = isIpad() ? -50 : -53
    var tableViewLeft:CGFloat = 0
    var tableViewRight:CGFloat = 0
    var segmentViewHeight:CGFloat = isIpad() ? 50 : 50
    var segmentTitleSize:CGFloat = isIpad() ? 20 : 18
    var lineViewLeft:CGFloat = isIpad() ? 60 : 0
    var linkViewRight:CGFloat = isIpad() ? -60 : 0
    var lineView2Left:CGFloat = isIpad() ? 60 : 0
    var previousStateYPosition:CGFloat = 0;
    var headerView:UIView = UIView.init()
    var containerView:UIView = UIView.init()
    var pangestureContainer:UIView = UIView.init()
    var upDirectionIconLbl: UILabel = UILabel.init()
    var tableviewHeaderView : UIView = UIView.init()
    
    var highlightedTextColor = UIColor.init(hexString:"#095E8E")
    open var theme = KBHDThemeVO()
    @objc public var _delegate:TOCViewControllerDelegate?
    @objc public var bookOrientation:BookOrientationMode = kBookOrientationModeDynamic
    @objc public var userSettingsModel = HDReaderSettingModel()
    @objc public var user:KitabooUser?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.backgroundColor = theme.toc_popup_background
        self.view.backgroundColor = isIpad() ? theme.toc_overlay_panel_background .withAlphaComponent(theme.toc_overlay_panel_opacity) : theme.toc_popup_background
        
        if(isIpad()){
        segmentWidth = (self.view.frame.width-120)/3
        }else{
            segmentWidth = self.view.frame.width/3
        }
     
        self.view.layoutIfNeeded()
        selectedButton = TOC
        self.configureContainerView()
        self.tableViewSetup()
        topConstraintOfTableView.constant = tableViewTop
        bottomConstraintOfTableView.constant = 0
        standardResourceView.isHidden = true
        lineView3.isHidden = true
        externalResourceView.isHidden = true
        lineView4.isHidden = true
        self.setAccessibilityForTOC()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topConstraintOfContainerView.constant = isIpad() ? (self.view.frame.height/2) - upDirectionIconLbl.frame.height:upDirectionIconLbl.frame.height

        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func tableViewSetup() {
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.backgroundColor = UIColor.clear
        self.containerView.addSubview(_tableView)
        bottomConstraintOfTableView = _tableView.bottomAnchor.constraint(equalTo:isIpad() ? self.view.bottomAnchor : segmentView.topAnchor , constant: 0)
        bottomConstraintOfTableView.isActive = true
        _tableView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
        _tableView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
         topConstraintOfTableView = _tableView.topAnchor.constraint(equalTo:isIpad() ? segmentView.bottomAnchor : headerView.topAnchor, constant: tableViewTop)
        topConstraintOfTableView.isActive = true
        _tableView.tableFooterView = UIView()
        let nib = UINib.init(nibName: "TOCTableViewCell", bundle: Bundle(for: TOCViewController.self))
        _tableView.register(nib, forCellReuseIdentifier: "TOCTableViewCell")
        let contentCellnib = UINib.init(nibName: "TOCContentCell", bundle: Bundle(for: TOCViewController.self))
        _tableView.register(contentCellnib, forCellReuseIdentifier: "TOCContentCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableviewHeaderView.frame = frame
        _tableView.tableHeaderView = tableviewHeaderView
        tableviewHeaderView.isHidden = true
        _tableView.sectionFooterHeight = 0.0;
        _tableView.separatorStyle = .none
    }
    
    func updateHeaderHeight(headerHeight:CGFloat){
        headerHeightConstraint.constant = headerHeight;
        if(headerHeight == headerDefaultHeight){
            containerView.layer.borderWidth = 0;
            upDirectionIconLbl.isHidden = true;
            headerView.isHidden = false
        }
        else{
            containerView.layer.borderWidth = 0.6;
            upDirectionIconLbl.isHidden = false;
            headerView.isHidden = true
        }
    }
    
    func configureContainerView(){
        //container view setup
        self.view.addSubview(pangestureContainer)
        self.pangestureContainer.backgroundColor = UIColor.clear
        pangestureContainer.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            leftConstraintOfContainerView = pangestureContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
            rightConstraintOfContainerView = pangestureContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0);
            topConstraintOfContainerView = pangestureContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0);
            pangestureContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true


        } else {
            // Fallback on earlier versions
            leftConstraintOfContainerView = pangestureContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
            rightConstraintOfContainerView = pangestureContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0);
            topConstraintOfContainerView = pangestureContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0);
            pangestureContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        };
        topConstraintOfContainerView.priority = .defaultHigh
        leftConstraintOfContainerView.isActive = true
        rightConstraintOfContainerView.isActive = true
        topConstraintOfContainerView.isActive = true

        if(isIpad()){
            self.topArraowIconForIpad()
            self.addPangestureToView(view: pangestureContainer)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.singleTapOnView(tapGes:)))
            tapGesture.delegate = self
            tapGesture.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapGesture)
        }
        self.congigureHeaderView()
        self.configureSegmentView()
        self.pangestureContainer.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        containerView.leadingAnchor.constraint(equalTo: pangestureContainer.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: pangestureContainer.trailingAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo:isIpad() ? upDirectionIconLbl.bottomAnchor : self.pangestureContainer.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: pangestureContainer.bottomAnchor, constant: 0).isActive = true

    }
    
    func congigureHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(headerView)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: isIpad() ? 0 : headerDefaultHeight)
        headerHeightConstraint.isActive=true
        headerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
        headerView.topAnchor.constraint(equalTo: self.containerView.topAnchor,constant:0).isActive=true
        headerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,constant:0).isActive=true
        let backButton = UIButton()
        backButton.setTitle(isIpad() ? ICON_DROPDOWN :ICON_BACK, for: .normal)
        backButton.titleLabel?.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 23 : 22)
        backButton.setTitleColor(theme.toc_selected_toc_title_color, for: UIControl.State.normal)
        backButton.addTarget(self, action:#selector(self.actionForCloseTOC), for: UIControl.Event.touchUpInside)
        backButton.backgroundColor = UIColor.clear
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.accessibilityIdentifier = TOC_BACK_BUTTON
        headerView.addSubview(backButton)
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive=true
        backButton.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 5).isActive=true
        backButton.topAnchor.constraint(equalTo: self.headerView.topAnchor,constant:10).isActive=true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive=true
        
        headerTitle.text = NSLocalizedString("Table_of_Content", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
        headerTitle.backgroundColor = UIColor.clear
        headerTitle.font =  getCustomFont(isIpad() ? 20 : 22)
        headerTitle.textColor=theme.toc_selected_toc_title_color
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerTitle)
        headerTitle.heightAnchor.constraint(equalToConstant: 40).isActive=true
        headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 60
            ).isActive=true
        headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor,constant:10).isActive=true
        headerTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
    }
    
    func topArraowIconForIpad(){
        self.pangestureContainer.addSubview(upDirectionIconLbl)
        upDirectionIconLbl.text = ICON_SCROLLUP
        upDirectionIconLbl.textColor = theme.toc_close_slider_icon_color
        upDirectionIconLbl.textAlignment = .center
        upDirectionIconLbl.font = UIFont(name: HDIconFontConstants.getFontName(), size: 34)
        upDirectionIconLbl.translatesAutoresizingMaskIntoConstraints = false
        upDirectionIconLbl.topAnchor.constraint(equalTo: self.pangestureContainer.topAnchor, constant: 0).isActive = true
        upDirectionIconLbl.centerXAnchor.constraint(equalTo: self.pangestureContainer.centerXAnchor, constant: 0).isActive = true
        upDirectionIconLbl.heightAnchor.constraint(equalToConstant: 46).isActive = true
        upDirectionIconLbl.layer.masksToBounds = false
        upDirectionIconLbl.layer.shadowOffset = CGSize(width: 0, height: -1)
        upDirectionIconLbl.layer.shadowRadius = 4.0
        upDirectionIconLbl.layer.shadowOpacity = 0.8
    }
    
    func configureTableHeaderView(){

        emptyBookMarkContainer  = UIView.init()
        tableviewHeaderView.addSubview(emptyBookMarkContainer!)
        emptyBookMarkContainer!.translatesAutoresizingMaskIntoConstraints = false
        emptyBookMarkContainer!.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor, constant: 0).isActive = true
        emptyBookMarkContainer!.centerYAnchor.constraint(equalTo: tableviewHeaderView.centerYAnchor, constant: 0).isActive = true
        emptyBookMarkContainer!.heightAnchor .constraint(equalToConstant: isIpad() ? 164 : 160).isActive = true
        emptyBookMarkContainer!.widthAnchor .constraint(equalToConstant:200).isActive = true

        let bookMarkIcon = UILabel.init()
        emptyBookMarkContainer!.addSubview(bookMarkIcon)
        bookMarkIcon.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 84 : 80)
        bookMarkIcon.text = "q"
        bookMarkIcon.textColor = UIColor(hexString: noContentAvailableIconColor)
        bookMarkIcon.translatesAutoresizingMaskIntoConstraints = false;
        bookMarkIcon.centerXAnchor.constraint(equalTo: emptyBookMarkContainer!.centerXAnchor).isActive = true
        bookMarkIcon.topAnchor.constraint(equalTo:emptyBookMarkContainer!.topAnchor, constant: 0).isActive = true
        bookMarkIcon.heightAnchor.constraint(equalToConstant: isIpad() ? 84 : 80).isActive = true
        let addBookMarkText = UILabel.init()
        emptyBookMarkContainer!.addSubview(addBookMarkText)
        addBookMarkText.text = NSLocalizedString("Your_added_bookmarks_will_be_listed_here", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
        addBookMarkText.textAlignment = .center
        addBookMarkText.textColor = UIColor(hexString: noContentAvailableTextColor)
        addBookMarkText.font = getCustomFont(isIpad() ? 18 : 16)
        addBookMarkText.numberOfLines = 0;
        addBookMarkText.translatesAutoresizingMaskIntoConstraints = false;
        addBookMarkText.leadingAnchor.constraint(equalTo: emptyBookMarkContainer!.leadingAnchor, constant: 0).isActive = true
        addBookMarkText.centerXAnchor.constraint(equalTo: emptyBookMarkContainer!.centerXAnchor).isActive = true
        addBookMarkText.topAnchor.constraint(equalTo: bookMarkIcon.bottomAnchor ,constant: 10).isActive = true
        addBookMarkText.heightAnchor.constraint(equalToConstant:50).isActive = true

    }
    
    func configureTableHeaderViewForResources(){
        
        emptyBookMarkContainer  = UIView.init();     tableviewHeaderView.addSubview(emptyBookMarkContainer!)
        emptyBookMarkContainer?.translatesAutoresizingMaskIntoConstraints = false
        emptyBookMarkContainer?.centerXAnchor.constraint(equalTo: tableviewHeaderView.centerXAnchor, constant: 0).isActive = true
        emptyBookMarkContainer?.centerYAnchor.constraint(equalTo: tableviewHeaderView.centerYAnchor, constant: 0).isActive = true
        emptyBookMarkContainer?.heightAnchor .constraint(equalToConstant: isIpad() ? 164 : 160).isActive = true
        emptyBookMarkContainer?.widthAnchor .constraint(equalToConstant:200).isActive = true
        
        let bookMarkIcon = UILabel.init()
        emptyBookMarkContainer?.addSubview(bookMarkIcon)
        bookMarkIcon.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 84 : 80)
        bookMarkIcon.text = "!"
        bookMarkIcon.textColor = UIColor(hexString: noContentAvailableIconColor)
        bookMarkIcon.translatesAutoresizingMaskIntoConstraints = false;
        bookMarkIcon.centerXAnchor.constraint(equalTo: emptyBookMarkContainer!.centerXAnchor).isActive = true
        bookMarkIcon.topAnchor.constraint(equalTo:emptyBookMarkContainer!.topAnchor, constant: 0).isActive = true
        bookMarkIcon.heightAnchor.constraint(equalToConstant: isIpad() ? 84 : 80).isActive = true
        let addBookMarkText = UILabel.init()
        emptyBookMarkContainer!.addSubview(addBookMarkText)
        addBookMarkText.text = NSLocalizedString("NO_INTERNAL_RESOURCES", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
        addBookMarkText.textAlignment = .center
        addBookMarkText.textColor = UIColor(hexString: noContentAvailableTextColor)
        addBookMarkText.font = getCustomFont(isIpad() ? 18 : 16)
        addBookMarkText.numberOfLines = 0;
        addBookMarkText.translatesAutoresizingMaskIntoConstraints = false;
        addBookMarkText.leadingAnchor.constraint(equalTo: emptyBookMarkContainer!.leadingAnchor, constant: 0).isActive = true
        addBookMarkText.centerXAnchor.constraint(equalTo: emptyBookMarkContainer!.centerXAnchor).isActive = true
        addBookMarkText.topAnchor.constraint(equalTo: bookMarkIcon.bottomAnchor ,constant: 10).isActive = true
            addBookMarkText.heightAnchor.constraint(equalToConstant:50).isActive = true
        
    }
    
    @objc func actionForCloseTOC(sender:Any) -> Void {
        
        _delegate?.didSelectActionToCloseTOC()
        if(isIpad()){
            self.topConstraintOfContainerView.constant = self.view.frame.height;
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }) { (finished:Bool) in
                self.dismiss(animated: false, completion: nil)
            }
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    func configureSegmentView() -> Void {
        segmentView.translatesAutoresizingMaskIntoConstraints=false
        segmentView.backgroundColor = theme.toc_tab_bg
        self.containerView.addSubview(segmentView)
        segmentView.heightAnchor.constraint(equalToConstant: segmentViewHeight).isActive=true
        segmentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
        segmentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
        segmentView.topAnchor.constraint(equalTo: isIpad() ? headerView.bottomAnchor: self.containerView.bottomAnchor, constant: isIpad() ? 15 : -segmentViewHeight).isActive = true
        
        contentButton.setTitle(NSLocalizedString("Content", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
        contentButton.titleLabel?.font = getCustomFont(segmentTitleSize)
        contentButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
        contentButton.addTarget(self, action:#selector(self.actionForButton), for: UIControl.Event.touchUpInside)
        contentButton.tag = Int(TOC.rawValue)
        contentButton.backgroundColor = UIColor.clear
        contentButton.translatesAutoresizingMaskIntoConstraints = false
        segmentView.addSubview(contentButton)
        contentButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        contentButtonLeadAnchor = contentButton.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor, constant: 0)
        contentButtonLeadAnchor.isActive=true
        contentButton.topAnchor.constraint(equalTo: segmentView.topAnchor,constant:0).isActive=true
        
        //--
        if (isExternalResourceAvailable == true) {
            externalResourceView.translatesAutoresizingMaskIntoConstraints=false
            externalResourceView.backgroundColor = UIColor.clear
            self.containerView.addSubview(externalResourceView)
            externalResourceView.heightAnchor.constraint(equalToConstant: segmentViewHeight).isActive=true
            externalResourceView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
            externalResourceView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
            if (isIpad())
            {
                externalResourceView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant:0).isActive = true
            }
            else
            {
                externalResourceView.bottomAnchor.constraint(equalTo: segmentView.topAnchor, constant:0).isActive = true
            }
            
            
            internalResourceButton.setTitle(NSLocalizedString("INTERNAL_RESOURCES", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            internalResourceButton.titleLabel?.font = getCustomFont(15)
            internalResourceButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            internalResourceButton.addTarget(self, action:#selector(self.actionForInternalResourcesButton), for: UIControl.Event.touchUpInside)
            internalResourceButton.backgroundColor = UIColor.clear
            internalResourceButton.translatesAutoresizingMaskIntoConstraints = false
            externalResourceView.addSubview(internalResourceButton)
            internalResourceButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            internalResourceButton.leadingAnchor.constraint(equalTo: externalResourceView.leadingAnchor).isActive=true
            internalResourceButton.topAnchor.constraint(equalTo: externalResourceView.topAnchor,constant:0).isActive=true
            
            externalResourceButton.setTitle(NSLocalizedString("EXTERNAL_RESOURCES", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            externalResourceButton.titleLabel?.font =  getCustomFont(15)
            externalResourceButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            externalResourceButton.addTarget(self, action:#selector(self.actionForExternalResourcesButton), for: UIControl.Event.touchUpInside)
            externalResourceButton.backgroundColor = UIColor.clear
            externalResourceButton.translatesAutoresizingMaskIntoConstraints = false
            externalResourceView.addSubview(externalResourceButton)
            externalResourceButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            externalResourceButton.leadingAnchor.constraint(equalTo: internalResourceButton.trailingAnchor).isActive=true
            externalResourceButton.trailingAnchor.constraint(equalTo: externalResourceView.trailingAnchor).isActive=true
            externalResourceButton.widthAnchor.constraint(equalTo:internalResourceButton.widthAnchor).isActive = true
            externalResourceButton.topAnchor.constraint(equalTo: externalResourceView.topAnchor,constant:0).isActive=true
        }
        if (_standardResourceArray.count > 0)
        {
            standardResourceView.translatesAutoresizingMaskIntoConstraints=false
            standardResourceView.backgroundColor = UIColor.clear
            self.containerView.addSubview(standardResourceView)
            standardResourceView.heightAnchor.constraint(equalToConstant: segmentViewHeight).isActive=true
            standardResourceView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
            standardResourceView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
            if (isIpad())
            {
                standardResourceView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant:0).isActive = true
            }
            else
            {
                standardResourceView.bottomAnchor.constraint(equalTo: segmentView.topAnchor, constant:0).isActive = true
            }
            
            
            teksButton.setTitle(NSLocalizedString("TEKS", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            teksButton.titleLabel?.font =  getCustomFont(15)
            teksButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            teksButton.addTarget(self, action:#selector(self.actionForTEKSButton), for: UIControl.Event.touchUpInside)
            teksButton.backgroundColor = UIColor.clear
            teksButton.translatesAutoresizingMaskIntoConstraints = false
            standardResourceView.addSubview(teksButton)
            teksButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            teksButton.leadingAnchor.constraint(equalTo: standardResourceView.leadingAnchor).isActive=true
            teksButton.topAnchor.constraint(equalTo: standardResourceView.topAnchor,constant:0).isActive=true
            
            elpsButton.setTitle(NSLocalizedString("ELPS", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            elpsButton.titleLabel?.font =  getCustomFont(15)
            elpsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            elpsButton.addTarget(self, action:#selector(self.actionForELPSButton), for: UIControl.Event.touchUpInside)
            elpsButton.backgroundColor = UIColor.clear
            elpsButton.translatesAutoresizingMaskIntoConstraints = false
            standardResourceView.addSubview(elpsButton)
            elpsButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            elpsButton.leadingAnchor.constraint(equalTo: teksButton.trailingAnchor).isActive=true
            elpsButton.trailingAnchor.constraint(equalTo: standardResourceView.trailingAnchor).isActive=true
            elpsButton.widthAnchor.constraint(equalTo:teksButton.widthAnchor).isActive = true
            elpsButton.topAnchor.constraint(equalTo: standardResourceView.topAnchor,constant:0).isActive=true
            
            
            standardsButton.setTitle(NSLocalizedString("Standards", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            standardsButton.titleLabel?.font =  getCustomFont(segmentTitleSize)
            standardsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            standardsButton.addTarget(self, action:#selector(self.actionForButton), for: UIControl.Event.touchUpInside)
            standardsButton.tag = Int(STANDARDS.rawValue)
            standardsButton.backgroundColor = UIColor.clear
            standardsButton.translatesAutoresizingMaskIntoConstraints = false
            segmentView.addSubview(standardsButton)
            standardsButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            standardsButton.leadingAnchor.constraint(equalTo: contentButton.trailingAnchor).isActive=true
            standardsButton.widthAnchor.constraint(equalTo:contentButton.widthAnchor).isActive = true
            standardsButton.topAnchor.constraint(equalTo: segmentView.topAnchor,constant:0).isActive=true
            
            if(!userSettingsModel.isBookmarkEnabled && _resourceArray.count == 0){
                standardsButton.trailingAnchor.constraint(equalTo:segmentView.trailingAnchor , constant: 0).isActive=true
            }
        }
        
        if(userSettingsModel.isBookmarkEnabled)
        {
            bookmarkButton.setTitle(NSLocalizedString("BOOKMARKS", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            bookmarkButton.titleLabel?.font =  getCustomFont(segmentTitleSize)
            bookmarkButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            bookmarkButton.addTarget(self, action:#selector(self.actionForButton), for: UIControl.Event.touchUpInside)
            bookmarkButton.tag = Int(BOOKMARK.rawValue)
            bookmarkButton.backgroundColor=UIColor.clear
            bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
            segmentView.addSubview(bookmarkButton)
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            if (_standardResourceArray.count>0){
                bookmarkButton.leadingAnchor.constraint(equalTo: standardsButton.trailingAnchor).isActive=true
            }
            else{
                bookmarkButton.leadingAnchor.constraint(equalTo: contentButton.trailingAnchor).isActive=true
            }
            bookmarkButton.topAnchor.constraint(equalTo: segmentView.topAnchor).isActive=true
            bookmarkButton.widthAnchor.constraint(equalTo:contentButton.widthAnchor).isActive = true
            if(_resourceArray.count == 0 && isExternalResourceAvailable == false){
                bookmarkButton.trailingAnchor.constraint(equalTo:segmentView.trailingAnchor , constant: 0).isActive=true
            }
        }
        
        if(_resourceArray.count > 0 || isExternalResourceAvailable == true){
            resourcesButton.setTitle(NSLocalizedString("Resources", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), for: UIControl.State.normal)
            resourcesButton.titleLabel?.font =  getCustomFont(segmentTitleSize)
            resourcesButton.setTitleColor(UIColor(hexString: "#5D5E5D"), for: UIControl.State.normal)
            resourcesButton.addTarget(self, action:#selector(self.actionForButton), for: UIControl.Event.touchUpInside)
            resourcesButton.tag = Int(RESOURCE.rawValue)
            resourcesButton.backgroundColor=UIColor.clear
            resourcesButton.translatesAutoresizingMaskIntoConstraints = false
            segmentView.addSubview(resourcesButton)
            resourcesButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
            resourcesButton.topAnchor.constraint(equalTo: segmentView.topAnchor,constant:0).isActive=true
            resourcesButton.widthAnchor.constraint(equalTo:contentButton.widthAnchor).isActive = true
            if(userSettingsModel.isBookmarkEnabled){
                bookmarkButton.trailingAnchor.constraint(equalTo:resourcesButton.leadingAnchor , constant: 0).isActive=true
            }
            else if(_standardResourceArray.count>0){
                resourcesButton.leadingAnchor.constraint(equalTo:standardsButton.trailingAnchor, constant: 0).isActive=true
            }
            else{
                resourcesButton.leadingAnchor.constraint(equalTo:contentButton.trailingAnchor, constant: 0).isActive=true
            }
            resourcesButton.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor, constant: 0).isActive=true
        }
        
        if(!userSettingsModel.isBookmarkEnabled && _standardResourceArray.count == 0 && _resourceArray.count == 0){
            contentButton.centerXAnchor.constraint(equalTo: segmentView.centerXAnchor).isActive = true
        }

        _tableView.rowHeight = UITableView.automaticDimension;
        _tableView.estimatedRowHeight = 65;
        _tableView.sectionHeaderHeight = UITableView.automaticDimension;
        _tableView.estimatedSectionHeaderHeight = 65;
        
        lineView2.backgroundColor = theme.toc_selected_tab_border
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(lineView2)
        lineView2.heightAnchor.constraint(equalToConstant: 2).isActive=true
        lineView2.topAnchor.constraint(equalTo:isIpad() ? segmentView.bottomAnchor : segmentView.topAnchor, constant: isIpad() ? -2 : 2).isActive=true
        lineViewLeftAnchor = lineView2.leftAnchor.constraint(equalTo: segmentView.leftAnchor , constant: 0)
        lineViewLeftAnchor.isActive = true
        lineView2.widthAnchor.constraint(equalTo: contentButton.widthAnchor).isActive=true
        
        let lineView=UIView()
        lineView.backgroundColor = theme.toc_tab_border
        lineView.translatesAutoresizingMaskIntoConstraints=false
        self.containerView.addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive=true
        lineView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
        lineView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
        LineViewTopAnchor = lineView.topAnchor.constraint(equalTo:isIpad() ? segmentView.bottomAnchor : segmentView.topAnchor, constant: isIpad() ? 0 : 1)
        LineViewTopAnchor.isActive=true
        
        if(_standardResourceArray.count>0)
        {
            lineView3.backgroundColor = theme.toc_tab_border
            lineView3.translatesAutoresizingMaskIntoConstraints=false
            self.containerView.addSubview(lineView3)
            lineView3.heightAnchor.constraint(equalToConstant: 1).isActive=true
            lineView3.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
            lineView3.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
            if(isIpad())
            {
                lineView3.topAnchor.constraint(equalTo:standardResourceView.bottomAnchor, constant: 0).isActive=true
            }
            else
            {
                lineView3.bottomAnchor.constraint(equalTo:standardResourceView.topAnchor, constant: 0).isActive=true
                lineView3.layer.shadowOffset = CGSize(width: 0, height: -1);
                lineView3.layer.shadowRadius = 3.0;
                lineView3.layer.shadowOpacity = 5.0;
            }
        }
        
        if(isExternalResourceAvailable == true)
        {
            lineView4.backgroundColor = theme.toc_tab_border
            lineView4.translatesAutoresizingMaskIntoConstraints=false
            self.containerView.addSubview(lineView4)
            lineView4.heightAnchor.constraint(equalToConstant: 1).isActive=true
            lineView4.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive=true
            lineView4.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive=true
            if(isIpad())
            {
                lineView4.topAnchor.constraint(equalTo:externalResourceView.bottomAnchor, constant: 0).isActive=true
            }
            else
            {
                lineView4.bottomAnchor.constraint(equalTo:externalResourceView.topAnchor, constant: 0).isActive=true
                lineView4.layer.shadowOffset = CGSize(width: 0, height: -1);
                lineView4.layer.shadowRadius = 3.0;
                lineView4.layer.shadowOpacity = 5.0;
            }
        }
    }
    
    func addPangestureToView(view:UIView){
        let pangesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.handlePan(panGes:)))
        pangesture.delegate = self
        pangesture.cancelsTouchesInView = false
        pangestureContainer.addGestureRecognizer(pangesture)
        self.updateHeaderHeight(headerHeight: 0)
        topConstraintOfContainerView.constant = isIpad() ? self.view.frame.height:upDirectionIconLbl.frame.height
        leftConstraintOfContainerView.constant = isIpad() ? 15:0;
        rightConstraintOfContainerView.constant = isIpad() ? -15:0;
        containerView.layer.borderColor = theme.toc_popup_border.cgColor
        containerView.layer.borderWidth = 0.6;
        containerView.layer.masksToBounds = false;
        containerView.layer.shadowOffset = CGSize(width: 0, height: -1);
        containerView.layer.shadowRadius = 4.0;
        containerView.layer.shadowOpacity = 0.6;
        self.view.layoutIfNeeded()
    }
    
    @objc func singleTapOnView(tapGes:UITapGestureRecognizer) {
        self.actionForCloseTOC(sender: tapGes)
    }
    
    @objc func handlePan(panGes:UIPanGestureRecognizer){
        let t:CGPoint = panGes.translation(in: self.view)
        let velocity = panGes.velocity(in: self.view)
        if (panGes.state == .began) {
            
            previousStateYPosition = topConstraintOfContainerView.constant;
            topConstraintOfContainerView.constant = max(-upDirectionIconLbl.frame.height,(previousStateYPosition+t.y));
            
        }else if (panGes.state == .changed) {
            
            topConstraintOfContainerView.constant = max(-upDirectionIconLbl.frame.height,previousStateYPosition+t.y);
            if(topConstraintOfContainerView.constant <= 0){
                rightConstraintOfContainerView.constant = 0;
                leftConstraintOfContainerView.constant = 0;
                self.updateHeaderHeight(headerHeight: headerDefaultHeight)
            }
            else{
                rightConstraintOfContainerView.constant = -15;
                leftConstraintOfContainerView.constant = 15;
                self.updateHeaderHeight(headerHeight: 0)
            }
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }else if (panGes.state == .ended) {
            if(topConstraintOfContainerView.constant < self.view.frame.height/2 && velocity.y < 0){
                topConstraintOfContainerView.constant = -upDirectionIconLbl.frame.height;
                rightConstraintOfContainerView.constant = 0
                leftConstraintOfContainerView.constant = 0
                self.updateHeaderHeight(headerHeight: headerDefaultHeight)
            }
            else if (topConstraintOfContainerView.constant < (self.view.frame.height/2) - upDirectionIconLbl.frame.height && velocity.y > 0){
                topConstraintOfContainerView.constant = (self.view.frame.height/2) - upDirectionIconLbl.frame.height
                rightConstraintOfContainerView.constant = -15
                leftConstraintOfContainerView.constant = 15
                self.updateHeaderHeight(headerHeight: 0)
            }
            else if (topConstraintOfContainerView.constant > (self.view.frame.height/3) - upDirectionIconLbl.frame.height && velocity.y > 0){
                self.actionForCloseTOC(sender:panGes);
                return;
            }
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer {
            if(tapGestureRecognizer.view == self.view){
                return true;
            }
            return false;
        }
        return true;
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        if gestureRecognizer is UITapGestureRecognizer {
            if(touch.view == self.view){
                return true;
            }
            return false;
        }
        return true;
    }
    
    @objc public init(themeVO:KBHDThemeVO ,book:KitabooBookVO, chapter:NSInteger, activePage:NSArray ,bookMarkDataArray:NSArray,resourceDataArray:NSMutableArray,tocDataArray:NSArray,standardResourceArray:NSArray){
        
        super.init(nibName: nil, bundle: nil)
        theme = themeVO;
        currentBook=book;
        currentChapter=chapter;
        activePages=activePage;
        selectedButton = TOC
        _bookMarkArray = bookMarkDataArray.mutableCopy() as! NSMutableArray
        _resourceArray = resourceDataArray.mutableCopy() as! NSMutableArray
        _standardResourceArray = standardResourceArray.mutableCopy() as! NSMutableArray
        self.setData(data: tocDataArray)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func setData(data:NSArray) -> Void {
        _dataArray.removeAllObjects()
        data .enumerateObjects { (object, index, stop) in
            let dict:NSMutableDictionary = NSMutableDictionary(dictionary: object as! NSDictionary)
            dict.setValue(false, forKey:"isExpanded")
            dict.setValue(false, forKey:"isSubCatExpanded")
            _dataArray.add(dict)
            if(self.checkIfCurrentPage(dict:dict)){
                dict.setValue(true, forKey:"isCurrentPage")
            }
            else{
                dict.setValue(false, forKey:"isCurrentPage")
            }
            let subCatArray:NSMutableArray = NSMutableArray()
            dict.setValue(subCatArray, forKey: "subCatArray")
            if let secondLevelArray:NSArray = dict["subnodes"] as? NSArray{
                secondLevelArray.enumerateObjects({ (objectSecond, secondIndex, stop) in
                    let secondLevelDict:NSMutableDictionary = objectSecond as! NSMutableDictionary
                    var isCurrentSection: Bool = false
                    subCatArray.add(secondLevelDict)
                    isCurrentSection = self.formattedSubnodeDict(dict: secondLevelDict, level:String(format: "%d",(index + 1)) , currentIndex: secondIndex, subCatArray: subCatArray)
                    if(isCurrentSection){
                        dict.setValue(true, forKey:"isExpanded")
                    }
                    //                    secondLevelDict.setValue(self.checkIfCurrentPage(dict: secondLevelDict), forKey: "isCurrentPage")
                    //                    if(self.checkIfCurrentPage(dict: secondLevelDict)){
                    //                        dict.setValue(true, forKey:"isExpanded")
                    //                    }
                    //
                    //                    secondLevelDict.setValue(false, forKey: "isSubSubCat")
                    //                    secondLevelDict.setValue(false, forKey:"isExpanded")
                    //                    secondLevelDict.setValue(String(format: "%d.%d",(index+1),(secondIndex + 1)), forKey: "level")
                    //                    var isCurrentSection: Bool = false
                    //                    if let thirdLevelArray:NSArray = secondLevelDict["subnodes"] as? NSArray{
                    //
                    //                        thirdLevelArray.enumerateObjects({ (objectThird, thirdIndex, stop) in
                    //                            let thirdLevelDict:NSMutableDictionary = objectThird as! NSMutableDictionary
                    //                            if(self.checkIfCurrentPage(dict: thirdLevelDict)){
                    //                            isCurrentSection = true
                    //                            }
                    //                            thirdLevelDict.setValue(self.checkIfCurrentPage(dict: thirdLevelDict), forKey: "isCurrentPage")
                    //                            thirdLevelDict.setValue(true, forKey: "isSubSubCat")
                    //                            thirdLevelDict.setValue(String(format: "%d.%d.%d",(index+1),(secondIndex + 1),(thirdIndex + 1)), forKey: "level")
                    //                        })
                    //                        subCatArray.add(secondLevelDict)
                    //                        if(isCurrentSection){
                    //                        secondLevelDict.setValue(true, forKey:"isExpanded")
                    //                        dict.setValue(true, forKey:"isExpanded")
                    //                        subCatArray.addObjects(from: thirdLevelArray as! [Any])
                    //                        }
                    //                    }
                })
                
            }
        }
        self.reloadTable()
    }
    
    func formattedSubnodeDict(dict:NSMutableDictionary,level:String,currentIndex:Int,subCatArray:NSMutableArray) -> Bool {
        var isCurrentSection = false;
        let thirdLevelDict:NSMutableDictionary = dict
        thirdLevelDict.setValue(false, forKey:"isExpanded")
        isCurrentSection = self.checkIfCurrentPage(dict: thirdLevelDict)
        thirdLevelDict.setValue(self.checkIfCurrentPage(dict: thirdLevelDict), forKey: "isCurrentPage")
        thirdLevelDict.setValue(currentIndex, forKey: "isSubSubCat")
        thirdLevelDict.setValue(String(format: "%@.%d",level,(currentIndex + 1)), forKey: "level")
        if let thirdLevelArray:NSArray = thirdLevelDict["subnodes"] as? NSArray{
            thirdLevelArray.enumerateObjects({ (objectThird, thirdIndex, stop) in
                let nextLevelDict:NSMutableDictionary = objectThird as! NSMutableDictionary
                if(self.formattedSubnodeDict(dict: nextLevelDict, level: String(format: "%@.%d",level,(currentIndex + 1)), currentIndex:thirdIndex,subCatArray: subCatArray)){
                    isCurrentSection = true
                }
            })
            
            //Resolved Issue: https://hurixpdg.atlassian.net/browse/CPI-1201
            if currentBook is KFBookVO {
                if(isCurrentSection && (level.components(separatedBy: ".").count < 2)){
                    thirdLevelDict.setValue(true, forKey:"isExpanded")
                    let range:NSRange = NSMakeRange((currentIndex + 1), thirdLevelArray.count)
                    subCatArray.insert(thirdLevelArray as! [Any], at:NSIndexSet(indexesIn: range) as IndexSet)
                }
            }
            else{
                if(isCurrentSection && (level.components(separatedBy: ".").count < 2)){
                    thirdLevelDict.setValue(false, forKey:"isExpanded")
                }
            }
//            if(isCurrentSection && (level.components(separatedBy: ".").count < 2)){
//                thirdLevelDict.setValue(true, forKey:"isExpanded")
//                let range:NSRange = NSMakeRange((currentIndex + 1), thirdLevelArray.count)
//                subCatArray.insert(thirdLevelArray as! [Any], at:NSIndexSet(indexesIn: range) as IndexSet)
//            }
        }
        return isCurrentSection;
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentView.layoutIfNeeded()
        switch selectedButton {
        case TOC:
            lineViewLeftAnchor.constant = isRTL() ? contentButton.frame.origin.x : 0
            break
        case BOOKMARK:
            lineViewLeftAnchor.constant = bookmarkButton.frame.origin.x
            break
        case RESOURCE:
            lineViewLeftAnchor.constant = resourcesButton.frame.origin.x
            break
        case STANDARDS:
            lineViewLeftAnchor.constant = standardsButton.frame.origin.x
            break
        default:
            lineViewLeftAnchor.constant = 0
            break
        }
    }
    
    func checkIfCurrentPage(dict:NSMutableDictionary) -> Bool {
        for page in activePages {
            if let pageVo:KFPageVO = page as? KFPageVO{
                if(pageVo.pageID ==  dict.value(forKey: "pageID") as! Int){
                    return true
                }
                else{
                    return false
                }
            }
            else if let pageVo:EPUBPage = page as? EPUBPage{
                if let src:String = dict.value(forKey: "src") as? String{
                    if(src.contains(pageVo.href)){
                        return true
                    }
                    else{
                        return false
                    }
                }
            }
            return false
        }
        return false
    }
    
   open func checkIfCurrentPageBookMark(bookmarVo: SDKBookmarkVO ) -> Bool {
        for page in activePages {
            if let pageVo:KFPageVO = page as? KFPageVO{
                let pageIdStr = String(format:"%d",pageVo.pageID)
                if( pageIdStr == bookmarVo.pageIdentifier){
                    return true
                }
                else{
                    return false
                }
            }
            else if let pageVo:EPUBPage = page as? EPUBPage{
                let pageIdStr = String(format:"%d",pageVo.fileIndex)
                if( pageIdStr == bookmarVo.pageIdentifier){
                    return true
                }
                else{
                    return false
                }
            }
            return false
        }
        return false
    }
    
    @objc open func actionForButton(sender:UIButton) -> Void {
        self.lineViewLeftAnchor.constant = sender.frame.origin.x
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        tableviewHeaderView.isHidden = true
        estimatedHeaderHeightDict.removeAllObjects()
        estimatedRowHeightDict.removeAllObjects()
        switch sender.tag
        {
        case Int(TOC.rawValue):
            tableviewHeaderView.frame = CGRect.zero;
            selectedButton = TOC
            topConstraintOfTableView.constant = tableViewTop
            bottomConstraintOfTableView.constant = 0
            standardResourceView.isHidden = true
            lineView3.isHidden = true
            externalResourceView.isHidden = true
            lineView4.isHidden = true
            headerTitle.text = NSLocalizedString("Table_of_Content", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
            resourcesButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            standardsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            bookmarkButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            contentButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            break
        case Int(BOOKMARK.rawValue):
            if(_bookMarkArray.count == 0){
                tableviewHeaderView.frame = CGRect(x: 0, y: 0, width:_tableView.frame.width, height:_tableView.frame.height)
                tableviewHeaderView.isHidden = false
                emptyBookMarkContainer?.removeFromSuperview()
                self.configureTableHeaderView();
            }
            else{
                tableviewHeaderView.frame = CGRect.zero;
            }
            selectedButton = BOOKMARK
            topConstraintOfTableView.constant = tableViewTop
            bottomConstraintOfTableView.constant = 0
            standardResourceView.isHidden = true
            lineView3.isHidden = true
            externalResourceView.isHidden = true
            lineView4.isHidden = true
            headerTitle.text = NSLocalizedString("BOOKMARKS", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
            contentButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            resourcesButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            standardsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            bookmarkButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            break
        case Int(RESOURCE.rawValue):
            if(_resourceArray.count == 0 && isExternalResourcesSelected == false){
                emptyBookMarkContainer?.removeFromSuperview()
                self.configureTableHeaderViewForResources();
            }
            tableviewHeaderView.frame = CGRect.zero;
            selectedButton = RESOURCE
            topConstraintOfTableView.constant = tableViewTop
            bottomConstraintOfTableView.constant = 0
            standardResourceView.isHidden = true
            lineView3.isHidden = true
            if isExternalResourceAvailable == true
            {
                bottomConstraintOfTableView.constant = isIpad() ? 0: -segmentViewHeight-5
                topConstraintOfTableView.constant = segmentViewHeight+5
                externalResourceView.isHidden = false
                lineView4.isHidden = false
            }
            
            if (_resourceArray.count == 0 && isExternalResourceAvailable == true && isExternalResourcesSelected == false){
                tableviewHeaderView.frame = CGRect(x: 0, y: 0, width:_tableView.frame.width, height:_tableView.frame.height)
                tableviewHeaderView.isHidden = false
            }
            headerTitle.text =  NSLocalizedString("Table_of_Resources", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
            contentButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            bookmarkButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            standardsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            resourcesButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            break
        case Int(STANDARDS.rawValue):
            tableviewHeaderView.frame = CGRect.zero;
            selectedButton = STANDARDS
            standardResourceView.isHidden = false
            lineView3.isHidden = false
            externalResourceView.isHidden = true
            lineView3.isHidden = true
            self._delegate?.didSelectTEKSStandard()
            topConstraintOfTableView.constant = segmentViewHeight+5
            bottomConstraintOfTableView.constant = isIpad() ? 0: -segmentViewHeight-5
            headerTitle.text = NSLocalizedString("Table_of_Resources", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")
            elpsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            teksButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            contentButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            bookmarkButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            resourcesButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
            standardsButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
            break
        default: break
        }
        self.reloadTable()
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self._tableView.reloadData()
            self._tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedButton {
        case TOC:
            return _dataArray.count
        case BOOKMARK:
            return 1
        case RESOURCE:
            return _resourceArray.count
        case STANDARDS:
            return _standardResourceArray.count
        default:
            return 1
        }
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedButton {
        case TOC:
            if(_dataArray.count > 0) {
                let dict: NSDictionary = _dataArray[section] as! NSDictionary
                if(dict.value(forKey: "isExpanded") as? Bool ?? false){
                    return (dict.value(forKey: "subCatArray") as! NSMutableArray).count
                }
                else{
                    return 0
                }
            }
            else{
                return 0
            }
            
        case BOOKMARK:
            return _bookMarkArray.count
            
        case RESOURCE:
            if(_resourceArray.count > 0 && isExternalResourcesSelected == false) {
                let dict: NSDictionary = _resourceArray[section] as! NSDictionary
                if(dict.value(forKey: "isExpanded") as? Bool ?? false){
                    return (dict.value(forKey: "resourceArray") as! NSArray).count
                }
                else{
                    return 0
                }
            }
            else if(_resourceArray.count > 0 && isExternalResourcesSelected == true){
                let dict: NSDictionary = _resourceArray[section] as! NSDictionary
                if(dict.value(forKey: "isExpanded") as! Bool){
                    return (dict.value(forKey: "subCatArray") as! NSArray).count
                }
                else{
                    return 0
                }
            }
            else{
                return 0
            }
        case STANDARDS:
            if(_standardResourceArray.count > 0) {
                
                let dict: NSDictionary = _standardResourceArray[section] as! NSDictionary
                if(dict.value(forKey: "isExpanded") as! Bool){
                    return (dict.value(forKey: "subCatArray") as! NSArray).count
                }
                else{
                    return 0
                }
            }
            else{
                return 0
            }
        default:
            return 0;
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(selectedButton == TOC ||  (selectedButton == RESOURCE) || (selectedButton == STANDARDS)){
            return UITableView.automaticDimension;
        }
        else{
            return 0.0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedButton {
            //        case BOOKMARK:
        //            return isIpad() ? 74 : 80
        case RESOURCE:
            return 55.4
        default:
            return UITableView.automaticDimension
            
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let estimatedHeight = estimatedRowHeightDict.object(forKey: indexPath) as? CGFloat{
            return estimatedHeight;
        }
        return 65;
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let estimatedHeight = estimatedHeaderHeightDict.object(forKey: section) as? CGFloat{
            return estimatedHeight;
        }
        return 65;
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let height = NSNumber(value: Int(view.frame.size.height))
        self.estimatedHeaderHeightDict.setObject(height, forKey: section as NSCopying)
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Int(cell.frame.size.height))
        estimatedRowHeightDict.setObject(height, forKey: indexPath as NSCopying)
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(selectedButton == TOC)
        {
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "TOCContentCell", for: indexPath) as! TOCContentCell
            contentCell.accessibilityIdentifier = "contentCell\(indexPath)"
            contentCell.sectionHeaderButton.accessibilityIdentifier = "contentCellSectionBtn\(indexPath)"
            contentCell.downArrowButton.accessibilityIdentifier = "contentCellDownArrow\(indexPath)"
            let toc:NSDictionary = _dataArray.object(at: indexPath.section) as! NSDictionary
            let subCat:NSArray
            contentCell.downArrowButton.removeTarget(nil, action: nil, for: .touchUpInside)
            contentCell.sectionHeaderButton.removeTarget(nil, action: nil, for: .touchUpInside)
            contentCell.sectionHeaderButton.isUserInteractionEnabled = false;
            subCat = toc.value(forKey: "subCatArray") as! NSArray
            if(subCat.count > 0){
                let dict : NSMutableDictionary = subCat[indexPath.row] as! NSMutableDictionary
                contentCell.configureViewForToc(dataDictionary: dict, themeVO: theme)
                contentCell.downArrowButton.tag = (indexPath.section * 100) + indexPath.row
                contentCell.downArrowButton.addTarget(self, action:#selector(TOCViewController.didSelectCellDropDownButton(sender:)), for: .touchUpInside)
                if let bookVo = currentBook as? KFBookVO{
                    let chapter:KFChapterVO = bookVo.getChapterForPageID((String(format: "%d", dict.value(forKey: "pageID") as! Int) as NSString) as String?)
                    let pageChapter = chapter.chapterID
                    if(currentChapter==pageChapter)
                    {
                        contentCell.contentView.backgroundColor = theme.toc_selected_toc_section_background
                        contentCell.seperatorView.backgroundColor = theme.toc_selected_toc_section_divider
                        contentCell.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                        contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                        contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                        contentCell.contentView.backgroundColor = theme.toc_selected_toc_section_background
                    }
                }
            }
            return contentCell
        }
        else if(selectedButton == STANDARDS)
        {
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "TOCContentCell", for: indexPath) as! TOCContentCell
            contentCell.accessibilityIdentifier = "standardsCell\(indexPath)"
            contentCell.sectionHeaderButton.accessibilityIdentifier = "standardsCellSectionBtn\(indexPath)"
            contentCell.downArrowButton.accessibilityIdentifier = "standardsCellDownArrow\(indexPath)"
            let toc:NSDictionary = _standardResourceArray.object(at: indexPath.section) as! NSDictionary
            let subCat:NSArray
            contentCell.downArrowButton.removeTarget(nil, action: nil, for: .touchUpInside)
            contentCell.sectionHeaderButton.removeTarget(nil, action: nil, for: .touchUpInside)
            contentCell.sectionHeaderButton.isUserInteractionEnabled = false;
            subCat = toc.value(forKey: "subCatArray") as! NSArray
            let dict : NSMutableDictionary = subCat[indexPath.row] as! NSMutableDictionary
            contentCell.configureViewForStandards(dataDictionary: dict, themeVO: theme)
            contentCell.downArrowButton.tag = (indexPath.section * 100) + indexPath.row
            contentCell.downArrowButton.addTarget(self, action:#selector(TOCViewController.didSelectCellDropDownButton(sender:)), for: .touchUpInside)
            contentCell.dataLabel.numberOfLines = 2
            if contentCell.downArrowButton.isSelected
            {
                contentCell.contentView.backgroundColor = theme.toc_selected_toc_section_background
                contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                contentCell.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                contentCell.dataLabel.numberOfLines = 0
            }
            return contentCell
        }
        else if(selectedButton == BOOKMARK)
        {
            let tocCell = tableView.dequeueReusableCell(withIdentifier: "TOCTableViewCell", for: indexPath) as! TOCTableViewCell
            tocCell.accessibilityIdentifier = "bookMarkCell\(indexPath)"
            tocCell.timeLabel.textColor = theme.toc_pageno_color
            tocCell.pageLabel.textColor = theme.toc_pageno_color
            tocCell.timeLabelBottomConstarint.constant = isIpad() ? 16 : 10;
            tocCell.backgroundColor=UIColor.clear
            tocCell.backgroundView?.backgroundColor=UIColor.clear
            tocCell.contentView.backgroundColor = theme.toc_popup_background
            tocCell.seperatorViewForHeaderView.isHidden = false
            tocCell.cellLeadConstraint.constant = 20
            tocCell.dataLabel.textColor = theme.toc_title_color
            tocCell.seperatorViewForHeaderView.backgroundColor = theme.toc_selected_toc_section_divider
            tocCell.bookmarkLabel.textColor = theme.toc_selected_toc_side_tab_background
            tocCell.barLabel.backgroundColor = UIColor.clear
            tocCell.timeLabel.isHidden=false
            tocCell.pageLabel.isHidden=false
            if (currentBook as? EPUBBookVO)?.meta.layout == ePUBReflowable {
                tocCell.pageLabel.isHidden=true
            }
            let bookmark:SDKBookmarkVO = _bookMarkArray.object(at: indexPath.row) as! SDKBookmarkVO
            tocCell.dataLabel?.text=bookmark.text
            tocCell.bookmarkLabel.text = TOC_BOOKMARK_NORMAL_ICON;
            tocCell.bookmarkLabel.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 26.4 : 20)
            if isRTL(){
                tocCell.pageLabel.text = NSString(format:"%@ %@",bookmark.displayNum,NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")) as String
            }else{
                tocCell.pageLabel.text = NSString(format:"%@ %@",NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), bookmark.displayNum) as String
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a   dd MMM yyyy"
            if (bookmark.getDisplayDate()) != nil{
                tocCell.timeLabel?.text = NSString.getLocalizedString(forDateString: bookmark.getDisplayDate())
            }
            tocCell.barLabel.backgroundColor=UIColor.clear
            tocCell.bookmarkTrailingConstraint.constant = 20;
            tocCell.verticalCenterConstarint.isActive = false
            tocCell.dataLabel.font = getCustomFontForWeight(isIpad() ? 16 : 14, .light)
            tocCell.pageLabel.font = getCustomFont(isIpad() ? 14 : 10)
            tocCell.timeLabel.font = getCustomFont(isIpad() ? 13 : 10)
            if(self.checkIfCurrentPageBookMark(bookmarVo: bookmark)){
                tocCell.barLabel.backgroundColor = theme.toc_selected_toc_title_color
                tocCell.dataLabel.textColor=theme.toc_selected_toc_title_color
            }
            return tocCell
        }
        else
        {
            if isExternalResourcesSelected == false{
                let tocCell = tableView.dequeueReusableCell(withIdentifier: "TOCTableViewCell", for: indexPath) as! TOCTableViewCell
                tocCell.accessibilityIdentifier = "resourcesCell\(indexPath)"
                tocCell.timeLabel.text = ""
                tocCell.pageLabel.textColor = theme.toc_pageno_color
                tocCell.backgroundColor = UIColor.clear
                tocCell.contentView.backgroundColor = theme.toc_popup_background
                tocCell.dataLabel.textColor = theme.toc_title_color
                tocCell.barLabel.backgroundColor = UIColor.clear
                
                tocCell.pageLabel.isHidden = false
                tocCell.timeLabel.isHidden=true
                tocCell.cellLeadConstraint.constant = isIpad() ? 45 : 30
                tocCell.bookmarkTrailingConstraint.constant = 20;
                tocCell.dataLabel.font = getCustomFontForWeight(isIpad() ? 16 : 14, .light)
                tocCell.pageLabel.font = getCustomFont(isIpad() ? 14 : 10)
                tocCell.timeLabel.font = getCustomFont(isIpad() ? 13 : 10)
               
                tocCell.timeLabelBottomConstarint.constant = isIpad() ? 10 : 2;
                tocCell.verticalCenterConstarint.isActive = true
                tocCell.bookmarkTrailingConstraint.constant = 30
                tocCell.barLabel.backgroundColor = UIColor.clear
                //Configure cell for FixedEpub
                if let book = currentBook as? EPUBBookVO, book.meta.layout == ePUBFixedLayout {
                    return configcellForFixedEpub(tocCell, at: indexPath)
                }
                //Configure cell for PDF
                let chapterDict:NSDictionary = _resourceArray.object(at: indexPath.section) as! NSDictionary
                let subCat:NSArray
                subCat = chapterDict.value(forKey: "resourceArray") as! NSArray
                let pageIdDescriptor = NSSortDescriptor(key: "pageID", ascending: true,selector: #selector(NSString.localizedStandardCompare(_:)))
                let titleDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
                
                let sortedArray = subCat.sortedArray(using: [
                    pageIdDescriptor,titleDescriptor
                ])
                if(indexPath.row == subCat.count - 1 && indexPath.section != _resourceArray.count - 1){
                    tocCell.seperatorViewForHeaderView.isHidden = false
                }
                else{
                    tocCell.seperatorViewForHeaderView.isHidden = true
                    
                }
                let resourceDict : NSMutableDictionary = sortedArray[indexPath.row] as! NSMutableDictionary
                if let linkVO: KFLinkVO = resourceDict.value(forKey: "linkVO") as? KFLinkVO{
                    tocCell.bookmarkLabel.text =  linkVO.getIconFor(linkVO.linkType)
                    tocCell.bookmarkLabel.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 20 : 14)
                    tocCell.bookmarkLabel.textColor = theme.toc_selected_toc_icon_color
                }
                if isRTL(){
                    tocCell.pageLabel.text = NSString(format:"%@ %@",resourceDict.value(forKey: "pageID") as! String,NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")) as String
                }else{
                tocCell.pageLabel.text = NSString(format:"%@ %@",NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), resourceDict.value(forKey: "pageID") as! String) as String
                }
                tocCell.dataLabel?.text = resourceDict.value(forKey: "title") as? String
                return tocCell
            }
            else{
                let contentCell = tableView.dequeueReusableCell(withIdentifier: "TOCContentCell", for: indexPath) as! TOCContentCell
                contentCell.accessibilityIdentifier = "externalResourcesCell\(indexPath)"
                contentCell.sectionHeaderButton.accessibilityIdentifier = "externalResourcesCellSectionBtn\(indexPath)"
                contentCell.downArrowButton.accessibilityIdentifier = "externalResourcesCellDownArrow\(indexPath)"
                let toc:NSDictionary = _resourceArray.object(at: indexPath.section) as! NSDictionary
                let subCat:NSArray
                contentCell.downArrowButton.removeTarget(nil, action: nil, for: .touchUpInside)
                contentCell.sectionHeaderButton.removeTarget(nil, action: nil, for: .touchUpInside)
                contentCell.sectionHeaderButton.isUserInteractionEnabled = false;
                subCat = toc.value(forKey: "subCatArray") as! NSArray
                let dict : NSMutableDictionary = subCat[indexPath.row] as! NSMutableDictionary
                contentCell.configureViewForExternalResources(dataDictionary: dict, themeVO: theme)
                contentCell.downArrowButton.tag = (indexPath.section * 100) + indexPath.row
                contentCell.downArrowButton.addTarget(self, action:#selector(TOCViewController.didSelectCellDropDownButton(sender:)), for: .touchUpInside)
                contentCell.dataLabel.numberOfLines = 2
                if contentCell.downArrowButton.isSelected
                {
                    contentCell.contentView.backgroundColor = theme.toc_selected_toc_section_background
                    contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                    contentCell.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                    contentCell.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                    contentCell.dataLabel.numberOfLines = 0
                }
                return contentCell
            }
            
            
        }
    }
    
    func configcellForFixedEpub(_ tocCell: TOCTableViewCell, at indexPath: IndexPath) -> TOCTableViewCell {
        let chapterDict:NSDictionary = _resourceArray.object(at: indexPath.section) as! NSDictionary
    
        let subCat = chapterDict.value(forKey: "resourceArray") as! NSArray
        let pageIdDescriptor = NSSortDescriptor(key: "href", ascending: true,selector: #selector(NSString.localizedStandardCompare(_:)))
        let titleDescriptor = NSSortDescriptor(key: "resourceName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        
        let sortedArray = subCat.sortedArray(using: [
            pageIdDescriptor,titleDescriptor
        ])
        if(indexPath.row == subCat.count - 1 && indexPath.section != _resourceArray.count - 1){
            tocCell.seperatorViewForHeaderView.isHidden = false
        }
        else{
            tocCell.seperatorViewForHeaderView.isHidden = true
            
        }
        let epubResource = sortedArray[indexPath.row] as? EPUBResource
        if let resource = epubResource {
            tocCell.bookmarkLabel.text = iconFor(typeId: resource.typeId)
            tocCell.bookmarkLabel.font = UIFont(name:TOCConstants.font_name, size: isIpad() ? 20 : 14)
            tocCell.bookmarkLabel.textColor = theme.toc_selected_toc_icon_color
        }

        let pageId = (epubResource?.href ?? "").filter { "1"..."9" ~= $0 }
        if isRTL(){
            tocCell.pageLabel.text = NSString(format:"%@ %@",pageId ,NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: "")) as String
        }else{
            tocCell.pageLabel.text = NSString(format:"%@ %@",NSLocalizedString("PAGE", tableName: READER_LOCALIZABLE_TABLE, bundle: TOCConstants.bundle!, value: "", comment: ""), pageId)   as String
        }
        tocCell.dataLabel?.text = epubResource?.resourceName ?? ""
        return tocCell
    }
        
    func iconFor(typeId: String) -> String {
        var iconString = ""
        switch typeId {
        case "video": iconString = ICON_VIDEO1
            break
        case "audio": iconString = ICON_AUDIO
            break
        case "web links": iconString = ICON_WEBLINK
            break
        case "documents": iconString = ICON_ASSESSMENT
            break
        case "image": iconString = ICON_IMAGE1
            break
        case "toc": iconString = ICON_JUMP_TO_SCREEN
            break
        default:
            break
        }
        return iconString
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentHeader = tableView.dequeueReusableCell(withIdentifier: "TOCContentCell") as! TOCContentCell
        contentHeader.levelLabel.textColor = theme.toc_title_color
        contentHeader.dataLabel.textColor = theme.toc_title_color
        contentHeader.downArrowButton.setTitleColor(theme.toc_more_icon_color, for: .normal)
        contentHeader.downArrowButton.setTitleColor(theme.toc_more_icon_color, for: .selected)
        contentHeader.barView.backgroundColor=UIColor.clear
        contentHeader.downArrowButton.isHidden = false
        contentHeader.downArrowButton.tag = section + 100
        contentHeader.downArrowButton.removeTarget(nil, action: nil, for: .touchUpInside)
        contentHeader.sectionHeaderButton.isUserInteractionEnabled = true
        contentHeader.sectionHeaderButton.tag = section + 2000;
        contentHeader.sectionHeaderButton.addTarget(self, action:#selector(TOCViewController.didSelectSection(sender:)), for: .touchUpInside)
        contentHeader.downArrowButton.addTarget(self, action:#selector(TOCViewController.didSelectDropdownForSection(sender:)), for: .touchUpInside)
        contentHeader.seperatorSuperviewLeadingConstraint.constant = 0
        contentHeader.dataLabel.font = getCustomFontForWeight(isIpad() ? 16 : 14, .light)
        contentHeader.levelLabel.text = ""
        contentHeader.levelLabel.font = getCustomFontForWeight(isIpad() ? 16 : 14, .light)
        contentHeader.seperatorView.backgroundColor = theme.toc_selected_toc_section_divider
        contentHeader.contentView.backgroundColor = theme.toc_popup_background;
        if(selectedButton == TOC){
            contentHeader.contentView.accessibilityIdentifier = "contentHeader\(section)"
            contentHeader.sectionHeaderButton.accessibilityIdentifier = "contentHeaderSectionBtn\(section)"
            contentHeader.downArrowButton.accessibilityIdentifier = "contentHeaderDownArrow\(section)"
            contentHeader.cellLeadConstraint.constant = 24
            if section<_dataArray.count{
                let toc:NSDictionary = _dataArray.object(at: section) as! NSDictionary
                let subNodeArray:NSArray = toc.value(forKey: "subCatArray") as! NSArray
                if(subNodeArray.count <= 0){
                    contentHeader.downArrowButton.isHidden = true
                }
                else{
                    contentHeader.downArrowButton.isSelected = toc.value(forKey: "isExpanded") as! Bool;
                }
                var dataText = ""
                if let _ = (toc.value(forKey: "title")) {
                    dataText = String(format:"%@",(toc.value(forKey: "title") as? String)! )
                }
                
                contentHeader.dataLabel.text = dataText
                //contentHeader.levelLabel.text = String(format:"%d. ",(section+1))
                contentHeader.dataLabel.sizeToFit()
                if  (toc.value(forKey:"isCurrentPage") as! Bool) {
                    contentHeader.contentView.backgroundColor = theme.toc_selected_toc_section_background
                    contentHeader.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                    contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
                    contentHeader.levelLabel.textColor = theme.toc_selected_toc_title_color
                    contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                    contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                }else{
                    if let bookVo = currentBook as? KFBookVO{
                        if  let chapter = (bookVo.getChapterForPageID((String(format: "%d", toc.value(forKey: "pageID") as! Int) as NSString) as String?)){
                            let pageChapter = chapter.chapterID
                            if(currentChapter==pageChapter)
                            {
                                contentHeader.contentView.backgroundColor = theme.toc_selected_toc_section_background
                                contentHeader.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                                let subNodeArray:NSArray = toc.value(forKey: "subCatArray") as! NSArray
                                if(subNodeArray.count == 0){
                                    contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
                                    contentHeader.levelLabel.textColor = theme.toc_selected_toc_title_color
                                }
                            }
                        }
                    }
                    else{
                        contentHeader.barView.backgroundColor = UIColor.clear
                        contentHeader.contentView.backgroundColor = theme.toc_popup_background
                        contentHeader.downArrowButton.setTitleColor(theme.toc_more_icon_color, for: UIControl.State.normal)
                        contentHeader.downArrowButton.setTitleColor(theme.toc_more_icon_color, for: UIControl.State.selected)
                    }
                }
                
                contentHeader.layoutIfNeeded()
            }
            return contentHeader.contentView
        }
        
        if(selectedButton == STANDARDS)
        {
            contentHeader.sectionHeaderButton.accessibilityIdentifier = "standardsHeaderSectionBtn\(section)"
            contentHeader.downArrowButton.accessibilityIdentifier = "standardsHeaderDownArrow\(section)"
            contentHeader.cellLeadConstraint.constant = 24
            
            let toc:NSDictionary = _standardResourceArray.object(at: section) as! NSDictionary
            let subNodeArray:NSArray = toc.value(forKey: "subCatArray") as! NSArray
            if(subNodeArray.count <= 0)
            {
                contentHeader.downArrowButton.isHidden = true
            }
            else
            {
                contentHeader.downArrowButton.isSelected = toc.value(forKey: "isExpanded") as! Bool;
            }
            let dataText = String(format:"%@",(toc.value(forKey: "title") as? String)! )
            contentHeader.dataLabel.numberOfLines = 2
            contentHeader.dataLabel.text = dataText
            if contentHeader.downArrowButton.isSelected
            {
                contentHeader.dataLabel.numberOfLines = 0
                contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
                contentHeader.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                contentHeader.contentView.backgroundColor = theme.toc_selected_toc_section_background
            }
            contentHeader.dataLabel.sizeToFit()
            if(subNodeArray.count == 0)
            {
                contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
            }
            contentHeader.layoutIfNeeded()
            return contentHeader.contentView
        }
        if(selectedButton == RESOURCE && _resourceArray.count>0 && isExternalResourcesSelected == false){
            //            if isExternalResourcesSelected == false{
            contentHeader.sectionHeaderButton.accessibilityIdentifier = "resourcesHeaderSectionBtn\(section)"
            contentHeader.downArrowButton.accessibilityIdentifier = "resourcesHeaderDownArrow\(section)"
            let resourDict:NSDictionary? = _resourceArray.object(at: section) as? NSDictionary
            let subNodeArray:NSArray? = (resourDict?.value(forKey: "resourceArray") as? NSArray)
            guard let _ = subNodeArray else{
                return nil
            }
            if(subNodeArray!.count <= 0){
                contentHeader.downArrowButton.isHidden = true
            }
            else{
                contentHeader.downArrowButton.isSelected = resourDict?.value(forKey: "isExpanded") as! Bool;
                
            }
            let dataText = String(format:"%@",(resourDict?.value(forKey: "ChapterName") as? String)! )
            contentHeader.dataLabel.text = dataText
            contentHeader.levelLabel.text = ""
            if  (resourDict?.value(forKey:"isCurrentChapter") as! Bool) {
                contentHeader.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
            }
            contentHeader.cellLeadConstraint.constant = isIpad() ? 35 : 18
            contentHeader.layoutIfNeeded()
            contentHeader.dataLabel.sizeToFit()
            return contentHeader
        }
        if (selectedButton == RESOURCE && isExternalResourcesSelected == true){
            contentHeader.cellLeadConstraint.constant = 24
            contentHeader.sectionHeaderButton.accessibilityIdentifier = "externalResourcesHeaderSectionBtn\(section)"
            contentHeader.downArrowButton.accessibilityIdentifier = "externalResourcesHeaderDownArrow\(section)"
            let toc:NSDictionary = _resourceArray.object(at: section) as! NSDictionary
            let subNodeArray:NSArray = toc.value(forKey: "subCatArray") as! NSArray
            if(subNodeArray.count <= 0)
            {
                contentHeader.downArrowButton.isHidden = true
            }
            else
            {
                contentHeader.downArrowButton.isSelected = toc.value(forKey: "isExpanded") as! Bool;
            }
            let dataText = String(format:"%@",(toc.value(forKey: "title") as? String)! )
            contentHeader.dataLabel.numberOfLines = 2
            contentHeader.dataLabel.text = dataText
            if contentHeader.downArrowButton.isSelected
            {
                contentHeader.dataLabel.numberOfLines = 0
                contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
                contentHeader.barView.backgroundColor = theme.toc_selected_toc_side_tab_background
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.normal)
                contentHeader.downArrowButton.setTitleColor(theme.toc_selected_toc_arrow_color, for: UIControl.State.selected)
                contentHeader.contentView.backgroundColor = theme.toc_selected_toc_section_background
            }
            contentHeader.dataLabel.sizeToFit()
            if(subNodeArray.count == 0)
            {
                contentHeader.dataLabel.textColor = theme.toc_selected_toc_title_color
            }
            contentHeader.layoutIfNeeded()
            return contentHeader.contentView
        }
            
        else{
            return UIView()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedButton == TOC){
            let toc:NSDictionary = _dataArray.object(at: indexPath.section) as! NSDictionary
            if let subCat:NSMutableArray = toc.value(forKey: "subCatArray") as? NSMutableArray {
                let dict : NSMutableDictionary = subCat[indexPath.row] as! NSMutableDictionary
                self.navigateToPage(dict: dict)
            }
            self.reloadTable()
        }
        else if(selectedButton == BOOKMARK){
            let bookmark:SDKBookmarkVO = _bookMarkArray.object(at: indexPath.row) as! SDKBookmarkVO
            self.dismiss(animated: true) {
                if((bookmark.href == nil)){
                    self._delegate?.navigateToPage(pageId: bookmark.pageIdentifier! as NSString)
                }
                else{
                    var path:NSString
                    if(bookmark.positionIdentifier == nil)
                    {
                        path = NSString(format:"%@#%@BOOKMARK", bookmark.href,bookmark.localID)
                    }
                    else
                    {
                        path = NSString(format:"%@#%@BOOKMARK", bookmark.href,bookmark.positionIdentifier)
                    }
                    self._delegate?.navigateToPage(pageId: path)
                }
                
            }
        }
        else if(selectedButton == STANDARDS)
        {
            let cell:TOCContentCell = tableView.cellForRow(at: indexPath) as! TOCContentCell
            if (cell.dataLabel.text?.contains("Narrative: "))!
            {
                self.dismiss(animated: false, completion: nil)
                self._delegate?.navigateToPage(pageId:cell.updatedURL! as NSString)
            }
            else if (cell.dataLabel.text?.contains("Activity: "))!
            {
                self.dismiss(animated: false, completion: nil)
                self._delegate?.didLoadWebLinkForStandards(webLink: cell.updatedURL! as NSString)
            }
        }
        else
        {
            if (_resourceArray.count > 0  && isExternalResourcesSelected == false){
                //Handel didSelect for EPub
                if let book = currentBook as? EPUBBookVO, book.meta.layout == ePUBFixedLayout {
                    handelDidSelectForEpubBook(at: indexPath)
                    reloadTable()
                    return
                }
                //Handel didSelect for PDF
                let toc:NSDictionary = _resourceArray.object(at: indexPath.section) as! NSDictionary
                if let subCat:NSArray = toc.value(forKey: "resourceArray") as? NSArray {
                    let pageIdDescriptor = NSSortDescriptor(key: "pageID", ascending: true,selector: #selector(NSString.localizedStandardCompare(_:)))
                    let titleDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
                    let sortedArray = subCat.sortedArray(using: [
                        pageIdDescriptor,titleDescriptor
                    ])
                    let dict : NSDictionary = sortedArray[indexPath.row] as! NSDictionary
                    self.navigateToPage(dict: dict)
                    self.perform(#selector(performActionForLink), with:dict.value(forKey:"linkVO"), afterDelay: 1.0);
                }
                self.reloadTable()
            }
            else{
                let cell:TOCContentCell = tableView.cellForRow(at: indexPath) as! TOCContentCell
                if let resourceURL = cell.updatedURL
                {
                    self.dismiss(animated: false, completion: nil)
                    self._delegate?.didLoadWebLinkForExternalResources(webLink: resourceURL as NSString)
                }
            }
        }
    }
    
    func handelDidSelectForEpubBook(at indexPath: IndexPath) {
        let toc:NSDictionary = _resourceArray.object(at: indexPath.section) as! NSDictionary
        if let subCat:NSArray = toc.value(forKey: "resourceArray") as? NSArray {
            
            let pageIdDescriptor = NSSortDescriptor(key: "href", ascending: true,selector: #selector(NSString.localizedStandardCompare(_:)))
            let titleDescriptor = NSSortDescriptor(key: "resourceName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
            
            let sortedArray = subCat.sortedArray(using: [
                pageIdDescriptor,titleDescriptor
            ])
            
            let epubResource = sortedArray[indexPath.row] as? EPUBResource
            let dict: NSDictionary = ["src": epubResource?.href ?? ""]
            self.navigateToPage(dict: dict)
            self.perform(#selector(performActionForLink), with:epubResource, afterDelay: 1.0);
        }
    }
    
    @objc open func didSelectSection(sender:UIButton) {
        if(selectedButton == TOC){
            if let dict: NSDictionary  = _dataArray[sender.tag - 2000] as? NSDictionary{
                self.navigateToPage(dict: dict)
            }
        }
        else if(selectedButton == RESOURCE){
            if let dict: NSDictionary  = _resourceArray[sender.tag - 2000] as? NSDictionary{
                self.navigateToPage(dict: dict)
            }
        }
    }
    @objc func performActionForLink(link:Any){
        if let resource = link as? EPUBResource {
            _delegate?.actionFor(resource: resource)
            return
        }
        _delegate?.actionForLink(linkVO: link as! KFLinkVO)
    }
    
    @objc open func navigateToPage(dict:NSDictionary){
        if(isIpad()){
            self.topConstraintOfContainerView.constant = self.view.frame.height;
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }) { (finished:Bool) in
                self.dismiss(animated: false, completion: {
                    if let  src = dict.value(forKey: "src") as? String{
                        self._delegate?.navigateToPage(pageId:String(format: "%@", src) as NSString)
                    }
                    else if let pageId = dict.value(forKey: "pageID") as? String{
                        self._delegate?.navigateToPage(pageId:String(format: "%@", pageId) as NSString)
                    }
                    else{
                        self._delegate?.navigateToPage(pageId:String(format: "%d", dict.value(forKey: "pageID") as! Int) as NSString)
                    }
                })
            }
        }
        else{
            self.dismiss(animated: true, completion: {
                if let  src = dict.value(forKey: "src") as? String{
                    self._delegate?.navigateToPage(pageId:String(format: "%@", src) as NSString)
                }
                else if let pageId = dict.value(forKey: "pageID") as? String{
                    self._delegate?.navigateToPage(pageId:String(format: "%@", pageId) as NSString)
                }
                else{
                    self._delegate?.navigateToPage(pageId:String(format: "%d", dict.value(forKey: "pageID") as! Int) as NSString)
                }
            })
        }
    }
    
    @objc open func didSelectDropdownForSection(sender:UIButton) {
        if(selectedButton == TOC){
            if let dict: NSDictionary  = _dataArray[sender.tag - 100] as? NSDictionary{
                if let subnodesArray = dict.value(forKey: "subnodes") as? NSArray {
                    if(subnodesArray.count > 0){
                        if(dict.value(forKey: "isExpanded") as! Bool){
                            dict.setValue(false, forKey: "isExpanded")
                            subnodesArray.setValue(false, forKey: "isExpanded")
                            let subCatArray = dict.value(forKey: "subCatArray") as! NSMutableArray
                            subCatArray.removeAllObjects()
                            subCatArray.addObjects(from: subnodesArray as! [Any])
                        }
                        else{
                            dict.setValue(true, forKey: "isExpanded")
                        }
                    }
                }
                self.reloadTable()
            }
        }
        else if(selectedButton == STANDARDS){
            if let dict: NSDictionary  = _standardResourceArray[sender.tag - 100] as? NSDictionary{
                if let subnodesArray = dict.value(forKey: "subnodes") as? NSArray {
                    if(subnodesArray.count > 0){
                        if(dict.value(forKey: "isExpanded") as! Bool){
                            dict.setValue(false, forKey: "isExpanded")
                            subnodesArray.setValue(false, forKey: "isExpanded")
                            let subCatArray = dict.value(forKey: "subCatArray") as! NSMutableArray
                            subCatArray.removeAllObjects()
                            subCatArray.addObjects(from: subnodesArray as! [Any])
                        }
                        else{
                            dict.setValue(true, forKey: "isExpanded")
                        }
                    }
                }
                self.reloadTable()
            }
        }
        else  if(selectedButton == RESOURCE){
            if isExternalResourcesSelected == false{
                if let dict: NSDictionary  = _resourceArray[sender.tag - 100] as? NSDictionary{
                    if let subnodesArray = dict.value(forKey: "resourceArray") as? NSArray {
                        if(subnodesArray.count > 0){
                            if(dict.value(forKey: "isExpanded") as! Bool){
                                dict.setValue(false, forKey: "isExpanded")
                            }
                            else{
                                dict.setValue(true, forKey: "isExpanded")
                            }
                        }
                    }
                    self.reloadTable()
                }
            }
            else{
                if let dict: NSDictionary  = _resourceArray[sender.tag - 100] as? NSDictionary{
                    if let subnodesArray = dict.value(forKey: "subnodes") as? NSArray {
                        if(subnodesArray.count > 0){
                            if(dict.value(forKey: "isExpanded") as! Bool){
                                dict.setValue(false, forKey: "isExpanded")
                                subnodesArray.setValue(false, forKey: "isExpanded")
                                let subCatArray = dict.value(forKey: "subCatArray") as! NSMutableArray
                                subCatArray.removeAllObjects()
                                subCatArray.addObjects(from: subnodesArray as! [Any])
                            }
                            else{
                                dict.setValue(true, forKey: "isExpanded")
                            }
                        }
                    }
                    self.reloadTable()
                }
            }
        }
    }
    
    @objc open func didSelectCellDropDownButton(sender:UIButton) {
        guard let cell = sender.superview?.superview as? TOCContentCell else{
            return
        }
        let indexPath = _tableView.indexPath(for: cell)
        //let row = sender.tag % 100
        let row = indexPath?.row ?? sender.tag % 100
        let dataDict:NSDictionary
        if (selectedButton == TOC){
            dataDict = (_dataArray.object(at:indexPath?.section ?? sender.tag/100)) as! NSDictionary
        }
        else if (selectedButton == RESOURCE && isExternalResourcesSelected == true){
            dataDict = (_resourceArray.object(at:sender.tag/100)) as! NSDictionary
        }
        else{
            dataDict = (_standardResourceArray.object(at:sender.tag/100)) as! NSDictionary
        }
        if let subCat:NSMutableArray = dataDict.value(forKey: "subCatArray") as? NSMutableArray {
            let dict : NSMutableDictionary = subCat[row] as! NSMutableDictionary;
            if let subSubCat = dict.value(forKey: "subnodes")  as? NSArray{
                if (subSubCat.count > 0){
                    //if tapped cell dictionary has subnodes then expand and collapse on the basis of isExpanded status
                    if dict.value(forKey: "isExpanded") as! Bool {
                        dict.setValue(false, forKey: "isExpanded")
                        let range:NSRange
                        let lastDict = (subSubCat.lastObject as! NSMutableDictionary)
                        //if it is expanded then for collapse remove all selected dictionary subnodes from subCat object
                        if(lastDict.value(forKey:"isExpanded") as! Bool){
                            let subnodesArray = lastDict.value(forKey: "subnodes")
                            subCat.removeObjects(in:subnodesArray as! [Any] )
                        }
                        if(subCat.contains(subSubCat.lastObject as Any)){
                            range = NSMakeRange(row + 1,subCat.index(of: subSubCat.lastObject as Any) - row)
                            subCat.removeObjects(in:range)
                        }
                    }
                    else{
                        dict.setValue(true, forKey: "isExpanded")
                        subSubCat.setValue(false, forKey: "isExpanded")
                        let range:NSRange = NSMakeRange((row + 1), subSubCat.count)
                        subCat.insert(subSubCat as! [Any], at:NSIndexSet(indexesIn: range) as IndexSet)
                    }
                }
                else{
                    _delegate?.navigateToPage(pageId:String(format: "%d", dict.value(forKey: "pageID") as! Int) as NSString)
                }
            }
            else{
                _delegate?.navigateToPage(pageId:String(format: "%d", dict.value(forKey: "pageID") as! Int) as NSString)
            }
            
        }
        self.reloadTable()
    }
    
    @objc func updateTOCViewConstraints(){
        if(selectedButton == BOOKMARK){
            if(_bookMarkArray.count == 0){
                tableviewHeaderView.frame = CGRect(x: 0, y: 0, width:_tableView.frame.width, height:_tableView.frame.height)
                tableviewHeaderView.isHidden = false
                
            }
            else{
                tableviewHeaderView.frame = CGRect.zero;
            }
        }
    }
    
    override public func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if(bookOrientation == kBookOrientationModeLandscapeOnePageOnly || bookOrientation == kBookOrientationModeLandscapeTwoPageOnly)
        {
            return .landscape;
        }
        else if(bookOrientation == kBookOrientationModePortrait)
        {
            return .portrait;
        }
        return .all;
    }
    
    
    @objc public func setStandardData(data:NSArray) -> Void {
        _standardResourceArray.removeAllObjects()
        data.enumerateObjects { (object, index, stop) in
            let dict:NSMutableDictionary = NSMutableDictionary(dictionary: object as! NSDictionary)
            dict.setValue(false, forKey:"isExpanded")
            _standardResourceArray.add(dict)
            let subCatArray:NSMutableArray = NSMutableArray()
            dict.setValue(subCatArray, forKey: "subCatArray")
            if let secondLevelArray:NSArray = dict["subnodes"] as? NSArray{
                secondLevelArray.enumerateObjects({ (objectSecond, secondIndex, stop) in
                    let secondLevelDict:NSMutableDictionary = objectSecond as! NSMutableDictionary
                    var isCurrentSection: Bool = false
                    subCatArray.add(secondLevelDict)
                    isCurrentSection = self.formattedSubnodeDictForStandards(dict: secondLevelDict, level:String(format: "%d",(index + 1)) , currentIndex: secondIndex, subCatArray: subCatArray)
                    if(isCurrentSection){
                        dict.setValue(true, forKey:"isExpanded")
                    }
                })
                
            }
        }
        self.reloadTable()
    }
    
    @objc public func setExternalResourcesData(data:NSArray) -> Void {
        _resourceArray.removeAllObjects()
        data.enumerateObjects { (object, index, stop) in
            let dict:NSMutableDictionary = NSMutableDictionary(dictionary: object as! NSDictionary)
            dict.setValue(false, forKey:"isExpanded")
            _resourceArray.add(dict)
            let subCatArray:NSMutableArray = NSMutableArray()
            dict.setValue(subCatArray, forKey: "subCatArray")
            if let secondLevelArray:NSArray = dict["subnodes"] as? NSArray{
                secondLevelArray.enumerateObjects({ (objectSecond, secondIndex, stop) in
                    let secondLevelDict:NSMutableDictionary = objectSecond as! NSMutableDictionary
                    var isCurrentSection: Bool = false
                    subCatArray.add(secondLevelDict)
                    isCurrentSection = self.formattedSubnodeDictForExternalResources(dict: secondLevelDict, level:String(format: "%d",(index + 1)) , currentIndex: secondIndex, subCatArray: subCatArray)
                    if(isCurrentSection){
                        dict.setValue(true, forKey:"isExpanded")
                    }
                })
                
            }
        }
        self.reloadTable()
    }
    
    func formattedSubnodeDictForExternalResources(dict:NSMutableDictionary,level:String,currentIndex:Int,subCatArray:NSMutableArray) -> Bool {
        var isCurrentSection = false;
        let thirdLevelDict:NSMutableDictionary = dict
        thirdLevelDict.setValue(false, forKey:"isExpanded")
        thirdLevelDict.setValue(currentIndex, forKey: "isSubSubCat")
        thirdLevelDict.setValue(String(format: "%@.%d",level,(currentIndex + 1)), forKey: "level")
        if let thirdLevelArray:NSArray = thirdLevelDict["subnodes"] as? NSArray{
            thirdLevelArray.enumerateObjects({ (objectThird, thirdIndex, stop) in
                let nextLevelDict:NSMutableDictionary = objectThird as! NSMutableDictionary
                if(self.formattedSubnodeDictForExternalResources(dict: nextLevelDict, level: String(format: "%@.%d",level,(currentIndex + 1)), currentIndex:thirdIndex,subCatArray: subCatArray)){
                    isCurrentSection = true
                }
            })
            if(isCurrentSection && (level.components(separatedBy: ".").count < 2)){
                thirdLevelDict.setValue(true, forKey:"isExpanded")
                let range:NSRange = NSMakeRange((currentIndex + 1), thirdLevelArray.count)
                subCatArray.insert(thirdLevelArray as! [Any], at:NSIndexSet(indexesIn: range) as IndexSet)
            }
        }
        return isCurrentSection;
    }
    func formattedSubnodeDictForStandards(dict:NSMutableDictionary,level:String,currentIndex:Int,subCatArray:NSMutableArray) -> Bool {
        var isCurrentSection = false;
        let thirdLevelDict:NSMutableDictionary = dict
        thirdLevelDict.setValue(false, forKey:"isExpanded")
        thirdLevelDict.setValue(currentIndex, forKey: "isSubSubCat")
        thirdLevelDict.setValue(String(format: "%@.%d",level,(currentIndex + 1)), forKey: "level")
        if let thirdLevelArray:NSArray = thirdLevelDict["subnodes"] as? NSArray{
            thirdLevelArray.enumerateObjects({ (objectThird, thirdIndex, stop) in
                let nextLevelDict:NSMutableDictionary = objectThird as! NSMutableDictionary
                if(self.formattedSubnodeDictForStandards(dict: nextLevelDict, level: String(format: "%@.%d",level,(currentIndex + 1)), currentIndex:thirdIndex,subCatArray: subCatArray)){
                    isCurrentSection = true
                }
            })
            if(isCurrentSection && (level.components(separatedBy: ".").count < 2)){
                thirdLevelDict.setValue(true, forKey:"isExpanded")
                let range:NSRange = NSMakeRange((currentIndex + 1), thirdLevelArray.count)
                subCatArray.insert(thirdLevelArray as! [Any], at:NSIndexSet(indexesIn: range) as IndexSet)
            }
        }
        return isCurrentSection;
    }
    
    @objc func actionForTEKSButton(sender:UIButton) -> Void
    {
        elpsButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
        teksButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
        if (!sender.isSelected)
        {
            self._delegate?.didSelectTEKSStandard()
        }
    }
    
    @objc func actionForELPSButton(sender:UIButton) -> Void
    {
        teksButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
        elpsButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
        if (!sender.isSelected)
        {
            self._delegate?.didSelectELPSStandard()
        }
    }
    
    @objc func actionForInternalResourcesButton(sender:UIButton) -> Void
    {
        externalResourceButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
        internalResourceButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
        if (!sender.isSelected)
        {
            isExternalResourcesSelected = false
            if let resources = self._delegate?.didSelectInternalResources()
            {
                if resources.count>0{
                    _resourceArray.removeAllObjects()
                    _resourceArray = (resources as? NSMutableArray)!
                }
                else{
                    _resourceArray.removeAllObjects()
                    tableviewHeaderView.frame = CGRect(x: 0, y: 0, width:_tableView.frame.width, height:_tableView.frame.height)
                    tableviewHeaderView.isHidden = false
                    emptyBookMarkContainer?.removeFromSuperview()
                    self.configureTableHeaderViewForResources()
                }
                self.reloadTable()
            }
        }
    }
    
    @objc func actionForExternalResourcesButton(sender:UIButton) -> Void
    {
        internalResourceButton.setTitleColor(theme.toc_tab_text_color, for: UIControl.State.normal)
        externalResourceButton.setTitleColor(theme.toc_selected_text_color, for: UIControl.State.normal)
        if (!sender.isSelected)
        {
            isExternalResourcesSelected = true
            tableviewHeaderView.isHidden = true
            emptyBookMarkContainer?.removeFromSuperview()
            tableviewHeaderView.frame = CGRect.zero;
            self._delegate?.didSelectExternalResources()
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAccessibilityForTOC()
    {
        headerTitle.accessibilityIdentifier = TOC_HEADER_TITLE
        contentButton.accessibilityIdentifier = TOC_CONTENT_BUTTON
        standardsButton.accessibilityIdentifier = TOC_STANDARDS_BUTTON
        teksButton.accessibilityIdentifier = TOC_TEKS_BUTTON
        elpsButton.accessibilityIdentifier = TOC_ELPS_BUTTON
        bookmarkButton.accessibilityIdentifier = TOC_BOOKMARK_BUTTON
        resourcesButton.accessibilityIdentifier = TOC_RESOURCES_BUTTON
        internalResourceButton.accessibilityIdentifier = TOC_INTERNAL_RESOURCE_BUTTON
        externalResourceButton.accessibilityIdentifier = TOC_EXTERNAL_RESOURCE_BUTTON
    }
  }
