//
//  KitabooBookVO.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An Object that manage a Content of a book, We never initialize this class, but use KFBookVO (For Kitaboo Fixed Type of Book) and EPubBookV0(For Epub Type of Books)
 @discussion The KitabooBookVO class is responsible for management of a book data such as, table of content, resources and thumbnail Data .
 @superclass SuperClass : NSObject
 */
@interface KitabooBookVO : NSObject
@property (nonatomic)NSInteger bookID;

/*!
 Book content to be shown on TOC
 @return object of NSArray which has book content for toc.
 @discussion This method returns toc Data where every toc element has the same level. There is no Parent Child Relationship between elements.
 */
- (NSArray *)getBookContentForTOC;

/*!
 Book Resources to be shown on TOC.
 @return object of NSArray which has book Resources for toc.
 @discussion This method returns Resources Data where every Resource element has the same level. There is no Parent Child Relationship between elements.
 */
- (NSArray *)getBookResourcesForTOC;

/*!
 Book Resources with Subnodes to be shown on TOC.
 @return object of NSArray which has book Resources for toc.
 @discussion This method returns Resources for toc with their subnodes. There can be a Parent child relationship between Resource elememts where every resource either has subnodes or no subnodes.
 */
- (NSArray *)getBookResourcesForTOCWithSubnodes;
/*!
 Book content subnodes to be shown on TOC
 @return object of NSArray which has book content for toc.
 @discussion This method returns Content for toc with their subnodes. There can be a Parent child relationship between Content elememts where every Content Element either has subnodes or no subnodes.
 */
- (NSArray *)getBookContentForTOCSubnodes;

/*!
 Data to be shown on Thumbnail.
 @return object of NSArray which has all the data of thumbnail.
 */
- (NSArray*)getThumbnailData;

/*!
 Book Resources with Subnodes to be shown on TOR.
 @return object of NSArray which has book Resources for tor.
 @discussion This method returns Resources for tor with their subnodes. There can be a Parent child relationship between Resource elememts where every resource either has subnodes or no subnodes.
 */
- (NSArray*)getBookResourcesForTORSubnodes;

/*!
 Book Resources with Subnodes to be shown on TOR.
 @param1 role string value which specify role of user (teacher/student)
 @param2 standardType string value which specify type of standards(TEKS/ELPS)
 @return object of NSArray which has book Resources for tor.
 @discussion This method returns Resources for tor with their subnodes. There can be a Parent child relationship between Resource elememts where every resource either has subnodes or no subnodes.
 */
- (NSArray *)getBookResourcesForTORSubnodesForRole:(NSString *)role ofStandardType:(NSString *)standardType;

@end
