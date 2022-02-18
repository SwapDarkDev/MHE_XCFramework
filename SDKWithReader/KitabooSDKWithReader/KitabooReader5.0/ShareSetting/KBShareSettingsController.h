//
//  ShareSettingsController.h
//
//  Created by Sumanth Myrala on 12/02/18.
//  Copyright © 2018 Hurix Systems Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"
typedef enum : short {
    
    kNoteShareSettings = 1,
    kHighlightShareSettings = 2
    
} kSettingsType;
@protocol KBShareSettingsControllerDelegate <NSObject>
@optional
/**
 * Will be called when user tap on the Cancel button
 */
- (void)didClickOnShareSettingsCancelButton;

/**
 * Will be called when user tap on the Done button
 @param1 bookClassInfoVO is the SDKBookClassInfoVO object
 */
- (void)didClickOnShareSettingsSaveButton:(SDKBookClassInfoVO *)bookClassInfoVO;

/**
 * Will be called when user tap on the Done button
 @param1 highlightVO is the SDKHighlightVO object
 */
- (void)didClickOnNoteShareSettingsSaveButton:(SDKHighlightVO *)highlightVO;

@end

@interface KBShareSettingsController : UIViewController

/**
 *Setter and getter for callback listner
 */
@property (nonatomic, weak) id<KBShareSettingsControllerDelegate> delegate;

/**
 *User should define the preffered setting type to NoteShareSettings/HighlightShareSettings
 */
@property (nonatomic, assign) kSettingsType settingsType;


/**
 Setter/Getting for Highlight, To open note controller highlight is mendatory
 */
@property (strong, nonatomic) SDKHighlightVO *highlightVO;
@property (nonatomic,assign) BOOL isFromMydataController;
@property (strong, nonatomic) KBHDThemeVO *themeVO;
@property (strong, nonatomic) NSString *selectedColor;
@property (strong, nonatomic) NSString *noteText;

/**
 * User should set the necessary data for displaying the data/content
 @param1 data is the array object where user need to set for specific segment tap
 */
- (void)setData:(NSArray *)data;
@end
