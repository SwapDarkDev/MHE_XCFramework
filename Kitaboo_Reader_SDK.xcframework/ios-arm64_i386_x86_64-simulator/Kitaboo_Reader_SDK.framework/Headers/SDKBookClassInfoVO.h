//
//  ClassInformation.h
//  Kitaboo
//
//  Copyright (c) 2014 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>

/** An Object that will be responsible for Data of Book.
 * @discussion As the name suggests, SDKBookClassInfoVO class contains all the data information about a book. For exampple Book title of the book, how many instructors and learners available for the book, total number of pages in the book etc.
 * @superclass SuperClass : NSObject
 */
@interface SDKBookClassInfoVO : NSObject

@property (nonatomic, copy) NSNumber *bookGuid;
@property (nonatomic, copy) NSString *bookIsbn;
@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSNumber *classId;
@property (nonatomic, copy) NSString *classTitle;
@property (nonatomic, retain) NSArray *instructors;
@property (nonatomic, retain) NSArray *learners;
@property (nonatomic, retain) NSArray *receiveList;
@property (nonatomic, retain) NSArray *shareList;
@property (nonatomic, retain) NSArray *sharingSetting;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSNumber *totalPages;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSNumber *roleID;
@property (nonatomic, strong) NSDictionary *classParticipants;
@property (assign, nonatomic)BOOL isSelected;
@property (nonatomic, strong)NSArray *sharedStudents;
@property (nonatomic, strong)NSArray *sharedInstructors;

/*!
 *shareNoteConfiguration is an object of BookClassSharingConfiguration class, which is used to check the Configuration of a note, whether it is shareable or Not.
 */
@property (strong, nonatomic) BookClassSharingConfiguration * shareNoteConfiguration;

/*!
 *shareHighlightConfiguration is an object of BookClassSharingConfiguration class, which is used to check the Configuration of a highlight, whether it is shareable or Not.
 */
@property (strong, nonatomic) BookClassSharingConfiguration * shareHighlightConfiguration;


/*!
 * Should be called to initialise the SDKBookClassInfoVO
 * @discussion Initializes and returns a newly allocated object with specified book Class Info Dictionary which contains all the book class Information with specified index. Index value is an integer value for accessing object/value at index position.
 * @param1 bookClassInfoDic Is the dictionary which contains all the book class Information
 * @param2 index Is integer value for accessing object/value at index position.
 * @code
 * [sdkBookClassInfoVO initWithDictonary:bookClassInfoDic andWithIndex:index];
 * @endcode
 */
- (id)initWithDictonary:(NSDictionary*)bookClassInfoDic andWithIndex:(int)index withUserID:(NSNumber *)userID;

/*!
 * To get the dictionary of Users.
 * @discussion This method returns dictionary of Users where user can be a student or a teacher or both. Parameter `userList` contains A list of all the users from which user can get all the students except current user and can get all teachers except current user. Index value is an integer value for accessing object/value at index position.
 * @param1 userList Contains A list of all the users
 * @param2 userID User id where user is loggedin.
 * @param2 index Is integer value for accessing object/value at index position.
 * @return Returns the dictionary of Users.
 * @code
 * [sdkBookClassInfoVO getUserListArray:userList forUser:userID andWithIndex:index];
 * @endcode
 */
- (NSDictionary *)getUserListArray:(NSArray *)userList forUser:(NSNumber *)userID andWithIndex:(NSInteger)index;

/*!
 * To get the dictionary of Users.
 * @param1 sharingSettingss Is the dictionary of share settings list.
 * @return Returns the dictionary of Users.
 */
- (NSDictionary *)getSharingSettings:(NSDictionary *)sharingSettingss;

/*!
 * Should be called when user deselect the from the list of ShareSettings.
 */
- (void)deSelect;
@end
