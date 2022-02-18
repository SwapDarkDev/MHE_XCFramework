//
//  IconFontConstants.m
//  KItabooSDK
//
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "IconFontConstants.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK-Swift.h>
#import "ReaderHeader.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "Constant.h"
#define LocalizationBundleForIconFontConstants  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]

NSString* const HELVETICA_FONT_LIGHT = @"HelveticaNeue-Light";
NSString* const HELVETICA_FONT_REGULAR = @"HelveticaNeue";
NSString* const HELVETICA_FONT_BOLD    = @"HelveticaNeue-Bold";

NSString* const ICON_ALERT = @"Ř";
NSString* const ICON_BOOKSHELF = @"a";
NSString* const ICON_COLORPALLET = @"Ṕ";
NSString* const ICON_CLOSE = @"∞";
NSString* const ICON_ERASER = @"$";
NSString* const ICON_REDO = @">";
NSString* const ICON_UNDO = @"<";
NSString* const ICON_CLEAR = @"č";
NSString* const ICON_DOWNARROW = @"7";
NSString* const ICON_SAVE = @"ẟ";
NSString* const ICON_SHARE_NOTE = @"ƽ";
NSString* const ICON_TOC = @"b";
NSString* const ICON_MYDATA = @"0";
NSString* const ICON_SEARCH = @"d";
NSString* const ICON_HIGHLIGHTER_K12 = @"e";
NSString* const ICON_HIGHLIGHT = @"f";
NSString* const ICON_TAPPABLE_STICKY_NOTE = @"¸";
NSString* const ICON_THUMBNAIL = @"g";
NSString* const ICON_FONTSETTING = @"£";
NSString* const ICON_TEXTANNOTATION = @"ʧ";
NSString* const ICON_ASSESSMENT = @"h";
NSString* const ICON_AUDIO = @"i";
NSString* const ICON_VIDEO1 = @"j";
NSString* const ICON_IMAGE1 = @"k";
NSString* const ICON_ACTIVITY = @"l";
NSString* const ICON_ANIMATION = @"m";
NSString* const ICON_WEBLINK = @"n";
NSString* const ICON_JUMP_TO_SCREEN = @"o";
NSString* const TOC_BOOKMARK_NORMAL_ICON = @"p";
NSString* const ICON_BOOKMARK_SELECTED = @"q";
NSString* const ICON_EDIT_CATEGORY = @"r";
NSString* const ICON_DOWNLOAD = @"s";
NSString* const ICON_PENTOOL = @"t";
NSString* const ICON_PENTThIKNESS = @"ỉ";
NSString* const ICON_MULTI_SELECT = @"∂";
NSString* const ICON_TEACHER_COMMENT = @"Ở";
NSString* const ICON_SELECT_CLASS = @"Ҭ";
NSString* const ICON_INCORRECT = @"2";
NSString* const RADIO_SELECT = @"Ź";
NSString* const RADIO_UNSELECT = @"ŷ";

NSString* const ICON_ADD_NOTES = @"u";
NSString* const ICON_FIT_HORIZONTAL = @"v";
NSString* const ICON_FIT_VERTICAL = @"w";
NSString* const ICON_ZOOM_IN = @"x";
NSString* const ICON_ZOOM_OUT = @"y";
NSString* const ICON_FIT_TO_SCREEN = @"z";
NSString* const ICON_PRINT = @"A";
NSString* const ICON_SETTING_OUTLINE = @"B";
NSString* const ICON_DELETE_OUTLINE = @"C";
NSString* const ICON_IMPORTANT = @"D";
NSString* const ICON_ADD_SHELF = @"E";
NSString* const ICON_CHECK = @"F";
NSString* const ICON_PREV_PAGE_ICON = @"G";
NSString* const ICON_NEXT = @"H";
NSString* const ICON_HISTORY_PREV = @"I";
NSString* const ICON_HISTORY_NEXT = @"J";
NSString* const ICON_MEDIA_PAUSE = @"K";
NSString* const ICON_MEDIA_PLAY  = @"L";
NSString* const ICON_MEDIA_STOP = @"M";
NSString* const ICON_CMENU_END_TAG = @"N";
NSString* const ICON_CMENU_START_TAG = @"O";
NSString* const ICON_BACK = @"G";
NSString* const ICON_HighlightNew = @"ﬨ";
NSString* const ICON_SCROLLUP = @"ﬦ";

//NSString* const ICON_CLEAR = @"č";
NSString* const NEXT_ICON = @"Q";
NSString* const ICON_SINGLE_PAGE_VIEW = @"R";
NSString* const ICON_TWO_PAGE_VIEW = @"S";
NSString* const NOTE_AUDIO_ICON = @"T";
NSString* const NOTE_IMAGE_ICON = @"U";
NSString* const NOTE_TEXT_ICON = @"V";
NSString* const NOTE_VIDEO_ICON = @"W";
NSString* const DELETE_BOOK_ICON = @"X";
NSString* const SYNC_ICON = @"Y";
NSString* const ANALYTICS_ICON = @"Z";

NSString* const MYDATA_ICON01 = @"0";
NSString* const ICON_FIT_TO_ACTUAL = @"1";
NSString* const VIDEO_PLAYER_CLOSE_ICON = @"2";
NSString* const STATISTIC_CLOSE_ICON = @"2";
NSString* const STATISTIC_LAUNCH_ICON = @"Ȕ";


NSString* const VIDEO_PLAYER_DRAG_HANDLE_ICON = @"3";
NSString* const CLOSE_ICON = @"4";
NSString* const ADD_ICON = @"5";
NSString* const ICON_MOVE_SHELF_UP = @"6";
NSString* const ICON_MOVE_SHELF_DOWN = @"7";
NSString* const ICON_CHECK_SHARE = @"8";
NSString* const EDIT_MENU_ICON = @"9";
NSString* const ICON_SHARE = @"ř";

NSString* const BRUSH_ICON = @"\"";
NSString* const DONE_ICON = @"#";
NSString* const ERASER_ICON = @"$";
NSString* const CIRCLE_TICK = @"Å";
NSString* const EXPAND_POP_ICON = @"%";
NSString* const COLLAPSE_POP_ICON = @"&";
NSString* const HIGHLIGHT_SORT_ICON = @"'";
NSString* const EXPAND_ICON = @"(";
NSString* const COLLAPSE_ICON = @")";
NSString* const ICON_SIGNIN_NEW = @"+";
NSString* const TEACHER_ICON = @"-";
NSString* const STUDENT_ICON = @".";
NSString* const TEACHER_ANNOTATION_ICON = @"/";
NSString* const CLOUD_UPLOAD_ICON = @":";
NSString* const MOVE_SHELF_UP_ICON = @"<";
NSString* const MOVE_SHELF_DOWN_ICON = @">";
NSString* const DELETE_SHELF_ICON = @";";
NSString* const EBOOK_DOWNLOAD_ICON = @"=";
NSString* const POPOUT_ICON = @"?";
NSString* const MULTIFILE_ICON = @"@";
NSString* const COMMENT_ICON = @"[";
NSString* const HTMLWRAP_ICON = @"]";
NSString* const TOC_MENU_ICON = @"b";
NSString* const BOOK_COVER_ICON = @"`";
NSString* const COLLECTION_COVER_ICON = @"ϵ";
NSString* const LEFT_ARROW_MARK_ICON = @"{";
NSString* const DOWN_ARROW_ICON = @"}";
NSString* const UPLOAD_ICON = @"|";
NSString* const ERASE_ICON = @"$";
NSString* const CLOSE_NOTE_ICON = @"\\";
NSString* const NO_RESOURCE_ICON = @"À";
NSString* const DOWNLOAD_BOOK_ICON = @"Á";
NSString* const INFO_ICON = @"ā";
NSString* const ACCESS_CODE_ICON = @"*";
NSString* const SLIDE_SHOW_ICON = @"Ã";
NSString* const KITABOO_LOGO_ICON = @"Ø";
NSString* const TEXT_SETTINGS_ICON = @"£";
NSString* const BACK_CIRCLE_ICON = @"ỡ";
NSString* const NEXT_CIRCLE_ICON = @"Ự";
NSString* const CHAPTER_NEXT_ICON = @"ĝ";
NSString* const CHAPTER_PREV_ICON = @"ĥ";
NSString* const COLOR_PICKER_ICON = @"ń";
NSString* const IMPORTANT_ICON = @"œ";
NSString* const ARCHIVE_ICON = @"§";
NSString* const KITABOO_TEXT_LOGO_ICON = @"Ù";
NSString* const STUDENT_TEACHER_ICON = @"¥";
NSString* const PREVIEW_ICON = @"©";
NSString* const SEND_ARROW_ICON = @"¤";
NSString* const PAGE_SESSION_ICON = @"ª";
NSString* const TOTAL_READING_SESSION_ICON = @"¦";
NSString* const READING_TIME_ICON = @"¨";
NSString* const PREVIEW_HIDE_ICON = @"Â";
NSString* const ICON_CHECKEDBOX = @"ͽ";
NSString* const ICON_UNCHECKEDBOX = @"ͻ";
NSString* const ICON_DROPDOWN = @"7";
NSString* const ICON_UPARROW = @"6";

NSString* const DRAG_AND_DROP_SEQUENCING_VERTICAL_ICON = @"È";
NSString* const ICON_COMMENT = @"É";
NSString* const PAGE_CURL_ICON = @"Ê";
NSString* const PAGE_TRANSITION_ICON = @"Ë";
NSString* const ICON_ACCORDION_ACTIVITY = @"Ì";
NSString* const ICON_ACCORDION_TEXT_AND_GRAPHIC = @"Í";
NSString* const BEAT_THE_CLOCK_ICON = @"Ò";
NSString* const BULLET_IMAGE_LR_ICON = @"Ó";
NSString* const CAROUSEL_ICON = @"Ô";
NSString* const ICON_CASE_STUDY_WITH_TABS_TF_AND_MCQ_IN_T = @"Ô";
NSString* const CATEGORISE_BOTTOM_ICON = @"Ý";
NSString* const CATEGORISE_RIGHT_ICON = @"Þ";
NSString* const ICON_CLICK_TO_REVEAL_BULLETED_TEXT = @"ß" ;
NSString* const ICON_CLICK_TO_REVEAL_TEXT_ON_TOP = @"à";
NSString* const ICON_CLICK_TO_REVEAL_TEXT_IMAGE_GRID_WITH_POPUP = @"â";
NSString* const ICON_CLICK_TO_REVEAL_HORIZONTAL_TEXT_IMAGE_GRID_WITH_POPUP = @"ã";
NSString* const CONCENTRATION_ICON = @"ä";
NSString* const CROSSWORD_ICON = @"æ";
NSString* const ICON_DD_HOT_SPOT_70_CHARS = @"è";
NSString* const ICON_DD_HOT_SPOT_150_CHARS = @"é";
NSString* const DECISION_TREE_ICON = @"ê";
NSString* const ICON_DRAG_AND_DROP_SEQUENCING_TIMELINE = @"ë";
NSString* const ICON_DRAG_AND_DROP_SORTING = @"ì";
NSString* const ICON_FILL_IN_THE_BLANK_DROP_DOWN = @"í";
NSString* const ICON_FILL_IN_THE_BLANK_INPUT_TYPE = @"î";
NSString* const ICON_FLASH_CARDS_MCQ = @"ï";
NSString* const ICON_FLASH_CARDS = @"ð";
NSString* const ICON_GENERIC = @"ñ";
NSString* const ICON_HANGMAN = @"ò";
NSString* const ICON_HOTSPOT_CLICK_TO_REVEAL = @"ó";
NSString* const ICON_IMAGE_ON_RIGHT_TEXT_ON_LEFT = @"ô";
NSString* const ICON_IMAGE_ON_TOP_TEXT_ON_BOTTOM = @"õ";
NSString* const ICON_IMAGE_ON_BOTTOM_TEXT_ON_TOP = @"ö";
NSString* const ICON_IMAGES_AT_TOP_RIGHT_BOTTOM_LEFT = @"ù";
NSString* const ICON_MATCH_THE_PAIRS_VERTICAL = @"ú";
NSString* const ICON_JOURNAL = @"û";
NSString* const ICON_JUMBLED_WORDS_MHOL = @"ü";
NSString* const ICON_IMAGES_ON_RIGHT_AND_TEXT_ON_LEFT = @"ý";
NSString* const ICON_LAYOUT_FOUR = @"þ";
NSString* const ICON_LAYOUT_ONE = @"ÿ";
NSString* const ICON_LAYOUT_THREE = @"Ā";
NSString* const ICON_LAYOUT_TWO = @"Ă";
NSString* const ICON_MATCH_THE_PAIRS_DRAW_LINES = @"Ą";
NSString* const TRUE_OR_FALSE_ICON = @"Đ";
NSString* const WORDS_SEARCH_ICON = @"Ĕ";
NSString* const ICON_VIDEO_2 = @"ē";
NSString* const ICON_VIDEO_WITH_INTERACTIVITY = @"Ē";
NSString* const ICON_TABBED_TABLE = @"Č";
NSString* const ICON_MULTIPLE_CHOICE_SINGLE_SELECT = @"Ċ";
NSString* const ICON_TEXT_CENTER_INLINE = @"Ď";
NSString* const ICON_MULTIPLE_CHOICE_MULTIPLE_SELECT = @"Ĉ";
NSString* const ICON_MATCH_THE_PAIRS = @"Ć";
NSString* const ICON_OVERFLOW = @"ľ";
NSString* const ICON_GALLERY_2 = @"ļ";
NSString* const ICON_IMAGE_2 = @"Ï";
NSString* const ICON_MIC = @"Î";
NSString* const ICON_VIDEO_3 = @"¹";
NSString* const ICON_BACK_ARROW_BUTTON = @"˛";
NSString* const ICON_SURVEY = @"ǿ";
NSString* const ICON_GLOSSARY = @"Ä";
NSString* const ICON_JUMP_TO_BOOK = @"ə";
NSString* const ICON_PORTO_REFRESH = @"Ü";
NSString* const ICON_IMAGE_ZOOM = @"Ĝ";
NSString* const ICON_MINIMIZE = @"Ʃ";
NSString* const ICON_DRAG = @"ď";
NSString* const ICON_NAME_EDIT = @"ɞ";
NSString* const ICON_PROTRACTOR = @"ọ";
NSString* const READ_TO_ME_LET_ME_READ = @"ǝ";
NSString* const READ_TO_ME_READ_TO_ME = @"Ş";
NSString* const READ_TO_ME_AUTOPLAY = @"i";
NSString* const ICON_EQUATION_EDITOR= @"ệ";
NSString* const ICON_USERNAME = @"ă";
NSString* const ICON_CONFIRM_PASSWORD = @"Ẋ";
NSString* const ICON_PASSWORD = @"Ẃ";
NSString* const ICON_CAMERA= @"ƈ";
NSString* const ICON_DEFAULT_PROFILE_PIC_ICON = @"Ƥ";
NSString* const ICON_HURIX_DIGITAL_LOGO = @"Ч";

NSString* const ICON_TEXTANNOTATION_ADD = @"Ƹ";
NSString* const ICON_LEFT_ALIGN = @"Ц";
NSString* const ICON_RIGHT_ALIGN = @"Щ";
NSString* const ICON_CENTER_ALIGN = @"Ш";
NSString* const ICON_TEXT_COLOR = @"Ɣ";
NSString* const ICON_KEYBOARD_DOWN = @"ƻ";
NSString* const ICON_KEYBOARD_UP = @"Ʀ";
NSString* const ICON_HEART_FAV = @"ʖ";
NSString* const ICON_HEART_UNFAV = @"Է";
NSString* const ICON_FORWARD = @"Ք";
NSString* const ICON_BACKWARD = @"Փ";

NSString* const ICON_AUDIO_SYNC = @"ᾅ";
NSString* const ICON_SPEECH = @"Ѷ";

@interface IconFontConstants ()
@end

@implementation IconFontConstants

+ (NSString *)getFontForCharacter:(NSString *)iconCharacter
{
    NSString *fontname;
    NSString *string = [[NSBundle mainBundle] pathForResource:[HDKitabooFontManager getFontName] ofType:@"ttf"];
//    NSString *string = [[NSBundle bundleForClass:[self class]] pathForResource:[HDKitabooFontManager getFontName] ofType:@"ttf"];
     fontname = [[string lastPathComponent] stringByDeletingPathExtension];
    if (fontname) {
        return fontname;
    }
    else {
        NSError *error = [NSError errorWithDomain:[SDKUtility getSDKDomain]
                                             code:SDKErrorKSDKErrorFontFileLoadingFailed
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@", NSLocalizedStringFromTableInBundle(@"FONT_FILE_MISSING",READER_LOCALIZABLE_TABLE, LocalizationBundleForIconFontConstants, nil)]
                                                    }];
        [KitabooDebugLog logWithType:KitabooLogTypeError className:self message:error.localizedDescription verboseMesage:@""];
        return @"";
    }
}

+(NSAttributedString*)getNSAttributedCoreTextStringFromDisplayString:(NSString *)entirePageString andSearchString:(NSString*)searchQueryString searchTextColor:(UIColor *)fontColor withTextColor:(UIColor*)textColor
{
    NSString *stringToReturn;
    int entirePageStringLength = (int)[entirePageString length];
    
    if(entirePageStringLength >= 300)
        stringToReturn = [entirePageString substringWithRange:NSMakeRange(0, MIN(300, entirePageStringLength))];
    else
        stringToReturn = entirePageString;
    
    NSString *toFind = [[NSString alloc] initWithFormat:@"%@", searchQueryString];
    
    int stringToReturnLength = (int)[stringToReturn length];
    if(entirePageStringLength > stringToReturnLength)
    {
        stringToReturn = [NSString stringWithFormat:@"%@...",[stringToReturn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"...." withString:@"."];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"?..." withString:@"?"];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"\"..." withString:@"\""];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"!..." withString:@"!"];
    }
    
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *mutableAttributedString=[[NSMutableAttributedString alloc] initWithString:stringToReturn attributes:options];
    
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineSpacing = 8.0
//    paragraphStyle.alignment = NSTextAlignment.natural
//    attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range:NSMakeRange(0, seachResult.searchResultAttributedString.length - 1))
//    attributedStr.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, seachResult.searchResultAttributedString.length - 1))
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = isIpad()?6:4;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.alignment = NSTextAlignmentNatural;
    UIFont *font = nil;
    font = getCustomFont(isIpad()?18:14);
    // On Search direct crash in IOS version 7.0
    if (font == nil && ([UIFontDescriptor class] != nil))
    {
        font = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), 14, NULL);
    }
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [stringToReturn length])];
    [mutableAttributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [stringToReturn length])];
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [stringToReturn length])];

    UIFont *fontForSearchText = getCustomFont(isIpad()?18:14);
    
    // Initialise the searching range to the whole string
    NSRange searchRange = NSMakeRange(0, [stringToReturn length]);
    do
    {
        // Search for next occurrence
        NSRange range = [stringToReturn rangeOfString:toFind options:NSCaseInsensitiveSearch range:searchRange];
        if (range.location != NSNotFound)
        {
            // If found, range contains the range of the current iteration
            // NOW DO SOMETHING WITH THE STRING / RANGE
            if ([stringToReturn length]  >0)
            {
                [mutableAttributedString addAttribute:NSFontAttributeName value:fontForSearchText range:NSMakeRange(range.location,  range.length)];
//                if([[UserController getInstance] isCurrentClientPorto])
//                {
//                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6000 green:0.6000 blue:0.6000 alpha:1.0] range:NSMakeRange(range.location,  range.length)];
//                }
//                else
//                {
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(range.location,  range.length)];
                    
//                }
            }
            // Reset search range for next attempt to start after the current found range
            searchRange.location = range.location + range.length;
            searchRange.length = [stringToReturn length] - searchRange.location;
        }
        else
        {
            // If we didn't find it, we have no more occurrences so stop the loop
            break;
        }
    } while (1);
    
    NSAttributedString *attributedString=[mutableAttributedString copy];
    return attributedString;
}

+(NSAttributedString*)getNSAttributedCoreTextStringFromDisplayString:(NSString *)entirePageString andSearchString:(NSString*)searchQueryString searchTextColor:(UIColor *)fontColor withTextColor:(UIColor*)textColor withFont:(UIFont *)font
{
    NSString *stringToReturn;
    int entirePageStringLength = (int)[entirePageString length];
    
    if(entirePageStringLength >= 300)
        stringToReturn = [entirePageString substringWithRange:NSMakeRange(0, MIN(300, entirePageStringLength))];
    else
        stringToReturn = entirePageString;
    
    NSString *toFind = [[NSString alloc] initWithFormat:@"%@", searchQueryString];
    
    int stringToReturnLength = (int)[stringToReturn length];
    if(entirePageStringLength > stringToReturnLength)
    {
        stringToReturn = [NSString stringWithFormat:@"%@...",[stringToReturn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"...." withString:@"."];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"?..." withString:@"?"];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"\"..." withString:@"\""];
        stringToReturn = [stringToReturn stringByReplacingOccurrencesOfString:@"!..." withString:@"!"];
    }
    
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *mutableAttributedString=[[NSMutableAttributedString alloc] initWithString:stringToReturn attributes:options];
    

    //    attributedStr.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, seachResult.searchResultAttributedString.length - 1))
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
 
    // On Search direct crash in IOS version 7.0
    if (font == nil && ([UIFontDescriptor class] != nil))
    {
        font = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), 14, NULL);
    }
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [stringToReturn length])];
    [mutableAttributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [stringToReturn length])];
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [stringToReturn length])];
    
    
    // Initialise the searching range to the whole string
    NSRange searchRange = NSMakeRange(0, [stringToReturn length]);
    do
    {
        // Search for next occurrence
        NSRange range = [stringToReturn rangeOfString:toFind options:NSCaseInsensitiveSearch range:searchRange];
        if (range.location != NSNotFound)
        {
            // If found, range contains the range of the current iteration
            // NOW DO SOMETHING WITH THE STRING / RANGE
            if ([stringToReturn length]  >0)
            {
                [mutableAttributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range.location,  range.length)];
                //                if([[UserController getInstance] isCurrentClientPorto])
                //                {
                //                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6000 green:0.6000 blue:0.6000 alpha:1.0] range:NSMakeRange(range.location,  range.length)];
                //                }
                //                else
                //                {
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(range.location,  range.length)];
                
                //                }
            }
            // Reset search range for next attempt to start after the current found range
            searchRange.location = range.location + range.length;
            searchRange.length = [stringToReturn length] - searchRange.location;
        }
        else
        {
            // If we didn't find it, we have no more occurrences so stop the loop
            break;
        }
    } while (1);
    
    NSAttributedString *attributedString=[mutableAttributedString copy];
    return attributedString;
}

@end
