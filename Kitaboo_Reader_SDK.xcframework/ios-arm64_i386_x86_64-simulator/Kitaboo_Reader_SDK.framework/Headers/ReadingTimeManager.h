//
//  ReadingTimeManager.h
//  KItabooSDK
//
//  Created by Manoranjan Nayak on 24/12/19.
//  Copyright © 2019 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * An Object that will be responsible to represent remaining time to completely read a book.
 */
@interface ReadingTimeManager : NSObject
/*!
* To Initiate ReadingTimeManager
* @param1 bookPath Device Physical path of book
* @discussion Initializes and returns a newly allocated view object with specified book path.
* @code
* [[RendererViewController alloc] initWithBookPath:bookPath];
* @endcode
*/
- (id)initWithBookPath:(NSString*)bookPath;

/// To get total time left to complete the book.
/// @param pageIdentifier page or cfi
/// @param averageTime average time per page in seconds
- (NSInteger)getTimeLeftForpage:(NSString*)pageIdentifier withAverageTimePerPage:(double)averageTime;

/// To set the default average time per page.
/// @param averageTime average time per page
- (void)setDefaultAverageTimePerPage:(double)averageTime;


/// To check if CFI data is available or not.
-(BOOL)isCFIDataAvailable;
@end

NS_ASSUME_NONNULL_END
