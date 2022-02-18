//
//  KitabooDataSyncingManager.h
//  KItabooSDK
//
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

/*!
 * @protocol KitabooDataSyncingManagerDelegate
 * @brief The delegate of a KitabooDataSyncingManager object must adopt the KitabooDataSyncingManagerDelegate protocol.
 * @discussion KitabooDataSyncingManagerDelegate Protocol used to handle all the callbacks of KitabooDataSyncingManager Class.The KitabooDataSyncingManagerDelegate protocol defines methods that allow user to perform actions when data is saved, fetched or synchronized successfully. The methods of this protocol are all optional.
 */
@protocol KitabooDataSyncingManagerDelegate <NSObject>
@optional
/*!
 * Will be called when Fetch UGC request is succeeded.
 * @discussion This is a delegate method used when Fetch UGC request execute successfully.
 */
-(void)didFetchedUGCSuccessfully;

/*!
 * Will be called when Fetch UGC request is failed.
 * @discussion This is a delegate method used when Fetch UGC request failed with error.
 * @param1 error Is the Fetch UGC fail error of type NSError.
 */
-(void)didFailedToFetchUGCWithError:(NSError*)error;

/*!
 * Will be called when Save UGC request is succeeded.
 * @discussion This is a delegate method used when Save UGC request execute successfully.
 */
-(void)didSavedUGCSuccessfully;

/*!
 * Will be called when Save UGC request is failed.
 * @discussion This is a delegate method used when Save UGC request failed with error.
 * @param1 error Is the Save UGC fail error of type NSError.
 */
-(void)didFailedToSaveUGCWithError:(NSError*)error;

/*!
 * Will be called wehn Sync UGC request execute successfully.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, saveUGCDataOperation, saveCollabData, fetchcollabUGC etc.
 */
-(void)didUGCSynchCompletedSuccessfully;

/*!
 * Will be called when UGC Sync request is failed.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, saveUGCDataOperation, saveCollabData, fetchcollabUGC etc.
 * @param1 error Is the UGC Sync fail error of type NSError.
 */
-(void)didUGCSynchFailedWithError:(NSError*)error;


/*!
 * Will be called when save teacher annotation request is succeeded.
 * @discussion Save Teacher Annotation is a process when teacher wants to save student's data with his/her reviews.
 
  - This is a delegate method used when save Teacher annotation request execute successfully.
 */
-(void)didSavedStudentAnotationSuccessfully;

/*!
 * Will be called when save student annotation request is failed.
 * @discussion Save Teacher Annotation is a process when teacher wants to save student's data with his/her reviews.
 
 - This is a delegate method used when save student annotation request failed with error.
 * @param1 error Is the save student annotation fail error of type NSError.
 */
-(void)didFailedToSaveStudentAnotationWithError:(NSError*)error;

/*!
 * Will be called when save student annotation request is succeeded.
 * @discussion Save Student Annotation is a process when student wants to save his/her data to teacher.
 
 - This is a delegate method used when save student annotation request execute successfully.
 */
-(void)didSubmitedAnotationSuccessfully;

/*!
 * Will be called when save student annotation request is failed.
 * @discussion Save Student Annotation is a process when student wants to save his/her data to teacher.
 
 - This is a delegate method used when save student annotation request failed with error.
 * @param1 error Is the save student annotation fail error of type NSError.
 */
-(void)didFailedToSubmitAnotationWithError:(NSError*)error;

/*!
 * Will be called when save scrom request is succeeded.
 */
-(void)didSavedScormDataSuccessfully;

/*!
 * Will be called when save scrom request is succeeded.
 * @param1 bookID is the book id for which save scorm is successfull
 * @param2 classID is the class id for which save scorm is successfull
 */
-(void)didSavedScormDataSuccessfullyWithBookID:(NSNumber *)bookID withScormID:(NSString *)scormID withClassID:(NSString *)classID;

/*!
 * Will be called when save scorm request is failed.
 * @param1 error Is the scorm request fail error of type NSError.
 */
-(void)didFailedToSaveScormWithError:(NSError*)error;

/*!
* Will be called when save scorm request is failed.
* @param1 error Is the scorm request fail error of type NSError.
* @param2 bookID is the book id for which save scorm is failed
* @param3 classID is the class id for which save scorm is failed
*/
-(void)didFailedToSaveScormWithError:(NSError*)error withBookID:(NSNumber *)bookID withScormID:(NSString *)scormID withClassID:(NSString *)classID;

/*!
 * Will be called when fetch scrom request is succeeded.
 */
-(void)didFetchScormDataSuccessfully;

/*!
 * Will be called when fetch scorm data request is failed.
 * @param1 error Is the Fetch request fail error of type NSError.
 */
-(void)didFailedToFetchScormWithError:(NSError*)error;

/*!
 * Will be called when UGC Sync request is succeeded for given userID and bookID.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, saveUGCDataOperation, saveCollabData, fetchcollabUGC etc.
 * @param1 userID UserID for which synch succeeded.
 * @param2 bookID BookID for which synch succeeded.
 */
-(void)didUGCSynchCompletedSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 * Will be called when UGC Sync request is failed for given userID and bookID.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, saveUGCDataOperation, saveCollabData, fetchcollabUGC etc.
 *@param1 error Is the synch UGC request fail error of type NSError.
 *@param2 userID UserID for which synch failed.
 *@param3 bookID BookID for which synch failed.
 */
-(void)didUGCSynchFailedWithError:(NSError*)error withUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 Will be called when UGC save request is succeeded for given userID and bookID.

 *@param1 userID userID for which save succeeded.
 *@param2 bookID bookID for which save succeeded.
 */
-(void)didUGCSaveCompletedSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
Will be called when UGC save request is succeeded for given userID and bookID with filtered partial ugc.

*@param1 userID userID for which save succeeded.
*@param2 bookID bookID for which save succeeded.
*/
-(void)didPartialUGCSaveCompletedSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 Will be called when UGC save request is failed for given userID and bookID.

 *@param1 error Is the save UGC request fail error of type NSError.
 *@param2 userID userID for which save failed
 *@param3 bookID bookID for which save failed
 */
-(void)didUGCSaveFailedWithError:(NSError*)error withUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
Will be called when UGC save request is failed for given userID and bookID with filtered partial ugc.

*@param1 error Is the save UGC request fail error of type NSError.
*@param2 userID userID for which save failed
*@param3 bookID bookID for which save failed
*/
-(void)didPartialUGCSaveFailedWithError:(NSError*)error withUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 Will be called when UGC fetch request is succeeded for given userID and bookID.
 *@discussion Fetch UGC Operation is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in Fetch UGC Operation, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, fetchcollabUGC etc.
 *@param1 userID userID for which fetch succeeded.
 *@param2 bookID bookID for which fetch succeeded.
 */
-(void)didUGCFetchCompletedSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 Will be called when UGC fetch request is failed for given userID and bookID.
 *@discussion Fetch UGC Operation is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in Fetch UGC Operation, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, fetchcollabUGC etc.
 *@param1 error error Is the save UGC request fail error of type NSError.
 *@param2 userID userID for which fetch failed.
 *@param3 bookID bookID for which fetch failed.
 */
-(void)didUGCFetchFailedWithError:(NSError*)error withUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 * Will be called when save highlight request is succeeded.
 * @discussion This method is used for Shared/Received Highlights. When user wants to save shared highlight list and received highlight list, he/she will use this method.
 
 - This is a delegate method used when save highlight request execute successfully.
 */
- (void)didSaveHighlightDataSuccessfully;

/*!
 * Will be called when save highlight request is failed.
 * @param1 error Is the save highlight request fail error of type NSError.
 */
- (void)didSaveHighlightDataFailedWithError:(NSError *)error;

/*!
 * Will be called when save highlight request is failed.
 * @param1 error Is the save highlight request fail error of type NSError.
 * @param2 shareAndRecieveDict Is an object of type NSDictionary with highlight lists shareList and receiveList.
 * @param2 bookID BookId of the current book.
 */
- (void)didSaveHighlightDataFailedWithError:(NSError *)error withShareAndRecieveDict:(NSDictionary*)shareAndRecieveDict ForBookID:(NSNumber*)bookID;

/*!
 * Will be called when save tracking request is succeeded.
 * @discussion This method is called when user wants to save tracked data(for example Highlight created, Note shared, User close the book etc.) for particular given book ID. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
 
 - This is a delegate method used when save tracking request execute successfully.
 */
- (void)didSaveTrackingDataSuccessfully;

/*!
* Will be called when save tracking request is succeeded.
- This is a delegate method used when save tracking request execute successfully.
* @param1 userID Is the user id for that save tracking request succeeded.
* @param2 bookID Is the book id for that save tracking request succeeded.
*/
-(void)didSaveTrackingDataSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;
/*!
 * Will be called when save tracking request is failed.
 * @param1 error Is the save tracking request fail error of type NSError.
 */
- (void)didSaveTrackingDataFailedWithError:(NSError *)error;

/*!
 * Will be called when save tracking request is failed.
 * @param1 error Is the save tracking request fail error of type NSError.
 * @param2 bookID Is the book id for that save tracking request failed.
 * @param3 userID Is the user id for that save tracking request failed.
 */
- (void)didSaveTrackingDataFailedWithError:(NSError *)error ForBookID:(NSNumber*)bookID ForUserId:(NSNumber *)userID;

/*!
 * Will be called when AcceptOrReject request is succeeded.
 * @discussion This Method is used for acceptance and rejection of collab (Note). Parameter `accepted` decides, whether the note will be accepted by the user or rejected by the user. Parameter `ugcID` is the that specific shared UGC (Collab/Note) which will be accepted or rejected.
 
 - This is a delegate method used when AcceptOrReject request execute successfully.
 */
- (void)didAcceptOrRejectDataSuccessfully;

/*!
 * Will be called when AcceptOrReject request is succeeded.
 * @discussion This Method is used for acceptance and rejection of collab (Note). Parameter `accepted` decides, whether the note will be accepted by the user or rejected by the user. Parameter `ugcID` is the that specific shared UGC (Collab/Note) which will be accepted or rejected.
 * @param1 ugcID Is the that specific UGC (Collab/Note).
 * @param2 accepted Is the boolean which is YES for acceptance and NO for rejection.
 - This is a delegate method used when AcceptOrReject request execute successfully.
 */
- (void)didAcceptOrRejectDataSuccessfullywithUGCId:(NSString *)ugcID andIsAccepted:(BOOL)accepted;

/*!
 * Will be called when AcceptOrReject request is failed.
 * @param1 error Is the AcceptOrReject request fail error of type NSError.
 */
- (void)didAcceptOrRejectDataFailedWithError:(NSError *)error;

/*!
 * Will be called when AcceptOrReject request is failed.
 * @param1 error Is the AcceptOrReject request fail error of type NSError.
 * @param2 ugcID Is the that specific UGC (Collab/Note).
 * @param3 accepted Is the boolean which is YES for acceptance and NO for rejection.
 */
- (void)didAcceptOrRejectDataFailedWithError:(NSError *)error withUGCId:(NSString *)ugcID andIsAccepted:(BOOL)accepted;

/*!
 * Will be called when save collab request is succeeded.
 * @discussion This method is used for Shared Notes (Collab Data). When user wants to save collab Data for book, he/she will use this method. Data will be fetched from local storage and saved on server.[For Managing Local Storage, it use HSDBManager].
 
 - This is a delegate method used when save collab request execute successfully.
 */
- (void)didSaveCollabDataSuccessfully;

/*!
 * Will be called when save collab request is failed.
 * @param1 error Is the save collab request fail error of type NSError.
 */
- (void)didSaveCollabDataFailedWithError:(NSError *)error;

/*!
 * Will be called when save collab request is failed.
 * @param1 error Is the save collab request fail error of type NSError.
 * @param2 bookID Is the book id for that save collab request failed.
 * @param2 userID Is the user id for that save collab request failed.
 */
- (void)didSaveCollabDataFailedWithError:(NSError *)error ForBookID:(NSNumber*)bookID ForUserId:(NSNumber *)userID;

/*!
* Will be called when save collab request is succeeded for filtered partial save collab data.
* @param2 bookID Is the book id for that save collab request failed.
* @param2 userID Is the user id for that save collab request failed.
*/
- (void)didSavePartialCollabDataSuccessfullyWithUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
* Will be called when save collab request is failed for filtered partial save collab data.
* @param1 error Is the save collab request fail error of type NSError.
* @param2 userID Is the user id for that save collab request failed.
* @param3 bookID Is the book id for that save collab request failed.
*/
- (void)didSavePartialCollabDataFailedWithError:(NSError*)error withUserID:(NSString*)userID withBookID:(NSString*)bookID;

/*!
 * Will be called when fetch furthest page data request is succeeded.
 * @param1 bookID Is the bookId for which furthest page data has been fetched.
 * @param2 furthestPageData Is the fetched furthestPageData.
 */
-(void)didFetchFurthestPageDataSuccessfullyForBookID:(NSNumber*)bookID WithFurthestPageData:(NSString*)furthestPageData;

/*!
 * Will be called when fetch furthest page data request is failed.
 * @param1 error Is the Fetch request fail error of type NSError.
 * @param2 bookID Is the bookId for which fetch furthest page data has been failed.

 */
-(void)didFailedToFetchFurthestPageDataWithError:(NSError*)error ForBookID:(NSNumber*)bookID;

/*!
 * Will be called when save furthest page data request is succeeded.
 *  @param1 bookID Is the bookId for which furthest page data has been saved.
 */
-(void)didSaveFurthestPageDataSuccessfully:(NSNumber*)bookID;

/*!
 * Will be called when save furthest page data request is failed.
 * @param1 error Is the Fetch request fail error of type NSError.
 * @param2 bookID Is the bookId for which save furthest page data has been failed.
 */
-(void)didFailedToSaveFurthestPageDataWithError:(NSError*)error ForBookID:(NSNumber*)bookID;

@end

/** An Object that will be responsible for Data Syncing.
 * @discussion KitabooDataSyncingManager is a manager class which is used to handle all the synchronization of data. It behaves like an intermediate class between local database and server, such as in case of fetch UGC, data is fetched from server and saved in database and in case of save UGC, data is fetched from database and saved on server.
 * @superclass SuperClass : NSObject
 */
@interface KitabooDataSyncingManager : NSObject

/** An Object that will be used to set Micro Services Base URL.
 *  SuperClass : NSString
 */
@property (nonatomic, strong) NSString *microServicesBaseURLString;

/*!
 * To Initialte KitabooDataSyncingManager class.
 * @param1 baseURLString Is the base URL String Path.
 * @param2 clientID ClientID.
 * @code
 * [kitabooDataSyncingManager initWithBaseURLString:baseURLString clientID:clientID];
 * @endcode
 * @discussion Initializes and returns a newly allocated object with specified Base URL and clientID.
 */
- (instancetype)initWithBaseURLString:(NSString*)baseURLString clientID:(NSString*)clientID;

/*!
 * Should be called when user wants to fetch UGC for book.
 * @discussion This method is used when user wants to fetch UGC for a book for given bookId, userId , userToken and delegate of type KitabooDataSyncingManagerDelegate. Data will be fetched from server and saved into local storage.[For Managing Local Storage, it use HSDBManager].
 * @param1 bookID Is the bookID of the current book.
 * @param2 userID Is the userId for the current loggedin user.
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param4 userToken Is userToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager fetchUGCForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)fetchUGCForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;

/*!
 * Should be called when user save the shareList & receiveList for highlight.
 * @discussion This method is used for Shared/Received Highlights. When user wants to save shared highlight list and received highlight list, he/she will use this method.
 
 - Parameter `ShareAndRecieveDict` contains all the highlights to be saved either shared or recevied, or both the type.
 * @param1 ShareAndRecieveDict Is an object of type NSDictionary with highlight lists shareList and receiveList.
 * @param2 bookID BookId of the current book.
 * @param3 userToken UserToekn for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveHighlightData:ShareAndRecieveDict ForBookID:bookID ForUserToken:userToken];
 * @endcode
 */
-(void)saveHighlightData:(NSDictionary*)ShareAndRecieveDict ForBookID:(NSNumber*)bookID ForUserToken:(NSString*)userToken;

/*!
 * Should be called when user save the shareList for note.
 * @discussion This method is used for Shared Notes (Collab Data). When user wants to save collab Data for book, he/she will use this method. Data will be fetched from local storage and saved on server.[For Managing Local Storage, it use HSDBManager].
 * @param1 bookID BookID of the current book.
 * @param2 userToken UserToken of the current loggedin user.
 * @param3 userID UserToken of the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveCollabDataForBookID:bookID ForUserToken:userToken ForUserId:userID];
 * @endcode
 */
-(void)saveCollabDataForBookID:(NSNumber*)bookID ForUserToken:(NSString*)userToken ForUserId:(NSNumber *)userID;

/*!
 * Should be called when user accept/reject the shared collab data.
 * @discussion This Method is used for acceptance and rejection of collab (Note). Parameter `accepted` decides, whether the note will be accepted by the user or rejected by the user. Parameter `ugcID` is the that specific shared UGC (Collab/Note) which will be accepted or rejected.
 * @param1 ugcID Is the that specific UGC (Collab/Note).
 * @param2 accepted Is the boolean which is YES for acceptance and NO for rejection.
 * @param3 userToken UserToken of the current loggedin user.
 * @code
 * [kitabooDataSyncingManager acceptOrRejectCollab:ugcID andIsAccepted:accepted ForUserToken:userToken];
 * @endcode
 */
- (void)acceptOrRejectCollab:(NSString *)ugcID andIsAccepted:(BOOL)accepted ForUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to save UGC for user.
 * @discussion This method is used to save the UGC data (highlights and notes) for given user and delegate of type KitabooDataSyncingManagerDelegate. Data will be fetched from local storage and saved on server.[For Managing Local Storage, it use HSDBManager]
 * @param1 userID UserID of the current loggedin user.
 * @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param3 userToken UserToken of the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveUGCForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)saveUGCForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;

/*!
 * Should be called when user wants to synch UGC for Book, for given bookId and user Id.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
    - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, saveUGCDataOperation, saveCollabData, fetchcollabUGC etc.
 * @param1 bookID BookID for the current loggedin user.
 * @param1 userID for the current loggedin user.
 * @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param2 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager synchUGCForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)synchUGCForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;

/*!
 * Should be called when user wants to synch UGC for book, for given bookId and user Id.
 * @discussion UGC Sync is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in UGC Sync, fetchBookClassInfo, fetchUGC, fetchTeacherAnnotations, fetchCollabShare, saveUGC, saveCollab, fetchcollabUGC.
 
 - Parameter `isUGCSharingEnabled` has a BOOL value which is related to Collab Sharing APLs. If it has YES value all Collab sharing APIs will be executed. In case of NO Collab sharing APIs will not be called.
 * @param1 bookID Book ID for the current loggedin user.
 * @param2 userID User ID for the current loggedin user
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param3 userToken User Token for the current loggedin user
 * @param4 isUGCSharingEnabled Boolean value to check whether ugc sharing enabled or not
 * @code
 * [kitabooDataSyncingManager synchUGCForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken withUGCSharingEnabled:YES];
 * @endcode
 */
-(void)synchUGCForBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken withUGCSharingEnabled:(BOOL)isUGCSharingEnabled;

/*!
 * Should be called to  save Teacher annotation.
 * @discussion Teacher Annotation is the process to submmiting student's pen tool data with his/her reviews. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
 
 - Parameter `annotationArray` contains all the teacher annotations, to be saved and `learnerId`  is the Id of that learner who created all the pen tool data.
 * @param1 annotationArray Contains all the teacher annotation.
 * @param2 learnerId LearnerId of the current learner.
 * @param3 bookId BookId of the current book.
 * @param4 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param5 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveTeacherAnnotationsForAnnotation:annotationArray forLearnerID:learnerId withBookID:bookId WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)saveTeacherAnnotationsForAnnotation:(NSArray*)annotationArray forLearnerID:(NSString*)learnerId withBookID:(NSNumber*)bookId WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;


/*!
 * Should be called to submit Student annotation for given Book and user.
 * @discussion Student Annotation is the process to submmiting student's pen tool data to teacher. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
 * @param1 bookID of the current book
 * @param2 userID for the current loggedin user
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param3 userToken for the current loggedin user
 * @code
 * [kitabooDataSyncingManager submitAnotationForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)submitAnotationForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to save Tracking Data for Book.
 * @discussion This method is called when user wants to save tracked data(for example Highlight created, Note shared, User close the book etc.) for particular given book ID. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
 * @param1 bookID Book ID of the current book.
 * @param2 userToken UserToken for the current loggedin user
 * @param3 userID UserId for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveTrackingDataForBookID:bookID ForUserToken:userToken ForUserId:userID];
 * @endcode
 */
- (void)saveTrackingDataForBookID:(NSNumber*)bookID ForUserToken:(NSString*)userToken ForUserId:(NSNumber *)userID;

/*!
* Should be called when user wants to save Tracking Data for Book.
* @discussion This method is called when user wants to save tracked data(for example Highlight created, Note shared, User close the book etc.) for particular given book ID. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
* @param1 bookID Book ID of the current book.
* @param2 userToken UserToken for the current loggedin user
* @param3 userID UserId for the current loggedin user.
* @param4 timeSpendLimit Minimum time spend limit for the data tracking in millisecond.
* @code
* [kitabooDataSyncingManager saveTrackingDataForBookID:bookID ForUserToken:userToken ForUserId:userID];
* @endcode
*/
- (void)saveTrackingDataForBookID:(NSNumber*)bookID ForUserToken:(NSString*)userToken ForUserId:(NSNumber *)userID WithMinimumTimeSpend:(int)timeSpendLimit;

/*!
 * Should be called when scorm data will be saved for perticular user and book.
 * @discussion Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
 * @param1 userID UserId for the current loggedin user.
 * @param2 bookID BookID of the current book.
 * @param3 classId ClassId for the current loggedin user.
 * @param4 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param5 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveSormDataForUserID:userID bookID:bookID andClassId:classId WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)saveSormDataForUserID:(NSNumber*)userID bookID:(NSNumber *)bookID andClassId:(NSString *)classId WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to fetch Scorm data from Server.
 * @discussion Data will be fetched from Server and saved on local storage. [For Managing Local Storage, it use HSDBManager].
 * @param1 userID for the current loggedin user
 * @param2 bookID of the current book
 * @param3 classId for the current loggedin user
 * @param4 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param5 userToken for the current loggedin user
 * @code
 * [kitabooDataSyncingManager fetchAndSaveSormDataForUserID:userID bookID:bookID andClassId:classId WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)fetchAndSaveSormDataForUserID:(NSNumber*)userID bookID:(NSNumber *)bookID andClassId:(NSString *)classId WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to save UGC Operation for given bookId and user Id.
 * @discussion Save UGC Operation is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in Save UGC Operation, saveUGCDataOperation, saveCollabData.
 
 * @param1 bookID BookID for the current loggedin user.
 * @param2 userID for the current loggedin user.
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param4 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager saveUGCOperationForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)saveUGCOperationForBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to save UGC Operation with meta data for given bookId and user Id.
 * @discussion Save UGC Operation is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in Save UGC Operation, saveUGCDataOperation, saveCollabData.
 
 * @param1 bookID BookID for the current loggedin user.
 * @param2 userID for the current loggedin user.
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param4 userToken UserToken for the current loggedin user.
 * @param5 metaData Meta Data.
 * @code
 * [kitabooDataSyncingManager saveUGCOperationForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken WithMetaData:metaData];
 * @endcode
 */
-(void)saveUGCOperationForBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken WithMetaData:(KitabooServiceMetaData *)metaData;

/*!
* Should be called when user wants to save UGC with pagination format with meta data for given bookId and user Id.
* @discussion Save UGC Operation is a Process to sync the unsynced ugc data to server and update the status in local storage. [For Managing Local Storage, it use HSDBManager].

- APIs which are used in this method are saveUGC, saveCollabData.

* @param1 bookID BookID for the current loggedin user.
* @param2 userID for the current loggedin user.
* @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param4 userToken UserToken for the current loggedin user.
* @param5 metaData Meta Data.
* @param6 isPagination is the option to sync all save ugc data or to sync save ugc data with pagination.
* @param7 isForUser is the optio to sync data for user or perticular book.
* @param8 isForSubmitAnotation is the option to sync ugc data with submit annotation.
* @code
* [kitabooDataSyncingManager saveUGCOperationForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken WithMetaData:metaData WithPagination:isPagination ForUser:isForUser ForSubmitAnotation:isForSubmitAnotation];
* @endcode
*/
-(void)saveUGCOperationForBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken WithMetaData:(KitabooServiceMetaData *)metaData WithPagination:(BOOL)isPagination ForUser:(BOOL)isForUser ForSubmitAnotation:(BOOL)isForSubmitAnotation;

/*!
 * Should be called when user wants to fetch UGC Operation for given bookId and user Id.
 * @discussion Fetch UGC Operation is a Process which uses combination of API Mentioned below to fetch UGC Data from server and Save to Local storage, and Vice versa. [For Managing Local Storage, it use HSDBManager].
 
 - APIs which are used in Fetch UGC Operation, fetchBookClassInfo, fetchUGCOperation, fetchTeacherAnnotations, fetchCollabShare, fetchcollabUGC .
 * @param1 bookID BookID for the current loggedin user.
 * @param1 userID for the current loggedin user.
 * @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param2 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager fetchUGCOperationForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)fetchUGCOperationForBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
* Should be called when user wants to save unsynced UGC Data for book with meta data for given bookId and user Id.
* @discussion Save UGC Operation is a Process to sync the unsynced ugc data to server and update the status in local storage. [For Managing Local Storage, it use HSDBManager].

- APIs which are used in this method are saveUGC, saveCollabData.

* @param1 bookID BookID for the current loggedin user.
* @param2 userID for the current loggedin user.
* @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param4 userToken UserToken for the current loggedin user.
* @param5 metaData Meta Data.
* @code
* [kitabooDataSyncingManager saveUGCOperationPerBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken WithMetaData:metaData];
* @endcode
*/
-(void)saveUGCOperationPerBookID:(NSNumber *)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken WithMetaData:(KitabooServiceMetaData *)metaData;

/*!
* Should be called when user wants to save Tracking Data for Book.
* @discussion This method is called when user wants to save tracked data(for example Highlight created, Note shared, User close the book etc.) for particular given book ID. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
* @param1 bookID Book ID of the current book.
* @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param3 userToken UserToken for the current loggedin user
* @param4 userID UserId for the current loggedin user.
* @code
* [kitabooDataSyncingManager saveTrackingDataPerBookID:bookID WithDelegate:delegate ForUserToken:userToken ForUserId:userID];
* @endcode
*/
- (void)saveTrackingDataPerBookID:(NSNumber*)bookID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate ForUserToken:(NSString*)userToken ForUserId:(NSNumber *)userID ;

/*!
* Should be called when user wants to save Tracking Data for Book.
* @discussion This method is called when user wants to save tracked data(for example Highlight created, Note shared, User close the book etc.) for particular given book ID. Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
* @param1 bookID Book ID of the current book.
* @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param3 userToken UserToken for the current loggedin user
* @param4 userID UserId for the current loggedin user.
* @param5 timeSpendLimit Minimum time spend limit for the data tracking in millisecond.
* @code
* [kitabooDataSyncingManager saveTrackingDataPerBookID:bookID WithDelegate:delegate ForUserToken:userToken ForUserId:userID];
* @endcode
*/
- (void)saveTrackingDataPerBookID:(NSNumber*)bookID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate ForUserToken:(NSString*)userToken ForUserId:(NSNumber *)userID WithMinimumTimeSpend:(int)timeSpendLimit;


/*!
* Should be called when scorm data will be saved for perticular user and scorm.
* @discussion Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
* @param1 userID UserId for the current loggedin user.
* @param2 scormID scormID of the current scorm.
* @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param4 userToken UserToken for the current loggedin user.
* @code
* [kitabooDataSyncingManager saveScormDataWithScormID:scormID forUserID:userID WithDelegate:delegate WithUserToken:userToken];
* @endcode
*/
-(void)saveScormDataWithScormID:(NSString *)scormID forUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString *)userToken;

/*!
 * Should be called when user wants to fetch Furthest Page Data  for given bookId and user Id.
 * @param1 bookID BookID for the current loggedin user.
 * @param2 userID for the current loggedin user.
 * @param3 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
 * @param4 userToken UserToken for the current loggedin user.
 * @code
 * [kitabooDataSyncingManager fetchFurthestPageDataForBookID:bookID ForUserID:userID WithDelegate:delegate WithUserToken:userToken];
 * @endcode
 */
-(void)fetchFurthestPageDataForBookID:(NSNumber*)bookID ForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;

/*!
* Should be called when furthest page data will be saved for particular user.
* @discussion Data will be fetched from local storage and saved on server. [For Managing Local Storage, it use HSDBManager].
* @param1 userID UserId for the current loggedin user.
* @param2 delegate Callback listener of type KitabooDataSyncingManagerDelegate.
* @param3 userToken UserToken for the current loggedin user.
* @code
* [kitabooDataSyncingManager saveFurthestPageDataForUserID:userID WithDelegate:delegate WithUserToken:userToken];
* @endcode
*/
-(void)saveFurthestPageDataForUserID:(NSNumber*)userID WithDelegate:(id<KitabooDataSyncingManagerDelegate>)delegate WithUserToken:(NSString*)userToken;
@end
