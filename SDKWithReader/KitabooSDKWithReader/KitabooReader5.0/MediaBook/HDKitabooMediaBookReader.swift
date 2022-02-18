//
//  HDKitabooMediaBookPlayerController.swift
//  KitabooSDKWithReader
//
//  Created by Jyoti Suthar on 09/03/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//


import UIKit
import MediaPlayer
import Kitaboo_Reader_SDK

public struct HDKitabooMediaBookReaderConstants {
  
    static let font_name = HDKitabooFontManager.getFontName()
}

/**
  The delegate of a HDKitabooMediaBookReader object must adopt the HDKitabooMediaBookReaderDelegate protocol.
 
 HDKitabooMediaBookReaderDelegate Protocol used to handle all the callbacks of HDKitabooMediaBookReader Class.The HDKitabooMediaBookReaderDelegate protocol defines methods to provide callback when user perform any action on HDKitabooMediaBookReader.

  When configuring the HDKitabooMediaBookReader object, assign your delegate object to its delegate property.
*/
@objc public protocol HDKitabooMediaBookReaderDelegate {
    /**
     Delegate method when tapped on back button
     
     This method will be called when user tap on the back button
     */
    @objc optional func didTapOnBack(_ additionalInfo:Dictionary<AnyHashable, Any>, mediaBookReader:HDKitabooMediaBookReader)
    
    /**
     Delegate method to update the thumbnail image

     This method will be called to set the thumbnail image.User need to return UIImageView after setting the image from thumbnailURL.If the UIImageView is not returned then SDK will load the image itself.
     UIImageView is not returned then
     - parameter thumbnailURL :thumbnailURL is the image URL String.thumbnailURL is the url of the image that needs to be displayed
    */
    @objc optional func imageViewForThumbnail(_ thumbnailURL:String) -> UIImageView?
    
    
    /**
     Delegate method when bookmark is created/deleted
     
     This method will be called when the bookmark is created/deleted
     - parameter bookmarkVO is the SDKBookmarkVO object.
     */
    @objc optional func didBookmarkComplete(bookmarkVO: SDKBookmarkVO)
    
    /**
    Delegate method which will be called for every 10 seconds.
    
    This method will be called for every 10 seconds.
    - parameter additionalInfo is the Dictionary object which actually contains the details such as currentTime, ChapterName , FolioID and the fileName of the Audio.
    */
    @objc optional func didSchedulerCalledWithInfo(_ additionalInfo:Dictionary<AnyHashable, Any>)
    
    /**
    Delegate method will be called when HLS Online media url service gets failed.
    
    - parameter error is the error for which HLS Media gets failed.
    - parameter bookId is the bookId for which HLS Media gets failed.
    - parameter timeStamp is the time stampe  for which HLS Media gets failed.
    */
    @objc optional func didHLSMediaServiceFail(error:Error, bookId:NSNumber, timeStamp:NSNumber)
    
    /**
    Delegate method will be called when HLS Online media URL service gets called successfully.
    
    - parameter mediaPath is the mediaPath which is loaded.
    - parameter bookId is the bookId for which mediaPath is loaded.
    */
    @objc optional func didHLSMediaServiceCallSuccessfully(mediaPath:String, withBookID bookId:NSNumber)
    
    /**
    Delegate method will be called every time whenever media state(Play/Pause) is changed.
    
    - parameter mediaState is the changed state of the media.
    */
    @objc optional func didMediaPlaybackStateChange(_ mediaState:String)
    
    
    /**
     Delegate method when user taps on Next media button.
     
     This method will be called when user taps on Next media button.
     */
    @objc optional func didTapOnNextMediaButton(_ mediaPlayer:HDKitabooMediaBookReader)
    
    /**
     Delegate method when user taps on user taps on Previous media button.
     
     This method will be called when user taps on Previous media button.
     */
    @objc optional func didTapOnPreviousMediaButton(_ mediaPlayer:HDKitabooMediaBookReader)
}

/** An object that initializes all the components which are part of the AudioBook/VideoBook.
 
 A HDKitabooMediaBookReader initializes all the components which are part of the AudioBook/VideoBook and provides/handles call backs of all the components
 
 - SuperClass : UIViewController
 */
@objc open class HDKitabooMediaBookReader: UIViewController,HDAudioBookPlayerViewControllerDelegate,HDMediaBookTOCControllerDelegate,HDMediaBookNarrationSpeedControllerDelegate,HDMediaBookBookmarkControllerDelegate,HDMediaBookPlayerDelegate,UIPopoverPresentationControllerDelegate,HDVideoBookPlayerViewControllerDelegate,HDKitabooSleepTimerControllerDelegate {
    
    /**
     An Object to get media book asset type, whether it is Audio or Video.
     */
    @objc public enum MediaBookType : Int{
        case kMediaBookAudio = 0,
        kMediaBookVideo
    }
    
    /**
     The object that acts as the delegate of the HDKitabooMediaBookReader.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var delegate:HDKitabooMediaBookReaderDelegate?
    
    /**
     The object that acts as the delegate of the HDAudioBookPlayerViewController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var audioPlayerDelegate:HDAudioBookPlayerViewControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDVideoBookPlayerViewController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var videoPlayerDelegate:HDVideoBookPlayerViewControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDMediaBookTOCController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var tocDelegate:HDMediaBookTOCControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDMediaBookNarrationSpeedController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var speedDelegate:HDMediaBookNarrationSpeedControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDMediaBookBookmarkController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var bookmarkDelegate:HDMediaBookBookmarkControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDMediaBookPlayer.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var mediaPlayerDelegate:HDMediaBookPlayerDelegate?
    
    /**
     The object that acts as the delegate of the HDKitabooSleepTimerController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var sleepTimerDelegate:HDKitabooSleepTimerControllerDelegate?
    
    /**
     The object that acts as the delegate of the HDKitabooMediaPopOverController.
     
     The delegate must adopt the HDKitabooMediaBookReaderDelegate protocol.
     */
    @objc public weak var popOverDelegate:HDKitabooMediaPopOverControllerDelegate?
    
    @inline(__always) private static func isIpad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    var audioSleepTimer : Timer?
    var sleepCountDownTimer : Timer?
    var sleepTimerCountDownTime : TimeInterval = 60
    var selectedSleepTime : TimeInterval?
    var metaDataTimer: Timer?
    var sleepButton:UIButton?
    let forwardBackwardTimeConstant:Float = 15.0
    var bookmarkDisabledTimeFrame = 1
    var bookmarks = NSArray()
    var _themeColor:UIColor?
    
    var _mediaBookModel:HDMediaBookModel?
    var _mediaBookPlayer:HDMediaBookPlayer?
    var sleepTimerVC:HDKitabooSleepTimerController?
    var selectedSleepAction : Kitaboo_Reader_SDK.SleepAction?
    var audioPlayerVC:HDAudioBookPlayerViewController?
    var tocController:HDMediaBookTOCController?
    var narrationSpeedController:HDMediaBookNarrationSpeedController?
    var popOverViewController:HDKitabooMediaPopOverController?
    var bookmarkController:HDMediaBookBookmarkController?
    var videoPlayerView:HDVideoBookPlayerViewController?
    
    var leftBorderView:UIView?
    var topBorderView:UIView?
    var nowPlayingInfo = [String : Any]()
    var playerTopBar:UIView?
    var hideBookmark:Bool = false
    var isVideoFullScreen:Bool = false
    var isVideoFullScreenForIphone = false
    var isHLSPlaying = false
    var currentPopOverItem:String = ""
    var registeredFontAndBundle:(String?,Bundle?)?
    var isNextPreviousFeatureEnabled:Bool = true
    var mediaDataLoaded:Bool = false
    lazy var mediaBookIDsHLSData:[String:String] = [:]
    lazy var mediaBooksCookies:[String:Any] = [:]
    lazy var mediaBookIDs:[NSNumber] = []
    var kitabooUser:KitabooUser?
    var baseURLString:String?
    var microServiceURL:String?
    var clientID:String?
    var hlsTimeStamp:NSNumber?
    var enableCDNCookies:Bool = false
    
    //-- Need to make dynamic
    var currentMediaBookType:MediaBookType = MediaBookType.kMediaBookVideo
    var _themeVO = HDKitabooMediaBookThemeVO()
    let playerTopBarHeight:CGFloat = isIpad() ? 70.0 : 50.0
    var playerTopBarTopConstraint : NSLayoutConstraint?
    var nextButtonTrailingConstraint:NSLayoutConstraint?
    var previousButtonLeadingConstraint:NSLayoutConstraint?
    
    lazy var contentViewSize =  (self.view.frame.size.width > self.view.frame.size.height) ?  CGSize(width: self.view.frame.width, height: self.view.frame.height * 2) : CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        return view
    }()
     
    lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = _themeVO.media_sidepanel_background
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var nextMediaButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? (UIDevice.current.orientation.isLandscape ? 30 : 40): 20)
        button.setTitleForAllState("Ѩ")
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextMediaButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var previousMediaButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? (UIDevice.current.orientation.isLandscape ? 30 : 40): 20)
        button.setTitleForAllState("Ѧ")
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousMediaButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    /**
      A font file which is used for all fonts.
     */
    public var registerFontAndBundle:(String?, Bundle?)? {
        set (newValue) {
            if let newValue = newValue {
                registeredFontAndBundle = newValue
                self.registerKitabooFont()
            }
        }
        get{
           return registeredFontAndBundle
        }
    }
    
    //MARK: Initializer Methods
    /**
     Initializes the HDKitabooMediaBookReader object
     
     This method should be called to initialize the HDKitabooMediaBookReader object where the extension can be m3u8/mp3/mp4 etc.
     - parameter mediaBookPath : mediaBookPath is the path of the Media to be played.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter bookId : bookId,  MediaBook bookId.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public init(_ mediaBookPath:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookId: String?, bookISBN:String?, additionalInfo:Dictionary<String,String>?) {
        super.init(nibName: nil, bundle: nil)
        self.updateMediaModelForPath(mediaBookPath, mediaThumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookId: bookId, bookISBN: bookISBN, additionalInfo: additionalInfo)
        self.parseAndLoadPlayer(mediaBookPath!, bookId: bookId) { (error) in
            if error == nil {
                self.playCurrentChapter()
            }
        }
    }
    
    /**
     Initializes the HDKitabooMediaBookReader object
     
     This method should be called to initialize the HDKitabooMediaBookReader object.
     
      NOTE : This method will only be used for HLS downloaded book where `metaDataPath` will be the path where all the additional data of Media Book will be downloaded i.e. Media images, TOC etc.
     
     - parameter metaDataPath : metaDataPath will be the path where all the additional data of Media Book will be downloaded i.e. Media images, TOC etc.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter bookId : bookId,  MediaBook bookId. Note : - It is a mandatory parameter and, It is the same asset name which is used to download the media.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public init(mediaMetaDataPath metaDataPath:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, bookId: String?, additionalInfo:Dictionary<String,String>?) {
        super.init(nibName: nil, bundle: nil)
        self.updateMediaModelForDownloaded(metaDataPath, mediaThumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookISBN: bookISBN, bookId: bookId , additionalInfo: additionalInfo)
        DispatchQueue.global(qos: .userInteractive).async {
            self.parseTOC{ (error) in
                if error == nil {
                    self.playCurrentChapter()
                }
            }
        }
    }
    
    /**
     Initializes the HDKitabooMediaBookReader object.
     
     This method should be called to initialize the HDKitabooMediaBookReader object. This method only be called for HLS Online Media Books where user is not having the m3u8 path.
     
     - parameter user : user, Object of KitabooUser.
     - parameter baseURLString : baseURLString,  Base URL String.
     - parameter clientID : clientID,  Client Id.
     - parameter bookId : bookId,  MediaBook bookId.
     - parameter timeStamp : timeStamp,  Time Stamp.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public init(kitabooUser user:KitabooUser, baseURLString:String, microServicesURL:String, clientID:String, bookId: NSNumber, timeStamp:NSNumber, thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, enableCDNCookies enable:Bool, additionalInfo:Dictionary<String,String>?) {
        super.init(nibName: nil, bundle: nil)
        self.enableCDNCookies = enable
        self.updateMediaModelForUser(user, baseURLString: baseURLString,microServiceURL: microServicesURL, clientID: clientID, bookId: bookId, timeStamp: timeStamp, thumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookISBN: bookISBN, additionalInfo: additionalInfo)
        self.loadHLSMediaBookPath(forUser: user, baseURLString: baseURLString, clientID: clientID, microServicesURL: microServicesURL, bookId: bookId, timeStamp: timeStamp, shouldLaunchMedia: true)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     To update the HDKitabooMediaBookReader object
     
     This method should be called to update the HDKitabooMediaBookReader object where the extension can be m3u8/mp3/mp4 etc.
     
     - parameter mediaBookPath : mediaBookPath is the path of the Media to be played.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter bookId : bookId,  MediaBook bookId.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public func updateMediaReader(bookPath mediaBookPath:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookId: String?, bookISBN:String?, additionalinfo:Dictionary<String,String>?) {
        _mediaBookPlayer?.stop()
        self.updateMediaModelForPath(mediaBookPath, mediaThumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookId: bookId, bookISBN: bookISBN, additionalInfo: additionalinfo)
        self.updateMediaComponents()
        self.parseAndLoadPlayer(mediaBookPath!, bookId: bookId) { (error) in
            if error == nil {
                self.playCurrentChapter()
            }
        }
    }
    
    /**
     To update the HDKitabooMediaBookReader object
     
     This method should be called to update the HDKitabooMediaBookReader object.
     
      NOTE : This method will only be used for HLS downloaded book where `metaDataPath` will be the path where all the additional data of Media Book will be downloaded i.e. Media images, TOC etc.
     
     - parameter path : path will be the path where all the additional data of Media Book will be downloaded i.e. Media images, TOC etc.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter bookId : bookId,  MediaBook bookId. Note : - It is a mandatory parameter and, It is the same asset name which is used to download the media.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public func updateMediaReader(metaDataPath path:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, bookId: String?,additionalinfo:Dictionary<String,String>?) {
        _mediaBookPlayer?.stop()
        self.updateMediaModelForDownloaded(path, mediaThumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookISBN: bookISBN, bookId: bookId, additionalInfo: additionalinfo)
        self.updateMediaComponents()
        self.parseTOC{ (error) in
            if error == nil {
                self._mediaBookPlayer?.play()
            }
        }
    }
    
    /**
     To update the HDKitabooMediaBookReader object.
     
     This method should be called to update the HDKitabooMediaBookReader object. This method only be called for HLS Online Media Books where user is not having the m3u8 path.
     
     - parameter user : user, Object of KitabooUser.
     - parameter baseURLString : baseURLString,  Base URL String.
     - parameter clientID : clientID,  Client Id.
     - parameter bookId : bookId,  MediaBook bookId.
     - parameter timeStamp : timeStamp,  Time Stamp.
     - parameter thumbnailURL : thumbnailURL is the image URL String. `thumbnailURL` is the url of the image that needs to be displayed. For Video Books, there will not be any image displayed.
     - parameter mediaBookType : mediaBookType,  An Object to get media book asset type, whether it is Audio or Video.
     - parameter bookISBN : bookISBN,  MediaBook ISBN.
     - parameter additionalInfo : additionalInfo is Dictionary where all additional data can pass. i.e  prefix for Encryption with prefix key
     */
    @objc public func updateMediaReader(kitabooUser user:KitabooUser, baseURLString:String, microServicesURL:String, clientID:String, bookId: NSNumber, timeStamp:NSNumber, thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, enableCDNCookies enable:Bool,additionalinfo:Dictionary<String,String>?) {
        self.enableCDNCookies = enable
        if let mediaPath = mediaBookIDsHLSData[bookId.stringValue] {
            self.updateMediaReader(bookPath: mediaPath, mediaThumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookId: bookId.stringValue, bookISBN: bookISBN, additionalinfo: additionalinfo)
        }else {
            _mediaBookPlayer?.stop()
            self.updateMediaModelForUser(user, baseURLString: baseURLString, microServiceURL: microServicesURL, clientID: clientID, bookId: bookId, timeStamp: timeStamp, thumbnailURL: thumbnailURL, mediaBookType: mediaBookType, bookISBN: bookISBN, additionalInfo: additionalinfo)
            self.updateMediaComponents()
            self.loadHLSMediaBookPath(forUser: user, baseURLString: baseURLString, clientID: clientID, microServicesURL: microServicesURL, bookId: bookId, timeStamp: timeStamp, shouldLaunchMedia: true)
        }
    }
    
    //MARK: Public Methods
    /**
     To set the theme color to various components of the views/controllers related to MediaBook

     This method should be called to set the color to various components of the views/controllers related to MediaBook. The colors will be fetched from the json provided. If this method is not called, then the default colors will be applied to UI components
     - parameter themeVO :themeVO is the HDKitabooMediaBookThemeVO instance.If this object is not set, then the default colors will be applied to UI components
     
    */
    @objc public func setTheme(_ themeVO:HDKitabooMediaBookThemeVO?) {
        if let themeVO = themeVO{
            _themeVO = themeVO
        }
    }
    
    /**
     To enable/disable the Bookmark Feature in AudioBook Player

     This method should be called to enable/disable the Bookmark Feature in AudioBook Player.If this method is not called then by default the Bookmark Feature will be enabled.
     - parameter enable :enable is a boolean.If this boolean is set as false, then Bookmark Feature will be disabled and vice versa.
    */
    @objc public func enableBookmark(_ enable:Bool) {
        if enable {
            hideBookmark = false
        }else{
            hideBookmark = true
        }
    }
    
    /**
     To set the bookmarks

     This method should be called to set the bookmarks
     - parameter bookmarkArray :bookmarkArray is a NSArray object.It should be an array of SDKBookmarkVO objects
    */
    @objc public func setBookmarks(_ bookmarkArray:NSArray) {
        self.bookmarks = bookmarkArray
        self.updateBookmarks()
    }
    
    func updateBookmarks() {
        self.disableBookmarks()
        if let bookmarks = self.getbookmarksForCurrentChapter(), bookmarks.count > 0 {
            bookmarks.forEach({ bookmarkVO in
                if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                    self.videoPlayerView?.addBookmark(bookmarkVO)
                } else {
                    self.audioPlayerVC?.addBookmark(bookmarkVO)
                }
            })
        }
        if self.tocController?.selectedMode == MediaBookTOCFilter.BOOKMARK {
            self.reloadTOC(self.bookmarks)
        }
    }
    
    /**
     To set start time of the AudioBook

     This method should be called to set the start time of the AudioBook when where the initial narration should start from
     - parameter time : It should be the start time of AudioBook.It is an Int value
    */
    @objc public func setStartTime(_ metaData: NSDictionary) {
        if let metaDataDict = metaData as? [String: Any], let chapterInfo = getChapterVOWithTime(dict: metaDataDict), let chapter = chapterInfo.0 {
            self.navigateToChapter(chapter: chapter, seekTime: chapterInfo.1)
        }
    }
    
    /**
     To enable next previous feature for media books.

     - parameter enabled : A Book Value
    */
    @objc public func enableNextPreviousFeature(_ enabled: Bool) {
        isNextPreviousFeatureEnabled = enabled
    }
    
    /**
     To enable next previous feature for media books.

     - parameter enabled : A Book Value
    */
    @objc public func setNextPreviousBookIds(_ bookIds: [NSNumber]) {
        self.mediaBookIDs = bookIds
        self.loadAllHLSMediaBookPaths()
    }
    
    /**
     To load HLS Media Book Path and play the Media.
     
     This method only be called for HLS Online Media Books where user is not having the m3u8 path.
     
     - parameter user : user, Object of KitabooUser.
     - parameter baseURLString : baseURLString,  Base URL String.
     - parameter clientID : clientID,  Client Id.
     - parameter bookId : bookId,  MediaBook bookId.
     - parameter timeStamp : timeStamp,  Time Stamp.
     - parameter launchMedia : launchMedia,  A Boolean value which means after loading the media book path, the media player should be launched or not.
     */
    @objc public func loadHLSMediaBookPath(forUser kitabooUser:KitabooUser, baseURLString:String, clientID:String, microServicesURL:String, bookId: NSNumber, timeStamp:NSNumber, shouldLaunchMedia launchMedia:Bool) {
        self.isHLSPlaying = true
        var iskitabooContentServer = true
        if let additionalInfo = self._mediaBookModel?.mediaBookAdditonalInfo, let isKitabooServer =  additionalInfo["isKitabooContentServer"], isKitabooServer == "NO"{
            iskitabooContentServer = false
        }
        let kitabooHlSServiceHandler = HDKitabooHLSServiceInterface.init(baseURLString, microServicesBaseUrl: microServicesURL, clientID: clientID, enableCDNCookies: self.enableCDNCookies, IsKitabooContentServer: iskitabooContentServer)
        kitabooHlSServiceHandler.fetchHLSMediaBookDownloadURL(kitabooUser.userToken!, bookId: bookId, timeStamp: timeStamp) {[weak self] (hlsBasePath, cookies) in
            guard let weakSelf = self else { return }
            weakSelf.mediaBookIDsHLSData[bookId.stringValue] = hlsBasePath
            if let cookies = cookies{
                weakSelf.mediaBooksCookies[bookId.stringValue] = cookies
            }
            if launchMedia {
                self?.parseAndLoadPlayer(hlsBasePath, bookId: bookId.stringValue, completion: { (error) in
                    DispatchQueue.main.async {
                        if error != nil {
                            weakSelf.delegate?.didHLSMediaServiceFail?(error: error!, bookId: bookId, timeStamp: timeStamp)
                        }else {
                            if bookId.stringValue == weakSelf._mediaBookModel?.mediaBookId {
                                weakSelf.delegate?.didHLSMediaServiceCallSuccessfully?(mediaPath: hlsBasePath, withBookID: bookId)
                                weakSelf.playCurrentChapter()
                            }
                        }
                    }
                })
            }
        } failureHandler: {[weak self] (error) in
            guard let weakSelf = self else { return }
            if bookId.stringValue == weakSelf._mediaBookModel?.mediaBookId {
                DispatchQueue.main.async {
                    weakSelf.delegate?.didHLSMediaServiceFail?(error: error, bookId: bookId, timeStamp: timeStamp)
                }
            }
        }
    }
    
    func playCurrentChapter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let mediaBookModel = self._mediaBookModel, mediaBookModel.currentChapter == nil {
                mediaBookModel.currentChapter = mediaBookModel.chapters?.first
                self._mediaBookPlayer?.play()
            }
        }
    }
    
    func parseAndLoadPlayer(_ mediaBookPath:String, bookId:String?, completion: @escaping (Error?) -> ()) {
        self._mediaBookModel?.mediaBookPath = mediaBookPath
        if let bookId = bookId{
            self._mediaBookModel?.cookies = self.mediaBooksCookies[bookId] as? [String : Any]
        }
        self.parseTOC(mediaBookPath.appending("/toc.json"), timeIndexString: mediaBookPath.appending("/time-index.json")) { (error) in
            completion(error)
        }
    }
    
    func parseTOC(_ tocJsonString:String? = nil, timeIndexString timeIndex:String? = nil, completion: @escaping (Error?) -> ()) {
        let parser = HDMediaBookParser()
        parser.bookParsingCompleted = { [weak self] mediaModel in
            guard let `self` = self else { return }
            self._mediaBookModel = mediaModel
            completion(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let `self` = self else { return }
                self.reloadTOC()
                if self.currentMediaBookType == MediaBookType.kMediaBookAudio {
                    self.audioPlayerVC?.updateAudioThumbnail()
                }
                if self._mediaBookModel?.chapters == nil, self.tocController?.selectedMode != MediaBookTOCFilter.BOOKMARK {
                    self.tocController?.setData(nil)
                }
            }
        }
        
        parser.bookParsingFailed = { error in
            completion(error)
        }
        
        if let mediaBookModel = _mediaBookModel {
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                if let toc = tocJsonString, let timeIndex = timeIndex {
                    parser.parseTOCTimeIndexJsonForVideo(mediaBookModel, tocjsonPath: toc, timeIndexPath: timeIndex)
                }else{
                    parser.parseTOCTimeIndexJsonForVideo(mediaBookModel)
                }
            }else if (currentMediaBookType == MediaBookType.kMediaBookAudio) {
                if let toc = tocJsonString, let timeIndex = timeIndex {
                    parser.parseTOCTimeIndexJsonForAudio(mediaBookModel, tocjsonPath: toc, timeIndexPath: timeIndex)
                }else{
                    parser.parseTOCTimeIndexJsonForAudio(mediaBookModel)
                }
            }
        }
    }
    
    func reloadTOC(_ data:NSArray? = nil) {
        if let data = data {
            self.tocController?.setData(data)
        }else if let mediaBookModel = self._mediaBookModel, let chapters = mediaBookModel.chapters, self.tocController?.selectedMode != MediaBookTOCFilter.BOOKMARK {
            self.tocController?.setData(chapters as NSArray)
        }
    }
    
    func registerKitabooFont() {
        if let registedFont = self.registeredFontAndBundle {
            HDKitabooFontManager.shared().registerFont(withFileNameString: registedFont.0, bundle: registedFont.1)
        }else{
            HDKitabooFontManager.shared().registerFont()
        }
    }
    
    func deleteAllBookmarks() {
        if let bookmarks = self.bookmarks as? [SDKBookmarkVO] {
            if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                self.videoPlayerView?.deleteAllBookmarks(bookmarks)
            }else {
                self.audioPlayerVC?.deleteAllBookmarks(bookmarks)
            }
        }
        self.bookmarks = []
    }
    
    private func updateMediaModelForPath(_ mediaBookPath:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookId: String?, bookISBN:String?, additionalInfo:Dictionary<String,String>?) {
        if _mediaBookModel != nil {
            _mediaBookModel = nil
        }
        _mediaBookModel = HDMediaBookModel()
        _mediaBookModel?.mediaBookPath = mediaBookPath
        _mediaBookModel?.thumbnailURL = thumbnailURL
        _mediaBookModel?.mediaBookId = bookId
        _mediaBookModel?.mediaBookISBN = bookISBN
        _mediaBookModel?.mediaBookAdditonalInfo = additionalInfo
        currentMediaBookType = mediaBookType
        self.registerKitabooFont()
    }
    
    private func updateMediaModelForDownloaded(_ metaDataPath:String?, mediaThumbnailURL thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, bookId: String?, additionalInfo:Dictionary<String,String>?) {
        if _mediaBookModel != nil {
            _mediaBookModel = nil
        }
        _mediaBookModel = HDMediaBookModel()
        _mediaBookModel?.mediaBookPath = metaDataPath
        _mediaBookModel?.thumbnailURL = thumbnailURL
        _mediaBookModel?.mediaBookId = bookId
        _mediaBookModel?.mediaBookISBN = bookISBN
        _mediaBookModel?.mediaBookAdditonalInfo = additionalInfo
        currentMediaBookType = mediaBookType
        self.registerKitabooFont()
    }
    
    private func updateMediaModelForUser(_ user:KitabooUser, baseURLString:String, microServiceURL:String, clientID:String, bookId: NSNumber, timeStamp:NSNumber, thumbnailURL:String?, mediaBookType:MediaBookType, bookISBN:String?, additionalInfo:Dictionary<String,String>?) {
        if _mediaBookModel != nil {
            _mediaBookModel = nil
        }
        _mediaBookModel = HDMediaBookModel()
        _mediaBookModel?.mediaBookISBN = bookISBN
        _mediaBookModel?.mediaBookId = bookId.stringValue
        _mediaBookModel?.thumbnailURL = thumbnailURL
        currentMediaBookType = mediaBookType
        _mediaBookModel?.mediaBookAdditonalInfo = additionalInfo
        self.kitabooUser = user
        self.baseURLString = baseURLString
        self.microServiceURL = microServiceURL
        self.clientID = clientID
        self.hlsTimeStamp = timeStamp
        self.registerKitabooFont()
    }
    
    func updateMediaComponents() {
        _mediaBookPlayer?._mediaBookModel = self._mediaBookModel
        tocController?._mediaBookModel = self._mediaBookModel
        bookmarkController?._mediaBookModel = self._mediaBookModel
        narrationSpeedController?._mediaBookModel = self._mediaBookModel
        if currentMediaBookType == .kMediaBookAudio {
            audioPlayerVC?._mediaBookModel = self._mediaBookModel
            audioPlayerVC?.updateAudioThumbnail()
        }else {
            videoPlayerView?._mediaBookModel = self._mediaBookModel
        }
    }
    
    func loadAllHLSMediaBookPaths() {
        if !self.mediaDataLoaded, mediaBookIDs.count > 0, let user = self.kitabooUser, let baseURLString = self.baseURLString, let microServiceURL = self.microServiceURL, let clientID = self.clientID, let timeStamp = self.hlsTimeStamp {
            self.mediaDataLoaded = true
            DispatchQueue.global(qos: .background).sync {
                self.mediaBookIDs.forEach({ bookId in
                    if bookId.stringValue != self._mediaBookModel?.mediaBookId, self.mediaBookIDsHLSData[bookId.stringValue] == nil {
                        self.loadHLSMediaBookPath(forUser: user, baseURLString: baseURLString, clientID: clientID, microServicesURL: microServiceURL, bookId: bookId, timeStamp: timeStamp, shouldLaunchMedia: false)
                    }
                })
            }
        }
    }
    
    //MARK: App Life Cycle Methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let frame = UIApplication.shared.keyWindow?.frame {
            self.view.frame = frame
        }
        self.disableNextMediaButton(true)
        self.disablePreviousMediaButton(true)
        self.view.backgroundColor = _themeVO.media_sidepanel_background
        metaDataTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(didCallScheduler), userInfo: nil, repeats: true)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addMediaPlayer()
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            self.addVideoPlayerView()
        }else{
            self.addAudioPlayerView()
        }
        self.addMediaTOCView()
        self.addPlayerTopBar()
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(didChangeInScreenRecording(_:)), name: UIScreen.capturedDidChangeNotification, object: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.isNextPreviousFeatureEnabled {
                self.addNextPreviousControls()
            }
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.removeNarrationSpeedController()
        self.removeMediaPopOverController()
        self.removeSleepTimerViewController()
        topBorderView?.backgroundColor = .clear
        leftBorderView?.backgroundColor = .clear
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.contentViewSize =  UIDevice.current.orientation.isLandscape ?  CGSize(width: self.view.frame.width, height: self.view.frame.height * 2) : CGSize(width: self.view.frame.width, height: self.view.frame.height)
            if (UIDevice.current.orientation.isLandscape || (UIScreen.main.bounds.width > UIScreen.main.bounds.height)) && HDKitabooMediaBookReader.isIpad() {
                if(isRTL()){
                    self.audioPlayerVC?.view.frame = CGRect(x: self.view.frame.size.width*0.4, y: 0, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height)
                }
                else{
                    self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height)
                }
                if self.isVideoFullScreen {
                    self.videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }else{
                    if(isRTL()){
                        self.videoPlayerView?.view.frame = CGRect(x: self.view.frame.size.width*0.4, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                    }
                    else{
                        self.videoPlayerView?.view.frame = CGRect(x: 0, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                    }
                }
                if #available(iOS 11.0, *) {
                    if(isRTL()){
                        self.tocController?.view.frame = CGRect(x: 0, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-self.playerTopBarHeight)
                    }
                    else{
                        self.tocController?.view.frame = CGRect(x: self.view.frame.size.width*0.6, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-self.playerTopBarHeight)
                    }
                } else {
                    if(isRTL()){
                        self.tocController?.view.frame = CGRect(x: 0, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-self.playerTopBarHeight)
                    }
                    else{
                        self.tocController?.view.frame = CGRect(x: self.view.frame.size.width*0.6, y: self.playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-self.playerTopBarHeight)
                    }
                }
                if(isRTL()){
                    self.leftBorderView?.frame.origin.x = (self.tocController?.view.bounds)!.width - 1.0;
                }
                self.topBorderView?.backgroundColor = self._themeVO.media_toppanel_bottom_line
                self.leftBorderView?.backgroundColor = self._themeVO.media_sidepanel_selected_chapter_divider_color
            }else if (UIDevice.current.orientation.isPortrait || (UIScreen.main.bounds.width < UIScreen.main.bounds.height)) && HDKitabooMediaBookReader.isIpad() {
                self.tocController?.view.addBoarderToLeft(with: .clear)
                self.tocController?.view.addTopBorder(with: .clear)
                self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5)
                if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                    self.tocController?.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5)
                }else{
                    self.tocController?.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.51+40, width: self.view.frame.size.width, height: self.view.frame.size.height*0.51-40)
                }
                
                if self.isVideoFullScreen {
                    self.videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }else{
                    if #available(iOS 11.0, *) {
                        self.videoPlayerView?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                    } else {
                        self.videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                    }
                }
            }else if (UIDevice.current.orientation.isLandscape || (UIScreen.main.bounds.width > UIScreen.main.bounds.height)) && !(HDKitabooMediaBookReader.isIpad()) {
                self.handleVideoUIForIPhoneLandscape()
            }else if (UIDevice.current.orientation.isPortrait || (UIScreen.main.bounds.width < UIScreen.main.bounds.height)) && !(HDKitabooMediaBookReader.isIpad()) {
                self.scrollView.frame = self.view.bounds
                self.scrollView.contentSize = self.contentViewSize
                self.containerView.frame.size = self.contentViewSize
                if #available(iOS 11.0, *) {
                    self.audioPlayerVC?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5+self.view.safeAreaInsets.top)
                    self.playerTopBarTopConstraint?.constant = self.view.safeAreaInsets.top
                } else {
                    self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5)
                    self.playerTopBarTopConstraint?.constant = 0
                }
                
                if #available(iOS 11.0, *) {
                    self.tocController?.view.frame = CGRect(x: 0, y: self.contentViewSize.height*0.5+self.view.safeAreaInsets.top+(self.contentViewSize.height*0.018), width: self.view.frame.size.width, height: self.contentViewSize.height*0.5-self.view.safeAreaInsets.top-(self.contentViewSize.height*0.018))
                } else {
                    self.tocController?.view.frame = CGRect(x: 0, y: self.contentViewSize.height*0.5+(self.contentViewSize.height*0.018), width: self.view.frame.size.width, height: self.contentViewSize.height*0.5-(self.contentViewSize.height*0.018))
                }
                if self.currentMediaBookType == MediaBookType.kMediaBookVideo{
                    self.tocController?.view.frame = CGRect(x: 0, y: self.contentViewSize.height*0.47 , width: self.view.frame.size.width, height: self.contentViewSize.height*0.53)
                }
                self.isVideoFullScreenForIphone = false
                self.updateVideoViewForFullScreen()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let bookmarks = self.getbookmarksForCurrentChapter() {
                    for bookmarkVO in bookmarks {
                        if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                            self.videoPlayerView?.deleteBookmark(bookmarkVO)
                            self.videoPlayerView?.addBookmark(bookmarkVO)
                        } else {
                            self.audioPlayerVC?.deleteBookmark(bookmarkVO)
                            self.audioPlayerVC?.addBookmark(bookmarkVO)
                        }
                    }
                }
            }
            self.handlePlayerTopBarForVideoPlayer()
            self.videoPlayerView?.updateViewOnOrientationChange()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDAudioBookViewOrientationChanged"), object: nil, userInfo: nil)
            self.updateNextPreviousControlsConstraint()
        })
    }
    
    func handleVideoUIForIPhoneLandscape() {
        if #available(iOS 11.0, *) {
            self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-self.view.safeAreaInsets.bottom)
            self.playerTopBarTopConstraint?.constant = self.view.safeAreaInsets.top
        } else {
            self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.playerTopBarTopConstraint?.constant = 0
        }
        self.scrollView.contentSize = self.contentViewSize
        self.containerView.frame.size = self.contentViewSize
        if UIDevice.current.orientation == .landscapeLeft {
            if #available(iOS 11.0, *) {
                self.tocController?.view.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.contentViewSize.height*0.5, width: self.view.frame.size.width-self.view.safeAreaInsets.left, height: self.contentViewSize.height*0.5)
            } else {
                self.tocController?.view.frame = CGRect(x: 0, y: self.contentViewSize.height*0.5, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5)
            }
            if #available(iOS 11.0, *) {
                self.audioPlayerVC?.view.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width-self.view.safeAreaInsets.left, height: self.contentViewSize.height*0.5)
            } else {
                self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5)
            }
        }else{
            if #available(iOS 11.0, *) {
                self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-self.view.safeAreaInsets.bottom)
            } else {
                self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
            self.scrollView.contentSize = self.contentViewSize
            self.containerView.frame.size = self.contentViewSize
            if #available(iOS 11.0, *) {
                self.tocController?.view.frame = CGRect(x: 0.0, y: self.contentViewSize.height*0.5, width: self.view.frame.size.width-self.view.safeAreaInsets.right, height: self.contentViewSize.height*0.5)
            } else {
                self.tocController?.view.frame = CGRect(x: 0, y: self.contentViewSize.height*0.5, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5)
            }
            if #available(iOS 11.0, *) {
                self.audioPlayerVC?.view.frame = CGRect(x: 0.0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width-self.view.safeAreaInsets.right, height: self.contentViewSize.height*0.5)
            } else {
                self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.contentViewSize.height*0.5)
            }
        }
        if self.isVideoFullScreen {
            self.isVideoFullScreenForIphone = false
        }else{
            self.isVideoFullScreenForIphone = true
        }
        if !self.isVideoFullScreen && self.isVideoFullScreenForIphone {
            if #available(iOS 11.0, *) {
                self.videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            } else {
                self.videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
            self.tocController?.view.isHidden = true
        }
        self.updateVideoViewForFullScreen()
    }
    
    //MARK: UI Methods
    func addAudioPlayerView() {
        audioPlayerVC = HDAudioBookPlayerViewController(_mediaBookModel!)
        audioPlayerVC?.delegate = self
        audioPlayerVC?.setTheme(_themeVO)
        audioPlayerVC?.hideBookmark(hideBookmark)
        if ((_mediaBookModel?.currentChapter == nil) || (_mediaBookModel!.mediaBookAllChaptersArray.firstIndex(of: _mediaBookModel!.currentChapter!) == 0)) {
            audioPlayerVC?.disablePreviousChapter(true)
            MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
        }
        if  HDKitabooMediaBookReader.isIpad() {
            self.addChild(audioPlayerVC!)
            self.view.addSubview(audioPlayerVC!.view)
            if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)){
                if(isRTL()){
                    self.audioPlayerVC?.view.frame = CGRect(x: self.view.frame.size.width*0.4, y: 0, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height)
                }
                else{
                    self.audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height)
                }
                
            }else{
                if #available(iOS 11.0, *) {
                    audioPlayerVC?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5+40)
                } else {
                    audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5+40)
                }
            }
        }else{
            self.view.addSubview(scrollView)
            scrollView.addSubview(containerView)
            containerView.addSubview(audioPlayerVC!.view)
            self.addChild(audioPlayerVC!)
            if (UIDevice.current.orientation.isPortrait || (self.view.frame.size.width < self.view.frame.size.height)){
                if #available(iOS 11.0, *) {
                    audioPlayerVC?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: contentViewSize.height*0.5+self.view.safeAreaInsets.top)
                } else {
                    audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentViewSize.height*0.5)
                }
            }else{
                if #available(iOS 11.0, *) {
                    scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-self.view.safeAreaInsets.bottom)
                } else {
                    scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
                if UIDevice.current.orientation == .landscapeLeft {
                    if #available(iOS 11.0, *) {
                        audioPlayerVC?.view.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width-self.view.safeAreaInsets.left, height: contentViewSize.height*0.5)
                    } else {
                        audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentViewSize.height*0.5)
                    }
                }else{
                    if #available(iOS 11.0, *) {
                        audioPlayerVC?.view.frame = CGRect(x: 0.0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width-self.view.safeAreaInsets.right, height: contentViewSize.height*0.5)
                    } else {
                        audioPlayerVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentViewSize.height*0.5)
                    }
                }
            }
        }
    }
    
    func addMediaTOCView() {
        tocController = HDMediaBookTOCController(_mediaBookModel!)
        tocController?.setTheme(_themeVO)
        tocController?.delegate = self
        tocController?.hideBookmark(hideBookmark)
        tocController?.hideTranscript(true)
        self.reloadTOC()
        leftBorderView = self.tocController?.view.addBoarderToLeft(with: .clear)
        topBorderView = self.tocController?.view.addTopBorder(with: .clear)
        if HDKitabooMediaBookReader.isIpad() {
            self.view.addSubview(tocController!.view)
            self.addChild(tocController!)
            if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)){
                if #available(iOS 11.0, *) {
                    if(isRTL()){
                        self.tocController?.view.frame = CGRect(x: 0, y: playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-playerTopBarHeight)
                    }
                    else{
                        self.tocController?.view.frame = CGRect(x: self.view.frame.size.width*0.6, y: playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-playerTopBarHeight)
                    }
                } else {
                    if(isRTL()){
                        self.tocController?.view.frame = CGRect(x: 0, y: playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-playerTopBarHeight)
                    }
                    else{
                        self.tocController?.view.frame = CGRect(x: self.view.frame.size.width*0.6, y: playerTopBarHeight, width: self.view.frame.size.width*0.4, height: self.view.frame.size.height-playerTopBarHeight)
                    }
                }
                if(isRTL()){
                    leftBorderView?.frame.origin.x = (self.tocController?.view.bounds)!.width - 1.0;
                }
                leftBorderView?.backgroundColor = _themeVO.media_sidepanel_selected_chapter_divider_color
                topBorderView?.backgroundColor = _themeVO.media_toppanel_bottom_line
            }else{
                if currentMediaBookType == MediaBookType.kMediaBookVideo {
                    tocController?.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5)
                }
                else{
                    tocController?.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.5+40, width: self.view.frame.size.width, height: self.view.frame.size.height*0.5-40)
                }
            }
            
        }else{
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                self.view.addSubview(tocController!.view)
                self.addChild(tocController!)
            }else{
                containerView.addSubview(tocController!.view)
                self.addChild(tocController!)
            }
            if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)) {
                if UIDevice.current.orientation == .landscapeLeft {
                    if #available(iOS 11.0, *) {
                        tocController?.view.frame = CGRect(x: self.view.safeAreaInsets.left, y: contentViewSize.height*0.5, width: self.view.frame.size.width-self.view.safeAreaInsets.left, height: contentViewSize.height*0.5)
                    } else {
                        tocController?.view.frame = CGRect(x: 0, y: contentViewSize.height*0.5, width: self.view.frame.size.width, height: contentViewSize.height*0.5)
                    }
                } else{
                    if #available(iOS 11.0, *) {
                        tocController?.view.frame = CGRect(x: 0.0, y: contentViewSize.height*0.5, width: self.view.frame.size.width-self.view.safeAreaInsets.right, height: contentViewSize.height*0.5)
                    } else {
                        tocController?.view.frame = CGRect(x: 0, y: contentViewSize.height*0.5, width: self.view.frame.size.width, height: contentViewSize.height*0.5)
                    }
                }
            } else{
                if #available(iOS 11.0, *) {
                    tocController?.view.frame = CGRect(x: 0, y: contentViewSize.height*0.5+self.view.safeAreaInsets.top+(contentViewSize.height*0.018), width: self.view.frame.size.width, height: contentViewSize.height*0.5-self.view.safeAreaInsets.top-(contentViewSize.height*0.018))
                } else {
                    tocController?.view.frame = CGRect(x: 0, y: contentViewSize.height*0.5+(contentViewSize.height*0.018) , width: self.view.frame.size.width, height: contentViewSize.height*0.5-(contentViewSize.height*0.018))
                }
                if currentMediaBookType == MediaBookType.kMediaBookVideo{
                    tocController?.view.frame = CGRect(x: 0, y: contentViewSize.height*0.47 , width: self.view.frame.size.width, height: contentViewSize.height*0.53)
                }
            }
        }
    }
    
    func addVideoPlayerView() {
        let audioPlayerLayer = _mediaBookPlayer?.getPlayerLayerView()
        videoPlayerView = HDVideoBookPlayerViewController(_mediaBookModel, withVideoPlayer: audioPlayerLayer!)
        videoPlayerView?.delegate = self
        videoPlayerView?.setTheme(_themeVO)
        videoPlayerView?.hideBookmark(hideBookmark)
        self.addChild(videoPlayerView!)
        self.view.addSubview(videoPlayerView!.view)
        if  HDKitabooMediaBookReader.isIpad() {
            self.addChild(videoPlayerView!)
            self.view.addSubview(videoPlayerView!.view)
            if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)){
                if(isRTL()){
                    self.videoPlayerView?.view.frame = CGRect(x: self.view.frame.size.width*0.4, y: playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                }
                else{
                    self.videoPlayerView?.view.frame = CGRect(x: 0, y: playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                }
            } else{
                if #available(iOS 11.0, *) {
                    videoPlayerView?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                } else {
                    videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                }
            }
        }else{
            if (UIDevice.current.orientation.isPortrait || (self.view.frame.size.width < self.view.frame.size.height)){
                if #available(iOS 11.0, *) {
                    videoPlayerView?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: contentViewSize.height*0.42)
                } else {
                    videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentViewSize.height*0.42)
                }
            } else{
                self.videoPlayerView?.setViewFullScreenForIphone()
                self.handleVideoUIForIPhoneLandscape()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let bookmarks = self.getbookmarksForCurrentChapter() {
                        for bookmarkVO in bookmarks{
                            if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                                self.videoPlayerView?.deleteBookmark(bookmarkVO)
                                self.videoPlayerView?.addBookmark(bookmarkVO)
                            } else {
                                self.audioPlayerVC?.deleteBookmark(bookmarkVO)
                                self.audioPlayerVC?.addBookmark(bookmarkVO)
                            }
                        }
                    }
                }
                self.handlePlayerTopBarForVideoPlayer()
                self.videoPlayerView?.updateViewOnOrientationChange()
                self.updateNextPreviousControlsConstraint()
            }
        }
    }
    
    func addMediaPlayer() {
        _mediaBookPlayer = HDMediaBookPlayer(_mediaBookModel!)
        _mediaBookPlayer?.delegate = self
        self.view.addSubview(_mediaBookPlayer!)
        if currentMediaBookType == MediaBookType.kMediaBookAudio {
            self.setupRemoteTransportControls()
            self.setupNowPlaying()
        }
    }
    
    func addPlayerTopBar() {
        playerTopBar = UIView(frame: .zero)
        self.view.addSubview(playerTopBar!)
        audioPlayerVC?.view.bringSubviewToFront(playerTopBar!)
        playerTopBar?.layer.zPosition = 1.0
        playerTopBar?.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            if HDKitabooMediaBookReader.isIpad() {
                 playerTopBarTopConstraint = playerTopBar?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
                playerTopBarTopConstraint?.isActive = true
            } else{
                playerTopBarTopConstraint = playerTopBar?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top)
                playerTopBarTopConstraint?.isActive = true
            }
            playerTopBar?.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            playerTopBar?.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            playerTopBar?.heightAnchor.constraint(equalToConstant: playerTopBarHeight).isActive = true
        } else{
            playerTopBar?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            playerTopBar?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            playerTopBar?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            playerTopBar?.heightAnchor.constraint(equalToConstant: playerTopBarHeight).isActive = true
        }
        playerTopBar?.backgroundColor = _themeVO.media_toppanel_background
        
        let backButtonn:UIButton = UIButton(frame: .zero)
        playerTopBar!.addSubview(backButtonn)
        
        backButtonn.setTitle(ICON_BACK_ARROW, for: .normal)
        backButtonn.setTitle(ICON_BACK_ARROW, for: .selected)
        backButtonn.setTitleColor(_themeVO.media_toppanel_icons_color, for: .normal)
        backButtonn.setTitleColor(_themeVO.media_toppanel_icons_color, for: .selected)
        backButtonn.titleLabel!.textAlignment = .center
        backButtonn.titleLabel!.font = UIFont(name: HDKitabooMediaBookReaderConstants.font_name, size: 23.0)
        backButtonn.addTarget(self, action: #selector(didTapOnBackButton(_:)), for: .touchUpInside)
        backButtonn.translatesAutoresizingMaskIntoConstraints = false
        backButtonn.topAnchor.constraint(equalTo: playerTopBar!.topAnchor, constant: 0).isActive = true
        backButtonn.leadingAnchor.constraint(equalTo: playerTopBar!.leadingAnchor, constant: 0).isActive = true
        backButtonn.heightAnchor.constraint(equalToConstant: playerTopBarHeight).isActive = true
        backButtonn.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        let audioBookTitleLabel:UILabel = UILabel()
        playerTopBar!.addSubview(audioBookTitleLabel)
        audioBookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        audioBookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        audioBookTitleLabel.topAnchor.constraint(equalTo: playerTopBar!.topAnchor, constant: 0).isActive = true
        audioBookTitleLabel.leadingAnchor.constraint(equalTo: playerTopBar!.leadingAnchor, constant: 62.0).isActive = true
        audioBookTitleLabel.trailingAnchor.constraint(equalTo: playerTopBar!.trailingAnchor, constant: 0).isActive = true
        audioBookTitleLabel.heightAnchor.constraint(equalToConstant: playerTopBarHeight).isActive = true
        audioBookTitleLabel.text = _mediaBookModel?.mediaBookTitle;
        audioBookTitleLabel.textColor = _themeVO.media_toppanel_bookTitle_text_color
        
        sleepButton = UIButton(frame: .zero)
        playerTopBar!.addSubview(sleepButton!)
        sleepButton!.setTitle(ICON_SLEEP_MODE, for: .normal)
        sleepButton!.setTitle(ICON_SLEEP_MODE, for: .selected)
        sleepButton!.setTitleColor(_themeVO.media_toppanel_icons_color, for: .normal)
        sleepButton!.setTitleColor(_themeVO.media_toppanel_icons_color, for: .selected)
        sleepButton!.setTitleColor(.gray, for: .disabled)
        sleepButton!.titleLabel!.textAlignment = .center
        sleepButton!.titleLabel!.font = UIFont(name: HDKitabooMediaBookReaderConstants.font_name, size: 23.0)
        sleepButton!.addTarget(self, action: #selector(didTapOnSleepButton(_:)), for: .touchUpInside)
        sleepButton!.translatesAutoresizingMaskIntoConstraints = false
        sleepButton!.centerYAnchor.constraint(equalTo: playerTopBar!.centerYAnchor, constant: 0).isActive = true
        sleepButton!.trailingAnchor.constraint(equalTo: playerTopBar!.trailingAnchor, constant: HDKitabooMediaBookReader.isIpad() ? -10 : -5).isActive = true
        sleepButton!.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sleepButton!.widthAnchor.constraint(equalToConstant: 36).isActive = true
        sleepButton!.layer.cornerRadius = 18
        self.handlePlayerTopBarForVideoPlayer()
    }
    
    func audioSleepTimerButtonIsEnabled(_ isEnabled : Bool) {
        if ((sleepButton) != nil) {
            sleepButton?.isEnabled = isEnabled
        }
    }
    
    //MARK:HDAudioBookPlayerViewControllerDelegate Methods
    public func didTapOnBookmark() {
        if let mediaBookModel = _mediaBookModel, mediaBookModel.currentTime > 0 {
            bookmarkController = HDMediaBookBookmarkController(_mediaBookModel)
            bookmarkController!.delegate = self
            bookmarkController!.setTheme(_themeVO)
            self.view.addSubview(bookmarkController!.view)
            self.addChild(bookmarkController!)
        }
        self.audioPlayerDelegate?.didTapOnBookmark?()
    }
    
    public func didTapOnNarrationSpeed(_ button: UIButton) {
        self.addNarrationSpeedController(button)
        self.audioPlayerDelegate?.didTapOnNarrationSpeed?(button)
    }
    
    public func didTapOnForward() {
        _mediaBookPlayer?.playForwardWithTime(forwardBackwardTimeConstant)
        self.disableBookmarks()
        self.audioPlayerDelegate?.didTapOnForward?()
    }
    
    public func didTapOnRewind() {
        _mediaBookPlayer?.playBackwardWithTime(forwardBackwardTimeConstant)
        self.disableBookmarks()
        self.audioPlayerDelegate?.didTapOnRewind?()
    }
    
    public func didTapOnNextChapter() {
        self.actionForNextChapter()
        self.disableBookmarks()
        self.audioPlayerDelegate?.didTapOnNextChapter?()
    }
    
    public func didTapOnPreviousChapter() {
        self.actionForPrevChapter()
        self.disableBookmarks()
        self.audioPlayerDelegate?.didTapOnPreviousChapter?()
    }
    
    public func didSeekBarValueChanged() {
        _mediaBookPlayer?.playToSeekTime(_mediaBookModel!.currentTime)
        self.disableBookmarks()
        if sleepButton != nil, let mediaBookModel = _mediaBookModel, let currentChapter = mediaBookModel.currentChapter, let currentChapterIndex = mediaBookModel.mediaBookAllChaptersArray.firstIndex(of: currentChapter), currentChapterIndex == mediaBookModel.mediaBookAllChaptersArray.count-1  {
            if _mediaBookModel!.currentTime == currentChapter.avAssetTotalTime {
                audioSleepTimerButtonIsEnabled(false)
            }else if sleepButton?.isEnabled == false {
                audioSleepTimerButtonIsEnabled(true)
            }
        }
        self.audioPlayerDelegate?.didSeekBarValueChanged?()
    }
    
    public func didTapOnPlayPause(_ mediaBookModel: HDMediaBookModel) {
        if _mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
            _mediaBookPlayer?.pause()
            delegate?.didMediaPlaybackStateChange?("Paused")
        }else {
            _mediaBookPlayer?.play()
            delegate?.didMediaPlaybackStateChange?("Playing")
        }
        self.audioPlayerDelegate?.didTapOnPlayPause?(mediaBookModel)
    }
    
    public func imageViewForThumbnail(_ thumbnailURL: String) -> UIImageView? {
        return delegate?.imageViewForThumbnail?(thumbnailURL)
    }
    
    //MARK:HDMediaBookNarrationSpeedControllerDelegate Methods
    public func didNarrationSpeedValueChanges(_ mediaBookModel: HDMediaBookModel?) {
        self.removeNarrationSpeedController()
        _mediaBookPlayer?.setReadingSpeed(mediaBookModel!)
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            videoPlayerView?.updatePlayerView(VideoPlayerViewStateUpdate.kVideoUpdateReadingSpeed, mediaBookModel: mediaBookModel!)
        }else{
            audioPlayerVC?.updatePlayerView(AudioBookPlayerViewStateUpdate.kAudioBookUpdateReadingSpeed, mediaBookModel: mediaBookModel!, showLoader: self.isHLSPlaying)
        }
        self.speedDelegate?.didNarrationSpeedValueChanges?(mediaBookModel)
    }
    
    public func didTapOnCancel() {
        self.removeNarrationSpeedController()
        self.speedDelegate?.didTapOnCancel?()
    }
    
    //MARK:HDMediaBookBookmarkControllerDelegate Methods
    public func didTapOnAddBookmark(_ bookmarkVO: SDKBookmarkVO) {
        self.bookmarks.adding(bookmarkVO)
        self.updateBookmark(bookmarkVO: bookmarkVO)
        audioPlayerVC?.addBookmark(bookmarkVO)
        bookmarkController!.view.removeFromSuperview()
        bookmarkController?.removeFromParent()
        self.bookmarkDelegate?.didTapOnAddBookmark?(bookmarkVO)
    }
    
    public func didTapOnDeleteBookmark(_ bookmarkVO: SDKBookmarkVO) {
        self.updateBookmark(bookmarkVO: bookmarkVO)
        bookmarkController!.view.removeFromSuperview()
        bookmarkController?.removeFromParent()
        self.bookmarkDelegate?.didTapOnDeleteBookmark?(bookmarkVO)
    }
    
    public func didTapOnCancelBookmark(_ bookmarkVO: SDKBookmarkVO?) {
        bookmarkController!.view.removeFromSuperview()
        bookmarkController?.removeFromParent()
        if let bookmarkVO = bookmarkVO {
            self.bookmarkDelegate?.didTapOnCancelBookmark?(bookmarkVO)
        }
    }
    
    
    // MARK: HDMediaBookTOCControllerDelegate Methods
    public func didTapOnChapterSegment() {
        self.reloadTOC()
        self.tocDelegate?.didTapOnChapterSegment?()
    }
    
    public func didTapOnTranscriptSegment() {
        self.tocDelegate?.didTapOnTranscriptSegment?()
    }
    
    public func didTapOnBookmarkSegment() {
        if self.bookmarks.count > 0, self.tocController?.selectedMode == MediaBookTOCFilter.BOOKMARK {
            self.reloadTOC(self.bookmarks)
        }else if self.tocController?.selectedMode == MediaBookTOCFilter.BOOKMARK{
            self.tocController?.setData(nil)
        }
        self.tocDelegate?.didTapOnBookmarkSegment?()
    }
    
    public func didTapOnChapter(_ chapterModel: HDMediaBookChapterVO) {
        self.navigateToChapter(chapter: chapterModel, seekTime: 0)
        self.tocDelegate?.didTapOnChapter?(chapterModel)
    }
    
    public func didTapOnTranscript(_ chapterModel: HDMediaBookTranscriptVO) {
        self.tocDelegate?.didTapOnTranscript?(chapterModel)
    }
    
    public func didTapOnBookmark(_ bookmarkVO: SDKBookmarkVO) {
        if let metaData = bookmarkVO.metaData as? [String: Any], let chapterInfo = getChapterVOWithTime(dict: metaData), let chapter = chapterInfo.0 {
            self.navigateToChapter(chapter: chapter, seekTime: chapterInfo.1)
        }
        tocController?.reloadBookmarkSection()
        self.tocDelegate?.didTapOnBookmark?(bookmarkVO)
    }
    
    public func didTapOnChapterPlayPause(_ mediaBookModel: HDMediaBookModel) {
        if _mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
            _mediaBookPlayer?.play()
            delegate?.didMediaPlaybackStateChange?("Playing")
        }else if _mediaBookModel?.mediaCurrentState == CurrentState.PAUSE{
            _mediaBookPlayer?.pause()
            delegate?.didMediaPlaybackStateChange?("Paused")
        }
        self.tocDelegate?.didTapOnChapterPlayPause?(mediaBookModel)
    }
    
    public func didTapOnBookmarkDelete(_ bookmarkVO: SDKBookmarkVO) {
        bookmarkController = HDMediaBookBookmarkController(_mediaBookModel, bookmarkVO: bookmarkVO)
        bookmarkController?.delegate = self
        bookmarkController!.setTheme(_themeVO)
        self.view.addSubview(bookmarkController!.view)
        self.addChild(bookmarkController!)
        self.tocDelegate?.didTapOnBookmarkDelete?(bookmarkVO)
    }
    
    // MARK: HDMediaBookPlayerDelegate Methods
    public func playerPlaying(currentTime: Int, totalTime: Int) {
        
        if let mediaBookModel = _mediaBookModel, let currentChapter = mediaBookModel.currentChapter, let currentChapterIndex = mediaBookModel.mediaBookAllChaptersArray.firstIndex(of: currentChapter), currentChapterIndex == mediaBookModel.mediaBookAllChaptersArray.count-1, currentTime == totalTime {
            audioSleepTimerButtonIsEnabled(false)
            if(audioSleepTimer != nil) {
                stopAudioSleepTimer()
            }
        }
        _mediaBookModel?.currentTime = currentTime
        _mediaBookModel?.currentChapter?.avAssetTotalTime = totalTime
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            videoPlayerView?.updatePlayerView(VideoPlayerViewStateUpdate.kVideoUpdateCurrentTime, mediaBookModel: _mediaBookModel!)
            if _mediaBookModel?.mediaCurrentState == CurrentState.LOADING {
                self.videoNextPreviousHandling(_mediaBookModel!)
            }
        }else{
            audioPlayerVC?.updatePlayerView(AudioBookPlayerViewStateUpdate.kAudioBookUpdateCurrentTime, mediaBookModel: _mediaBookModel!, showLoader: self.isHLSPlaying)
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self._mediaBookModel?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self._mediaBookModel?.currentChapter?.avAssetTotalTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self._mediaBookModel?.mediaNarrationSpeedRate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        self.updateMediaViewsUIForUpdatedChapter(chapterIsUpdated: true)
        self.disableBookmarks()
        self.mediaPlayerDelegate?.playerPlaying?(currentTime: currentTime, totalTime: totalTime)
    }
    
    public func playerDidFinishPlaying() {
        self.actionForNextChapter()
        if let mediaBookModel = _mediaBookModel, let currentChapter = mediaBookModel.currentChapter, let currentChapterIndex = mediaBookModel.mediaBookAllChaptersArray.firstIndex(of: currentChapter), currentChapterIndex == mediaBookModel.mediaBookAllChaptersArray.count-1  {
            mediaBookModel.currentChapter = mediaBookModel.mediaBookAllChaptersArray.first
            audioSleepTimerButtonIsEnabled(true)
            self.updateMediaViewsUIForUpdatedChapter(chapterIsUpdated: false)
            self.mediaPlayerDelegate?.playerDidFinishPlaying?()
        }
    }
    
    public func playerFailedToPlay(error: Error) {
        DispatchQueue.main.async {
            self.delegate?.didMediaPlaybackStateChange?("Paused")
            self.mediaPlayerDelegate?.playerFailedToPlay?(error: error)
        }
    }
    
    public func playerDidChangeState(mediaBookModel: HDMediaBookModel) {
        self.addMediaSelections(mediaBookModel)
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            videoPlayerView?.updatePlayerView(VideoPlayerViewStateUpdate.kVideoUpdatePlayPauseState, mediaBookModel: mediaBookModel)
            self.videoNextPreviousHandling(mediaBookModel)
        }else{
            audioPlayerVC?.updatePlayerView(AudioBookPlayerViewStateUpdate.kAudioBookUpdatePlayPauseState, mediaBookModel: mediaBookModel, showLoader: self.isHLSPlaying)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tocController?.setPlayPauseState(mediaBookModel)
        }
        if mediaBookModel.mediaCurrentState == CurrentState.PLAYING {
            delegate?.didMediaPlaybackStateChange?("Playing")
        }else {
            delegate?.didMediaPlaybackStateChange?("Paused")
        }
        if mediaBookModel.mediaCurrentState == CurrentState.LOADING {
            self.updateBookmarks()
        }
        self.mediaPlayerDelegate?.playerDidChangeState?(mediaBookModel: mediaBookModel)
    }
    
    func videoNextPreviousHandling(_ mediaBookModel: HDMediaBookModel) {
        if mediaBookModel.mediaCurrentState == CurrentState.PLAYING {
            videoPlayerView?.isVideoReadyToPlay(true)
            self.hideNextPreviousControls(false)
        }else if mediaBookModel.mediaCurrentState == CurrentState.LOADING {
            videoPlayerView?.isVideoReadyToPlay(false)
            self.hideNextPreviousControls(true)
        }
    }
    
    //MARK: MPRemoteCommandCenter
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [weak self] event in
            if self?._mediaBookModel?.mediaCurrentState == CurrentState.PAUSE {
                self?._mediaBookPlayer?.play()
                self?.delegate?.didMediaPlaybackStateChange?("Playing")
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [weak self] event in
            if self?._mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
                self?._mediaBookPlayer?.pause()
                self?.delegate?.didMediaPlaybackStateChange?("Paused")
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Forward Command
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            if (self?._mediaBookModel?.mediaCurrentState == CurrentState.PLAYING || self?._mediaBookModel?.mediaCurrentState == CurrentState.PAUSE){
                self?.actionForNextChapter()
                return .success
            }
            return .commandFailed
        }
        // Add handler for Backward Command
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            if (self?._mediaBookModel?.mediaCurrentState == CurrentState.PLAYING || self?._mediaBookModel?.mediaCurrentState == CurrentState.PAUSE){
                self?.actionForPrevChapter()
                return .success
            }
            return .commandFailed
        }
        
        if #available(iOS 9.1, *) {
            commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
                if (self?._mediaBookModel?.mediaCurrentState == CurrentState.PLAYING || self?._mediaBookModel?.mediaCurrentState == CurrentState.PAUSE){
                    if let remoteEvent =  event as? MPChangePlaybackPositionCommandEvent {
                        self?._mediaBookPlayer?.playToSeekTime(Int(Int64(remoteEvent.positionTime)))
                    }
                    return .success
                }
                return .commandFailed
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        
        DispatchQueue.global().async {
            
            if let mediaBookModel = self._mediaBookModel,let urlString = mediaBookModel.thumbnailURL, let url = URL(string:urlString)  {
                if let data = try? Data.init(contentsOf: url), let image = UIImage(data: data) {
                    
                    if #available(iOS 10.0, *) {
                        self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_ size : CGSize) -> UIImage in
                            
                            return image
                            
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        nowPlayingInfo[MPMediaItemPropertyTitle] = _mediaBookModel?.mediaBookTitle
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _mediaBookModel?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = _mediaBookModel?.currentChapter?.avAssetTotalTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = _mediaBookModel?.mediaNarrationSpeedRate
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    //MARK: Utility Methods
    @objc func didCallScheduler() {
        delegate?.didSchedulerCalledWithInfo?(self.getMetaData())
    }
    
    func stopScheduler() {
        if (metaDataTimer != nil) {
            metaDataTimer?.invalidate()
            metaDataTimer = nil
        }
    }
    
    @objc func didChangeInScreenRecording(_ notification:NSNotification) {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                if _mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
                    _mediaBookPlayer?.pause()
                }
            }else {
                if _mediaBookModel?.mediaCurrentState == CurrentState.PAUSE {
                    _mediaBookPlayer?.play()
                }
            }
        }
    }
    
    /**
      It will return a Dictionary which will contains all the information about a media book, i.e. Media book current time, folio ID etc.
     */
    @objc public func getMetaData() -> Dictionary<AnyHashable, Any> {
        if let mediaBookModel = _mediaBookModel, let timeIndexVOArray = mediaBookModel.timeIndexVOArray{
                if mediaBookModel.multiAudioPackage {
                    return multiAudioMediaModle(mediaBookModel)
                }
            for timeIndexVO in timeIndexVOArray {
                if (timeIndexVO.startTime...timeIndexVO.endTime ~= mediaBookModel.currentTime) {
                    if let fileName = timeIndexVO.fileName, let folio = timeIndexVO.folio {
                        let dict = ["currentTime" : mediaBookModel.currentTime,
                                    "fileName" : fileName,
                                    "chapterName": mediaBookModel.currentChapter?.chapterTitle ?? mediaBookModel.mediaBookTitle!,
                                    "folioID":folio] as [String : Any]
                        return dict
                    }
                    break
                }
            }
        }
        return [:]
    }
    
    private func multiAudioMediaModle(_ mediaBookModel: HDMediaBookModel) -> Dictionary<AnyHashable, Any> {
        for timeIndexVO in mediaBookModel.timeIndexVOArray! {
            let audioName = mediaBookModel.currentChapter?.urlLastPathComponent!.components(separatedBy: "#").first!
            if let currentChapter = mediaBookModel.currentChapter, (timeIndexVO.chapterTitle == mediaBookModel.currentChapter?.chapterTitle && audioName == timeIndexVO.fileName!) && (timeIndexVO.startTime...timeIndexVO.endTime ~= mediaBookModel.currentTime || timeIndexVO.startTime...timeIndexVO.endTime ~= mediaBookModel.currentTime + currentChapter.chapterStartTimeForBook) {
                if let fileName = timeIndexVO.fileName, let folio = timeIndexVO.folio {
                    let currentTime = mediaBookModel.currentTime
                    let dict = ["currentTime" : currentTime,
                                "fileName" : fileName,
                                "chapterName": mediaBookModel.currentChapter?.chapterTitle ?? mediaBookModel.mediaBookTitle!,
                                "folioID":folio] as [String : Any]
                    return dict
                }
                break
            }
        }
        return [:]
    }
    
    func actionForNextChapter(){
        if let mediaBookModel = _mediaBookModel, let currentChapter = mediaBookModel.currentChapter, let currentChapterIndex = mediaBookModel.mediaBookAllChaptersArray.firstIndex(of: currentChapter), currentChapterIndex < mediaBookModel.mediaBookAllChaptersArray.count-1{
            let nextChapter = mediaBookModel.mediaBookAllChaptersArray[currentChapterIndex+1]
            self.navigateToChapter(chapter: nextChapter, seekTime: 0)
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.disablePreviousChapter(false)
            } else{
                audioPlayerVC?.disablePreviousChapter(false)
                MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
            }
        }else {
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.disableNextChapter(true)
            }else{
                audioPlayerVC?.disableNextChapter(true)
                MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
            }
        }
    }
    
    func actionForPrevChapter(){
        if let mediaBookModel = _mediaBookModel, let currentChapter = mediaBookModel.currentChapter, let currentChapterIndex = mediaBookModel.mediaBookAllChaptersArray.firstIndex(of: currentChapter), currentChapterIndex > 0{
            let nextChapter = mediaBookModel.mediaBookAllChaptersArray[currentChapterIndex-1]
            self.navigateToChapter(chapter: nextChapter, seekTime: 0)
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.disableNextChapter(false)
            }else{
                audioPlayerVC?.disableNextChapter(false)
                MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = true
            }
        }else {
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.disablePreviousChapter(true)
            }else{
                audioPlayerVC?.disablePreviousChapter(true)
                MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
            }
        }
    }
    
    func updateMediaViewsUIForUpdatedChapter(chapterIsUpdated:Bool){
        if chapterIsUpdated, let chapterVO = _mediaBookModel?.currentChapter, let chapterIndex = _mediaBookModel?.mediaBookAllChaptersArray.firstIndex(of: chapterVO) {
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = chapterVO.chapterTitle
            tocController?.updateTOCForCurrentChapter(chapterVO)
            
            if chapterIndex >= 1 {
                if currentMediaBookType == MediaBookType.kMediaBookVideo {
                    videoPlayerView?.disablePreviousChapter(false)
                }else{
                    audioPlayerVC?.disablePreviousChapter(false)
                    MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
                }
            }else{
                if currentMediaBookType == MediaBookType.kMediaBookVideo {
                    videoPlayerView?.disablePreviousChapter(true)
                }else{
                    audioPlayerVC?.disablePreviousChapter(true)
                    MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
                }
            }
            
            if chapterIndex+1 == _mediaBookModel!.mediaBookAllChaptersArray.count{
                if currentMediaBookType == MediaBookType.kMediaBookVideo {
                    videoPlayerView?.disableNextChapter(true)
                }else{
                    audioPlayerVC?.disableNextChapter(true)
                    MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
                }
            } else{
                if currentMediaBookType == MediaBookType.kMediaBookVideo {
                    videoPlayerView?.disableNextChapter(false)
                }else{
                    audioPlayerVC?.disableNextChapter(false)
                    MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = true
                }
            }
            
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.setCurrentChapter(chapterVO)
            }else{
                audioPlayerVC?.setCurrentChapter(chapterVO)
            }
        } else{
            if currentMediaBookType == MediaBookType.kMediaBookVideo {
                videoPlayerView?.disablePreviousChapter(true)
                videoPlayerView?.disableNextChapter(false)
                videoPlayerView?.setCurrentChapter(nil)
            }else{
                audioPlayerVC?.disablePreviousChapter(true)
                MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
                MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = true
                audioPlayerVC?.disableNextChapter(false)
                audioPlayerVC?.setCurrentChapter(nil)
            }
            tocController?.updateTOCForCurrentChapter(nil)
        }
    }
    
    @objc func didTapOnBackButton(_ sender:UIButton){
        self.closePlayer()
        delegate?.didTapOnBack?(self.getMetaData(), mediaBookReader: self)
        if currentMediaBookType == MediaBookType.kMediaBookAudio {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
            nowPlayingInfo = [:]
        }
    }
    
    @objc func didTapOnSleepButton(_ button:UIButton){
        sleepTimerVC = HDKitabooSleepTimerController()
        sleepTimerVC!.delegate = self
        sleepTimerVC!.setTheme(_themeVO)
        sleepTimerVC!.setSourceViewForSleepTimerViewController(button)
        self.view.addSubview(sleepTimerVC!.view)
        self.addChild(sleepTimerVC!)
        if let sleepAction = self.selectedSleepAction {
            sleepTimerVC?.updateSelectedSleepAction(sleepAction)
        }
        if let time = self.selectedSleepTime {
            sleepTimerVC?.updateCustomSelectedTime(time: time)
        }
    }
    
    func addBookmarkController() {
        if let mediaBookModel = _mediaBookModel, mediaBookModel.currentTime > 0{
            bookmarkController = HDMediaBookBookmarkController(_mediaBookModel)
            bookmarkController!.delegate = self
            bookmarkController!.setTheme(_themeVO)
            self.view.addSubview(bookmarkController!.view)
            self.addChild(bookmarkController!)
        }
    }
    
    func addNarrationSpeedController(_ button:UIButton) {
        narrationSpeedController = HDMediaBookNarrationSpeedController(_mediaBookModel)
        narrationSpeedController?.setTheme(_themeVO)
        narrationSpeedController?.delegate = self
        narrationSpeedController?.setSourceViewForNarrationSpeedController(button)
        self.view.addSubview(narrationSpeedController!.view)
        self.addChild(narrationSpeedController!)
    }
    
    func updateVideoViewForFullScreen() {
        if  !HDKitabooMediaBookReader.isIpad() && UIDevice.current.orientation.isLandscape && !isVideoFullScreen && !isVideoFullScreenForIphone {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
        self.handlePlayerTopBarForVideoPlayer()
        if isVideoFullScreen {
            if #available(iOS 11.0, *) {
                videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            } else {
                videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
            tocController?.view.isHidden = true
        } else{
            if  HDKitabooMediaBookReader.isIpad() {
                if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)){
                    if(isRTL()){
                        self.videoPlayerView?.view.frame = CGRect(x: self.view.frame.size.width*0.4, y: playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                    }
                    else{
                        self.videoPlayerView?.view.frame = CGRect(x: 0, y: playerTopBarHeight, width: self.view.frame.size.width*0.6, height: self.view.frame.size.height*0.5)
                    }
                }else{
                    if #available(iOS 11.0, *) {
                        videoPlayerView?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                    } else {
                        videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.48)
                    }
                }
            }else{
                if (UIDevice.current.orientation.isLandscape || (self.view.frame.size.width > self.view.frame.size.height)){
                    
                }else{
                    if #available(iOS 11.0, *) {
                        videoPlayerView?.view.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: contentViewSize.height*0.42)
                    } else {
                        videoPlayerView?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentViewSize.height*0.42)
                    }
                }
            }
            tocController?.view.isHidden = false
        }
        self.updateNextPreviousControlsConstraint()
    }
    
    /**
      A method to close media book Player.
     */
    @objc public func closePlayer() {
        _mediaBookPlayer?.stop()
        _mediaBookPlayer = nil
        _mediaBookPlayer = nil
        videoPlayerView = nil
        audioPlayerVC = nil
        tocController = nil
        narrationSpeedController = nil
        sleepTimerVC = nil
        if let topBar = playerTopBar{
            topBar.removeFromSuperview()
            playerTopBar = nil
        }
        self.stopScheduler()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        nowPlayingInfo = [:]
    }
    
    // MARK: Bookmark Methods
    func updateBookmark(bookmarkVO : SDKBookmarkVO) {
        delegate?.didBookmarkComplete?(bookmarkVO: bookmarkVO)
        if bookmarkVO.status == DELETE {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.disableBookmarks()
                if self.currentMediaBookType == MediaBookType.kMediaBookVideo{
                    self.videoPlayerView?.deleteBookmark(bookmarkVO)
                }else{
                    self.audioPlayerVC?.deleteBookmark(bookmarkVO)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.bookmarks.count > 0, self.tocController?.selectedMode == MediaBookTOCFilter.BOOKMARK {
                self.reloadTOC(self.bookmarks)
            }else if self.tocController?.selectedMode == MediaBookTOCFilter.BOOKMARK{
                self.tocController?.setData(nil)
            }
        }
    }

    func disableBookmarks() {
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            videoPlayerView?.disableBookmark(false)
        }else{
            audioPlayerVC?.disableBookmark(false)
        }
        
        if let bookmarks = self.getbookmarksForCurrentChapter() {
            for bookmark in bookmarks{
                let metaData = bookmark.metaData as! [String : Any]
                let currentTimee = metaData["CurrentTime"]
                let time = currentTimee as? Int
                if let time = time, let currentTime = _mediaBookModel?.currentTime{
                    if (time == currentTime || (time...time+bookmarkDisabledTimeFrame ~= currentTime) || (time-bookmarkDisabledTimeFrame...time ~= currentTime)) {
                        if currentMediaBookType == MediaBookType.kMediaBookVideo {
                            videoPlayerView?.disableBookmark(true)
                        }else{
                            audioPlayerVC?.disableBookmark(true)
                        }
                    }
                }
            }
        }
    }
    
    
    func removeNarrationSpeedController() {
        if let presentedViewController = narrationSpeedController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: {})
        }
        narrationSpeedController?.view.removeFromSuperview()
        narrationSpeedController?.removeFromParent()
        narrationSpeedController = nil
    }
    
    func handlePlayerTopBarForVideoPlayer() {
        if currentMediaBookType == MediaBookType.kMediaBookVideo {
            sleepButton?.isHidden = true
            if HDKitabooMediaBookReader.isIpad() {
                if self.view.frame.size.height > self.view.frame.size.width {
                    playerTopBar?.isHidden = true
                }else{
                    if isVideoFullScreen {
                        playerTopBar?.isHidden = true
                    } else{
                        playerTopBar?.isHidden = false
                    }
                }
            }else {
                playerTopBar?.isHidden = true
            }
        }else {
            sleepButton?.isHidden = false
        }
    }
    
    //MARK: HDVideoBookPlayerViewControllerDelegate Method
    public func didTapOnVideoView(_ enableControls: Bool) {
        self.nextMediaButton.isHidden = enableControls
        self.previousMediaButton.isHidden = enableControls
    }
    
    public func didTapOnVideoFullScreen(_ isFullScreen: Bool) {
        isVideoFullScreen = isFullScreen
        if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let bookmarks = self.getbookmarksForCurrentChapter() {
                    for bookmarkVO in bookmarks {
                        self.videoPlayerView?.deleteBookmark(bookmarkVO)
                        self.videoPlayerView?.addBookmark(bookmarkVO)
                    }
                }
            }
        }
        self.updateVideoViewForFullScreen()
        self.videoPlayerDelegate?.didTapOnVideoFullScreen?(isFullScreen)
    }
    
    public func didTapOnVideoMute(_ isMute: Bool) {
        _mediaBookPlayer?.mute(isMute)
        self.videoPlayerDelegate?.didTapOnVideoMute?(isMute)
    }
    
    public func didTapOnVideoBack() {
        self.closePlayer()
        delegate?.didTapOnBack?(self.getMetaData(), mediaBookReader: self)
        self.videoPlayerDelegate?.didTapOnVideoBack?()
    }
    
    public func didTapOnVideoBookmark() {
        self.addBookmarkController()
        self.videoPlayerDelegate?.didTapOnVideoBookmark?()
    }
    
    public func didTapOnVideoNarrationSpeed(_ button: UIButton) {
        self.addNarrationSpeedController(button)
        self.videoPlayerDelegate?.didTapOnVideoNarrationSpeed?(button)
    }
    
    public func didTapOnVideoRewind() {
        self.disableBookmarks()
        _mediaBookPlayer?.playBackwardWithTime(forwardBackwardTimeConstant)
        self.videoPlayerDelegate?.didTapOnVideoRewind?()
    }
    
    public func didTapOnVideoForward() {
        self.disableBookmarks()
        _mediaBookPlayer?.playForwardWithTime(forwardBackwardTimeConstant)
        self.videoPlayerDelegate?.didTapOnVideoForward?()
    }
    
    public func didTapOnVideoPlayPause(_ mediaBookModel: HDMediaBookModel) {
        if _mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
            _mediaBookPlayer?.pause()
            delegate?.didMediaPlaybackStateChange?("Paused")
        }else {
            _mediaBookPlayer?.play()
            delegate?.didMediaPlaybackStateChange?("Playing")
        }
        self.videoPlayerDelegate?.didTapOnVideoPlayPause?(mediaBookModel)
    }
    
    public func didTapOnVideoNextChapter() {
        self.disableBookmarks()
        self.actionForNextChapter()
        self.videoPlayerDelegate?.didTapOnVideoNextChapter?()
    }
    
    public func didTapOnVideoPreviousChapter() {
        self.disableBookmarks()
        self.actionForPrevChapter()
        self.videoPlayerDelegate?.didTapOnVideoPreviousChapter?()
    }
    
    public func didVideoSeekBarValueChanged() {
        _mediaBookPlayer?.playToSeekTime(_mediaBookModel!.currentTime)
        self.disableBookmarks()
        self.videoPlayerDelegate?.didVideoSeekBarValueChanged?()
    }
    
    public func didTapOnSubtitleView(_ enabled: Bool) {
        self.enableDisableSubtitle(enabled)
        self.videoPlayerDelegate?.didTapOnSubtitleView?(enabled)
    }
    
    public func didTapOnVideoMoreOptions(_ view: UIView) {
        self.addMediaPopOverController(self.getCustomPopOverModel(view))
        self.videoPlayerDelegate?.didTapOnVideoMoreOptions?(view)
    }
    
    //MARK: HDKitabooSleepTimerControllerDelegate Method
    public func didRemoveSleepTimerView() {
        self.removeSleepTimerViewController()
        self.sleepTimerDelegate?.didRemoveSleepTimerView?()
    }
            
    public func didSetAudioSleepTimer(selectedSleepTime: TimeInterval, selectedSleepAction: Kitaboo_Reader_SDK.SleepAction) {
        stopAudioSleepTimer()
        if _mediaBookModel?.mediaCurrentState == CurrentState.PAUSE {
            _mediaBookPlayer?.play()
        }
        startAudioSleepTimer(selectedSleepTime: selectedSleepTime)
        changeSleepButtonStatus(isSleepTimerOff: false)
        self.selectedSleepAction = selectedSleepAction
        if(selectedSleepAction == SleepAction.kSleepActionCustom) {
            self.selectedSleepTime = selectedSleepTime
        }
        removeSleepTimerViewController()
        self.sleepTimerDelegate?.didSetAudioSleepTimer?(selectedSleepTime: selectedSleepTime, selectedSleepAction: selectedSleepAction)
    }
    
    func startAudioSleepTimer(selectedSleepTime: TimeInterval) {
        audioSleepTimer = Timer.scheduledTimer(timeInterval: selectedSleepTime, target: self, selector: #selector(pauseAudio), userInfo: nil, repeats: false)
        startSleepCountDownTimer(time: selectedSleepTime)
    }
    
    func changeSleepButtonStatus(isSleepTimerOff : Bool) {
        if(isSleepTimerOff){
            sleepButton!.backgroundColor = .clear
            sleepButton!.setTitleColor(_themeVO.media_toppanel_icons_color, for: .normal)
            sleepButton!.setTitleColor(_themeVO.media_toppanel_icons_color, for: .selected)
        } else{
            sleepButton!.backgroundColor = _themeVO.media_playerView_selected_icon_background
            sleepButton!.setTitleColor(_themeVO.media_playerView_selected_icon_color, for: .normal)
            sleepButton!.setTitleColor(_themeVO.media_playerView_selected_icon_color, for: .selected)
        }
    }
    
    public func didSetAudioSleepTimerOff() {
        stopAudioSleepTimer()
        self.removeSleepTimerViewController()
        self.sleepTimerDelegate?.didSetAudioSleepTimerOff?()
    }
    
    @objc func pauseAudio() {
        if _mediaBookModel?.mediaCurrentState == CurrentState.PLAYING {
            _mediaBookPlayer?.pause()
        }
        
        if((sleepTimerVC) != nil) {
            sleepTimerVC?.updateSelectedSleepAction(SleepAction.kSleepActionNone)
            sleepTimerVC?.updateCustomSelectedTime(time: 0)
        }
        
        stopAudioSleepTimer()
    }
    
    func stopAudioSleepTimer() {
        if audioSleepTimer != nil {
            audioSleepTimer!.invalidate()
            audioSleepTimer = nil
            selectedSleepAction = nil
            selectedSleepTime = nil
            changeSleepButtonStatus(isSleepTimerOff: true)
            stopSleepCountDownTimer()
        }
    }
    
    func removeSleepTimerViewController() {
        if let presentedViewController = sleepTimerVC?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: {})
        }
        if((sleepTimerVC) != nil) {
            sleepTimerVC?.view.removeFromSuperview()
            sleepTimerVC?.removeFromParent()
            sleepTimerVC = nil
        }
    }
    
    func startSleepCountDownTimer(time : TimeInterval) {
        sleepTimerCountDownTime = time
        audioPlayerVC?.addSleepTimeView()
        showSleepTimerCountDownTime(sleepTimerCountDownTime)
        sleepCountDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateSleepCountDownTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateSleepCountDownTimer() {
        if sleepTimerCountDownTime < 1 {
            sleepCountDownTimer!.invalidate()
        } else {
            sleepTimerCountDownTime -= 1
            showSleepTimerCountDownTime(sleepTimerCountDownTime)
        }
    }
    
    func showSleepTimerCountDownTime(_ sleepCountDownTime:TimeInterval) {
        let countDownTime = getCountDownTime(time: sleepCountDownTime)
        audioPlayerVC?.setSleepTimeLabelText(countDownTime)
    }
    
    func getCountDownTime(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return NumberLocalizationHandler.localizeTime(time:String(format:"%02i:%02i:%02i", hours, minutes, seconds),format: "HH:mm:ss")

    }
    
    func stopSleepCountDownTimer() {
        if sleepCountDownTimer != nil {
            sleepCountDownTimer!.invalidate()
            sleepCountDownTimer = nil
            audioPlayerVC?.removeSleepTimeView()
        }
    }
    
    //MARK: De-Initializer Method
    deinit {
        _mediaBookPlayer?.stop()
        _mediaBookPlayer = nil
        audioPlayerVC = nil
        videoPlayerView = nil
        tocController = nil
        _mediaBookModel = nil
        narrationSpeedController = nil
        popOverViewController = nil
        sleepTimerVC = nil
        kitabooUser = nil
        hlsTimeStamp = nil
        if let topBar = playerTopBar{
            topBar.removeFromSuperview()
            playerTopBar = nil
        }
        self.stopScheduler()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        nowPlayingInfo = [:]
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "HDAudioBookViewOrientationChanged"), object: nil)
        if #available(iOS 11.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }
}

extension HDKitabooMediaBookReader {
    
    func addMediaSelections(_ mediaBookModel:HDMediaBookModel) {
        if (mediaBookModel.mediaCurrentState == CurrentState.PLAYING || mediaBookModel.mediaCurrentState == CurrentState.LOADED) {
            _mediaBookModel?.mediaSupportedAudios = mediaBookModel.mediaSupportedAudios
            _mediaBookModel?.mediaSupportedSubtitles = mediaBookModel.mediaSupportedSubtitles
        }
    }
    
    func addMediaPopOverController(_ model:HDKitabooMediaPopOverModel) {
        self.popOverViewController = HDKitabooMediaPopOverController.init(model)
        self.popOverViewController?.delegate = self
        self.view.addSubview(self.popOverViewController!.view)
        self.addChild(self.popOverViewController!)
    }
    
    func getCustomPopOverModel(_ view:UIView) -> HDKitabooMediaPopOverModel {
        let moreOptionStrings = self.getMoreOptionStrings()
        let model = HDKitabooMediaPopOverModel.init()
        model.enableCustomController = true
        if (!HDKitabooMediaBookReader.isIpad()) {
            model.enableCustomControllerRightArrow = true
        }
        model.popOverSourceView = view
        model.itemsTitles = moreOptionStrings.0
        model.customItemTitles = moreOptionStrings.1
        model.itemFont = UIFont(name: "OpenSans-Regular", size:HDKitabooMediaBookReader.isIpad() ? 22 : 16)!
        model.customItemFont = UIFont(name: HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? 30.0 : 22)!
        return model
    }
    
    func getDefaultPopOverModel(_ title:String?, withTitles titles:[String], defaultCustomised customised:Bool = false) -> HDKitabooMediaPopOverModel {
        let model = HDKitabooMediaPopOverModel.init()
        model.popOverTitle = title
        model.itemsTitles = titles
        model.selectedItemColor = _themeVO.media_sidepanel_selected_text_color
        model.itemFont = UIFont(name: "OpenSans-Bold", size:20.0)!
        if (customised) {
            model.enableDefaultCustomisedController = true
            if let currentSelectedSubtitle = _mediaBookPlayer?.currentSelectedSubtitle {
                model.selectedItem = currentSelectedSubtitle
                model.switchState = true
            }else {
                model.switchState = false
            }
            model.switchLabelFont = UIFont(name: "OpenSans-Regular", size:HDKitabooMediaBookReader.isIpad() ? 24 : 18)!
            model.switchTintColor = _themeVO.media_playerView_slider_filled_color ?? .gray
        }
        return model
    }
    
    func removeMediaPopOverController() {
        if let presentedViewController = popOverViewController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: {})
        }
        self.popOverViewController?.view.removeFromSuperview()
        self.popOverViewController?.removeFromParent()
        self.popOverViewController = nil
    }
    
    func getMoreOptionStrings() -> ([String],[String]) {
        var stringArray:[String] = []
        var iconArray:[String] = []
        if let audios = _mediaBookModel?.mediaSupportedAudios, audios.count > 0  {
            iconArray.append("Ü")
            stringArray.append(LocalizationHelper.localizedString(key: "LANGUAGE"))
        }
        if let audios = _mediaBookModel?.mediaSupportedResolutions, audios.count > 0  {
            iconArray.append("Ƀ")
            stringArray.append(LocalizationHelper.localizedString(key: "QUALITY"))
        }
        if let subtitles = _mediaBookModel?.mediaSupportedSubtitles, subtitles.count > 0 {
            iconArray.append("ꬼ")
            stringArray.append(LocalizationHelper.localizedString(key: "SUBTITLES_CC"))
        }
        return (stringArray, iconArray)
    }
    
    func enableDisableSubtitle(_ enabled:Bool) {
        if enabled, let subtitle = _mediaBookModel?.mediaSupportedAudios?.first {
            _mediaBookPlayer?.changeMediaSubtitle(subtitle)
            self.videoPlayerView?.setSubtitleViewColor(.red)
        }else {
            _mediaBookPlayer?.changeMediaSubtitle(nil)
            self.videoPlayerView?.setSubtitleViewColor(.clear)
        }
        self.videoPlayerView?.setSubtitleViewState(enabled)
    }
}

extension HDKitabooMediaBookReader : HDKitabooMediaPopOverControllerDelegate {
    
    public func didTapOnItem(_ itemTitle: String) {
        self.removeMediaPopOverController()
        if itemTitle == LocalizationHelper.localizedString(key: "LANGUAGE"), let audios = _mediaBookModel?.mediaSupportedAudios, audios.count > 0 {
            currentPopOverItem = itemTitle
            let model = self.getDefaultPopOverModel(itemTitle, withTitles: audios)
            model.enableDefaultCustomisedController = true
            model.enableSwitchControl = false
            if let currentSelectedAudio = _mediaBookPlayer?.currentSelectedAudio{
                model.selectedItem = currentSelectedAudio
            }
            self.addMediaPopOverController(model)
        }else if itemTitle == LocalizationHelper.localizedString(key: "QUALITY"), let resolutions = _mediaBookModel?.mediaSupportedResolutions, resolutions.count > 0 {
            currentPopOverItem = itemTitle
            let model = self.getDefaultPopOverModel(itemTitle, withTitles: resolutions)
            model.enableDefaultCustomisedController = true
            model.enableSwitchControl = false
            if #available(iOS 11.0, *), let resolution = _mediaBookPlayer?.currentSelectedQuality {
                model.selectedItem = resolution
            } else {
            }
            self.addMediaPopOverController(model)
        }else if itemTitle == LocalizationHelper.localizedString(key: "SUBTITLES_CC"), let subtitles = _mediaBookModel?.mediaSupportedSubtitles, subtitles.count > 0  {
            currentPopOverItem = itemTitle
            self.addMediaPopOverController(self.getDefaultPopOverModel(itemTitle, withTitles: subtitles, defaultCustomised: true))
        }else {
            self.changeMediaSelection(itemTitle)
        }
        self.popOverDelegate?.didTapOnItem?(itemTitle)
    }
    
    func changeMediaSelection(_ itemTitle: String) {
        if currentPopOverItem == LocalizationHelper.localizedString(key: "LANGUAGE"), let audio = _mediaBookModel?.mediaSupportedAudios?.first(where: {$0 == itemTitle}) {
            _mediaBookPlayer?.changeMediaLanguage(audio)
        }else if currentPopOverItem == LocalizationHelper.localizedString(key: "QUALITY") {
            _mediaBookPlayer?.changeVideoQuality(itemTitle)
        }else if currentPopOverItem == LocalizationHelper.localizedString(key: "SUBTITLES_CC"), let subtitle = _mediaBookModel?.mediaSupportedSubtitles?.first(where: {$0 == itemTitle}) {
            _mediaBookPlayer?.changeMediaSubtitle(subtitle)
            self.videoPlayerView?.setSubtitleViewState(true)
            self.videoPlayerView?.setSubtitleViewColor(.red)
            self.addSubtitleSelectedTextView(itemTitle)
        }
    }
    
    func addSubtitleSelectedTextView(_ itemTitle: String) {
        let view = UIView.init()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        let label = UILabel()
        label.backgroundColor = .black
        label.alpha = 0.80
        label.text = LocalizationHelper.localizedString(key: "SUBTITLES_CC_TURNED_ON") + itemTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: HDKitabooMediaBookReader.isIpad() ? 20 : 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: HDKitabooMediaBookReader.isIpad() ? 350 : 220).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 3.0, animations: {}) { finished in
                label.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
    }
    
    public func didTapOnCancelItem() {
        self.removeMediaPopOverController()
        self.popOverDelegate?.didTapOnCancelItem?()
    }
    
    public func didChangeSwitchState(_ isOn: Bool) {
        self.enableDisableSubtitle(isOn)
        self.popOverDelegate?.didChangeSwitchState?(isOn)
    }
}

extension HDKitabooMediaBookReader {
    
    func addNextPreviousControls() {
        if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
            if let mediaBookPlayer = self._mediaBookPlayer, let viewForControls = self.videoPlayerView?.view.subviews.first(where: {$0 === mediaBookPlayer.getPlayerLayerView()}) {
                self.videoPlayerView?.view.addSubview(self.previousMediaButton)
                self.videoPlayerView?.view.addSubview(self.nextMediaButton)
                
                self.previousMediaButton.centerYAnchor.constraint(equalTo: viewForControls.centerYAnchor, constant: 0).isActive = true
                self.previousMediaButton.widthAnchor.constraint(equalToConstant: HDKitabooMediaBookReader.isIpad() ? 80.0 : 60.0).isActive = true
                self.previousMediaButton.heightAnchor.constraint(equalTo: self.previousMediaButton.widthAnchor, multiplier: 1.0).isActive = true
                
                self.previousButtonLeadingConstraint = self.previousMediaButton.leadingAnchor.constraint(equalTo: self.videoPlayerView!.view.leadingAnchor, constant: 0)
                self.previousButtonLeadingConstraint?.isActive = true
                
                self.nextMediaButton.centerYAnchor.constraint(equalTo: viewForControls.centerYAnchor, constant: 0).isActive = true
                self.nextMediaButton.widthAnchor.constraint(equalToConstant: HDKitabooMediaBookReader.isIpad() ? 80.0 : 60.0).isActive = true
                self.nextMediaButton.heightAnchor.constraint(equalTo: self.previousMediaButton.widthAnchor, multiplier: 1.0).isActive = true
                
                self.nextButtonTrailingConstraint = self.nextMediaButton.trailingAnchor.constraint(equalTo: self.videoPlayerView!.view.trailingAnchor, constant: 0)
                self.nextButtonTrailingConstraint?.isActive = true
                
                self.videoPlayerView?.view.bringSubviewToFront(self.previousMediaButton)
                self.videoPlayerView?.view.bringSubviewToFront(self.nextMediaButton)
                self.hideNextPreviousControls(true)
            }
        }else {
            if let imageView = self.audioPlayerVC?.getThumbnailContainerView(), let viewForControls = imageView.subviews.first(where: {type(of: $0) == UIImageView.self}) as? UIImageView {
                self.audioPlayerVC?.view.addSubview(self.previousMediaButton)
                self.audioPlayerVC?.view.addSubview(self.nextMediaButton)
                
                self.previousMediaButton.centerYAnchor.constraint(equalTo: viewForControls.centerYAnchor, constant: 0).isActive = true
                self.previousMediaButton.widthAnchor.constraint(equalToConstant: HDKitabooMediaBookReader.isIpad() ? 80.0 : 60.0).isActive = true
                self.previousMediaButton.heightAnchor.constraint(equalTo: self.previousMediaButton.widthAnchor, multiplier: 1.0).isActive = true
                
                self.previousButtonLeadingConstraint = self.previousMediaButton.trailingAnchor.constraint(equalTo: viewForControls.leadingAnchor, constant: 0)
                self.previousButtonLeadingConstraint?.isActive = true
                
                self.nextMediaButton.centerYAnchor.constraint(equalTo: viewForControls.centerYAnchor, constant: 0).isActive = true
                self.nextMediaButton.widthAnchor.constraint(equalToConstant: HDKitabooMediaBookReader.isIpad() ? 80.0 : 60.0).isActive = true
                self.nextMediaButton.heightAnchor.constraint(equalTo: self.previousMediaButton.widthAnchor, multiplier: 1.0).isActive = true
                
                self.nextButtonTrailingConstraint = self.nextMediaButton.leadingAnchor.constraint(equalTo: viewForControls.trailingAnchor, constant: 0)
                self.nextButtonTrailingConstraint?.isActive = true
                
                self.audioPlayerVC?.view.bringSubviewToFront(self.previousMediaButton)
                self.audioPlayerVC?.view.bringSubviewToFront(self.nextMediaButton)
                
            }
        }
        self.updateNextPreviousControlsConstraint()
    }
    
    func updateNextPreviousControlsConstraint() {
        if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
            if #available(iOS 11.0, *) {
                self.previousButtonLeadingConstraint?.constant = (HDKitabooMediaBookReader.isIpad() ? 30 : (UIDevice.current.orientation.isLandscape ? 70 : 3)) + self.videoPlayerView!.view.safeAreaInsets.left
                self.nextButtonTrailingConstraint?.constant = -((HDKitabooMediaBookReader.isIpad() ? 30 : (UIDevice.current.orientation.isLandscape ? 70 : 3)) + self.videoPlayerView!.view.safeAreaInsets.right)
            }else {
                self.previousButtonLeadingConstraint?.constant = (HDKitabooMediaBookReader.isIpad() ? 30 : (UIDevice.current.orientation.isLandscape ? 70 : 3))
                self.nextButtonTrailingConstraint?.constant = -(HDKitabooMediaBookReader.isIpad() ? 30 : (UIDevice.current.orientation.isLandscape ? 70 : 3))
            }
            self.nextMediaButton.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? 30 : 20)
            self.previousMediaButton.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? 30 : 20)
        }else {
            self.nextMediaButton.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? 25 : 18)
            self.previousMediaButton.titleLabel?.font = UIFont(name:HDKitabooMediaBookReaderConstants.font_name, size: HDKitabooMediaBookReader.isIpad() ? 25 : 18)
            self.previousButtonLeadingConstraint?.constant = -(HDKitabooMediaBookReader.isIpad() ? (UIDevice.current.orientation.isLandscape ? 80 : 100) : 50)
            self.nextButtonTrailingConstraint?.constant = (HDKitabooMediaBookReader.isIpad() ? (UIDevice.current.orientation.isLandscape ? 80 : 100) : 50)
        }
    }
    
    /**
      A method to enable/disable media Book next media Button UI.
     */
    @objc public func disableNextMediaButton(_ disable:Bool) {
        if disable {
            self.nextMediaButton.isUserInteractionEnabled = false
            self.nextMediaButton.setTitleColor(_themeVO.media_playerView_disabled_navigation_arrow_color, for: .normal)
            self.nextMediaButton.setTitleColor(_themeVO.media_playerView_disabled_navigation_arrow_color, for: .selected)
        }else {
            self.nextMediaButton.isUserInteractionEnabled = true
            if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                self.nextMediaButton.setTitleColor(_themeVO.video_player_icon_color, for: .normal)
                self.nextMediaButton.setTitleColor(_themeVO.video_player_icon_color, for: .selected)
            }else {
                self.nextMediaButton.setTitleColor(_themeVO.media_playerView_slider_filled_color, for: .normal)
                self.nextMediaButton.setTitleColor(_themeVO.media_playerView_slider_filled_color, for: .selected)
            }
        }
    }
    
    /**
      A method to enable/disable media Book previous media Button UI.
     */
    @objc public func disablePreviousMediaButton(_ disable:Bool) {
        if disable {
            self.previousMediaButton.isUserInteractionEnabled = false
            self.previousMediaButton.setTitleColor(_themeVO.media_playerView_disabled_navigation_arrow_color, for: .normal)
            self.previousMediaButton.setTitleColor(_themeVO.media_playerView_disabled_navigation_arrow_color, for: .selected)
        }else {
            self.previousMediaButton.isUserInteractionEnabled = true
            if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                self.previousMediaButton.setTitleColor(_themeVO.video_player_icon_color, for: .normal)
                self.previousMediaButton.setTitleColor(_themeVO.video_player_icon_color, for: .selected)
            }else {
                self.previousMediaButton.setTitleColor(_themeVO.media_playerView_slider_filled_color, for: .normal)
                self.previousMediaButton.setTitleColor(_themeVO.media_playerView_slider_filled_color, for: .selected)
            }
        }
    }
    
    @objc func nextMediaButtonTapped(_ sender: UIButton) {
        delegate?.didTapOnNextMediaButton?(self)
        self.updateMediaToDefaultBehaviour()
    }
    
    @objc func previousMediaButtonTapped(_ sender: UIButton) {
        delegate?.didTapOnPreviousMediaButton?(self)
        self.updateMediaToDefaultBehaviour()
    }
    
    /**
      A method to hide/unhide media Book next/previous media Button UI.
     */
    @objc public func hideNextPreviousControls(_ hide:Bool) {
        if hide {
            self.previousMediaButton.isHidden = true
            self.nextMediaButton.isHidden = true
        }else{
            self.previousMediaButton.isHidden = false
            self.nextMediaButton.isHidden = false
        }
    }
    
    func updateMediaToDefaultBehaviour() {
        self._mediaBookModel?.mediaNarrationSpeedRate = 1
        self.didNarrationSpeedValueChanges(self._mediaBookModel)
        self.deleteAllBookmarks()
        self.tocController?.setData(nil)
        self.stopAudioSleepTimer()
        self.removeSleepTimerViewController()
        self.removeNarrationSpeedController()
        self.removeMediaPopOverController()
        if let presentedViewController = bookmarkController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: {})
        }
        bookmarkController?.view.removeFromSuperview()
        bookmarkController?.removeFromParent()
        if currentMediaBookType == .kMediaBookVideo {
            self.enableDisableSubtitle(false)
            self.videoPlayerView?.isVideoReadyToPlay(false)
            self.videoPlayerView?.enableDisbleMuteButton(true)
            self.hideNextPreviousControls(true)
        }
    }
}

extension HDKitabooMediaBookReader{
    func getChapterVOWithTime(dict metaData:[String:Any]) -> (HDMediaBookChapterVO?, Int)? {
        var fileName = ""
        if let file = metaData["FileName"] as? String {
            fileName = file
        } else if let file = metaData["fileName"] as? String {
            fileName = file
        }
        var chapterName = ""
        if let chapter = metaData["ChapterName"] as? String {
            chapterName = chapter
        } else if let chapter = metaData["chapterName"] as? String {
            chapterName = chapter
        }
        if let chapterVo = _mediaBookModel?.mediaBookAllChaptersArray.first(where: {$0.urlLastPathComponent!.components(separatedBy: "#").first == fileName && $0.chapterTitle! == chapterName}) {
            if let currentTime = metaData["CurrentTime"] as? Int {
                return (chapterVo, currentTime)
            } else if let currentTime = metaData["currentTime"] as? Int  {
                return (chapterVo, currentTime)
            }
            return (chapterVo, 0)
        }
        return nil
    }
    
    func navigateToChapter(chapter:HDMediaBookChapterVO, seekTime:Int) {
        if let chapterVoLastPath = chapter.urlLastPathComponent?.components(separatedBy: "#").first, let currentChapterLastPath  = _mediaBookModel?.currentChapter?.urlLastPathComponent?.components(separatedBy: "#").first, chapterVoLastPath != currentChapterLastPath {
            self.deleteBookmarksForCurrentChapter()
        }
        _mediaBookPlayer?.navigateToChapter(chapter, withSeekTime: seekTime)
        self.updateMediaViewsUIForUpdatedChapter(chapterIsUpdated: true)
    }
    
    func deleteBookmarksForCurrentChapter() {
        if let allBookmarks = self.bookmarks as? [SDKBookmarkVO], let currentChapter = _mediaBookModel?.currentChapter {
            let currentChpaterbookmarks = allBookmarks.filter { bookmark in
                if let metaData = bookmark.metaData as? [String: Any]{
                    var fileName = ""
                    if let file = metaData["FileName"] as? String {
                        fileName = file
                    } else if let file = metaData["fileName"] as? String {
                        fileName = file
                    }
                    
                    if fileName == currentChapter.urlLastPathComponent?.components(separatedBy: "#").first {
                        return true
                    }
                }
                return false
            }
            if currentChpaterbookmarks.count > 0 {
                if self.currentMediaBookType == MediaBookType.kMediaBookVideo {
                    self.videoPlayerView?.deleteAllBookmarks(currentChpaterbookmarks)
                }else {
                    self.audioPlayerVC?.deleteAllBookmarks(currentChpaterbookmarks)
                }
            }
        }
    }
    
    func getbookmarksForCurrentChapter() -> [SDKBookmarkVO]? {
        if let allBookmarks = self.bookmarks as? [SDKBookmarkVO], let currentChapter = _mediaBookModel?.currentChapter {
            let currentChpaterbookmarks = allBookmarks.filter { bookmark in
                if let metaData = bookmark.metaData as? [String: Any]{
                    var fileName = ""
                    if let file = metaData["FileName"] as? String {
                        fileName = file
                    } else if let file = metaData["fileName"] as? String {
                        fileName = file
                    }
                    
                    if fileName == currentChapter.urlLastPathComponent?.components(separatedBy: "#").first {
                        return true
                    }
                }
                return false
            }
            return currentChpaterbookmarks
        }
        return nil
    }
}
