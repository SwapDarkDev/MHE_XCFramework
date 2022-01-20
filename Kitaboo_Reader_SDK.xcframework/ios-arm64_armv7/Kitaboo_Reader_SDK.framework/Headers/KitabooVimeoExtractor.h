//
//  YTVimeoExtractor.h
//  YTVimeoExtractor
//
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YTVimeoPlayerConfigURL;
extern NSString *const YTVimeoExtractorErrorDomain;

enum {
    YTVimeoExtractorErrorCodeNotInitialized,
    YTVimeoExtractorErrorInvalidIdentifier,
    YTVimeoExtractorErrorUnsupportedCodec,
    YTVimeoExtractorErrorUnavailableQuality
};

typedef enum YTVimeoVideoQuality : NSUInteger {
    YTVimeoVideoQualityLow,
    YTVimeoVideoQualityMedium,
    YTVimeoVideoQualityHigh
}YTVimeoVideoQuality;

typedef void (^completionHandler) (NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality);
typedef void (^metadataCompletionHandler) (NSURL *videoURL, NSDictionary* metadata, NSError *error, YTVimeoVideoQuality quality);

@protocol  KitabooVimeoExtractorDelegate;

@interface KitabooVimeoExtractor : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, readonly) BOOL running;
@property (nonatomic, readonly) YTVimeoVideoQuality quality;
@property (nonatomic, readonly) NSString* referer;
@property (strong, nonatomic, readonly) NSURL *vimeoURL;

@property (unsafe_unretained, nonatomic) id<KitabooVimeoExtractorDelegate> delegate;

+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler;
+ (void)fetchVideoURLFromID:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(completionHandler)handler;
+ (void)fetchVideoURLFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(completionHandler)handler;
+ (void)fetchVideoURLFromID:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(completionHandler)handler;

+ (void)fetchVideoMetadataFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(metadataCompletionHandler)handler;
+ (void)fetchVideoMetadataFromID:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality completionHandler:(metadataCompletionHandler)handler;
+ (void)fetchVideoMetadataFromURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(metadataCompletionHandler)handler;
+ (void)fetchVideoMetadataFromID:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer completionHandler:(metadataCompletionHandler)handler;


- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality;
- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality;
- (id)initWithURL:(NSString *)videoURL quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer;
- (id)initWithID:(NSString *)videoID quality:(YTVimeoVideoQuality)quality referer:(NSString *)referer;

- (void)start;

@end

@protocol KitabooVimeoExtractorDelegate <NSObject>

@optional
- (void)vimeoExtractor:(KitabooVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL withQuality:(YTVimeoVideoQuality)quality;
- (void)vimeoExtractor:(KitabooVimeoExtractor *)extractor didSuccessfullyExtractVimeoURL:(NSURL *)videoURL metadata:(NSDictionary*)metadata withQuality:(YTVimeoVideoQuality)quality;

@required
- (void)vimeoExtractor:(KitabooVimeoExtractor *)extractor failedExtractingVimeoURLWithError:(NSError *)error;

@end
