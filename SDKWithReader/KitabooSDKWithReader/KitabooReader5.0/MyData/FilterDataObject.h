//
//  FilterDataObject.h
//  Kitaboo
//
//  Created by Priyanka Singh on 20/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum{
    FilterTypeHIGHLIGHT = 100,
    FilterTypeNOTE = 101,
    FilterTypeALL = 102,
    FilterTypeNONE = 104,
    FilterTypeCONTEXTUAL = 106

} FilterType;

@interface FilterDataObject : NSObject<NSCopying>
@property(nonatomic,strong) NSString *titleTextStr;
@property(nonatomic,assign) FilterType filterType;
@property(nonatomic,assign) BOOL isSubSection;
@property(nonatomic,assign) BOOL isExpanded;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSString *titleColor;
-(id)copyWithZone:(NSZone *)zone;
+(FilterDataObject*)getFilterTypeObjectWithTitle:(NSString *)title FilterType:(FilterType)filterType isSubSection:(BOOL)isSubSecion isExpanded:(BOOL)isExpanded textColor:(NSString *)color andSeleted:(BOOL)isSelected;
@end
