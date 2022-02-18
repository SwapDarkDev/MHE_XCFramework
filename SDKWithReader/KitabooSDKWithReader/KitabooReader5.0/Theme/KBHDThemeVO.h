//
//  HDThemeVO.h
//  KItabooSDK
//
//  Created by Hurix System on 22/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KBHDThemeVO : NSObject
{
    NSMutableSet *_listeners;
    NSDictionary *defaultJson;
}

@property (nonatomic, strong)UIColor *canvas_background;

@property (nonatomic, strong)UIColor *top_toolbar_background;
@property (nonatomic, strong)UIColor *top_toolbar_icons_color;
@property (nonatomic, strong)UIColor *top_toolbar_shadow;
@property (nonatomic, strong)UIColor *top_toolbar_selected_icon_color;
@property (nonatomic, strong)UIColor *top_toolbar_selected_icon_bg;

@property (nonatomic, strong)UIColor *side_bottom_background;
@property (nonatomic, strong)UIColor *side_bottom_icons_color;
@property (nonatomic, strong)UIColor *side_bottom_shadow;
@property (nonatomic, strong)UIColor *side_bottom_selected_icon_color;
@property (nonatomic, strong)UIColor *side_bottom_selected_icon_bg;

@property (nonatomic, strong)UIColor *toc_overlay_panel_background;
@property (nonatomic, assign)CGFloat toc_overlay_panel_opacity;
@property (nonatomic, strong)UIColor *toc_popup_background;
@property (nonatomic, strong)UIColor *toc_popup_border;
@property (nonatomic, strong)UIColor *toc_tab_bg;
@property (nonatomic, strong)UIColor *toc_tab_border;
@property (nonatomic, strong)UIColor *toc_tab_text_color;
@property (nonatomic, strong)UIColor *toc_selected_tab_border;
@property (nonatomic, strong)UIColor *toc_selected_text_color;
@property (nonatomic, strong)UIColor *toc_selected_toc_section_background;
@property (nonatomic, strong)UIColor *toc_selected_toc_section_divider;
@property (nonatomic, strong)UIColor *toc_selected_toc_title_color;
@property (nonatomic, strong)UIColor *toc_selected_toc_title_description_color;
@property (nonatomic, strong)UIColor *toc_selected_toc_arrow_color;
@property (nonatomic, strong)UIColor *toc_selected_toc_icon_color;
@property (nonatomic, strong)UIColor *toc_selected_toc_side_tab_background;
@property (nonatomic, strong)UIColor *toc_title_color;
@property (nonatomic, strong)UIColor *toc_description_color;
@property (nonatomic, strong)UIColor *toc_pageno_color;
@property (nonatomic, strong)UIColor *toc_more_icon_color;
@property (nonatomic, strong)UIColor *toc_divider_color;
@property (nonatomic, strong)UIColor *toc_close_slider_background;
@property (nonatomic, strong)UIColor *toc_close_slider_icon_color;

@property (nonatomic, strong)UIColor *mydata_overlay_panel_background;
@property (nonatomic, assign)CGFloat mydata_overlay_panel_opacity;
@property (nonatomic, strong)UIColor *mydata_popup_background;
@property (nonatomic, strong)UIColor *mydata_popup_border;
@property (nonatomic, strong)UIColor *mydata_tab_bg;
@property (nonatomic, strong)UIColor *mydata_tab_border;
@property (nonatomic, strong)UIColor *mydata_tab_text_color;
@property (nonatomic, strong)UIColor *mydata_selected_tab_border;
@property (nonatomic, strong)UIColor *mydata_selected_text_color;
@property (nonatomic, strong)UIColor *mydata_selected_button_background;
@property (nonatomic, strong)UIColor *mydata_selected_button_text_color;
@property (nonatomic, strong)UIColor *mydata_deselected_button_background;
@property (nonatomic, strong)UIColor *mydata_deselected_button_text_color;
@property (nonatomic, strong)UIColor *mydata_tabs_icon_color;
@property (nonatomic, strong)UIColor *mydata_disabled_tabs_icon_color;
@property (nonatomic, assign)CGFloat mydata_disabled_icon_opacity;
@property (nonatomic, strong)UIColor *mydata_chpater_text_color;
@property (nonatomic, strong)UIColor *mydata_page_date_text_color;
@property (nonatomic, strong)UIColor *mydata_contextual_text_color;
@property (nonatomic, strong)UIColor *mydata_note_text_color;
@property (nonatomic, strong)UIColor *mydata_commentShare_button_text_icon_color;
@property (nonatomic, strong)UIColor *mydata_commentShare_button_disabled_text_icon_color;
@property (nonatomic, strong)UIColor *mydata_notification_circle_color;

@property (nonatomic, strong)UIColor *filterPopUp_background;
@property (nonatomic, strong)UIColor *filterPopUp_border_color;
@property (nonatomic, strong)UIColor *filterPopUp_all_box_border_color;
@property (nonatomic, strong)UIColor *filterPopUp_check_color;
@property (nonatomic, strong)UIColor *filterPopUp_text_color;
@property (nonatomic, strong)UIColor *filterPopUp_arrow_color;
@property (nonatomic, strong)UIColor *filterPopUp_action_text_color;
@property (nonatomic, strong)UIColor *filterPopUp_color_box_border_color;

@property (nonatomic, strong)UIColor *settings_background;
@property (nonatomic, strong)UIColor *settings_header_title_color;
@property (nonatomic, strong)UIColor *settings_icon_color;
@property (nonatomic, strong)UIColor *settings_box_border_color;
@property (nonatomic, strong)UIColor *settings_section_title_color;
@property (nonatomic, strong)UIColor *settings_text_color;
@property (nonatomic, strong)UIColor *settings_check_color;
@property (nonatomic, strong)UIColor *settings_done_button_background;
@property (nonatomic, strong)UIColor *settings_done_button_text_color;
@property (nonatomic, strong)UIColor *settings_cancel_button_border_color;
@property (nonatomic, strong)UIColor *settings_cancel_button_text_color;

@property (nonatomic, strong)UIColor *bookmark_icon_color;
@property (nonatomic, strong)UIColor *bookmark_selected_icon_color;
@property (nonatomic, strong)UIColor *bookmark_popup_background;
@property (nonatomic, strong)UIColor *bookmark_popup_border;
@property (nonatomic, strong)UIColor *bookmark_input_panel_bg;
@property (nonatomic, strong)UIColor *bookmark_hint_text_color;
@property (nonatomic, strong)UIColor *bookmark_text_color;
@property (nonatomic, strong)UIColor *bookmark_button_background;
@property (nonatomic, strong)UIColor *bookmark_button_text_color;

@property (nonatomic, strong)UIColor *search_popup_background;
@property (nonatomic, strong)UIColor *search_popup_border;
@property (nonatomic, strong)UIColor *search_main_icon_color;
@property (nonatomic, strong)UIColor *search_hint_text_color;
@property (nonatomic, strong)UIColor *search_title_color;
@property (nonatomic, strong)UIColor *search_tab_border;
@property (nonatomic, strong)UIColor *search_selected_text_color;
@property (nonatomic, strong)UIColor *search_separation_background;
@property (nonatomic, strong)UIColor *search_cross_icon_color;
@property (nonatomic, strong)UIColor *search_description_color;
@property (nonatomic, strong)UIColor *search_subtext_color;
@property (nonatomic, strong)UIColor *search_input_panelBg_color;
@property (nonatomic, strong)UIColor *search_selection_text_color_bg;
@property (nonatomic, strong)UIColor *search_selected_text_color_bg;

@property (nonatomic, strong)UIColor *pen_tool_toolbar_background;
@property (nonatomic, strong)UIColor *pen_tool_toolbar_icons_color;
@property (nonatomic, strong)UIColor *pen_tool_disabled_icon_color;
@property (nonatomic, assign)CGFloat pen_tool_disabled_opacity;
@property (nonatomic, strong)UIColor *pen_tool_selected_icon_background;
@property (nonatomic, strong)UIColor *pen_tool_selected_icon_color;
@property (nonatomic, strong)UIColor *pen_tool_pen_popup_background;
@property (nonatomic, strong)UIColor *pen_tool_pen_popup_border;
@property (nonatomic, strong)UIColor *pen_tool_slider_color;
@property (nonatomic, strong)UIColor *pen_tool_slider_filled_color;
@property (nonatomic, strong)UIColor *pen_tool_thicknessPopUp_backgroundColor;
@property (nonatomic, strong)UIColor *pen_tool_thicknessPopUp_border;
@property (nonatomic, strong)UIColor *pen_tool_pen_color;

@property (nonatomic, strong)UIColor *thumbnail_slider_popup_background;
@property (nonatomic, strong)UIColor *thumbnail_slider_slider_color;
@property (nonatomic, strong)UIColor *thumbnail_chapter_icon_color;
@property (nonatomic, strong)UIColor *thumbnail_slider_filled_color;
@property (nonatomic, strong)UIColor *thumbnail_default_thumbnail_color;
@property (nonatomic, strong)UIColor *thumbnail_selected_thumbnail_color;
@property (nonatomic, strong)UIColor *thumbnail_pageNo_text_color;
@property (nonatomic, strong)UIColor *thumbnail_selected_title_color;
@property (nonatomic, strong)UIColor *thumbnail_title_color;
@property (nonatomic, strong)UIColor *thumbnail_icon_color;
@property (nonatomic, strong)UIColor *thumbnail_botton_bar_text_color;

@property (nonatomic, strong)UIColor *note_popup_background;
@property (nonatomic, strong)UIColor *note_popup_border;
@property (nonatomic, strong)UIColor *note_title_color;
@property (nonatomic, strong)UIColor *note_back_icon_color;
@property (nonatomic, strong)UIColor *note_selected_icon_border;
@property (nonatomic, strong)UIColor *note_contextualtext_color;
@property (nonatomic, strong)UIColor *note_hint_text_color;
@property (nonatomic, strong)UIColor *note_description_color;
@property (nonatomic, strong)UIColor *note_note_text_color;

@property (nonatomic, strong)UIColor *share_share_popup_background;
@property (nonatomic, strong)UIColor *share_icon_color;
@property (nonatomic, strong)UIColor *share_shareSettings_section_title_color;
@property (nonatomic, strong)UIColor *share_shareSettings_box_border_color;
@property (nonatomic, strong)UIColor *share_shareSettings_all_box_border_color;
@property (nonatomic, strong)UIColor *share_shareSettings_check_color;
@property (nonatomic, strong)UIColor *share_shareSettings_bottom_background;
@property (nonatomic, strong)UIColor *share_shareSettings_text_color;
@property (nonatomic, strong)UIColor *share_shareSettings_main_action_color;

@property (nonatomic, strong)UIColor *comments_back_icon_color;
@property (nonatomic, strong)UIColor *comments_tab_text_color;
@property (nonatomic, strong)UIColor *comments_divider_color;
@property (nonatomic, strong)UIColor *comments_other_message_background;
@property (nonatomic, strong)UIColor *comments_other_message_border_color;
@property (nonatomic, strong)UIColor *comments_other_message_name_color;
@property (nonatomic, strong)UIColor *comments_other_message_description_color;
@property (nonatomic, strong)UIColor *comments_other_message_time_text_color;
@property (nonatomic, strong)UIColor *comments_my_message_background;
@property (nonatomic, strong)UIColor *comments_my_message_border_color;
@property (nonatomic, strong)UIColor *comments_my_message_name_color;
@property (nonatomic, strong)UIColor *comments_my_message_description_color;
@property (nonatomic, strong)UIColor *comments_my_message_time_text_color;
@property (nonatomic, strong)UIColor *comments_bottom_panel_background;
@property (nonatomic, strong)UIColor *comments_bottom_panel_border_color;
@property (nonatomic, strong)UIColor *comments_bottom_panel_hint_text_color;
@property (nonatomic, strong)UIColor *comments_bottom_panel_text_color;
@property (nonatomic, strong)UIColor *comments_bottom_panel_icon_color_disabled;
@property (nonatomic, strong)UIColor *comments_bottom_panel_icon_color;



@property (nonatomic, strong)UIColor *fontSettings_overlayPanel_background;
@property (nonatomic, strong)UIColor *fontSettings_overlayPanel_opacity;
@property (nonatomic, strong)UIColor *fontSettings_popup_background;
@property (nonatomic, strong)UIColor *fontSettings_popup_border;
@property (nonatomic, strong)UIColor *fontSettings_tab_border;
@property (nonatomic, strong)UIColor *fontSettings_tab_text_color;
@property (nonatomic, strong)UIColor *fontSettings_selected_tab_border;
@property (nonatomic, strong)UIColor *fontSettings_selected_text_color;
@property (nonatomic, strong)UIColor *fontSettings_reset_color;
@property (nonatomic, strong)UIColor *fontSettings_font_text_color;
@property (nonatomic, strong)UIColor *fontSettings_font_divider_color;
@property (nonatomic, strong)UIColor *fontSettings_font_pointer_bg;
@property (nonatomic, strong)UIColor *fontSettings_font_icon_color;
@property (nonatomic, strong)UIColor *fontSettings_font_box_border_color;
@property (nonatomic, strong)UIColor *fontSettings_font_selected_icon_bg;
@property (nonatomic, strong)UIColor *fontSettings_font_selected_icon_border;
@property (nonatomic, strong)UIColor *fontSettings_font_dropdown_bg;
@property (nonatomic, strong)UIColor *fontSettings_font_dropdown_text_color;
@property (nonatomic, strong)UIColor *fontSettings_font_more_icon_color;
@property (nonatomic, strong)UIColor *fontSettings_other_text_color;
@property (nonatomic, strong)UIColor *fontSettings_other_icon_color;
@property (nonatomic, strong)UIColor *fontSettings_other_selected_icon_color;
@property (nonatomic, strong)UIColor *fontSettings_other_brightness_slider_color;
@property (nonatomic, strong)UIColor *fontSettings_other_brightness_slider_selected_color;
@property (nonatomic, strong)UIColor *fontSettings_other_brightness_icon_faded;
@property (nonatomic, strong)UIColor *fontSettings_other_brightness_icon_bright;
@property (nonatomic, strong)UIColor *fontSettings_other_mode;
@property (nonatomic, strong)UIColor *fontSettings_mode_selected_tab_border;
@property (nonatomic, strong)UIColor *fontSettings_mode_day_tab_bg;
@property (nonatomic, strong)UIColor *fontSettings_mode_day_text_color;
@property (nonatomic, strong)UIColor *fontSettings_mode_night_tab_bg;
@property (nonatomic, strong)UIColor *fontSettings_mode_night_text_color;
@property (nonatomic, strong)UIColor *fontSettings_mode_sepia_text_color;
@property (nonatomic, strong)UIColor *fontSettings_mode_sepia_tab_bg;
@property (nonatomic, strong)UIColor *fontSettings_Other_ScrollView_tab_bg;
@property (nonatomic, strong)UIColor *fontSettings_Other_ScrollView_selected_Tab_bg;
@property (nonatomic, strong)UIColor *fontSettings_Other_ScrollView_selected_text_color;

@property (nonatomic, strong)UIColor *teacherSettings_popup_background;
@property (nonatomic, strong)UIColor *teacherSettings_popup_border;
@property (nonatomic, strong)UIColor *teacherSettings_title_color;
@property (nonatomic, strong)UIColor *teacherSettings_main_icon_color;
@property (nonatomic, strong)UIColor *teacherSettings_text_color;
@property (nonatomic, strong)UIColor *teacherSettings_selected_icon_color;
@property (nonatomic, strong)UIColor *teacherSettings_selected_icon_bg;
@property (nonatomic, strong)UIColor *teacherSettings_pen1_color;
@property (nonatomic, strong)UIColor *teacherSettings_pen2_color;
@property (nonatomic, strong)UIColor *teacherSettings_box_border_color;
@property (nonatomic, strong)UIColor *teacherSettings_check_color;

@property (nonatomic, strong)UIColor *teacher_studentlist_popup_background;
@property (nonatomic, strong)UIColor *teacher_studentlist_popup_border;
@property (nonatomic, strong)UIColor *teacher_studentlist_shadow;
@property (nonatomic, strong)UIColor *teacher_studentlist_title_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_hint_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_tab_border;
@property (nonatomic, strong)UIColor *teacher_studentlist_tab_selected_bar;
@property (nonatomic, strong)UIColor *teacher_studentlist_tab_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_name_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_data_added_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_nodata_added_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_refresh_box_border_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_refresh_button_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_selected_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_class_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_change_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_search_input_panel_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_search_main_icon_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_search_hint_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_search_text_color;
@property (nonatomic, strong)UIColor *teacher_studentlist_search_clear_icon_color;

@property (nonatomic, strong)UIColor *textAnnotation_background;
@property (nonatomic, strong)UIColor *textAnnotation_lineColor;
@property (nonatomic, strong)UIColor *textAnnotation_iconsColor;
@property (nonatomic, strong)UIColor *textAnnotation_disabled_iconColor;
@property (nonatomic, strong)UIColor *textAnnotation_selected_icon_bg;
@property (nonatomic, strong)UIColor *textAnnotation_selected_icon_color;
@property (nonatomic, strong)UIColor *textAnnotation_align_popup_background;
@property (nonatomic, strong)UIColor *textAnnotation_align_popup_icon_color;
@property (nonatomic, strong)UIColor *textAnnotation_align_popup_selected_border_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_selected_border_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color1_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color1_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color2_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color2_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color3_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color3_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color4_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color4_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color5_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color5_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color6_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color6_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color7_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color7_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color8_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color8_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color9_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color9_text_color;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color10_background;
@property (nonatomic, strong)UIColor *textAnnotation_color_popup_color10_text_color;

@property (nonatomic, strong)UIColor *highlight_popup_background;
@property (nonatomic, strong)UIColor *highlight_popup_border;
@property (nonatomic, strong)UIColor *highlight_popup_icon_color;
@property (nonatomic, strong)NSArray *highlight_Color_Array;

@property (nonatomic, strong)UIColor *glossary_underline_color;
@property (nonatomic, strong)UIColor *glossary_popup_background_color;
@property (nonatomic, strong)UIColor *glossary_icon_color;
@property (nonatomic, strong)UIColor *glossary_icon_border_color;
@property (nonatomic, strong)UIColor *glossary_alphabet_label_color;
@property (nonatomic, strong)UIColor *glossary_keyword_label_color;
@property (nonatomic, strong)UIColor *glossary_description_color;
@property (nonatomic, strong)UIColor *glossary_synonym_color;

@property (nonatomic, strong)NSArray *pen_Color_Array;
-(void) updateThemeFromFileAtPath:(NSString *)filepath;
//-(void) updateFromServer:(NSDictionary*)data;
@end
