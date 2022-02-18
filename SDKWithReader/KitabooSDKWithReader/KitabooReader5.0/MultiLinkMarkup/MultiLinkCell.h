//
//  MultiLinkCell.h
//  KItabooSDK
//
//  Created by amol shelke on 12/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiLinkCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier linkIconWidth:(CGFloat)width;
@property (nonatomic)UILabel *linkIcon;
@property (nonatomic)UILabel *linkName;
@end
