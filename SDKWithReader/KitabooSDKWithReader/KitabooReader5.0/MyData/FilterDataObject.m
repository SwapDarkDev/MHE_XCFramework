//
//  FilterDataObject.m
//  Kitaboo
//
//  Created by Priyanka Singh on 20/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "FilterDataObject.h"

@implementation FilterDataObject
+(FilterDataObject*)getFilterTypeObjectWithTitle:(NSString *)title FilterType:(FilterType)filterType isSubSection:(BOOL)isSubSecion isExpanded:(BOOL)isExpanded textColor:(NSString *)color andSeleted:(BOOL)isSelected{
    
    FilterDataObject *filterObj = [FilterDataObject new];
    filterObj.filterType = filterType;
    filterObj.titleTextStr = title;
    filterObj.isSubSection = isSubSecion;
    filterObj.isExpanded = isExpanded;
    filterObj.isSubSection =  filterType == FilterTypeNONE ? YES:NO;
    filterObj.titleColor = color;
    filterObj.isSelected = isSelected;
    return filterObj;
}

-(id)copyWithZone:(NSZone *)zone
{
    FilterDataObject *filterObj = [[FilterDataObject allocWithZone: zone] init];
    filterObj.filterType = self.filterType;
    filterObj.titleTextStr = self.titleTextStr;
    filterObj.isSubSection = self.isSubSection;
    filterObj.isExpanded = self.isExpanded;
    filterObj.isSubSection =  self.isSubSection;
    filterObj.titleColor = self.titleColor;
    filterObj.isSelected = self.isSelected;
    return filterObj;
}
@end
