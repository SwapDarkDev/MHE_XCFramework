//
//  HDReaderSettingModel.m
//  Kitaboo
//
//  Created by Sumanth Myrala on 05/06/20.
//  Copyright © 2020 Hurix System. All rights reserved.
//

#import "HDReaderSettingModel.h"

@implementation HDReaderSettingModel

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setDefaultUserSettings];
    }
    return self;
}

- (void)setDefaultUserSettings
{
    _isBookmarkEnabled = YES;
    _isSharingEnabled = YES;
    _isAutoLoginEnabled = NO;
    _isHighLightEnabled = YES;
    _isStickyNotesEnabled = YES;
    _isSearchEnabled = YES;
    _isAutoReadAloudEnabled = NO;
    _isAnalyicsButtonEnabled = YES;
    _isMathEditorEnabled = YES;
    _isProtractorEnabled = YES;
    _isReviewEnabled = YES;
    _isPenToolEnabled = YES;
    _isContextualNoteEnabled = YES;
    _pentoolPenColors = [[NSArray alloc] init];
    _isClearAllFIBsEnabled = YES;
    _isTextAnnotationEnabled = NO;
    _isAudioBookBookmarkEnabled = YES;
    _isAudioSyncEnabled = NO;
    _isMyDataPrintEnabled = NO;
}

- (BOOL)isMydataEnabled
{
    if (_isHighLightEnabled || _isContextualNoteEnabled || _isStickyNotesEnabled)
    {
        return YES;
    }
    return NO;
}

@end
