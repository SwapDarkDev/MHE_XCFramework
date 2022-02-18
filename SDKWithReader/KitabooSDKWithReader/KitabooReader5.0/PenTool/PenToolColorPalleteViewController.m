//
//  PenToolColorPalleteViewController.m
//  PlayerTopBarController
//
//  Created by amol shelke on 12/02/18.
//  Copyright © 2018 amol shelke. All rights reserved.
//

#import "PenToolColorPalleteViewController.h"
#import "HSUIColor-Expanded.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define icon_penTool @"f"
#define font_name @"kitabooread"
#define item_fontSize 70
#define PenToolBar_ItemWidth isIPAD ? 62:58.4
#define item_top 7
#define item_bottom -7
#define item_width PenToolBar_ItemWidth-17

typedef enum
{
    kPlayerActionBarPenTool
}kPlayerActionBar;

@interface PenToolColorPalleteViewController ()
{
    PlayerActionBar *penItemsBar;
    PlayerActionBar *secondLinePenItemBar;

}
@end

@implementation PenToolColorPalleteViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _penColors=[[NSArray alloc]init];
        penItemsBar =[[PlayerActionBar alloc]init];
        penItemsBar.tag=kPlayerActionBarPenTool;
        penItemsBar.delegate=self;
        secondLinePenItemBar =[[PlayerActionBar alloc]init];
        secondLinePenItemBar.tag=kPlayerActionBarPenTool;
        secondLinePenItemBar.delegate=self;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:penItemsBar];
    penItemsBar.translatesAutoresizingMaskIntoConstraints = NO;
    [penItemsBar.heightAnchor constraintEqualToConstant:isIPAD?64:50].active = YES;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penItemsBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:isIPAD?0:6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penItemsBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:isIPAD?0:4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:penItemsBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:isIPAD?0:-4]];
    penItemsBar.clipsToBounds = YES;

    [self.view addSubview:secondLinePenItemBar];
    secondLinePenItemBar.translatesAutoresizingMaskIntoConstraints = NO;
    [secondLinePenItemBar.leftAnchor constraintEqualToAnchor:penItemsBar.leftAnchor constant:0].active = YES;
    [secondLinePenItemBar.rightAnchor constraintEqualToAnchor:penItemsBar.rightAnchor constant:0].active = YES;
    [secondLinePenItemBar.topAnchor constraintEqualToAnchor:penItemsBar.bottomAnchor constant:0].active = YES;
    [secondLinePenItemBar.heightAnchor constraintEqualToConstant: isIPAD?0:((_penColors.count > 5)?50:0)].active = YES;
    secondLinePenItemBar.clipsToBounds = YES;
    if(isIPAD){
        for (int i = 0;i < _penColors.count; i++ )
        {
            [penItemsBar addActionBarItem:[self getPenToolColorPalleteItemForColor:[_penColors objectAtIndex:i]] withItemsWidth:PenToolBar_ItemWidth withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
        }
    }
    else{
    for (int i = 0;i < ((_penColors.count >= 5)? 5 : _penColors.count); i++ )
    {
        [penItemsBar addActionBarItem:[self getPenToolColorPalleteItemForColor:[_penColors objectAtIndex:i]] withItemsWidth:PenToolBar_ItemWidth withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }
    
    if(_penColors.count >= 5)
        for (int i = 5;i < _penColors.count; i++ )
    {
        [secondLinePenItemBar addActionBarItem:[self getPenToolColorPalleteItemForColor:[_penColors objectAtIndex:i]] withItemsWidth:PenToolBar_ItemWidth withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateSelectItemUI:[self->penItemsBar getSelectedItem]];
        [self updateSelectItemUI:[self->secondLinePenItemBar getSelectedItem]];
        [self addShadow];

    });
}

-(void)setColorPickerBackgroundColor:(UIColor *)backgroundColor{
    penItemsBar.backgroundColor = backgroundColor;
    secondLinePenItemBar.backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
}


-(PlayerActionBarItem *)getPenToolColorPalleteItemForColor:(NSString*)color
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    [actionBarItem.metaData setValue:color forKey:@"PenColor"];
    
    HighLightToolView *highlightToolV = [[HighLightToolView alloc] init];
    highlightToolV.iconLabel.clipsToBounds = YES;
    highlightToolV.iconLabel.backgroundColor = [UIColor colorWithHexString:color];
    actionBarItem.backgroundColor = highlightToolV.contentView.backgroundColor = [UIColor clearColor];
    highlightToolV.borderView.layer.borderWidth = 1.0;
    highlightToolV.borderView.layer.borderColor = [UIColor clearColor].CGColor;
    [highlightToolV resetViewForColorPalletWithColorHeight: isIPAD?(PenToolBar_ItemWidth) - 36 : (PenToolBar_ItemWidth) - 31.4];
    highlightToolV.iconLabel.accessibilityIdentifier = [NSString stringWithFormat:@"penTool_%@", color];
    [actionBarItem addSubview:highlightToolV];
    highlightToolV.translatesAutoresizingMaskIntoConstraints = NO;
    actionBarItem.translatesAutoresizingMaskIntoConstraints = NO;
    [actionBarItem.heightAnchor constraintEqualToConstant:isIPAD?64:50].active = YES;
    [highlightToolV.leftAnchor constraintEqualToAnchor:actionBarItem.leftAnchor constant:0].active = YES;
    [highlightToolV.rightAnchor constraintEqualToAnchor:actionBarItem.rightAnchor constant:0].active = YES;;
    [highlightToolV.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:0].active = YES;;
    [highlightToolV.bottomAnchor constraintEqualToAnchor:actionBarItem.bottomAnchor constant:0].active = YES;
    [highlightToolV layoutIfNeeded];
    if([color isEqualToString:_selectedPenColor])
    {
        actionBarItem.selected=YES;
        highlightToolV.borderView.layer.borderColor = self.selectionBorderColor.CGColor;

    }
    
    return actionBarItem;
}

-(void)updateSelectItemUI:(PlayerActionBarItem*)selectedItem
{
    for (UIView *view in selectedItem.subviews)
    {
        if([view isKindOfClass:[HighLightToolView class]])
        {
            HighLightToolView *selectedView = (HighLightToolView*)view;
            selectedView.borderView.layer.borderColor = self.selectionBorderColor.CGColor;
        }
    }
}
-(void)didSelectedPlayerActionBar:(PlayerActionBar *)playerActionBar withItem:(PlayerActionBarItem *)item
{
    [penItemsBar resetPlayerActionBarSelection];
    [secondLinePenItemBar resetPlayerActionBarSelection];
    [_delegate didSelectPenColor:[item.metaData  objectForKey:@"PenColor"]];
    [self updateSelectItemUI:item];
}

-(void)willResetPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    NSArray *tappableItems = [playerActionBar getTappableItems];
//    selectedItem.selected=NO;
    for (UIView *view in tappableItems)
    {
        for (UIView *subview in view.subviews)

        if([subview isKindOfClass:[HighLightToolView class]])
        {
            HighLightToolView *selectedView = (HighLightToolView*)subview;
            selectedView.borderView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [penItemsBar removeFromSuperview];
    penItemsBar=nil;
    [_delegate willDismissPenToolColorPalleteView];
}
-(void)dealloc
{
    //[KitabooDebugLog logWithType:KitabooLogTypeInformation className:[self class] message:@"Inside dealloc of PenToolColorPalleteViewController.h" verboseMesage:@""];
}

-(void)addShadow{

    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = self.selectionBorderColor.CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    self.view.layer.shadowOpacity = 0.4f;
    self.view.layer.borderWidth = 0.6;
    self.view.layer.borderColor = _containerBorderColor.CGColor;
//    self.view.layer.shadowPath = shadowPath.CGPath;
    self.view.clipsToBounds = NO;
    self.view.layer.cornerRadius = 8;
    penItemsBar.clipsToBounds = isIPAD;
    penItemsBar.layer.cornerRadius = 8;
}


@end
