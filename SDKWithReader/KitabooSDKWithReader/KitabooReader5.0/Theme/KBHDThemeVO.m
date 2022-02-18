//
//  HDThemeVO.m
//  KItabooSDK
//
//  Created by Hurix System on 22/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "KBHDThemeVO.h"
#import "HSUIColor-Expanded.h"
#import "ReaderHeader.h"
#define ColorWithHex(hexStr) [UIColor colorWithHexString:hexStr]
@implementation KBHDThemeVO

-(id)init
{
    self = [super init];
    if(self)
    {
        [self readDefaultThemeFile];
    }
    return self;
}

-(void)readDefaultThemeFile{
    //check if theme file is available at user's location
    SystemInformation *systemInformation = [SystemInformation getInstance];
    NSString *userFolder = [systemInformation getUsersFolderPath];
    NSString *themeFilePath = [userFolder stringByAppendingPathComponent:@"readerDefault_theme.json"];
    
    //if theme file is not available at users location read default theme
    if (![[NSFileManager defaultManager] fileExistsAtPath:themeFilePath]) {
        themeFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"readerDefault_theme"
        ofType:@"json"];
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:themeFilePath];
    NSError *error;
    defaultJson = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
}

- (void)makeDefaultTheme
{
        // Reader Theme
        NSDictionary *readerDayModeDict = [[defaultJson valueForKey:@"Reader"] valueForKey:@"DayMode"];
        NSDictionary *tempDict = [readerDayModeDict valueForKey:@"main"];
        _canvas_background = ColorWithHex([tempDict valueForKey:@"canvas_background"]);
        _top_toolbar_background = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"]);
        _top_toolbar_icons_color = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"icons-color"]);
        _top_toolbar_shadow = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"]);
        _top_toolbar_selected_icon_color = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon-color"]);
        _top_toolbar_selected_icon_bg = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon_bg"]);
        
        _side_bottom_background = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"]);
        _side_bottom_icons_color = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"icons-color"]);
        _side_bottom_shadow = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"]);
        _side_bottom_selected_icon_color = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon-color"]);
        _side_bottom_selected_icon_bg = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon_bg"]);
        
        tempDict = [readerDayModeDict valueForKey:@"tableofcontents"];
        _toc_overlay_panel_background = ColorWithHex([[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"]);
        _toc_overlay_panel_opacity = [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue]: 0.45;
        _toc_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _toc_popup_border = ColorWithHex( [tempDict valueForKey:@"popup_border"]);
        _toc_tab_bg = ColorWithHex([tempDict valueForKey:@"tab_bg"]);
        _toc_tab_border = ColorWithHex([tempDict valueForKey:@"tab_border"]);
        _toc_tab_text_color = ColorWithHex([tempDict valueForKey:@"tab_text-color"]);
        _toc_selected_tab_border = ColorWithHex([tempDict valueForKey:@"selected_tab_border"]);
        _toc_selected_text_color =  ColorWithHex([tempDict valueForKey:@"selected_text-color"]);
        _toc_selected_toc_section_background = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"background"]);
        _toc_selected_toc_section_divider = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"divider"]);
        _toc_selected_toc_title_color = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"title-color"]);
        _toc_selected_toc_title_description_color = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"description-color"]);
        _toc_selected_toc_arrow_color = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"arrow_color"]);
        _toc_selected_toc_icon_color = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"icon_color"]);
        _toc_selected_toc_side_tab_background = ColorWithHex([[tempDict valueForKey:@"selected_toc"] valueForKey:@"side_tab_background"]);
        _toc_title_color = ColorWithHex([tempDict valueForKey:@"title-color"]);
        _toc_description_color = ColorWithHex([tempDict valueForKey:@"description-color"]);
        _toc_pageno_color = ColorWithHex([tempDict valueForKey:@"pageno-color"] );
        _toc_divider_color = ColorWithHex([tempDict valueForKey:@"divider-color"]);
        _toc_more_icon_color = ColorWithHex([tempDict valueForKey:@"more_icon-color"]);
        _toc_close_slider_background = ColorWithHex([[tempDict valueForKey:@"close_slider"] valueForKey:@"background"]);
        _toc_close_slider_icon_color = ColorWithHex([[tempDict valueForKey:@"close_slider"] valueForKey:@"icon_color"]);
        
        tempDict = [readerDayModeDict valueForKey:@"MyData"];
        _mydata_overlay_panel_background = ColorWithHex([[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"]);
        _mydata_overlay_panel_opacity = [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue]: 0.45;
        _mydata_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _mydata_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _mydata_tab_bg = ColorWithHex([tempDict valueForKey:@"tab_bg"]);
        _mydata_tab_border = ColorWithHex([tempDict valueForKey:@"tab_border"]);
        _mydata_tab_text_color= ColorWithHex([tempDict valueForKey:@"tab_text-color"]);
        _mydata_selected_tab_border = ColorWithHex([tempDict valueForKey:@"selected_tab_border"]);
        _mydata_selected_text_color = ColorWithHex([tempDict valueForKey:@"selected_text-color"]);
        _mydata_selected_button_background = ColorWithHex([[tempDict valueForKey:@"selected_button"] valueForKey:@"background"]);
        _mydata_selected_button_text_color = ColorWithHex([[tempDict valueForKey:@"selected_button"] valueForKey:@"text-color"]);
        _mydata_deselected_button_background = ColorWithHex([[tempDict valueForKey:@"de-selected_button"] valueForKey:@"background"]);
        _mydata_deselected_button_text_color = ColorWithHex([[tempDict valueForKey:@"de-selected_button"] valueForKey:@"text-color"]);
        _mydata_tabs_icon_color = ColorWithHex([tempDict valueForKey:@"icon_color"]);
        _mydata_disabled_tabs_icon_color = ColorWithHex([[tempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"]);
        _mydata_disabled_icon_opacity = [[tempDict valueForKey:@"disabled_icon"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"disabled_icon"] valueForKey:@"opacity"] floatValue]: 0.45;
        _mydata_chpater_text_color = ColorWithHex([tempDict valueForKey:@"text-color"]);
        _mydata_page_date_text_color = ColorWithHex([tempDict valueForKey:@"metadata-color"]);
        _mydata_contextual_text_color = ColorWithHex([tempDict valueForKey:@"contextualtext-color"]);
        _mydata_note_text_color = ColorWithHex([tempDict valueForKey:@"description-color"]);
        _mydata_commentShare_button_text_icon_color  = ColorWithHex([[tempDict valueForKey:@"sub_button"] valueForKey:@"text-icon_color"]);
        _mydata_commentShare_button_disabled_text_icon_color = ColorWithHex([[tempDict valueForKey:@"sub_button"] valueForKey:@"disabled_text-icon_color"]);
        _mydata_notification_circle_color = ColorWithHex([tempDict valueForKey:@"notification_circle_color"]);
        
        _filterPopUp_background = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"background"]);
        _filterPopUp_border_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"border_color"]);
        _filterPopUp_all_box_border_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"all_box_border-color"]);
        _filterPopUp_color_box_border_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"box_border-color"]);
        _filterPopUp_check_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"check_color"]);
        _filterPopUp_text_color  = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"text-color"]);
        _filterPopUp_arrow_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"arrow_color"]);
        _filterPopUp_action_text_color = ColorWithHex([[tempDict valueForKey:@"filter_popup"] valueForKey:@"action_text-color"]);
        
        _settings_background = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"background"]);
        _settings_header_title_color = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"title-color"]);
        _settings_icon_color = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"icon_color"]);
        _settings_box_border_color  = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"box_border-color"]);
        _settings_section_title_color = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"section_title-color"]);
        _settings_text_color = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"text-color"]);
        _settings_check_color = ColorWithHex([[tempDict valueForKey:@"settings"] valueForKey:@"check_color"]);
        _settings_done_button_background  = ColorWithHex([[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"background"]);
        _settings_done_button_text_color = ColorWithHex([[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"text-color"]);
        _settings_cancel_button_border_color = ColorWithHex([[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]);
        _settings_cancel_button_text_color = ColorWithHex([[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]);
        
        tempDict = [readerDayModeDict valueForKey:@"Bookmark"];
        _bookmark_icon_color = ColorWithHex([tempDict valueForKey:@"icon_color"]);
        _bookmark_selected_icon_color = ColorWithHex([tempDict valueForKey:@"selected_icon-color"]);
        _bookmark_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _bookmark_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _bookmark_input_panel_bg = ColorWithHex([tempDict valueForKey:@"input_panel-bg"]);
        _bookmark_hint_text_color= ColorWithHex([tempDict valueForKey:@"hint_text-color"]);
        _bookmark_text_color= ColorWithHex([tempDict valueForKey:@"text-color"]);
        _bookmark_button_background= ColorWithHex([tempDict valueForKey:@"button_background"]);
        _bookmark_button_text_color= ColorWithHex([tempDict valueForKey:@"button_background"]);
        
        tempDict = [readerDayModeDict valueForKey:@"Search"];
        _search_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _search_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _search_main_icon_color = ColorWithHex([tempDict valueForKey:@"main_icon-color"]);
        _search_hint_text_color = ColorWithHex([tempDict valueForKey:@"hint_text-color"]);
        _search_title_color= ColorWithHex([tempDict valueForKey:@"title-color"]);
        _search_tab_border= ColorWithHex([tempDict valueForKey:@"tab_border"]);
        _search_selected_text_color= ColorWithHex([tempDict valueForKey:@"selected_text-color"]);
        _search_separation_background = ColorWithHex([tempDict valueForKey:@"seperation_background"]);
        _search_cross_icon_color = ColorWithHex([tempDict valueForKey:@"cross_icon-color"]);
        _search_description_color = ColorWithHex([tempDict valueForKey:@"description-color"]);
        _search_subtext_color = ColorWithHex([tempDict valueForKey:@"subtext-color"]);
        _search_input_panelBg_color = ColorWithHex([tempDict valueForKey:@"input_panel-bg"]);
        _search_selection_text_color_bg = ColorWithHex([tempDict valueForKey:@"selection_text_color_bg"]);
        _search_selected_text_color_bg = ColorWithHex([tempDict valueForKey:@"selected_text_color_bg"]);

    
        tempDict = [readerDayModeDict valueForKey:@"Pentool"];
        _pen_tool_toolbar_background = ColorWithHex([[tempDict valueForKey:@"toolbar"] valueForKey:@"background"]);
        _pen_tool_toolbar_icons_color = ColorWithHex([[tempDict valueForKey:@"toolbar"] valueForKey:@"icons-color"]);
        _pen_tool_disabled_icon_color = ColorWithHex([[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"icon_color"]);
        _pen_tool_disabled_opacity = [[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"opacity"] != nil ? [[[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"opacity"] doubleValue]: 0.45;
        _pen_tool_selected_icon_background = ColorWithHex([[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_background"]);
        _pen_tool_selected_icon_color = ColorWithHex([[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_color"]);
        _pen_tool_pen_popup_background = ColorWithHex([[tempDict valueForKey:@"Pen"] valueForKey:@"popup_background"]);
        _pen_tool_pen_popup_border = ColorWithHex([[tempDict valueForKey:@"Pen"] valueForKey:@"popup_border"]);
        _pen_Color_Array = [NSArray arrayWithArray:[tempDict valueForKey:@"pen-color"]] ;
        _pen_tool_thicknessPopUp_backgroundColor = ColorWithHex([[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_background"]);
        _pen_tool_thicknessPopUp_border = ColorWithHex([[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_border"]);
        
        _pen_tool_slider_color = ColorWithHex([[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-color"]);
        _pen_tool_slider_filled_color= ColorWithHex([[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-filled-color"]);
        
        tempDict = [readerDayModeDict valueForKey:@"Thumbnail_Slider"];
        _thumbnail_slider_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _thumbnail_slider_slider_color = ColorWithHex([tempDict valueForKey:@"slider-color"]);
        _thumbnail_chapter_icon_color = ColorWithHex([tempDict valueForKey:@"chapter_icon_color"]);
        _thumbnail_slider_filled_color = ColorWithHex([tempDict valueForKey:@"slider-filled-color"]);
        _thumbnail_default_thumbnail_color = ColorWithHex([tempDict valueForKey:@"default_thumbnail_color"]);
        _thumbnail_selected_thumbnail_color = ColorWithHex([tempDict valueForKey:@"selected_thumbnail_color"]);
        _thumbnail_pageNo_text_color = ColorWithHex([tempDict valueForKey:@"thumbnail_text-color"]);
        _thumbnail_selected_title_color= ColorWithHex([tempDict valueForKey:@"selected_title_color"]);
        _thumbnail_title_color= ColorWithHex([tempDict valueForKey:@"title-color"]);
        _thumbnail_icon_color= ColorWithHex([tempDict valueForKey:@"icon_color"]);
        _thumbnail_botton_bar_text_color = ColorWithHex([tempDict valueForKey:@"text-color"]);
        
        tempDict = [readerDayModeDict valueForKey:@"Note"];
        _note_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _note_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _note_title_color = ColorWithHex([tempDict valueForKey:@"title-color"]);
        _note_back_icon_color= ColorWithHex([tempDict valueForKey:@"back_icon-color"]);
        _note_selected_icon_border= ColorWithHex([tempDict valueForKey:@"selected_icon_border"]);
        _note_contextualtext_color= ColorWithHex([tempDict valueForKey:@"contextualtext-color"]);
        _note_hint_text_color= ColorWithHex([tempDict valueForKey:@"hint_text-color"]);
        _note_description_color= ColorWithHex([tempDict valueForKey:@"description-color"]);
        _note_note_text_color= ColorWithHex([tempDict valueForKey:@"metadata-color"]);
    
        tempDict = [readerDayModeDict valueForKey:@"Share"];
        _share_share_popup_background= ColorWithHex([tempDict valueForKey:@"share_popup_background"]);
        _share_icon_color= ColorWithHex([tempDict valueForKey:@"icon_color"]);
        _share_shareSettings_section_title_color = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"section_title-color"]);
        _share_shareSettings_box_border_color = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"box_border-color"]);
        _share_shareSettings_all_box_border_color = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"all_box_border-color"]);
        _share_shareSettings_check_color = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"check_color"]);
        _share_shareSettings_bottom_background = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"bottom_background"]);
        _share_shareSettings_text_color = ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"text-color"] );
        _share_shareSettings_main_action_color= ColorWithHex([[tempDict valueForKey:@"share_settings"] valueForKey:@"main_action_color"]);
    
        tempDict = [readerDayModeDict valueForKey:@"Comments"];
        _comments_back_icon_color = ColorWithHex([tempDict valueForKey:@"back_icon_color"]);
        _comments_tab_text_color= ColorWithHex([tempDict valueForKey:@"tab_text_color"]);
        _comments_divider_color = ColorWithHex([tempDict valueForKey:@"divider_color"]);
        _comments_other_message_background = ColorWithHex([[tempDict valueForKey:@"other_message"] valueForKey:@"background"]);
        _comments_other_message_border_color = ColorWithHex([[tempDict valueForKey:@"other_message"] valueForKey:@"border_color"]);
        _comments_other_message_name_color = ColorWithHex([[tempDict valueForKey:@"other_message"] valueForKey:@"name_color"]);
        _comments_other_message_description_color = ColorWithHex([[tempDict valueForKey:@"other_message"] valueForKey:@"description-color"]);
        _comments_other_message_time_text_color = ColorWithHex([[tempDict valueForKey:@"other_message"] valueForKey:@"time_text_color"] );
        _comments_my_message_background = ColorWithHex([[tempDict valueForKey:@"my_message"] valueForKey:@"background"]);
        _comments_my_message_border_color = ColorWithHex([[tempDict valueForKey:@"my_message"] valueForKey:@"border_color"]);
        _comments_my_message_name_color = ColorWithHex([[tempDict valueForKey:@"my_message"] valueForKey:@"name_color"]);
        _comments_my_message_description_color = ColorWithHex([[tempDict valueForKey:@"my_message"] valueForKey:@"description-color"]);
        _comments_my_message_time_text_color = ColorWithHex([[tempDict valueForKey:@"my_message"] valueForKey:@"time_text_color"] );
        _comments_bottom_panel_background = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"background"]);
        _comments_bottom_panel_border_color = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"border_color"]);
        _comments_bottom_panel_hint_text_color = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"hint_text-color"]);
        _comments_bottom_panel_text_color = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"text-color"]);
        _comments_bottom_panel_icon_color_disabled = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color_disabled"] );
        _comments_bottom_panel_icon_color = ColorWithHex([[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"] );

        tempDict = [readerDayModeDict valueForKey:@"Teacher_Settings"];
        _teacherSettings_popup_background =  ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _teacherSettings_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _teacherSettings_title_color = ColorWithHex( [tempDict valueForKey:@"title-color"] );
        _teacherSettings_main_icon_color = ColorWithHex( [tempDict valueForKey:@"main_icon-color"]);
        _teacherSettings_text_color = ColorWithHex([tempDict valueForKey:@"text-color"] );
        _teacherSettings_selected_icon_color = ColorWithHex([tempDict valueForKey:@"selected_icon-color"]);
        _teacherSettings_selected_icon_bg = ColorWithHex([tempDict valueForKey:@"selected_icon_bg"]);
        _teacherSettings_pen1_color = ColorWithHex([tempDict valueForKey:@"pen1-color"]);
        _teacherSettings_pen2_color = ColorWithHex([tempDict valueForKey:@"pen2-color"]);
        _teacherSettings_box_border_color = ColorWithHex([tempDict valueForKey:@"box_border-color"]);
        _teacherSettings_check_color = ColorWithHex([tempDict valueForKey:@"check_color"]);
    
        tempDict = [readerDayModeDict valueForKey:@"Teacher_studentlist"];
        _teacher_studentlist_popup_background = ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _teacher_studentlist_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _teacher_studentlist_shadow = ColorWithHex([tempDict valueForKey:@"shadow"]);
        _teacher_studentlist_title_color = ColorWithHex([tempDict valueForKey:@"title-color"]);
        _teacher_studentlist_hint_text_color = ColorWithHex([tempDict valueForKey:@"hint_text-color"]);
        _teacher_studentlist_tab_border = ColorWithHex([tempDict valueForKey:@"tab_border"]);
        _teacher_studentlist_tab_selected_bar = ColorWithHex([tempDict valueForKey:@"tab_selected_bar"]);
        _teacher_studentlist_tab_text_color = ColorWithHex([tempDict valueForKey:@"tab_text-color"]);
        _teacher_studentlist_name_color = ColorWithHex([tempDict valueForKey:@"name_color"]);
        _teacher_studentlist_data_added_color = ColorWithHex([tempDict valueForKey:@"data_added_color"]);
        _teacher_studentlist_nodata_added_color = ColorWithHex([tempDict valueForKey:@"nodata_added_color"]);
        _teacher_studentlist_refresh_box_border_color = ColorWithHex([[tempDict valueForKey:@"refresh"] valueForKey:@"box_border-color"]);
        _teacher_studentlist_refresh_button_text_color = ColorWithHex([[tempDict valueForKey:@"refresh"] valueForKey:@"button_text-color"]);
        _teacher_studentlist_selected_color = ColorWithHex([tempDict valueForKey:@"selected_color"]);
    
    NSDictionary *glossaryDict = [defaultJson valueForKey:@"Markup_Glossary"];
    _glossary_underline_color = ColorWithHex([glossaryDict valueForKey:@"link_line_color"]);
    _glossary_popup_background_color = ColorWithHex([glossaryDict valueForKey:@"popup_background"]);
    _glossary_icon_color = ColorWithHex([glossaryDict valueForKey:@"icon_color"]);
    _glossary_icon_border_color = ColorWithHex([glossaryDict valueForKey:@"icon_border_color"]);
    _glossary_alphabet_label_color = ColorWithHex([glossaryDict valueForKey:@"title-color"]);
    _glossary_keyword_label_color = ColorWithHex([glossaryDict valueForKey:@"language_text_color"]);
    _glossary_description_color = ColorWithHex([glossaryDict valueForKey:@"description_text_color"]);
    _glossary_synonym_color = ColorWithHex([glossaryDict valueForKey:@"synonym_text_color"]);
    
    tempDict = [readerDayModeDict valueForKey:@"FontSettings"];
    _fontSettings_popup_background =  ColorWithHex([tempDict valueForKey:@"popup_background"]);
    _fontSettings_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
    _fontSettings_selected_text_color = ColorWithHex([tempDict valueForKey:@"selected_text-color"]);
    _fontSettings_reset_color = ColorWithHex([tempDict valueForKey:@"reset-color"]);
    _fontSettings_font_text_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"text-color"]);
    _fontSettings_font_divider_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"divider-color"]);
    _fontSettings_font_pointer_bg = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"pointer_bg"]);
    _fontSettings_font_icon_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"icon_color"]);
    _fontSettings_font_box_border_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"box_border-color"]);
    _fontSettings_font_selected_icon_border = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"selected_icon-border"]);
    _fontSettings_font_dropdown_text_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"dropdown_text-color"]);
    _fontSettings_font_more_icon_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"more_icon-color"]);
    _fontSettings_other_icon_color = ColorWithHex([[tempDict valueForKey:@"Other"] valueForKey:@"icon_color"]);
    _fontSettings_other_selected_icon_color = ColorWithHex([[tempDict valueForKey:@"Other"] valueForKey:@"selected_icon-color"]);
    _fontSettings_other_brightness_slider_color = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"Brightness"] valueForKey:@"slider-color"]);
    _fontSettings_Other_ScrollView_tab_bg = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"tab_bg"]);
    _fontSettings_Other_ScrollView_selected_Tab_bg = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"selected_Tab_bg"]);
    _fontSettings_Other_ScrollView_selected_text_color = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"selected_text-color"]);
}

-(void)updateThemeFromFileAtPath:(NSString *)filepath
{
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filepath];
    
    if (!jsonData || jsonData.length == 0)
    {
        [self makeDefaultTheme];
    }
    else
    {
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error];
        // Reader Theme
        NSDictionary *readerDayModeDict = [[jsonDict valueForKey:@"Reader"] valueForKey:@"DayMode"];
        NSDictionary *tempDict = [readerDayModeDict valueForKey:@"main"];
        
        NSDictionary *defaultReaderDayModeDict = [[defaultJson valueForKey:@"Reader"] valueForKey:@"DayMode"];
        NSDictionary *defaultTempDict = [defaultReaderDayModeDict valueForKey:@"main"];
        NSDictionary *defaultGlossaeyDict = [defaultJson valueForKey:@"Markup_Glossary"];
        
        _canvas_background = [UIColor colorWithHexString:[tempDict valueForKey:@"canvas_background"] != nil ? [tempDict valueForKey:@"canvas_background"] : [defaultTempDict valueForKey:@"canvas_background"]];
        _top_toolbar_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"]];
        _top_toolbar_icons_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"icons-color"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"icons-color"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"icons-color"]];
        _top_toolbar_shadow = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"background"]];
        _top_toolbar_selected_icon_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon-color"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon-color"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon-color"]];
        _top_toolbar_selected_icon_bg = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon_bg"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon_bg"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"top"] valueForKey:@"selected_icon_bg"]];
        
        _side_bottom_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"]];
        _side_bottom_icons_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"icons-color"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"icons-color"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"icons-color"]];
        _side_bottom_shadow = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"background"]];
        _side_bottom_selected_icon_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon-color"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon-color"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon-color"]];
        _side_bottom_selected_icon_bg = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon_bg"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon_bg"] :[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"side_bottom"] valueForKey:@"selected_icon_bg"]];
        
        tempDict = [readerDayModeDict valueForKey:@"tableofcontents"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"tableofcontents"];
        _toc_overlay_panel_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"]!= nil ? [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"overlay_panel"] valueForKey:@"background"]];
        _toc_overlay_panel_opacity = [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue]: [[[defaultTempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue];
        _toc_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] : [defaultTempDict valueForKey:@"popup_background"]];
        _toc_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] : [defaultTempDict valueForKey:@"popup_border"]];
        _toc_tab_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_bg"] != nil ? [tempDict valueForKey:@"tab_bg"] : [defaultTempDict valueForKey:@"tab_bg"]];
        _toc_tab_border = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_border"] != nil ? [tempDict valueForKey:@"tab_border"] :[defaultTempDict valueForKey:@"tab_border"]];
        _toc_tab_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_text-color"] != nil ? [tempDict valueForKey:@"tab_text-color"] :[defaultTempDict valueForKey:@"tab_text-color"]];
        _toc_selected_tab_border = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_tab_border"] != nil ? [tempDict valueForKey:@"selected_tab_border"] :[defaultTempDict valueForKey:@"selected_tab_border"]];
        _toc_selected_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_text-color"] != nil ? [tempDict valueForKey:@"selected_text-color"] :[defaultTempDict valueForKey:@"selected_text-color"]];
        _toc_selected_toc_section_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"background"]];
        _toc_selected_toc_section_divider = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"divider"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"divider"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"divider"]];
        _toc_selected_toc_title_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"title-color"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"title-color"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"title-color"]];
        _toc_selected_toc_title_description_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"description-color"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"description-color"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"description-color"]];
        _toc_selected_toc_arrow_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"arrow_color"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"arrow_color"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"arrow_color"]];
        _toc_selected_toc_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"icon_color"]];
        _toc_selected_toc_side_tab_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_toc"] valueForKey:@"side_tab_background"] != nil ? [[tempDict valueForKey:@"selected_toc"] valueForKey:@"side_tab_background"] :[[defaultTempDict valueForKey:@"selected_toc"] valueForKey:@"side_tab_background"]];
        _toc_title_color = [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] :[defaultTempDict valueForKey:@"title-color"]];
        _toc_description_color = [UIColor colorWithHexString:[tempDict valueForKey:@"description-color"] != nil ? [tempDict valueForKey:@"description-color"] :[defaultTempDict valueForKey:@"description-color"]];
        _toc_pageno_color = [UIColor colorWithHexString:[tempDict valueForKey:@"pageno-color"] != nil ? [tempDict valueForKey:@"pageno-color"] :[defaultTempDict valueForKey:@"pageno-color"]];
        _toc_divider_color = [UIColor colorWithHexString:[tempDict valueForKey:@"divider-color"] != nil ? [tempDict valueForKey:@"divider-color"] :[defaultTempDict valueForKey:@"divider-color"]];
        _toc_more_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"more_icon-color"] != nil ? [tempDict valueForKey:@"more_icon-color"] :[defaultTempDict valueForKey:@"more_icon-color"]];
        _toc_close_slider_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"close_slider"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"close_slider"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"close_slider"] valueForKey:@"background"]];
        _toc_close_slider_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"close_slider"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"close_slider"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"close_slider"] valueForKey:@"icon_color"]];

        tempDict = [readerDayModeDict valueForKey:@"MyData"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"MyData"];
        _mydata_overlay_panel_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"overlay_panel"] valueForKey:@"background"]];
        _mydata_overlay_panel_opacity = [[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue]: [[[defaultTempDict valueForKey:@"overlay_panel"] valueForKey:@"opacity"] doubleValue];
        _mydata_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] :  [defaultTempDict valueForKey:@"popup_background"]];
        _mydata_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :  [defaultTempDict valueForKey:@"popup_border"]];
        _mydata_tab_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_bg"] != nil ? [tempDict valueForKey:@"tab_bg"] :  [defaultTempDict valueForKey:@"tab_bg"]];
        _mydata_tab_border = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_border"] != nil ? [tempDict valueForKey:@"tab_border"] :  [defaultTempDict valueForKey:@"tab_border"]];
        _mydata_tab_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"tab_text-color"] != nil ? [tempDict valueForKey:@"tab_text-color"] : [defaultTempDict valueForKey:@"tab_text-color"]];
        _mydata_selected_tab_border = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_tab_border"] != nil ? [tempDict valueForKey:@"selected_tab_border"] : [defaultTempDict valueForKey:@"selected_tab_border"]];
        _mydata_selected_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_text-color"] != nil ? [tempDict valueForKey:@"selected_text-color"] :  [defaultTempDict valueForKey:@"selected_text-color"]];
        _mydata_selected_button_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_button"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"selected_button"] valueForKey:@"background"] :  [[defaultTempDict valueForKey:@"selected_button"] valueForKey:@"background"]];
        _mydata_selected_button_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"selected_button"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"selected_button"] valueForKey:@"text-color"] :  [[defaultTempDict valueForKey:@"selected_button"] valueForKey:@"text-color"]];
        _mydata_deselected_button_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"de-selected_button"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"de-selected_button"] valueForKey:@"background"] :  [[defaultTempDict valueForKey:@"de-selected_button"] valueForKey:@"background"]];
        _mydata_deselected_button_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"de-selected_button"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"de-selected_button"] valueForKey:@"text-color"] :  [[defaultTempDict valueForKey:@"de-selected_button"] valueForKey:@"text-color"]];
        _mydata_tabs_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"icon_color"] != nil ? [tempDict valueForKey:@"icon_color"] :  [defaultTempDict valueForKey:@"icon_color"]];
        _mydata_disabled_tabs_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] :  [[defaultTempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"]];
        _mydata_disabled_icon_opacity = [[tempDict valueForKey:@"disabled_icon"] valueForKey:@"opacity"] != nil ? [[[tempDict valueForKey:@"disabled_icon"] valueForKey:@"opacity"] floatValue]: [[[defaultTempDict valueForKey:@"disabled_icon"] valueForKey:@"opacity"] floatValue];
        _mydata_chpater_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"text-color"] != nil ? [tempDict valueForKey:@"text-color"] :  [defaultTempDict valueForKey:@"text-color"]];
        _mydata_page_date_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"metadata-color"] != nil ? [tempDict valueForKey:@"metadata-color"] : [defaultTempDict valueForKey:@"metadata-color"]];
        _mydata_contextual_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"contextualtext-color"] != nil ? [tempDict valueForKey:@"contextualtext-color"] : [defaultTempDict valueForKey:@"contextualtext-color"]];
        _mydata_note_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"description-color"] != nil ? [tempDict valueForKey:@"description-color"] :[defaultTempDict valueForKey:@"description-color"]];
        _mydata_commentShare_button_text_icon_color  = [UIColor colorWithHexString:[[tempDict valueForKey:@"sub_button"] valueForKey:@"text-icon_color"] != nil ? [[tempDict valueForKey:@"sub_button"] valueForKey:@"text-icon_color"] : [[defaultTempDict valueForKey:@"sub_button"] valueForKey:@"text-icon_color"]];
        _mydata_commentShare_button_disabled_text_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"sub_button"] valueForKey:@"disabled_text-icon_color"] != nil ? [[tempDict valueForKey:@"sub_button"] valueForKey:@"disabled_text-icon_color"] : [[defaultTempDict valueForKey:@"sub_button"] valueForKey:@"disabled_text-icon_color"]];
        _mydata_notification_circle_color = [UIColor colorWithHexString:[tempDict valueForKey:@"notification_circle_color"] != nil ? [tempDict valueForKey:@"notification_circle_color"] : [defaultTempDict valueForKey:@"notification_circle_color"]];
        
        _filterPopUp_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"background"] :  [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"background"]];
        _filterPopUp_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"border_color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"border_color"] :  [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"border_color"]];
        _filterPopUp_all_box_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"all_box_border-color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"all_box_border-color"] : [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"all_box_border-color"]];
        _filterPopUp_color_box_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"box_border-color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"box_border-color"] : [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"box_border-color"]];
        _filterPopUp_check_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"check_color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"check_color"] :  [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"check_color"]];
        _filterPopUp_text_color  = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"text-color"] : [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"text-color"]];
        _filterPopUp_arrow_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"arrow_color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"arrow_color"] :  [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"arrow_color"]];
        _filterPopUp_action_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"filter_popup"] valueForKey:@"action_text-color"] != nil ? [[tempDict valueForKey:@"filter_popup"] valueForKey:@"action_text-color"] :  [[defaultTempDict valueForKey:@"filter_popup"] valueForKey:@"action_text-color"]];
        
        _settings_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"background"] :  [[defaultTempDict valueForKey:@"settings"] valueForKey:@"background"]];
        _settings_header_title_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"title-color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"title-color"] : [[defaultTempDict valueForKey:@"settings"] valueForKey:@"title-color"]];
        _settings_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"icon_color"] : [[defaultTempDict valueForKey:@"settings"] valueForKey:@"icon_color"]];
        _settings_box_border_color  = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"box_border-color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"box_border-color"] :  [[defaultTempDict valueForKey:@"settings"] valueForKey:@"box_border-color"]];
        _settings_section_title_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"section_title-color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"section_title-color"] :  [[defaultTempDict valueForKey:@"settings"] valueForKey:@"section_title-color"]];
        _settings_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"text-color"] :  [[defaultTempDict valueForKey:@"settings"] valueForKey:@"text-color"]];
        _settings_check_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"settings"] valueForKey:@"check_color"] != nil ? [[tempDict valueForKey:@"settings"] valueForKey:@"check_color"] : [[defaultTempDict valueForKey:@"settings"] valueForKey:@"check_color"]];
        _settings_done_button_background  = [UIColor colorWithHexString:[[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"background"]  != nil ? [[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"background"] :  [[[[defaultTempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"background"]];
        _settings_done_button_text_color = [UIColor colorWithHexString:[[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"text-color"]  != nil ? [[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"text-color"] :  [[[[defaultTempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"main"] valueForKey:@"text-color"]];
        _settings_cancel_button_border_color = [UIColor colorWithHexString:[[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]  != nil ? [[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"] :  [[[[defaultTempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]];
        _settings_cancel_button_text_color = [UIColor colorWithHexString:[[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]  != nil ? [[[[tempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"] :  [[[[defaultTempDict valueForKey:@"settings"] valueForKey:@"action_button"]  valueForKey:@"cancel"] valueForKey:@"border_color"]];
        
        tempDict = [readerDayModeDict valueForKey:@"Bookmark"];
        _bookmark_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"icon_color"] != nil ? [tempDict valueForKey:@"icon_color"] :  [defaultTempDict valueForKey:@"icon_color"]];;
        _bookmark_selected_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon-color"] != nil ? [tempDict valueForKey:@"selected_icon-color"] : [defaultTempDict valueForKey:@"selected_icon-color"]];
        _bookmark_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] : [defaultTempDict valueForKey:@"popup_background"]];
        _bookmark_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :  [defaultTempDict valueForKey:@"popup_border"]];
        _bookmark_input_panel_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"input_panel-bg"] != nil ? [tempDict valueForKey:@"input_panel-bg"] :  [defaultTempDict valueForKey:@"input_panel-bg"]];
        _bookmark_hint_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"hint_text-color"] != nil ? [tempDict valueForKey:@"hint_text-color"] : [defaultTempDict valueForKey:@"hint_text-color"]];
        _bookmark_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"text-color"] != nil ? [tempDict valueForKey:@"text-color"] : [defaultTempDict valueForKey:@"text-color"]];
        _bookmark_button_background= [UIColor colorWithHexString:[tempDict valueForKey:@"button_background"] != nil ? [tempDict valueForKey:@"button_background"] : [defaultTempDict valueForKey:@"button_background"]];
        _bookmark_button_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"button_background"] != nil ? [tempDict valueForKey:@"button_background"] : [defaultTempDict valueForKey:@"button_background"]];

        tempDict = [readerDayModeDict valueForKey:@"Search"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Search"];
        _search_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] :  [defaultTempDict valueForKey:@"popup_background"]];
        _search_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :[defaultTempDict valueForKey:@"popup_border"]];
        _search_main_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"main_icon-color"] != nil ? [tempDict valueForKey:@"main_icon-color"] : [defaultTempDict valueForKey:@"main_icon-color"]];
        _search_hint_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"hint_text-color"] != nil ? [tempDict valueForKey:@"hint_text-color"] : [defaultTempDict valueForKey:@"hint_text-color"]];
        _search_title_color= [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] : [defaultTempDict valueForKey:@"title-color"]];
        _search_tab_border= [UIColor colorWithHexString:[tempDict valueForKey:@"tab_border"] != nil ? [tempDict valueForKey:@"tab_border"] : [defaultTempDict valueForKey:@"tab_border"]];
        _search_selected_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"selected_text-color"] != nil ? [tempDict valueForKey:@"selected_text-color"] : [defaultTempDict valueForKey:@"selected_text-color"]];
        _search_separation_background = [UIColor colorWithHexString:[tempDict valueForKey:@"seperation_background"] != nil ? [tempDict valueForKey:@"seperation_background"] : [defaultTempDict valueForKey:@"seperation_background"]];
        _search_cross_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"cross_icon-color"] != nil ? [tempDict valueForKey:@"cross_icon-color"] :[defaultTempDict valueForKey:@"cross_icon-color"]];
        _search_description_color = [UIColor colorWithHexString:[tempDict valueForKey:@"description-color"] != nil ? [tempDict valueForKey:@"description-color"] :[defaultTempDict valueForKey:@"description-color"]];
        _search_subtext_color = [UIColor colorWithHexString:[tempDict valueForKey:@"subtext-color"] != nil ? [tempDict valueForKey:@"subtext-color"] :[defaultTempDict valueForKey:@"subtext-color"]];
        _search_input_panelBg_color = [UIColor colorWithHexString:[tempDict valueForKey:@"input_panel-bg"] != nil ? [tempDict valueForKey:@"input_panel-bg"] :[defaultTempDict valueForKey:@"input_panel-bg"]];
        _search_selection_text_color_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"selection_text_color_bg"] != nil ? [tempDict valueForKey:@"selection_text_color_bg"] :[defaultTempDict valueForKey:@"selection_text_color_bg"]];
        _search_selected_text_color_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_text_color_bg"] != nil ? [tempDict valueForKey:@"selected_text_color_bg"] :[defaultTempDict valueForKey:@"selected_text_color_bg"]];

        tempDict = [readerDayModeDict valueForKey:@"Pentool"];
        defaultTempDict = [readerDayModeDict valueForKey:@"Pentool"];
        _pen_tool_toolbar_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"toolbar"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"toolbar"] valueForKey:@"background"] :  [[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"background"]];
        _pen_tool_toolbar_icons_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"toolbar"] valueForKey:@"icons-color"] != nil ? [[tempDict valueForKey:@"toolbar"] valueForKey:@"icons-color"] :  [[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"icons-color"]];
        _pen_tool_disabled_icon_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] != nil ? [[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] : [[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"icon_color"]];
        _pen_tool_disabled_opacity = [[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"opacity"] != nil ? [[[[tempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"opacity"] doubleValue]: [[[[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"disabled_icon"] valueForKey:@"opacity"] doubleValue];
        _pen_tool_selected_icon_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_background"] != nil ? [[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_background"] : [[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_background"]];
        _pen_tool_selected_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_color"] != nil ? [[tempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_color"] : [[defaultTempDict valueForKey:@"toolbar"] valueForKey:@"selected_icon_color"]];
        _pen_tool_pen_popup_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"Pen"] valueForKey:@"popup_background"] != nil ? [[tempDict valueForKey:@"Pen"] valueForKey:@"popup_background"] :  [[defaultTempDict valueForKey:@"Pen"] valueForKey:@"popup_background"]];
        _pen_tool_pen_popup_border = [UIColor colorWithHexString:[[tempDict valueForKey:@"Pen"] valueForKey:@"popup_border"] != nil ? [[tempDict valueForKey:@"Pen"] valueForKey:@"popup_border"] :  [[defaultTempDict valueForKey:@"Pen"] valueForKey:@"popup_border"]];
        _pen_Color_Array = [NSArray arrayWithArray:[tempDict valueForKey:@"pen-color"] != nil ? [tempDict valueForKey:@"pen-color"]:[defaultTempDict valueForKey:@"pen-color"]];
         _pen_tool_thicknessPopUp_backgroundColor = [UIColor colorWithHexString:[[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_background"] != nil ? [[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_background"] : [[defaultTempDict valueForKey:@"Thickness"] valueForKey:@"popup_background"]];
        _pen_tool_thicknessPopUp_border = [UIColor colorWithHexString:[[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_border"] != nil ? [[tempDict valueForKey:@"Thickness"] valueForKey:@"popup_border"] :  [[defaultTempDict valueForKey:@"Thickness"] valueForKey:@"popup_border"]];

        _pen_tool_slider_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-color"] != nil ? [[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-color"] :[[defaultTempDict valueForKey:@"Thickness"] valueForKey:@"slider-color"]];
        _pen_tool_slider_filled_color= [UIColor colorWithHexString:[[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-filled-color"] != nil ? [[tempDict valueForKey:@"Thickness"] valueForKey:@"slider-filled-color"] :[[defaultTempDict valueForKey:@"Thickness"] valueForKey:@"slider-filled-color"]];
        
        tempDict = [readerDayModeDict valueForKey:@"Thumbnail_Slider"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Thumbnail_Slider"];

        _thumbnail_slider_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] : [defaultTempDict valueForKey:@"popup_background"]];
        _thumbnail_slider_slider_color = [UIColor colorWithHexString:[tempDict valueForKey:@"slider-color"] != nil ? [tempDict valueForKey:@"slider-color"] : [defaultTempDict valueForKey:@"slider-color"]];
        _thumbnail_chapter_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"chapter_icon_color"] != nil ? [tempDict valueForKey:@"chapter_icon_color"] :[defaultTempDict valueForKey:@"chapter_icon_color"]];
        _thumbnail_slider_filled_color = [UIColor colorWithHexString:[tempDict valueForKey:@"slider-filled-color"] != nil ? [tempDict valueForKey:@"slider-filled-color"] :[defaultTempDict valueForKey:@"slider-filled-color"]];
        _thumbnail_default_thumbnail_color = [UIColor colorWithHexString:[tempDict valueForKey:@"default_thumbnail_color"] != nil ? [tempDict valueForKey:@"default_thumbnail_color"] :  [defaultTempDict valueForKey:@"default_thumbnail_color"]];
        _thumbnail_selected_thumbnail_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_thumbnail_color"] != nil ? [tempDict valueForKey:@"selected_thumbnail_color"] :  [defaultTempDict valueForKey:@"selected_thumbnail_color"]];
        _thumbnail_pageNo_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"thumbnail_text-color"] != nil ? [tempDict valueForKey:@"thumbnail_text-color"] : [defaultTempDict valueForKey:@"thumbnail_text-color"]];
        _thumbnail_selected_title_color= [UIColor colorWithHexString:[tempDict valueForKey:@"selected_title_color"] != nil ? [tempDict valueForKey:@"selected_title_color"] :[defaultTempDict valueForKey:@"selected_title_color"]];
        _thumbnail_title_color= [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] :[defaultTempDict valueForKey:@"title-color"]];
        _thumbnail_icon_color= [UIColor colorWithHexString:[tempDict valueForKey:@"icon_color"] != nil ? [tempDict valueForKey:@"icon_color"] : [defaultTempDict valueForKey:@"icon_color"]];
        _thumbnail_botton_bar_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"text-color"] != nil ? [tempDict valueForKey:@"text-color"] :[defaultTempDict valueForKey:@"text-color"]];
        
        tempDict = [readerDayModeDict valueForKey:@"Note"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Note"];
        _note_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] : [defaultTempDict valueForKey:@"popup_background"]];
        _note_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :[defaultTempDict valueForKey:@"popup_border"]];
        _note_title_color = [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] :[defaultTempDict valueForKey:@"title-color"]];
        _note_back_icon_color= [UIColor colorWithHexString:[tempDict valueForKey:@"back_icon-color"] != nil ? [tempDict valueForKey:@"back_icon-color"] :[defaultTempDict valueForKey:@"back_icon-color"]];
        _note_selected_icon_border= [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon_border"] != nil ? [tempDict valueForKey:@"selected_icon_border"] : [defaultTempDict valueForKey:@"selected_icon_border"]];
        _note_contextualtext_color= [UIColor colorWithHexString:[tempDict valueForKey:@"contextualtext-color"] != nil ? [tempDict valueForKey:@"contextualtext-color"] :[defaultTempDict valueForKey:@"contextualtext-color"]];
        _note_hint_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"hint_text-color"] != nil ? [tempDict valueForKey:@"hint_text-color"] :[defaultTempDict valueForKey:@"hint_text-color"]];
        _note_description_color= [UIColor colorWithHexString:[tempDict valueForKey:@"hint_text-color"] != nil ? [tempDict valueForKey:@"description-color"] :[defaultTempDict valueForKey:@"hint_text-color"]];
        _note_note_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"metadata-color"] != nil ? [tempDict valueForKey:@"metadata-color"] :[defaultTempDict valueForKey:@"metadata-color"]];
        
        
        tempDict = [readerDayModeDict valueForKey:@"Share"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Share"];
        _share_share_popup_background= [UIColor colorWithHexString:[tempDict valueForKey:@"share_popup_background"] != nil ? [tempDict valueForKey:@"share_popup_background"] :[defaultTempDict valueForKey:@"share_popup_background"]];
        _share_icon_color= [UIColor colorWithHexString:[tempDict valueForKey:@"icon_color"] != nil ? [tempDict valueForKey:@"icon_color"] :[defaultTempDict valueForKey:@"icon_color"]];
        _share_shareSettings_section_title_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"section_title-color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"section_title-color"] :[[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"section_title-color"]];
        _share_shareSettings_box_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"box_border-color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"box_border-color"] :[[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"box_border-color"]];
        _share_shareSettings_all_box_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"all_box_border-color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"all_box_border-color"] : [[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"all_box_border-color"]];
        _share_shareSettings_check_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"check_color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"check_color"] :  [[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"check_color"]];
        _share_shareSettings_bottom_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"bottom_background"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"bottom_background"] :[[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"bottom_background"]];
        _share_shareSettings_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"text-color"] : [[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"text-color"]];
        _share_shareSettings_main_action_color= [UIColor colorWithHexString:[[tempDict valueForKey:@"share_settings"] valueForKey:@"main_action_color"] != nil ? [[tempDict valueForKey:@"share_settings"] valueForKey:@"main_action_color"] :[[defaultTempDict valueForKey:@"share_settings"] valueForKey:@"main_action_color"]];
        
        //need to resolve here.
        tempDict = [readerDayModeDict valueForKey:@"Comments"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Comments"];
        
       // _share_share_popup_background= [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"]];
        
        _comments_back_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"back_icon_color"] != nil ? [tempDict valueForKey:@"back_icon_color"] :[defaultTempDict valueForKey:@"back_icon_color"]];
        _comments_tab_text_color= [UIColor colorWithHexString:[tempDict valueForKey:@"tab_text_color"] != nil ? [tempDict valueForKey:@"tab_text_color"] :[defaultTempDict valueForKey:@"tab_text_color"]];
        _comments_divider_color = [UIColor colorWithHexString:[tempDict valueForKey:@"divider_color"] != nil ? [tempDict valueForKey:@"divider_color"] :[defaultTempDict valueForKey:@"divider_color"]];
        _comments_other_message_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"other_message"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"other_message"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"other_message"] valueForKey:@"background"]];
        _comments_other_message_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"other_message"] valueForKey:@"border_color"] != nil ? [[tempDict valueForKey:@"other_message"] valueForKey:@"border_color"] :[[defaultTempDict valueForKey:@"other_message"] valueForKey:@"border_color"]];
        _comments_other_message_name_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"other_message"] valueForKey:@"name_color"] != nil ? [[tempDict valueForKey:@"other_message"] valueForKey:@"name_color"] :[[defaultTempDict valueForKey:@"other_message"] valueForKey:@"name_color"]];
        _comments_other_message_description_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"other_message"] valueForKey:@"description-color"] != nil ? [[tempDict valueForKey:@"other_message"] valueForKey:@"description-color"] :[[defaultTempDict valueForKey:@"other_message"] valueForKey:@"description-color"]];
        _comments_other_message_time_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"other_message"] valueForKey:@"time_text_color"] != nil ? [[tempDict valueForKey:@"other_message"] valueForKey:@"time_text_color"] :[[defaultTempDict valueForKey:@"other_message"] valueForKey:@"time_text_color"]];
        _comments_my_message_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"my_message"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"my_message"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"my_message"] valueForKey:@"background"]];
        _comments_my_message_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"my_message"] valueForKey:@"border_color"] != nil ? [[tempDict valueForKey:@"my_message"] valueForKey:@"border_color"] :[[defaultTempDict valueForKey:@"my_message"] valueForKey:@"border_color"]];
        _comments_my_message_name_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"my_message"] valueForKey:@"name_color"] != nil ? [[tempDict valueForKey:@"my_message"] valueForKey:@"name_color"] :[[defaultTempDict valueForKey:@"my_message"] valueForKey:@"name_color"]];
        _comments_my_message_description_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"my_message"] valueForKey:@"description-color"] != nil ? [[tempDict valueForKey:@"my_message"] valueForKey:@"description-color"] :[[defaultTempDict valueForKey:@"my_message"] valueForKey:@"description-color"]];
        _comments_my_message_time_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"my_message"] valueForKey:@"time_text_color"] != nil ? [[tempDict valueForKey:@"my_message"] valueForKey:@"time_text_color"] :[[defaultTempDict valueForKey:@"my_message"] valueForKey:@"time_text_color"]];
        _comments_bottom_panel_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"background"]];
        _comments_bottom_panel_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"border_color"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"border_color"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"border_color"]];
        _comments_bottom_panel_hint_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"hint_text-color"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"hint_text-color"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"hint_text-color"]];
        _comments_bottom_panel_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"text-color"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"text-color"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"text-color"]];
        _comments_bottom_panel_icon_color_disabled = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color_disabled"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color_disabled"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color_disabled"]];
        _comments_bottom_panel_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"bottom_panel"] valueForKey:@"icon_color"]];

        tempDict = [readerDayModeDict valueForKey:@"Teacher_Settings"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Teacher_Settings"];

        _teacherSettings_popup_background =  [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] :[defaultTempDict valueForKey:@"popup_background"]];
        _teacherSettings_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :  [defaultTempDict valueForKey:@"popup_border"]];
        _teacherSettings_title_color = [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] :[defaultTempDict valueForKey:@"title-color"]];
        _teacherSettings_main_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"main_icon-color"] != nil ? [tempDict valueForKey:@"main_icon-color"] :[defaultTempDict valueForKey:@"main_icon-color"]];
        _teacherSettings_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"text-color"] != nil ? [tempDict valueForKey:@"text-color"] :[defaultTempDict valueForKey:@"text-color"]];
        _teacherSettings_selected_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon-color"] != nil ? [tempDict valueForKey:@"selected_icon-color"] :[defaultTempDict valueForKey:@"selected_icon-color"]];
        _teacherSettings_selected_icon_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon_bg"] != nil ? [tempDict valueForKey:@"selected_icon_bg"] :[defaultTempDict valueForKey:@"selected_icon_bg"]];
        _teacherSettings_pen1_color = [UIColor colorWithHexString:[tempDict valueForKey:@"pen1-color"] != nil ? [tempDict valueForKey:@"pen1-color"] :[defaultTempDict valueForKey:@"pen1-color"]];
        _teacherSettings_pen2_color = [UIColor colorWithHexString:[tempDict valueForKey:@"pen2-color"] != nil ? [tempDict valueForKey:@"pen2-color"] :[defaultTempDict valueForKey:@"pen2-color"]];
        _teacherSettings_box_border_color = [UIColor colorWithHexString:[tempDict valueForKey:@"box_border-color"] != nil ? [tempDict valueForKey:@"box_border-color"] :[defaultTempDict valueForKey:@"box_border-color"]];
        _teacherSettings_check_color = [UIColor colorWithHexString:[tempDict valueForKey:@"check_color"] != nil ? [tempDict valueForKey:@"check_color"] :[defaultTempDict valueForKey:@"check_color"]];
        
        tempDict = [readerDayModeDict valueForKey:@"Teacher_studentlist"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Teacher_Settings"];
        _teacher_studentlist_popup_background = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_background"] != nil ? [tempDict valueForKey:@"popup_background"] :[defaultTempDict valueForKey:@"popup_background"]];
        _teacher_studentlist_popup_border = [UIColor colorWithHexString:[tempDict valueForKey:@"popup_border"] != nil ? [tempDict valueForKey:@"popup_border"] :[defaultTempDict valueForKey:@"popup_border"]];
        _teacher_studentlist_shadow = [UIColor colorWithHexString:[tempDict valueForKey:@"shadow"] != nil ? [tempDict valueForKey:@"shadow"] :[defaultTempDict valueForKey:@"shadow"]];
        _teacher_studentlist_title_color = [UIColor colorWithHexString:[tempDict valueForKey:@"title-color"] != nil ? [tempDict valueForKey:@"title-color"] :[defaultTempDict valueForKey:@"title-color"]];
        _teacher_studentlist_hint_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"hint_text-color"] != nil ? [tempDict valueForKey:@"hint_text-color"] :[defaultTempDict valueForKey:@"hint_text-color"]];
        _teacher_studentlist_tab_border = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_border"] != nil ? [tempDict valueForKey:@"tab_border"] :[defaultTempDict valueForKey:@"tab_border"]];
        _teacher_studentlist_tab_selected_bar = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_selected_bar"] != nil ? [tempDict valueForKey:@"tab_selected_bar"] :[defaultTempDict valueForKey:@"tab_selected_bar"]];
        _teacher_studentlist_tab_text_color = [UIColor colorWithHexString:[tempDict valueForKey:@"tab_text-color"] != nil ? [tempDict valueForKey:@"tab_text-color"] :[defaultTempDict valueForKey:@"tab_text-color"]];
        _teacher_studentlist_name_color = [UIColor colorWithHexString:[tempDict valueForKey:@"name_color"] != nil ? [tempDict valueForKey:@"name_color"] :[defaultTempDict valueForKey:@"name_color"]];
        _teacher_studentlist_data_added_color = [UIColor colorWithHexString:[tempDict valueForKey:@"data_added_color"] != nil ? [tempDict valueForKey:@"data_added_color"] :[defaultTempDict valueForKey:@"data_added_color"]];
        _teacher_studentlist_nodata_added_color = [UIColor colorWithHexString:[tempDict valueForKey:@"nodata_added_color"] != nil ? [tempDict valueForKey:@"nodata_added_color"] :[defaultTempDict valueForKey:@"nodata_added_color"]];
        _teacher_studentlist_refresh_box_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"refresh"] valueForKey:@"box_border-color"] != nil ? [[tempDict valueForKey:@"refresh"] valueForKey:@"box_border-color"] :[[defaultTempDict valueForKey:@"refresh"] valueForKey:@"box_border-color"]];
        _teacher_studentlist_refresh_button_text_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"refresh"] valueForKey:@"button_text-color"] != nil ? [[tempDict valueForKey:@"refresh"] valueForKey:@"button_text-color"] :[[defaultTempDict valueForKey:@"refresh"] valueForKey:@"button_text-color"]];
        _teacher_studentlist_selected_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_color"] != nil ? [tempDict valueForKey:@"selected_color"] :[defaultTempDict valueForKey:@"selected_color"]];
        tempDict = [[readerDayModeDict valueForKey:@"Teacher_Settings"] valueForKey:@"Teacher_studentlist"];
        _teacher_studentlist_class_text_color = ColorWithHex([tempDict valueForKey:@"Class-Text-color"]);
        _teacher_studentlist_change_text_color = ColorWithHex([tempDict valueForKey:@"Change-Text-color"]);
        _teacher_studentlist_search_input_panel_color = ColorWithHex([[tempDict valueForKey:@"Search"] valueForKey:@"input_panel"]);
        _teacher_studentlist_search_main_icon_color = ColorWithHex([[tempDict valueForKey:@"Search"] valueForKey:@"main_icon-color"]);
        _teacher_studentlist_search_hint_text_color = ColorWithHex([[tempDict valueForKey:@"Search"] valueForKey:@"hint_text-color"]);
        _teacher_studentlist_search_text_color = ColorWithHex([[tempDict valueForKey:@"Search"] valueForKey:@"text-color"]);
        _teacher_studentlist_search_clear_icon_color = ColorWithHex([[tempDict valueForKey:@"Search"] valueForKey:@"clear-icon-color"]);
        
        tempDict = [readerDayModeDict valueForKey:@"Highlight"];
        defaultTempDict = [defaultReaderDayModeDict valueForKey:@"Highlight"];
        _highlight_popup_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"popup"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"popup"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"popup"] valueForKey:@"background"]];
        _highlight_popup_border = [UIColor colorWithHexString:[[tempDict valueForKey:@"popup"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"popup"] valueForKey:@"border"] :[[defaultTempDict valueForKey:@"popup"] valueForKey:@"border"]];
        _highlight_popup_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"icon_color"]!= nil ? [tempDict valueForKey:@"icon_color"] :[defaultTempDict valueForKey:@"icon_color"]];
        _highlight_Color_Array = [NSArray arrayWithArray:[tempDict valueForKey:@"highlightColor"] != nil ? [tempDict valueForKey:@"highlightColor"]:[defaultTempDict valueForKey:@"highlightColor"]];
        
        NSDictionary *glossaryDict = [jsonDict valueForKey:@"Reader"];
       _glossary_underline_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"link_line_color"] != nil ? [glossaryDict valueForKey:@"link_line_color"] :[defaultGlossaeyDict valueForKey:@"link_line_color"]];
        _glossary_popup_background_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"popup_background"] != nil ? [glossaryDict valueForKey:@"popup_background"] :[defaultGlossaeyDict valueForKey:@"popup_background"]];
        _glossary_icon_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"icon_color"] != nil ? [glossaryDict valueForKey:@"icon_color"] :[defaultGlossaeyDict valueForKey:@"icon_color"]];
        _glossary_icon_border_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"icon_border_color"] != nil ? [glossaryDict valueForKey:@"icon_border_color"] :[defaultGlossaeyDict valueForKey:@"icon_border_color"]];
        _glossary_alphabet_label_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"title-color"] != nil ? [glossaryDict valueForKey:@"title-color"] :[defaultGlossaeyDict valueForKey:@"title-color"]];
        _glossary_keyword_label_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"language_text_color"] != nil ? [glossaryDict valueForKey:@"language_text_color"] :[defaultGlossaeyDict valueForKey:@"language_text_color"]];
        _glossary_description_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"description_text_color"] != nil ? [glossaryDict valueForKey:@"description_text_color"] :[defaultGlossaeyDict valueForKey:@"description_text_color"]];
        _glossary_synonym_color = [UIColor colorWithHexString:[glossaryDict valueForKey:@"synonym_text_color"] != nil ? [glossaryDict valueForKey:@"synonym_text_color"] :[defaultGlossaeyDict valueForKey:@"synonym_text_color"]];
        
        tempDict = [jsonDict valueForKey:@"Text_Annotation"];
        defaultTempDict = [defaultJson valueForKey:@"Text_Annotation"];
        _textAnnotation_background = [UIColor colorWithHexString:[tempDict valueForKey:@"background"] != nil ? [tempDict valueForKey:@"background"] :[defaultTempDict valueForKey:@"background"]];
        _textAnnotation_lineColor = [UIColor colorWithHexString:[tempDict valueForKey:@"line_color"] != nil ? [tempDict valueForKey:@"line_color"] :[defaultTempDict valueForKey:@"line_color"]];
        _textAnnotation_iconsColor = [UIColor colorWithHexString:[tempDict valueForKey:@"icons-color"] != nil ? [tempDict valueForKey:@"icons-color"] :[defaultTempDict valueForKey:@"icons-color"]];
        _textAnnotation_disabled_iconColor = [UIColor colorWithHexString:[[tempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"disabled_icon"] valueForKey:@"icon_color"]];
        _textAnnotation_selected_icon_bg = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon-bg"] != nil ? [tempDict valueForKey:@"selected_icon-bg"] :[defaultTempDict valueForKey:@"selected_icon-bg"]];
        _textAnnotation_selected_icon_color = [UIColor colorWithHexString:[tempDict valueForKey:@"selected_icon-color"] != nil ? [tempDict valueForKey:@"selected_icon-color"] :[defaultTempDict valueForKey:@"selected_icon-color"]];
        _textAnnotation_align_popup_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"align_popup"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"align_popup"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"align_popup"] valueForKey:@"background"]];
        _textAnnotation_align_popup_icon_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"align_popup"] valueForKey:@"icon_color"] != nil ? [[tempDict valueForKey:@"align_popup"] valueForKey:@"icon_color"] :[[defaultTempDict valueForKey:@"align_popup"] valueForKey:@"icon_color"]];
        _textAnnotation_align_popup_selected_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"align_popup"] valueForKey:@"selected_border_color"] != nil ? [[tempDict valueForKey:@"align_popup"] valueForKey:@"selected_border_color"] :[[defaultTempDict valueForKey:@"align_popup"] valueForKey:@"selected_border_color"]];
        _textAnnotation_color_popup_background = [UIColor colorWithHexString:[[tempDict valueForKey:@"color_popup"] valueForKey:@"background"] != nil ? [[tempDict valueForKey:@"color_popup"] valueForKey:@"background"] :[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"background"]];
        _textAnnotation_color_popup_selected_border_color = [UIColor colorWithHexString:[[tempDict valueForKey:@"color_popup"] valueForKey:@"selected_border_color"] != nil ? [[tempDict valueForKey:@"color_popup"] valueForKey:@"selected_border_color"] :[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"selected_border_color"]];
        _textAnnotation_color_popup_color1_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color1_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color1"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color2_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color2_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color2"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color3_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color3_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color3"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color4_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color4_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color4"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color5_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color5_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color5"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color6_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color6_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color6"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color7_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color7_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color7"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color8_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color8_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color8"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color9_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color9_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color9"] valueForKey:@"text-color"]];
        _textAnnotation_color_popup_color10_background = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"background"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"background"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"background"]];
        _textAnnotation_color_popup_color10_text_color = [UIColor colorWithHexString:[[[tempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"text-color"] != nil ? [[[tempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"text-color"] :[[[defaultTempDict valueForKey:@"color_popup"] valueForKey:@"color10"] valueForKey:@"text-color"]];
        
        tempDict = [readerDayModeDict valueForKey:@"FontSettings"];
        _fontSettings_popup_background =  ColorWithHex([tempDict valueForKey:@"popup_background"]);
        _fontSettings_popup_border = ColorWithHex([tempDict valueForKey:@"popup_border"]);
        _fontSettings_selected_text_color = ColorWithHex([tempDict valueForKey:@"selected_text-color"]);
        _fontSettings_reset_color = ColorWithHex([tempDict valueForKey:@"reset-color"]);
        _fontSettings_font_text_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"text-color"]);
        _fontSettings_font_divider_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"divider-color"]);
        _fontSettings_font_pointer_bg = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"pointer_bg"]);
        _fontSettings_font_icon_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"icon_color"]);
        _fontSettings_font_box_border_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"box_border-color"]);
        _fontSettings_font_selected_icon_border = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"selected_icon-border"]);
        _fontSettings_font_dropdown_text_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"dropdown_text-color"]);
        _fontSettings_font_more_icon_color = ColorWithHex([[tempDict valueForKey:@"Font"] valueForKey:@"more_icon-color"]);
        _fontSettings_other_icon_color = ColorWithHex([[tempDict valueForKey:@"Other"] valueForKey:@"icon_color"]);
        _fontSettings_other_selected_icon_color = ColorWithHex([[tempDict valueForKey:@"Other"] valueForKey:@"selected_icon-color"]);
        _fontSettings_other_brightness_slider_color = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"Brightness"] valueForKey:@"slider-color"]);
        _fontSettings_Other_ScrollView_tab_bg = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"tab_bg"]);
        _fontSettings_Other_ScrollView_selected_Tab_bg = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"selected_Tab_bg"]);
        _fontSettings_Other_ScrollView_selected_text_color = ColorWithHex([[[tempDict valueForKey:@"Other"] valueForKey:@"ScrollView"] valueForKey:@"selected_text-color"]);
    }
}

@end
