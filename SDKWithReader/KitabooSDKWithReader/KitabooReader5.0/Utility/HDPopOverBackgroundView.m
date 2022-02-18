//
//  HDPopOverBackgroundView.m
//  Kitaboo 5.0
//
//  Created by Rajat.Babhulgaonkar on 19/08/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

#import "HDPopOverBackgroundView.h"

static UIColor *_arrowColor;
@interface HDPopOverBackgroundView()
- (UIImage *)drawArrowImage:(CGSize)size;
@end

#define kArrowBase 30.0f
#define kArrowHeight 15.0f
#define kBorderInset 0.0f

@implementation HDPopOverBackgroundView

@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;
@synthesize arrowImageView = _arrowImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        // arrowImageView.backgroundColor = [UIColor redColor];
        self.arrowImageView = arrowImageView;
        [self addSubview:self.arrowImageView];
        
    }
    return self;
}

+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (CGFloat)arrowHeight
{
    return kArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kBorderInset, kBorderInset, kBorderInset, kBorderInset);
}

- (UIColor *) getArrowColor
{
    return  [UIColor blackColor];
}

+ (void)setArrowColor:(UIColor *)arrowColor
{
    _arrowColor = arrowColor;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

-(void) setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

-(void) setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

- (UIImage *)drawArrowImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f);
    CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height);
    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height);
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    
    UIColor *fillColor = nil;
    
    if (_arrowColor != nil)
    {
        fillColor = _arrowColor;
    }
    else
    {
        fillColor = [self getArrowColor];
    }
    
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat popoverImageOriginX = 0;
    CGFloat popoverImageOriginY = 0;
    
    CGFloat popoverImageWidth = self.bounds.size.width;
    CGFloat popoverImageHeight = self.bounds.size.height;
    
    CGFloat arrowImageOriginX = 0;
    CGFloat arrowImageOriginY = 0;
    
    CGFloat arrowImageWidth = kArrowBase;
    CGFloat arrowImageHeight = kArrowHeight;
    
    // Radius value you used to make rounded corners in your popover background image
    CGFloat cornerRadius = 9;
    
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    self.arrowImageView.image = [self drawArrowImage:arrowSize];
    
    switch (self.arrowDirection) {
            
        case UIPopoverArrowDirectionUp:
            
            popoverImageOriginY = kArrowHeight - 2;
            popoverImageHeight = self.bounds.size.height - kArrowHeight;
            
            // Calculating arrow x position using arrow offset, arrow width and popover width
            arrowImageOriginX = roundf((self.bounds.size.width - kArrowBase) / 2 + self.arrowOffset);
            
            // If arrow image exceeds rounded corner arrow image x postion is adjusted
            arrowImageOriginX = MIN(arrowImageOriginX, self.bounds.size.width - kArrowBase - cornerRadius);
            arrowImageOriginX = MAX(arrowImageOriginX, cornerRadius);
            
            CGAffineTransform rotateUp= CGAffineTransformIdentity;
            [self.arrowImageView setTransform:rotateUp];
            
            break;
            
            
            
        case UIPopoverArrowDirectionDown:
            
            popoverImageHeight = self.bounds.size.height - kArrowHeight + 2;
            
            arrowImageOriginX = roundf((self.bounds.size.width - kArrowBase) / 2 + self.arrowOffset);
            
            arrowImageOriginX = MIN(arrowImageOriginX, self.bounds.size.width - kArrowBase - cornerRadius);
            arrowImageOriginX = MAX(arrowImageOriginX, cornerRadius);
            
            arrowImageOriginY = popoverImageHeight - 2;
            
            CGAffineTransform rotateDown = CGAffineTransformMakeRotation(M_PI);
            [self.arrowImageView setTransform:rotateDown];
            
            break;
            
        case UIPopoverArrowDirectionLeft:
            
            popoverImageOriginX = kArrowHeight - 2;
            popoverImageWidth = self.bounds.size.width - kArrowHeight;
            
            arrowImageOriginY = roundf((self.bounds.size.height - kArrowBase) / 2 + self.arrowOffset);
            
            arrowImageOriginY = MIN(arrowImageOriginY, self.bounds.size.height - kArrowBase - cornerRadius);
            arrowImageOriginY = MAX(arrowImageOriginY, cornerRadius);
            
            arrowImageWidth = kArrowHeight;
            arrowImageHeight = kArrowBase;
            
            CGAffineTransform rotateLeft = CGAffineTransformMakeRotation(-M_PI_2);
            [self.arrowImageView setTransform:rotateLeft];
            
            break;
            
        case UIPopoverArrowDirectionRight:
            
            popoverImageWidth = self.bounds.size.width - kArrowHeight + 2;
            
            arrowImageOriginX = popoverImageWidth - 2;
            arrowImageOriginY = roundf((self.bounds.size.height - kArrowBase) / 2 + self.arrowOffset);
            
            arrowImageOriginY = MIN(arrowImageOriginY, self.bounds.size.height - kArrowBase - cornerRadius);
            arrowImageOriginY = MAX(arrowImageOriginY, cornerRadius);
            
            arrowImageWidth = kArrowHeight;
            arrowImageHeight = kArrowBase;
            
            CGAffineTransform rotateRight = CGAffineTransformMakeRotation(M_PI_2);
            [self.arrowImageView setTransform:rotateRight];
            
            break;
            
        default:
            
            // For popovers without arrows (Thanks Martin!)
            popoverImageHeight = self.bounds.size.height - kArrowHeight + 2;
            
            break;
    }
    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
