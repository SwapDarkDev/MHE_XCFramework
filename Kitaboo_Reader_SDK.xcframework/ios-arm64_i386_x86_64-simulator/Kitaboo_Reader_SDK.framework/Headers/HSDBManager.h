//
//  ePUBDBManager.h
//  ePUBSDK

#import <Foundation/Foundation.h>
#import "UGC.h"
#import "KitabooBookVO.h"
#import "SDKBookClassInfoVO.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import "EPUBBookVO.h"


/** An Object that will be responsible for Presisting the SDK Data, The Data is been stored using Core Data (ORM), and will use Sqlite for actual storage.
 * @discussion HSDBManager is a manager class which is used to handle all the communication of data, with database such as saving highlight to database, deleting any highlight from the database, updating shared data to database etc.
 * @superclass SuperClass : NSObject
 */
@interface HSDBManager : NSObject

/** Object of type KitabooBookVO*/
@property (strong, nonatomic) KitabooBookVO * book;

#pragma Highlight DB Calls
/*!
 * To persist highlight.
 * @discussion This method is used when user wants to save highlight permanently in the database for given book. Parameter `highlightVO` contains all the information about the highlight eg. text of the highlight, color of the highlight etc.
 * @param1 highlightVO Oject of type SDKHighlightVO, to be persisted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager saveHighlight:highlightVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)saveHighlight:(SDKHighlightVO *)highlightVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To get persisted highlights for provided Bookid and page ID.
 * @discussion This method is used to return all the saved highlights of given page, for given book and user.
 * @param1 pageID An unique page Identifier.
 * @param2 displayNumber Page number eg. Eg I,II,III.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
 * @code
 * [dbManager highlightForPageID:pageID ForDisplayNumber:displayNumber bookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted highlights for given bookId and PageId.
 */
- (NSArray *)highlightForPageID:(NSString*)pageID ForDisplayNumber:(NSString*)displayNumber
                         bookID:(NSNumber *)bookID
                         userID:(NSNumber *)userID;
/*!
 * To delete highlight.
 * @discussion When a highlight to be deleted for given book and user.
 
 - If given highlightVO is available for book, method returns YES else NO. Parameter `highlightVO` contains all the information about highlight.
 * @param1 highlightVO Oject of type UGC, to be deleted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager deleteHighlight:highlightVO bookID:bookID userID:userID];
 * @endcode
 * @return Returns A BOOL Value.
 */
- (BOOL)deleteHighlight:(UGC *)highlightVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To get persisted highlights for provided Book Id.
 * @discussion This method is used when user wants to get all the highlights of a book.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User  who has created the UGC.
 * @code
 * [dbManager highlightBookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted highlights for given bookId.
 */
- (NSArray *)highlightBookID:(NSNumber *)bookID userID:(NSNumber *)userID;

#pragma Bookmark DB Calls
/*!
 * To get persisted bookmarks for provided Book Id.
 * @discussion This method is used when user wants to get all the bookmarks of a book.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager bookMarkBookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted bookmarks for given bookId.
 */
- (NSArray *)bookMarkBookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To persist bookmark.
 * @discussion This method is used when user wants to save bookmark permanently in the database for given book. Parameter `bookmarkVO` contains all the information about the bookmark eg. text on the bookmark, creator name of the bookmark etc.
 * @param1 bookmarkVO Oject of type SDKBookmarkVO, to be persisted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager saveBookmark:bookmarkVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)saveBookmark:(SDKBookmarkVO *)bookmarkVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To get persisted bookmarks for provided Book Id and page ID.
 * @discussion This method is used to return all the saved bookmarks of given page, for given book and user.
 * @param1 pageID An unique page Identifier.
 * @param2 displayNumber Page number eg. Eg I,II,III.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
 * @code
 * [dbManager bookmarkForPageID:pageID ForDisplayNumber:displayNumber bookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted highlights for given bookId and PageId.
 */
- (NSArray *)bookmarkForPageID:(NSString*)pageID ForDisplayNumber:(NSString*)displayNumber
                        bookID:(NSNumber *)bookID
                        userID:(NSNumber *)userID;

/*!
 * To delete Bookmark.
 * @discussion When a Bookmark to be deleted for given book and user.
 
 - If given bookmarkVO is available for book, method returns YES else NO. Parameter `bookmarkVO` contains all the information about bookmark.
 * @param1 bookmarkVO Oject of type UGC, to be deleted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager deleteBookmark:bookmarkVO bookID:bookID userID:userID];
 * @endcode
 * @return Returns A BOOL Value.
 */
- (BOOL)deleteBookmark:(UGC *)bookmarkVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

#pragma Pentool DB Calls
/*!
 * To persist pentool drawing.
 * @discussion This method is used when user wants to save pentool drawing permanently in the database for given book. Parameter `pentoolVO` contains all the information about the pentool drawing eg. Color Code, Pentool Thickness, Pen Color etc.
 * @param1 pentoolVO Oject of type SDKPentoolVO, to be persisted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager savePentoolDrawing:pentoolVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)savePentoolDrawing:(SDKPentoolVO *)pentoolVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To get persisted pentool drawings for provided Bookid and page ID.
 * @discussion This method is used to return all the saved pentool drawings of given page, for given book and user.
 * @param1 pageID An unique page Identifier.
 * @param2 displayNumber Page number eg. Eg I,II,III.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
 * @code
 * [dbManager pentoolDrawingForPageID:pageID ForDisplayNumber:displayNumber bookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted pentool drawings for provided Bookid and page ID.
 */
- (NSArray *)pentoolDrawingForPageID:(NSString*)pageID ForDisplayNumber:(NSString*)displayNumber
                              bookID:(NSNumber *)bookID
                              userID:(NSNumber *)userID;

/*!
 * To delete Pentool Drawing.
 * @discussion When a Pentool Drawing to be deleted for given book and user.
 
 - If given pentoolVO is available for book, method returns YES else NO. Parameter `pentoolVO` contains all the information about pentool.
 * @param1 pentoolVO Oject of type UGC, to be deleted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager deletePentoolDrawing:pentoolVO bookID:bookID userID:userID];
 * @endcode
 * @return Returns A BOOL Value.
 */
- (BOOL)deletePentoolDrawing:(UGC *)pentoolVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

#pragma mark BookClassInfo DB Calls
/*!
 * To persist Book Information of type SDKBookClassInfoVO.
 * @discussion This method is used when user wants to save SDKBookClassInfoVO object permanently in the database for given book. Parameter `bookClassInfoVO` contains all the information about the Book eg. Title of the book, Total number of pages in book etc.
 * @param1 bookClassInfoVO Oject of type SDKBookClassInfoVO, to be persisted.
 * @param1 bookGuid Book id for which SDKBookClassInfoVO is created.
 * @param1 userId User who has created the SDKBookClassInfoVO.
 * @code
 * [dbManager saveClassInfoOfBook:bookClassInfoVO ofBook:bookGuid forUser:userId];
 * @endcode
 */
- (BOOL)saveClassInfoOfBook:(SDKBookClassInfoVO *)bookClassInfoVO ofBook:(NSNumber *)bookGuid forUser:(NSNumber *)userId;

/*!
 * To get persisted SDKBookClassInfoVO for provided Book Id and user Id.
 * @discussion This method is used to return all the saved SDKBookClassInfoVO Objects for given book and user.
 * @param1 bookGuid Book id for which SDKBookClassInfoVO is created.
 * @param2 userId User who has created the SDKBookClassInfoVO.
 * @code
 * [dbManager bookClassInfoArrayForBookID:bookGuid forUser:userId];
 * @endcode
 * @return Returns persisted SDKBookClassInfoVO for provided Book Id and user Id.
 */
- (NSArray *)bookClassInfoArrayForBookID:(NSNumber *)bookGuid forUser:(NSNumber *)userId;


/*!
 * Should be called to save UGC.
 * @discussion This method is used to save dictionary of KitabooUGC in database for given book and user. Parameter `ugcDictionary` contains serverId and LocalId, with help of that user can get to know whether any KitabooUGC available in database or not.
 
 - If KitabooUGC is not available in database, it will return NO else return YES.
 
 @param1 ugcDictionary Is the KitabooUGC dictionary to be persisted.
 @param2 bookID Book id for which KitabooUGC is created.
 @param3 userID User id for which KitabooUGC is created.
 @param4 isSynced A BOOL value to be persisted.
 @param5 modifiedDate Last modified date to be persisted.
 * @code
 * [dbManager saveKitabooUGCWithDictionary:ugcDictionary withBookID:bookID userID:userID withIsSynced:YES WithModifiedDate:modifiedDate];
 * @endcode
 * @return Returns A BOOL value.
 */
-(BOOL)saveKitabooUGCWithDictionary:(NSDictionary *)ugcDictionary withBookID:(NSNumber *)bookID userID:(NSNumber *)userID withIsSynced:(BOOL)isSynced WithModifiedDate:(NSDate*)modifiedDate;


/*!
 * Should be called to update SharedCollabData.
 * @discussion SharedCollabData is nothing but shared notes. This method is used when user wants to update shared notes data for given book Id. Parameter `sharedUGCData` contains all the information about upadated SharedCollabData.
 * @param1 sharedUGCData Is the dictionary to be persisted.
 * @param2 bookID Book id for which KitabooUGC is created.
 * @param3 userID User who has created the KitabooUGC.
 * @code
 * [dbManager updateSharedCollabData:sharedUGCData ofBook:bookID ForUserID:userId];
 * @endcode
 */
-(void)updateSharedCollabData:(NSDictionary *)sharedUGCData ofBook:(NSNumber *)bookID ForUserID:(NSNumber*)userID;


/*!
 * Should be called to update ugc data.
 * @discussion With the help of parameter `localId` user can get the existing UGC. If UGC with this local Id exists and its status is DELETE, UGC will be deleted. Otherwise server Id, date time, isSynced etc parameters will be updated in existing UGC according to given data.
 * @param1 localId Used to get existing UGC.
 * @param1 ugcId Is the ugc to be persisted.
 * @param2 dateTime Is the NSString value which to be persisted.
 * @param3 synced Is the boolean to be persisted.
 * @code
 * [dbManager updateUGC:localId ugcId:ugcId dateTime:dateTime synced:YES];
 * @endcode
 */
- (void)updateUGC:(NSString *)localId ugcId:(NSString *)ugcId dateTime:(NSString *)dateTime synced:(BOOL)synced;


/*!
 * To get the unsynced ugc data.
 * @discussion This method fetch all the unsynced ugc data, that stored in database and returns the unsynced ugc data for given user ID.
 * @param1 userID User id who has created the KitabooUGC.
 * @return Returns Dictionary of unsynced ugc data.
 * @code
 * [dbManager getUnsynedUGCDictionaryForUserID:userID];
 * @endcode
 */
-(NSDictionary*)getUnsynedUGCDictionaryForUserID:(NSNumber*)userID;


/*!
 * To get a string of last synced date for book.
 * @param1 bookID Book id.
 * @param2 userID User id who has created the BookSyncInfo.
 * @return String of last synced date for book.
 * @code
 * [dbManager getLastSyncedDateForBookID:bookID ForUserID:userID];
 * @endcode
 */
-(NSString*)getLastSyncedDateForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;


/*!
 * Should be called to set the last sync date for given book and user.
 * @param1 lastSyncDate To be persisted.
 * @param2 bookID Book id.
 * @param3 userID User id who has created the BookSyncInfo.
 * @code
 * [dbManager setLastSyncedDate:lastSyncDate ForBookID:bookID ForUserID:userID];
 * @endcode
 */
-(void)setLastSyncedDate:(NSString*)lastSyncDate ForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;


/*!
 * Should to called to submit the annotations.
 * @param1 bookID Book id.
 * @param2 userID User id who has created the KitabooUGC.
 * @code
 * [dbManager submitAnotationForBookID:bookID ForUserID:userID];
 * @endcode
 */
-(void)submitAnotationForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;

/*!
 * Should be called to submit the annotations for fib.
 * @param1 bookID Book id.
 * @param2 userID User id who has created the KitabooUGC.
 * @code
 * [dbManager submitAnotationForFibForBookID:bookID ForUserID:userID];
 * @endcode
 */
-(void)submitAnotationForFibForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;


/*!
 * To get the SDKPentoolVO from ugc dictionary.
 * @discussion This method is used to return object of type SDKPentoolVO from given penToolUGCDict, which contains all the information about pentool as well UGC.
 * @param1 penToolUGCDict To be persisted.
 * @code
 * [dbManager getSDKPenToolVOFromUGCDictionary:penToolUGCDict];
 * @endcode
 * @return Returns the SDKPentoolVO from ugc dictionary.
 */
-(SDKPentoolVO *)getSDKPenToolVOFromUGCDictionary:(NSDictionary *)penToolUGCDict;


/*!
 *To get a dictionary format from SDKPenToolVO object.
 * @param1 penToolVO To be persisted.
 * @code
 * [dbManager getPenToolUGCDictionaryFromSDKPenToolVO:penToolVO];
 * @endcode
 * @return Returns a dictionary format from SDKPenToolVO object.
 */
-(NSDictionary *)getPenToolUGCDictionaryFromSDKPenToolVO:(SDKPentoolVO *)penToolVO;


/*!
 * To get to know for given book and user submission of Annotation is allowed or not.
 * @discussion If this returns YES, user will be able to submit annotation for the book else, he/she will not be able to submit annotation for particular book.
 * @param1 bookID Book id.
 * @param3 userID User id who has created the KitabooUGC.
 * @code
 * [dbManager isSubmitAnotationAllowedForBookID:bookID ForUserID:userID];
 * @endcode
 * @return Returns a BOOL.
 */
-(BOOL)isSubmitAnotationAllowedForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;

/*!
 * To get to know for given book and user submission of Annotation for fib is allowed or not.
 * @discussion If this returns YES, user will be able to submit annotation for the book else, he/she will not be able to submit annotation for particular book.
 * @param1 bookID Book id.
 * @param3 userID User id who has created the KitabooUGC.
 * @code
 * [dbManager isSubmitAnotationAllowedForFibForBookID:bookID ForUserID:userID];
 * @endcode
 * @return Returns a BOOL.
 */
-(BOOL)isSubmitAnotationAllowedForFibForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID;


/*!
 * Should be called to delete saved received ugc from database.
 * @discussion This method is used to delete already saved received UGC for given book and user.
 * @param1 bookID Book id.
 * @param3 userID User id who has created the BookSyncInfo.
 * @code
 * [dbManager deleteAllReceivedUGCForBookID:bookID UserID:userID];
 * @endcode
 */
-(void)deleteAllReceivedUGCForBookID:(NSNumber *)bookID UserID:(NSNumber *)userID;


/*!
 * To get the unsynced Collab data.
 * @discussion This method is used to fetch Unsynced Collab Data which is shared/received notes data for given user.
 * @param1 userID User id who has created the KitabooUGC.
 * @return Returns unsynced Collab data.
 * @code
 * [dbManager getUnsyncedCollabDataDictionaryForUserID:userID];
 * @endcode
 */
- (NSDictionary *)getUnsyncedCollabDataDictionaryForUserID:(NSNumber *)userID;


/*!
 * Should be called to update Accept/Reject Collab data.
 * @param1 ugcId Is the ugc to be persisted
 * @param2 accepted Is the boolean to be persisted.
 * @param3 userId User id who has created the KitabooUGC.
 * @code
 * [dbManager updateAnsweredUGC:ugcId accepted:accepted andUserId:userId];
 * @endcode
 */
- (void)updateAnsweredUGC:(NSString *)ugcId accepted:(BOOL)accepted andUserId:(NSString *)userId;

/*!
 * Should be called to update the isCollabSubmitted.
 * @param1 userID User id who has created the KitabooUGC.
 * @code
 * [dbManager setCollabDataSubmittedForUserID:userId];
 * @endcode
 */
- (void)setCollabDataSubmittedForUserID:(NSNumber *)userID;

/*!
* Should be called to update the isCollabSubmitted for UGC id.
* @param1 userID User id who has created the KitabooUGC.
* @param2 ugcIdArray is the array of unique server id.
* @code
* [dbManager setCollabDataSubmittedForUserID:ForUGCIdArray:];
* @endcode
*/
- (void)setCollabDataSubmittedForUserID:(NSNumber *)userID ForUGCIdArray:(NSArray *)ugcIdArray;

/*!
 * Should be called to check whether resources are decrypted or not.
 * @discussion Returns YES if recources are decrypted, NO if not decrypted.
 * @param1 bookID Book id.
 * @return A BOOL.
 * @code
 * [dbManager isResourcesDecryptedForBookID:bookID];
 * @endcode
 */
- (BOOL)isResourcesDecryptedForBookID:(NSNumber *)bookID;

/*!
 * Should be called to update whether resources are decrypted.
 * @param1 bookID Book id.
 * @param2 isDecrypted Is the boolean to be persisted.
 * @code
 * [dbManager updateResourceDecryption:isDecrypted ForBookID:bookID];
 * @endcode
 */
- (void)updateResourceDecryption:(BOOL)isDecrypted ForBookID:(NSNumber *)bookID;

/*!
 * Create Reader Analytics Session and return Session ID.
 * @code
 * [dbManager createReaderAnalyticsSessionForUserID:userID WithBookID:bookID WithAnalyticsData:analyticsData];
 * @endcode
 */
- (NSString*)createReaderAnalyticsSessionForUserID:(NSString*)userID WithBookID:(NSString*)bookID withAnalyticsData:(NSString *)analyticsData;

/*!
 *Should be called to update reader analytics for user
 @param1 userID user id who has created the reader ananlytics.
 @param2 bookID book id.
 @param3 analyticsJSON is the reader analytics tracked data.
 * @code
 * [dbManager updateReaderAnalyticsSessionForUser:userID WithBookID:bookID WithAnalyticsData:analyticsJSON];
 * @endcode
 */
-(void)updateReaderAnalyticsSessionForUser:(NSNumber *)userID WithBookID:(NSNumber *)bookID WithAnalyticsData:(NSString*)analyticsJSON;

/*!
 *Should be called to get reader analytics data for user
 @param1 userID user id who has created the reader ananlytics.
 @param2 bookID book id.
 * @code
 * [dbManager getReaderAnalyticsForUser:userID WithBookID:bookID];
 * @endcode
 */
-(NSDictionary *)getReaderAnalyticsForUser:(NSNumber *)userID WithBookID:(NSNumber *)bookID;

/*!
 *Should be called to delete reader analytics data for user
 @param1 userID user id who has created the reader ananlytics.
 @param2 bookID book id.
 * @code
 * [dbManager deleteReaderAnalyticsForUser:userID WithBookID:bookID withSessionID:sessionID];
 * @endcode
 */
-(void)deleteReaderAnalyticsForUser:(NSNumber *)userID WithBookID:(NSNumber *)bookID withSessionID:(NSString *)sessionID;
/*!
 *Should be called to delete All reader analytics data for user
 @param1 userID user id who has created the reader ananlytics.
 @param2 bookID book id.
 * @code
 * [dbManager deleteAllReaderAnalyticsForUser:userID WithBookID:bookID];
 * @endcode
 */
-(void)deleteAllReaderAnalyticsForUser:(NSNumber *)userID WithBookID:(NSNumber *)bookID;
/*!
 *Should be called to delete All reader analytics data
 * @code
 * [dbManager deleteAllReaderAnalytics];
 * @endcode
 */
-(void)deleteAllReaderAnalytics;
/*!
 *Should be called to get SDKFIBVO Object
 @param1 linkId link id of FIB.
 @param2 userId user id ho has created FIB.
 * @code
 * [dbManager getFIBObjectWithLinkId:linkId forUserId:userId];
 * @endcode
 */
- (SDKFIBVO *) getFIBObjectWithLinkId:(NSNumber *)linkId forUserId:(NSNumber *) userId;

/*!
 *Should to called to Save the FIB data
 @param1 fibVO fibVO Object of SDKFIBVO to save.
 @param2 bookID book id.
 @param3 userID user id who has created the FIB.
 * @code
 * [dbManager saveFIB:fibVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)saveFIB:(SDKFIBVO *)fibVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 *Should to called to Delete the FIB data
 @param1 fibVO fibVO Object of SDKFIBVO to delete.
 @param2 bookID book id.
 @param3 userID user id who has created the FIB.
 * @code
 * [dbManager deleteFIB:fibVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)deleteFIB:(SDKFIBVO *)fibVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 *Should to called to Update the FIB data
 @param1 fibVO fibVO Object of SDKFIBVO to update.
 @param2 bookID book id.
 @param3 userID user id who has created the FIB.
 * @code
 * [dbManager updateFIB:fibVO bookID:bookID userID:userID];
 * @endcode
 */
- (void)updateFIB:(SDKFIBVO *)fibVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 *Returns the SDKFIBVO from ugc dictionary
 @param1 fibUGCDict to be persisted.
 * @code
 * [dbManager getSDKFIBVOFromUGCDictionary:fibUGCDict];
 * @endcode
 */
-(SDKFIBVO *)getSDKFIBVOFromUGCDictionary:(NSDictionary *)fibUGCDict;

/*!
 *Returns a dictionary format from SDKFIBVO object
 @param1 fibVO to be persisted.
 * @code
 * [dbManager getFIBUCGDictionaryFromSDKFIBVO:fibVO];
 * @endcode
 */
-(NSDictionary*)getFIBUCGDictionaryFromSDKFIBVO:(SDKFIBVO *)fibVO;

/*!
 *Should to called to update share list and receive list
 @param1 shareRecieveListDic shareRecieveListDic dictionary of share and receive list
 @param2 bookGuid book id.
 @param3 userId user id who has created.
 * @code
 * [dbManager saveSharedReceivedInfo:shareRecieveListDic ofBook:bookGuid forUser:userId];
 * @endcode
 */
- (BOOL)saveSharedReceivedInfo:(NSDictionary *)shareRecieveListDic ofBook:(NSNumber *)bookGuid forUser:(NSNumber *)userId;
/*!
 To persist TextAnnotation
 @param1 textAnnotationVO SDKTextAnnotationVO(UGC) object be persisted
 @param2 bookID book id for which UGC is created.
 @param3 userID user id who has created the UGC.
 * @code
 * [dbManager saveTextAnnotation:textAnnotationVO bookID:bookID userID:userID];
 * @endcode
 **/
- (BOOL)saveTextAnnotation:(SDKTextAnnotationVO *)textAnnotationVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 Returns persisted textAnnotationVO for provided Bookid and page ID.
 @param1 pageID unique page Identifier
 @param2 displayNumber page display Number/folio Number
 @param3 bookID book id for which UGC is created.
 @param4 userID user id who has created the UGC.
 * @code
 * [dbManager textAnnotationVOForPageID:pageID ForDisplayNumber:displayNumber bookID:bookID userID:userID];
 * @endcode
 */
- (NSArray *)textAnnotationVOForPageID:(NSString*)pageID ForDisplayNumber:(NSString*)displayNumber
                         bookID:(NSNumber *)bookID
                         userID:(NSNumber *)userID;

/*!
 To delete TextAnnotationVO.
 @param1 ugc SDKTextAnnotationVO(UGC) object be deleted
 @param2 bookID book id for which UGC is created.
 @param3 userID user id who has created the UGC.
 * @code
 * [dbManager deleteTextAnnotation:ugc bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)deleteTextAnnotation:(SDKTextAnnotationVO *)ugc bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * Should to called to fetch scorm data.
 @param1 bookID book id.
 @param2 userID user id of current user.
 @param3 classId classid of book.
 @param4 checkSynced whether to check for item is synced or not.
 * @return Returns scorm data.
 * @code
 * [dbManager fetchSCORMInfoFromDBWithBookID:bookID forUser:userID andClassId:classId checkIfSynced:YES];
 * @endcode
 */
- (NSMutableArray *)fetchSCORMInfoFromDBWithBookID:(NSNumber *)bookID forUser:(NSNumber *)userID  andClassId:(NSString *)classId checkIfSynced:(BOOL)checkSynced;

/*!
 * Should to called to save scorm data.
 * @param1 bookID book id.
 * @param2 userID user id of current user.
 * @param3 scormId scorm id of scorm resource.
 * @param4 scormDataString scorm core_cmi data string.
 * @param5 classId classid of book.
 * @param6 activityName name of scorm
 * @param7 isSynced whether it is is synced or not
 * @code
 * [dbManager saveSCORMdataToDB:bookID forUser:userID forSCORMId:scormId withSCORMString:scormDataString andClassId:classId andPageID:pageID andActivityname:activityName andIsSynced:YES];
 * @endcode
 */
- (void)saveSCORMdataToDB:(NSNumber *)bookID forUser:(NSNumber *)userID forSCORMId:(NSString *)scormId withSCORMString:(NSString *)scormDataString andClassId:(NSString *)classId andPageID:(NSNumber *)pageID andActivityname:(NSString *)activityName andIsSynced:(BOOL)isSynced;
/*!
 * Should to called to fetch scorm data.
 * @discussion This method is used to fetch saved scorm Data for given book and user.
 * @param1 bookID Book id.
 * @param2 userID User id of current user.
 * @param3 scormId Scorm id of scorm resource.
 * @return Returns scorm data.
 * @code
 * [dbManager fetchScormDataWithBookID:bookID forUser:userID forSCORMId:scormId];
 * @endcode
 */
-(NSString *)fetchScormDataWithBookID:(NSNumber *)bookID forUser:(NSNumber *)userID forSCORMId:(NSNumber *)scormId;
#pragma Protractor DB Calls
/*!
 * To persist protractor drawing.
 * @discussion This method is used when user wants to save protractor drawing permanently in the database for given book. Parameter `protractorVO` contains all the information about the protractor drawing eg. Color Code, protractor data etc.
 * @param1 protractorVO Oject of type SDKProtractorVO, to be persisted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager saveProtractor:protractorVO bookID:bookID userID:userID];
 * @endcode
 */
- (BOOL)saveProtractor:(SDKProtractorVO *)protractorVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To get persisted protractor drawings for provided Bookid and page ID.
 * @discussion This method is used to return all the saved protractor drawings of given page, for given book and user.
 * @param1 pageID An unique page Identifier.
 * @param2 displayNumber Page number eg. Eg I,II,III.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
 * @code
 * [dbManager protractorDrawingForPageID:pageID ForDisplayNumber:displayNumber bookID:bookID userID:userID];
 * @endcode
 * @return Returns persisted protractor drawings for provided Bookid and page ID.
 */
- (NSArray *)protractorDrawingForPageID:(NSString*)pageID ForDisplayNumber:(NSString*)displayNumber bookID:(NSNumber *)bookID userID:(NSNumber *)userID;

/*!
 * To delete Protractor Drawing.
 * @discussion When a Protractor Drawing to be deleted for given book and user.
 
 - If given protractorVO is available for book, method returns YES else NO. Parameter `protractorVO` contains all the information about protractor.
 * @param1 protractorVO Oject of type UGC, to be deleted.
 * @param1 bookID Book id for which UGC is created.
 * @param1 userID User who has created the UGC.
 * @code
 * [dbManager deleteProtractorDrawing:protractorVO bookID:bookID userID:userID];
 * @endcode
 * @return Returns A BOOL Value.
 */
- (BOOL)deleteProtractorDrawing:(UGC *)protractorVO bookID:(NSNumber *)bookID userID:(NSNumber *)userID;
/*!
*Returns the SDKFIBVO for Equation Editor
@param1 text equation editor text
@param1 link object of type KFLinkVO
@param1 userId User who has created the UGC
* @code
* [dbManager getEquationFIBObjectForText:text WithLink:link forUserId:userID];
* @endcode
*/
- (SDKFIBVO *)getEquationFIBObjectForText:(NSString*)text WithLink:(KFLinkVO *)link forUserId:(NSNumber *)userId;
/*!
* To Clear All unsubmitted FIBs on Page Number.
* @discussion This method is used to clear/delete  All unsubmitted FIBs,Dropdowns and EquationEditors  for given page Number, book and user.
* @param1 pageID  An unique page Identifier.
* @param2 displayNum  page display Number/folio Number.
* @param3 bookID Book id for which UGC is created.
* @param4 userID User who has created the UGC.
* @code
* [dbManager clearAllFIBsOnPageNumber:pageID withDisplayNumber:displayNum bookID:bookID andUserID:userID];
* @endcode
*/
-(void)clearAllFIBsOnPageNumber:(NSString*)pageID withDisplayNumber:(NSString*)displayNum bookID:(NSNumber*)bookID andUserID:(NSNumber *)userID;

/*!
* To Clear All FIBs on Page Number.
* @discussion This method is used to clear/delete  All unsubmitted FIBs,Dropdowns and EquationEditors  for given page Number, book and user.
* @param1 pageID  An unique page Identifier.
* @param2 displayNum  page display Number/folio Number.
* @param3 bookID Book id for which UGC is created.
* @param4 userID User who has created the UGC.
* @param5 isSubmitted Clear all for for all fibs or only for unsubmitted fibs.
* @code
* [dbManager clearAllFIBsOnPageNumber:pageID withDisplayNumber:displayNum bookID:bookID andUserID:userID withSubmitted:isSubmitted];
* @endcode
*/
-(void)clearAllFIBsOnPageNumber:(NSString*)pageID withDisplayNumber:(NSString*)displayNum bookID:(NSNumber*)bookID andUserID:(NSNumber *)userID withSubmitted:(BOOL)isSubmitted;

/*!
* Should be called to check whether unsubmitted FIBs Available on Page Number or not.
* @discussion Returns YES if unsubmitted FIBs Available on Page, NO if  unsubmitted FIBs not Available on Page.
 * @param1 pageID  An unique page Identifier.
 * @param2 displayNum  page display Number/folio Number.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
* @return A BOOL.
* @code
* [dbManager isUnsubmittedFIBsAvailableOnPageID:pageID withDisplayNumber:displayNum bookID:bookID andUserID:userID];
* @endcode
*/
-(BOOL)isUnsubmittedFIBsAvailableOnPageID:(NSString*)pageID withDisplayNumber:(NSString*)displayNum bookID:(NSNumber*)bookID andUserID:(NSNumber *)userID;

/*!
* Should be called to check whether unsubmitted FIBs Available on Page Number or not.
* @discussion Returns YES if unsubmitted FIBs Available on Page, NO if  unsubmitted FIBs not Available on Page.
 * @param1 pageID  An unique page Identifier.
 * @param2 displayNum  page display Number/folio Number.
 * @param3 bookID Book id for which UGC is created.
 * @param4 userID User who has created the UGC.
 * @param5 isSubmitted is FIBs Available for for all fibs or only for unsubmitted fibs.
* @return A BOOL.
* @code
* [dbManager isFIBsAvailableOnPageID:pageID withDisplayNumber:displayNum bookID:bookID andUserID:userID withSubmitted:isSubmitted];
* @endcode
*/
-(BOOL)isFIBsAvailableOnPageID:(NSString*)pageID withDisplayNumber:(NSString*)displayNum bookID:(NSNumber*)bookID andUserID:(NSNumber *)userID withSubmitted:(BOOL)isSubmitted;

-(NSDictionary*)getUnsynedUGCDictionaryForUserID:(NSNumber*)userID withBookID:(NSNumber *)bookId;

-(NSArray*)getDistinctBookIdsForUnsyncedUGCsForUserID:(NSNumber*)userID;
-(NSArray*)getDistinctBookIdsForUnsyncedTrackingDataForUserID:(NSNumber*)userID;
-(NSDictionary*)getUnsyncedCollabDataDictionaryForUserID:(NSNumber *)userID withBookID:(NSNumber *)bookId;

- (NSArray *)getDistinctScormIdsForUnsyncedScormForUserID:(NSNumber *)userID;
- (NSMutableArray *)fetchScormInfoWithScormID:(NSString *)scormID forUser:(NSNumber *)userID checkIfSynced:(BOOL)checkSynced;
- (NSNumber *)getBookIDForScormID:(NSString *)scormID;
- (void)updateScorm:(NSNumber *)bookID forSCORMId:(NSString *)scormId isSynced:(BOOL)isSynced;

/*!
 * Should be called to save the book metadata/additional details for given book and user.
 * @param1 metadata Book metadata/additional details.
 * @param2 bookID Book id.
 * @param3 userID User id who has created the BookSyncInfo.
 * @code
 * [dbManager saveBookMetadata:metadata ForBookID:bookID ForUserID:userID];
 * @endcode
 */
- (void)saveBookMetadata:(NSDictionary *)metadata ForBookID:(NSNumber *)bookID ForUserID:(NSNumber *)userID;

/*!
 * To get the book metadata/additional details.
 * @param1 bookID Book id.
 * @param2 userID User id who has created the BookSyncInfo.
 * @return NSDictionary of book metadata.
 * @code
 * [dbManager getBookMetadataForbookID:bookID ForUserID:userID];
 * @endcode
 */
- (NSDictionary *)getBookMetadataForbookID:(NSNumber *)bookID ForUserID:(NSNumber *)userID;

/*!
 * To get the unsynced book metadata/additional details.
 * @param1 userID User id who has created the BookSyncInfo.
 * @return NSDictionary of unsynced book metadata.
 * @code
 * [dbManager getUnsyncedFurthestPageDataDictionaryForUserID:userID];
 * @endcode
 */
- (NSDictionary *)getUnsyncedFurthestPageDataDictionaryForUserID:(NSNumber *)userID;

/*!
 * To get the distinct book IDs for  unsynced book metadata/additional details.
 * @param1 userID User id who has created the BookSyncInfo.
 * @return NSArray of didtinct book IDs for  unsynced book metadata.
 * @code
 * [dbManager getBookIdsForUnsyncedFurthestPageDataForUserID:userID];
 * @endcode
 */
-(NSArray*)getBookIdsForUnsyncedFurthestPageDataForUserID:(NSNumber*)userID;

/*!
 * To update isSynced property of particular bookID .
 * @param1 bookID Book id.
 * @param2 userID User id who has created the BookSyncInfo.
 * @param3 isSynced Int value 0/1.
 * @code
 * [dbManager updateIsSyncedFurtherPageForBookID:bookID ForUserID:userID isSynced:isSynced];
 * @endcode
 */
-(void)updateIsSyncedFurtherPageForBookID:(NSNumber *)bookID ForUserID:(NSNumber *)userID isSynced:(int)isSynced WithTimeStamp:(NSString*)timeStamp;

/*!
 * Should be called to save the Reader Font Settings for given book and user in book meatadata.
 * @param1 fontSetting reader font settings.
 * @param2 bookID Book id.
 * @param3 userID User id who has created the BookSyncInfo.
 * @code
 * [dbManager saveReaderFontSetting:fontSetting ForBookID:bookID ForUserID:userID];
 * @endcode
 */
- (void)saveReaderFontSetting:(ReaderFontSetting *)fontSetting ForBookID:(NSNumber *)bookID ForUserID:(NSNumber *)userID;

/*!
 * To get the Reader Font Settings from book metadata.
 * @param1 bookID Book id.
 * @param2 userID User id who has created the BookSyncInfo.
 * @return ReaderFontSetting reader font settings.
 * @code
 * [dbManager getReaderFontSettingForBookID:bookID ForUserID:userID];
 * @endcode
 */
- (ReaderFontSetting *)getReaderFontSettingForBookID:(NSNumber *)bookID ForUserID:(NSNumber *)userID;
@end
