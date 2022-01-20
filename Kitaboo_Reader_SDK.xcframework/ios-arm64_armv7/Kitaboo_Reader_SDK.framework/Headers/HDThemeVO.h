//
//  HDThemeVO.h
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 HDThemeVO refers to the UIColor of all the components inside the Reader.
 */
@interface HDThemeVO : NSObject
{
    NSMutableSet *_listeners;
}

@property (nonatomic, strong) UIColor *bookShelf_header;
@property (nonatomic, strong) UIColor *bookShelf_downloaded_Area;
@property (nonatomic, strong) UIColor *bookShelf_bookshelf_back;
@property (nonatomic, strong) UIColor *bookShelf_footer;
@property (nonatomic, strong) UIColor *bookShelf_font_color;
@property (nonatomic, strong) UIColor *bookShelf_icons_color;
@property (nonatomic, strong) UIColor *bookShelf_sub_header;
@property (nonatomic, strong) UIColor *bookShelf_usertxt;
@property (nonatomic, strong) UIColor *bookShelf_poweredByKitaboo;
@property (nonatomic, strong) UIColor *reader_menu_note;
@property (nonatomic, strong) UIColor *reader_panel_selection;
@property (nonatomic, strong) UIColor *reader_panel_column2;
@property (nonatomic, strong) UIColor *reader_menu_selection;
@property (nonatomic, strong) UIColor *reader_panel_header;
@property (nonatomic, strong) UIColor *reader_menu_icons_color;
@property (nonatomic, strong) UIColor *reader_tab_selection;
@property (nonatomic, strong) UIColor *reader_font;
@property (nonatomic, strong) UIColor *reader_footer;
@property (nonatomic, strong) UIColor *reader_second_panel;
@property (nonatomic, strong) UIColor *reader_poweredByKitaboo;
@property (nonatomic, strong) UIColor *reader_bookmark;
@property (nonatomic, strong) UIColor *reader_menu_icon_select;

// New book shelf theme properties

// Header
@property (nonatomic, strong) UIColor *bookShelf_header_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_header_color;

// Carousel
@property (nonatomic, strong) UIColor *bookShelf_carousel_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_carousel_color;

@property (nonatomic, strong)UIColor *bookshelf_carousel_collection_background;
@property (nonatomic, strong)UIColor *bookshelf_carousel_collection_color;


// Selected book
@property (nonatomic, strong) UIColor *bookShelf_selected_book_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_selected_book_color;
@property (nonatomic, strong) UIColor *bookShelf_inner_selected_background_color;
@property (nonatomic, strong) UIColor *bookShelf_inner_unselected_background_color;
@property (nonatomic, strong) UIColor *bookShelf_inner_shadow_color;

// Footer
@property (nonatomic, strong) UIColor *bookShelf_footer_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_footer_color;

// Book details
@property (nonatomic, strong) UIColor *bookShelf_book_details_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_book_details_color;

// Buttons
@property (nonatomic, strong) UIColor *bookShelf_launch_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_launch_color;

// Archive
@property (nonatomic, strong) UIColor *bookShelf_archive_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_archive_color;

// Statistics
@property (nonatomic, strong) UIColor *bookShelf_statistics_backgroundColor;
@property (nonatomic, strong) UIColor *bookShelf_statistics_color;

//Download All
@property (nonatomic, strong)UIColor *bookshelf_download_all_color;

//Side Menu Item
@property (nonatomic, strong)UIColor *side_menu_item_background;
@property (nonatomic, strong)UIColor *side_menu_item_dotted_line;
@property (nonatomic, strong)UIColor *side_menu_item_header_title_background;
@property (nonatomic, strong)UIColor *side_menu_item_header_title_color;


@property (nonatomic, strong)UIColor *side_menu_item_category_item_background;
@property (nonatomic, strong)UIColor *side_menu_item_category_item_selected_background;
@property (nonatomic, strong)UIColor *side_menu_item_category_item_color;
@property (nonatomic, strong)UIColor *side_menu_item_category_item_icon_color;

@property (nonatomic, strong)UIColor *side_menu_item_sign_out_background;
@property (nonatomic, strong)UIColor *side_menu_item_sign_out_icon_color;
@property (nonatomic, strong)UIColor *side_menu_item_sign_out_color;

// New book player theme properties

// Reader header and footer

@property (nonatomic, strong) UIColor *reader_header;

// Icon color
@property (nonatomic, strong) UIColor *reader_icon_backgroundColor;
@property (nonatomic, strong) UIColor *reader_icon_color;

// Icon selected color
@property (nonatomic, strong) UIColor *reader_icon_selected_backgroundColor;
@property (nonatomic, strong) UIColor *reader_icon_selected_color;

// Bookmark Color
@property (nonatomic, strong) UIColor *reader_bookmark_color;
@property (nonatomic, strong) UIColor *reader_bookmark_selectedColor;

//Pentool Color
@property (nonatomic, strong) UIColor *reader_pentool_backgroundColor;
@property (nonatomic, strong) UIColor *reader_pentool_selection_backgroundColor;

// Default panel
@property (nonatomic, strong) UIColor *reader_default_panel_backgroundColor;
@property (nonatomic, strong) UIColor *reader_default_panel_color;
@property (nonatomic, strong) UIColor *reader_default_panel_divider;
@property (nonatomic, strong) UIColor *reader_default_panel_actions;
@property (nonatomic, strong) UIColor *reader_default_panel_metadata;
@property (nonatomic, strong) UIColor *reader_default_header_color;



/// Tab
@property (nonatomic, strong) UIColor *reader_tab_backgroundColor;
@property (nonatomic, strong) UIColor *reader_tab_color;

// Thumbnail Panel
@property (nonatomic, strong) UIColor *reader_thumbnail_panel_backgroundColor;
@property (nonatomic, strong) UIColor *reader_thumbnail_panel_color;
@property (nonatomic, strong) UIColor *reader_thumbnail_panel_selection;

//Image Caption
@property (nonatomic, strong)UIColor *image_caption_backgroundColor;
@property (nonatomic, strong)UIColor *image_caption_color;
@property (nonatomic, strong)UIColor *image_caption_imagebackground;

//Read aloud menu
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_background_backgroundColor;
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_background_border_color;

//Header title
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_header_title_background;
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_header_title_color;

//Close icon
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_close_icon_background;
@property (nonatomic, strong)UIColor *reader_read_aloud_menu_close_icon_color;

//option text
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_option_text_background;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_option_text_Color;

//Buttons
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_let_me_read_background;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_let_me_read_icon_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_let_me_read_icon_border_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_let_me_read_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_let_me_read_border_color;

//Autoplay
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_autoplay_background;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_autoplay_icon_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_autoplay_icon_border_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_autoplay_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_autoplay_border_color;

//Read to me
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_read_to_me_background;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_read_to_me_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_read_to_me_icon_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_read_to_me_icon_border_color;
@property (nonatomic,strong)UIColor *reader_read_aloud_menu_buttons_read_to_me_border_color;

//Login
@property (nonatomic,strong)UIColor *reader_login_background;
@property (nonatomic,strong)UIColor *reader_login_header_background;
@property (nonatomic,strong)UIColor *reader_login_header_color;

//Input box
@property (nonatomic,strong)UIColor *reader_login_input_box_border;
@property (nonatomic,strong)UIColor *reader_login__input_box_color;

//Login theme properties
@property (nonatomic, strong)UIColor *login_background;

//header
@property (nonatomic, strong)UIColor *login_header_background;
@property (nonatomic, strong)UIColor *login_header_color;

//Input Box
@property (nonatomic, strong)UIColor *login_input_box_border_color;
@property (nonatomic, strong)UIColor *login_input_box_color;

@property (nonatomic,strong)UIColor *reader_profile_setting_background;
@property (nonatomic,strong)UIColor *reader_profile_setting_header_background;
@property (nonatomic,strong)UIColor *reader_profile_setting_header_color;
@property (nonatomic,strong)UIColor *reader_profile_setting_user_name_background;
@property (nonatomic,strong)UIColor *reader_profile_setting_user_name_color;
@property (nonatomic,strong)UIColor*reader_profile_setting_email_link_background;
@property (nonatomic,strong)UIColor *reader_profile_setting_email_link_color;
@property (nonatomic,strong)UIColor *reader_profile_setting_buttons_background;
@property (nonatomic,strong)UIColor *reader_profile_setting_buttons_color;


//Forgot Password Link
@property (nonatomic, strong)UIColor *login_forgotPasswordLink_background;
@property (nonatomic, strong)UIColor *login_forgotPasswordLink_color;

//Other Link
@property (nonatomic, strong)UIColor *login_otherLink_background;
@property (nonatomic, strong)UIColor *login_otherLink_color;

//Buttons
@property (nonatomic, strong)UIColor *login_buttons_background;
@property (nonatomic, strong)UIColor *login_buttons_color;

@property (nonatomic, strong)UIColor *search_text_color;


//Profile Settings Theme Properties

@property (nonatomic, strong)UIColor *profile_setting_background;

//Header
@property (nonatomic, strong)UIColor *profile_setting_header_background;
@property (nonatomic, strong)UIColor *profile_setting_header_color;

//Username
@property (nonatomic, strong)UIColor *profile_setting_username_background;
@property (nonatomic, strong)UIColor *profile_setting_username_color;

//Emaid_id
@property (nonatomic, strong)UIColor *profile_setting_email_link_background;
@property (nonatomic, strong)UIColor *profile_setting_email_link_color;

//Buttons
@property (nonatomic, strong)UIColor *profile_setting_buttons_background;
@property (nonatomic, strong)UIColor *profile_setting_buttons_border;
@property (nonatomic, strong)UIColor *profile_setting_buttons_color;

/**
 This method should be called when .json file for Reader is unavailable or when user want the default them of SDK
 * @code
 * [themeVO setDefaultTheme];
 * @endcode
 */
-(void) setDefaultTheme;

/**
 This method should be called when  .json file of theme is available.If the .json file is unavailable default theme will be reflected.
 * @param1 filepath Json file path of the theme
 * @code
 * [themeVO updateThemeFromFileAtPath:themeFilePath];
 * @endcode
 */
- (void)updateThemeFromFileAtPath:(NSString *)filepath;
@end
