//
//  PenToolBarItemPoint.m
//  PlayerTopBarController
//
//  Created by amol shelke on 14/02/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "PenToolThicknessPalleteViewController.h"
#import "HSUIColor-Expanded.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#define PointTool_ItemWidth 60

typedef enum
{
    kPointToolItemThickness=0,
    kPointToolItemSlider=1
    
}PointToolItemsType;

@interface PenToolThicknessPalleteViewController ()
{
    UIView  *pointItemsBar;
    NSLayoutConstraint *widthConstaint;
    NSLayoutConstraint *heightConstaint;
    UIColor *verticalSparatorBarColor;
}
@end

@implementation PenToolThicknessPalleteViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        pointItemsBar = [[UIView alloc]init];
//        pointItemsBar.delegate=self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [pointItemsBar addActionBarItem:[self getItemForThickness] withItemsWidth:100 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
//    [pointItemsBar addActionBarItem:[self getItemForVerticalBar] withItemsWidth:2 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:NO];
//    [pointItemsBar addActionBarItem:[self getItemForSlider] withItemsWidth:isIPAD?236 :214 withItemAlignments:PlayerActionBarAlignmentLeft isTappable:YES];
    UISlider *slider = [[UISlider alloc]init];
    slider.tintColor=_thickenessSliderTintColor ;
    slider.thumbTintColor = _thickenessSliderTintColor;
    slider.maximumTrackTintColor = _sliderFilledColor;
    slider.minimumValue = 2;
    slider.maximumValue = 10;
    slider.continuous = NO;
    [slider setValue:_selectedThicknessValue];
    slider.accessibilityIdentifier = PENTOOL_SLIDER;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pointItemsBar addSubview:slider];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [slider.centerYAnchor constraintEqualToAnchor:pointItemsBar.centerYAnchor constant:0].active = YES;
//    [slider.heightAnchor constraintEqualToConstant:20].active = YES;
    [slider.leftAnchor constraintEqualToAnchor:pointItemsBar.leftAnchor constant:20].active = YES;
    [slider.rightAnchor constraintEqualToAnchor:pointItemsBar.rightAnchor constant:-20].active = YES;
    
        [self.view addSubview:pointItemsBar];
    
    pointItemsBar.clipsToBounds = YES;
    pointItemsBar.layer.cornerRadius = isIPAD? 4 :8;
    pointItemsBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointItemsBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointItemsBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointItemsBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointItemsBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
//    if(!isIPAD)
    [self addShadow];
    [self.view layoutSubviews];
}

-(void)setThicknessPickerViewBackgroundColor:(UIColor *)backgroundColor{
    pointItemsBar.backgroundColor = backgroundColor;
}
- (void)setVerticalSeperatorColor:(UIColor *)seperatorColor{
     verticalSparatorBarColor = seperatorColor;
}

-(PlayerActionBarItem *)getItemForThickness
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
    actionBarItem.tag =kPointToolItemThickness;
    UIView *thicknessView = [[UIView alloc]init];
    thicknessView.backgroundColor=[UIColor colorWithHexString:_thicknessColor];
    thicknessView.layer.cornerRadius=_selectedThicknessValue/2;
    [actionBarItem addSubview:thicknessView];
    thicknessView.translatesAutoresizingMaskIntoConstraints =NO;

    widthConstaint = [NSLayoutConstraint constraintWithItem:thicknessView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_selectedThicknessValue];
    heightConstaint = [NSLayoutConstraint constraintWithItem:thicknessView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_selectedThicknessValue];
    
    [actionBarItem addConstraint:widthConstaint];
    [actionBarItem addConstraint:heightConstaint];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:thicknessView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:thicknessView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return actionBarItem;
}
-(PlayerActionBarItem *)getItemForVerticalBar
{
    PlayerActionBarItem *actionBarItem=[[PlayerActionBarItem alloc]initWithFrame:CGRectZero];
  
    UIView *view =[[UIView alloc]init];
    view.backgroundColor =verticalSparatorBarColor;
 
    [actionBarItem addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints =NO;
    
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem: view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    
    return actionBarItem;
}
-(UIView *)getItemForSlider
{
    
    UIView *actionBarItem = [[UIView alloc] initWithFrame:CGRectZero];
    actionBarItem.tag = kPointToolItemSlider;
    CustomSlider *slider = [[CustomSlider alloc]init];
    slider.tintColor=_thickenessSliderTintColor ;
    slider.thumbTintColor = _thickenessSliderTintColor;
    slider.minimumValue =2;
    slider.maximumValue =10;
    slider.continuous = NO;
    [slider setValue:_selectedThicknessValue];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [actionBarItem addSubview:slider];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [slider.topAnchor constraintEqualToAnchor:actionBarItem.topAnchor constant:22].active = YES;
    [slider.leftAnchor constraintEqualToAnchor:actionBarItem.leftAnchor constant:0].active = YES;
    [slider.rightAnchor constraintEqualToAnchor:actionBarItem.rightAnchor constant:0].active = YES;
    [slider.centerYAnchor constraintEqualToAnchor:actionBarItem.centerYAnchor].active = YES;
    [slider.heightAnchor constraintEqualToConstant:5].active = YES;
//    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:actionBarItem attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [actionBarItem addConstraint:[NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120]];
    
    return actionBarItem;
}

-(void)sliderValueChanged:(UISlider *)slider
{
    [_delegate didSelectPenThickness:slider.value];
    
//    NSArray *itemsArray = [pointItemsBar getTappableItems];
//    for (PlayerActionBarItem *actionBarItem in itemsArray)
//    {
//        if(actionBarItem.tag == kPointToolItemThickness)
//        {
//            widthConstaint.constant=slider.value;
//            heightConstaint.constant=slider.value;
//            [actionBarItem layoutIfNeeded];
//            if([actionBarItem.subviews count])
//            [actionBarItem.subviews objectAtIndex:0].layer.cornerRadius=slider.value/2;
//            return;
//        }
//    }
}
-(void)didSelectedPlayerActionBar:(PlayerActionBar *)playerActionBar withItem:(PlayerActionBarItem *)item
{
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willResetPlayerActionBar:(PlayerActionBar *)playerActionBar
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [pointItemsBar removeFromSuperview];
    pointItemsBar=nil;
    [_delegate willDismissPenToolThicknessPalleteView];
}
-(void)dealloc
{
    pointItemsBar=nil;
    widthConstaint=nil;
    heightConstaint=nil;
}

-(void)addShadow{
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
    self.view.layer.shadowOpacity = 0.4f;
    self.view.layer.shadowRadius = isIPAD? 14: 8;
//    self.view.layer.shadowPath = shadowPath.CGPath;
    self.view.clipsToBounds = NO;
    self.view.layer.borderWidth = 0.3;
    self.view.layer.cornerRadius = isIPAD? 5: 8;
}

@end
