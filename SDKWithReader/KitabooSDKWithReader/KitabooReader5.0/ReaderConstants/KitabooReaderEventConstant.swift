//
//  KitabooReaderEventConstant.swift
//  KitabooSDKWithReader
//
//  Created by Sumanth Myrala on 05/10/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

import UIKit

@objc public class KitabooReaderEventConstant: NSObject
{
    @objc public static let bookmarkEventName: String = "bookmark_data_live"
    @objc public static let pentoolEventName: String = "pen_tool_data_live"
    @objc public static let protractorEventName: String = "protractor_data_live"
    @objc public static let equationEditorEventName: String = "equation_editor_data_live"
    @objc public static let readAloudEventName: String = "read_aloud_data_live"
    @objc public static let homeButtonEventName: String = "home_button_use_live"
    @objc public static let tocEventName: String = "toc_icon_use_live"
    @objc public static let thumbnailEventName: String = "thumbnail_data_live"
    @objc public static let teacherReviewEventName: String = "teacher_review_data_live"
    @objc public static let fontResetEventName: String = "reset_data_live"

    @objc public static let highlightEventName: String = "highlight_data_live"
    @objc public static let highlightEventParameterNoteColor: String = "note_color"
    
    @objc public static let stickyNoteEventName: String = "sticky_note_data_live"
    @objc public static let stickyNoteEventParameterNoteColor: String = "note_color"
    
    @objc public static let contextualNoteEventName: String = "contextual_note_data_live"
    @objc public static let contextualNoteEventParameterNoteColor: String = "note_color"
    
    @objc public static let searchEventName: String = "search_performed_live"
    @objc public static let searchEventParameterSearchText: String = "search_text"
    
    @objc public static let fontFamilyEventName: String = "font_data_live"
    @objc public static let fontFamilyEventParameterFontValue: String = "font_value"
    
    @objc public static let fontSizeEventName: String = "font_size_data_live"
    @objc public static let fontSizeEventParameterFontSizeValue: String = "font_size_value"
    
    @objc public static let fontAlignmentDataEventName: String = "alignment_data_live"
    @objc public static let fontAlignmentDataEventParameterFontAlignment: String = "font_alignment"
    
    @objc public static let fontLineSpacingEventName: String = "line_spacing_data_live"
    @objc public static let fontLineSpacingEventParameterFontLineSpacing: String = "font_line_spacing"
    
    @objc public static let fontMarginDataEventName: String = "margin_data_live"
    @objc public static let fontMarginDataEventParameterFontMarginData: String = "font_margin"
    
    @objc public static let fontReadingModeEventName: String = "reading_mode_data_live"
    @objc public static let fontReadingModeEventParameterFontReadingMode: String = "font_reading_mode"
       
    @objc public static let fontScrollViewEventName: String = "scroll_view_data_live"
    @objc public static let fontScrollViewEventParameterFontScrollView: String = "font_scroll_view"
    
    @objc public static let markupEventName: String = "markup_live"
    @objc public static let markupEventParameterKey: String = "markup_type"
    @objc public static let markupEventNormalVideoParameterValue: String = "Normal Video"
    @objc public static let markupEventYoutubeVideoParameterValue: String = "You tube video"
    @objc public static let markupEventInlineVideoParameterValue: String = "Inline video"
    @objc public static let markupEventDocumentParameterValue: String = "Document"
    @objc public static let markupEventKitabooWidgetParameterValue: String = "Kitaboo Widget"
    @objc public static let markupEventHTMLActivityParameterValue: String = "HTML Activity"
    @objc public static let markupEventWebLinkParameterValue: String = "Web Link"
    @objc public static let markupEventScormParameterValue: String = "Scorm"
    @objc public static let markupEventFIBParameterValue: String = "FIB"
    @objc public static let markupEventKalturaVideoParameterValue: String = "Kaltura Video"
    @objc public static let markupEventImageParameterValue: String = "Image"
    @objc public static let markupEventImageSlideShowParameterValue: String = "Image Slide show"
    @objc public static let markupEventInstructionMarkupParameterValue: String = "Instruction markup"
    @objc public static let markupEventAudioSyncParameterValue: String = "Audio Sync"
    @objc public static let markupEventAudioParameterValue: String = "Audio"
    @objc public static let markupEventGotoPageParameterValue: String = "Goto page"
    @objc public static let markupEventMultilinkMarkupParameterValue: String = "Multilink Markup"
    @objc public static let markupEventDropDownParameterValue: String = "Drop Down"
    @objc public static let markupEventJumpToBookParameterValue: String = "Goto/Jump to Book"
    @objc public static let markupEventImageMagnificationParameterValue: String = "Image Magnification"
}
