//
//  FilterViewController.m
//  Kitaboo
//
//  Created by Priyanka Singh on 19/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>
#import "FilterViewController.h"
#import "ReaderHeader.h"
#import "FilterCollectionCell.h"
#import "FilterDataObject.h"
#define RedColor @"#FF0000"
#define ViewDefaultHeight (isIpad?155:145)
#define SubSectionCellHeight (isIpad()? 58 : (([UIScreen mainScreen].bounds.size.width)>([UIScreen mainScreen].bounds.size.height)?37:50))
#define SectionCellHeight (isIpad()? 60 :(([UIScreen mainScreen].bounds.size.width)>([UIScreen mainScreen].bounds.size.height) ?37:50))
#define CollectionViewHeight (isIpad?52 :44)
#define MiddleIndexArray [NSArray arrayWithObjects:1,4, nil]
#define LocalizationBundleForFilterViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
@interface FilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>{
    NSMutableArray *noteDataArray,*highlightDataArray,*previousStateArray,*subSectionNotesPreviousState,*subSectionContextualPreviousState;
    NSMutableArray *subSectionNotesArray,*subSectionContextualArray;
    NSArray *colorsArray;
    FilterType selectedFilter;
    __weak IBOutlet UIButton *applyButton;
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIView *collectionContainerView;
    __weak IBOutlet UIView *viewContainer;
    __weak IBOutlet UILabel *filterByLabel;
    __weak IBOutlet NSLayoutConstraint *heightConstraintOfView;
    __weak IBOutlet UIView *transaparentBackgroundView;
    BOOL isHightlightFilter;
}

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateView];
    [self initiliseArrays];
    if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
        selectedFilter = FilterTypeALL;
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnFilter:)];
    singleTapGesture.delegate = self;
    [self.view addGestureRecognizer:singleTapGesture];
    [self setAccessibilityForFilterItems];
}

-(void)viewDidLayoutSubviews{
    if(_isStickyNotesEnabled){
        NSArray *expadedDataArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpanded = 1"]];
        
        if ((!_userSettingsModel.isContextualNoteEnabled || !_userSettingsModel.isStickyNotesEnabled) && !isHightlightFilter && ([expadedDataArray count] == 0)) {
            heightConstraintOfView.constant = SectionCellHeight + ViewDefaultHeight + 8 ;
        }
        if (!isHightlightFilter && expadedDataArray.count == 0 && !isIpad())
        {
            if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
            {
                filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
                heightConstraintOfView.constant = SectionCellHeight * 3 + ViewDefaultHeight + 8 /*margin*/;
            }
        }
        [self.view layoutIfNeeded];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadCollectionView];

    if(isHightlightFilter){
        filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"Highlights_filter_by" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        heightConstraintOfView.constant = ((ceil(highlightDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
        previousStateArray = [[NSMutableArray alloc] initWithArray:highlightDataArray copyItems:YES];
    }else if(!_isStickyNotesEnabled){
        filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        heightConstraintOfView.constant = ((ceil(noteDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
        previousStateArray = [[NSMutableArray alloc] initWithArray:noteDataArray copyItems:YES];
    }else{
        if(_userSettingsModel.isContextualNoteEnabled)
           filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"CONTEXTUAL_NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        else
           filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
       
        if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled) {
            filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        heightConstraintOfView.constant = SectionCellHeight * 3 + ViewDefaultHeight + 8 /*margin*/;
        }
        NSArray *expadedDataArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpanded = 1"]];
        if(expadedDataArray.count){
            FilterDataObject *filterObj = [expadedDataArray firstObject];
            filterObj.isExpanded = NO;
            if(filterObj.filterType == FilterTypeNOTE){
                [noteDataArray removeObjectsInArray:subSectionNotesArray];
            }
            else{
                [noteDataArray removeObjectsInArray:subSectionContextualArray];
            }
        }
        previousStateArray = [[NSMutableArray alloc] initWithArray:noteDataArray copyItems:YES];
        subSectionNotesPreviousState = [[NSMutableArray alloc] initWithArray:subSectionNotesArray copyItems:YES];
        subSectionContextualPreviousState = [[NSMutableArray alloc] initWithArray:subSectionContextualArray copyItems:YES];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    [self enableApplyButton:NO];
}

-(void)reloadCollectionView{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self->collectionView reloadData];
    });
}

-(void)enableApplyButton:(BOOL)isEnable{
    if(isEnable){
        applyButton.enabled = YES;
        applyButton.backgroundColor =  isIpad()? _themeVO.filterPopUp_action_text_color : _themeVO.filterPopUp_background;
    }
    else{
        applyButton.enabled = NO;
        applyButton.backgroundColor =  isIpad()? [_themeVO.filterPopUp_action_text_color colorWithAlphaComponent:_themeVO.mydata_disabled_icon_opacity] : _themeVO.filterPopUp_background;
    }
}

-(void)updateApplyButtonStatus{
    BOOL isAnyFilterSelected;
    if(isHightlightFilter){
        isAnyFilterSelected = [self getAllSelectedFilterColors:highlightDataArray].count?YES:NO;
    }else{
        if([self getAllSelectedFilterColors:subSectionContextualArray].count){
            isAnyFilterSelected = YES;
        }
        else if([self getAllSelectedFilterColors:subSectionNotesArray].count){
            isAnyFilterSelected = YES;
        }else if(((FilterDataObject*)[noteDataArray firstObject]).isSelected)
            isAnyFilterSelected = YES;
        else
            isAnyFilterSelected = NO;
    }
    [self enableApplyButton:isAnyFilterSelected];
}

-(NSArray *)getAllSelectedFilterColors:(NSMutableArray *)arrayfilter{
    NSArray *seletedDataArray;
        seletedDataArray = [arrayfilter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = 1"]];
    seletedDataArray =  [seletedDataArray valueForKey:@"titleColor"];
    return seletedDataArray;
}

-(void)updateView{
    if(isIpad()){
        viewContainer.layer.cornerRadius = 12;
        viewContainer.backgroundColor= self.themeVO.filterPopUp_background;
//        viewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        viewContainer.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
        viewContainer.layer.shadowOpacity = 0.7f;
        viewContainer.layer.borderWidth = 1;
        viewContainer.layer.borderColor = self.themeVO.filterPopUp_border_color.CGColor;
        collectionContainerView.backgroundColor = [UIColor clearColor];
    }
    else{
        viewContainer.backgroundColor = [UIColor clearColor];
        collectionContainerView.layer.borderWidth = 1.0;
        collectionContainerView.layer.cornerRadius = 10;
        collectionContainerView.layer.borderColor = self.themeVO.filterPopUp_border_color.CGColor;
        collectionContainerView.clipsToBounds = YES;
        collectionContainerView.backgroundColor= self.themeVO.filterPopUp_background;
        applyButton.layer.borderColor = self.themeVO.filterPopUp_border_color.CGColor;
        applyButton.layer.borderWidth = 1.0;
        applyButton.clipsToBounds = YES;
    }
    [collectionView registerClass:[FilterCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    applyButton.layer.cornerRadius = isIpad()? 2 : 10;
    applyButton.backgroundColor =  isIpad()? _themeVO.filterPopUp_action_text_color : _themeVO.filterPopUp_background;
    [applyButton setTitleColor:isIpad()?_themeVO.filterPopUp_background :_themeVO.filterPopUp_action_text_color  forState: UIControlStateNormal];
    [applyButton setTitleColor:isIpad()?_themeVO.filterPopUp_background :[_themeVO.filterPopUp_action_text_color colorWithAlphaComponent:_themeVO.mydata_disabled_icon_opacity]  forState: UIControlStateDisabled];
    [applyButton setTitle:[LocalizationHelper localizedStringWithKey:@"APPLY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController] forState:UIControlStateNormal];
    [applyButton.titleLabel setFont:getCustomFont(17)];
    
    filterByLabel.font = getCustomFont(isIpad() ? 22 : 18);
    filterByLabel.adjustsFontSizeToFitWidth = true;
    filterByLabel.minimumScaleFactor = 0.5;
    filterByLabel.numberOfLines = 2;
    filterByLabel.textColor = _themeVO.filterPopUp_action_text_color;

}

-(void)initiliseArrays{
    noteDataArray = [[NSMutableArray alloc] init];

    if([_userSettingsModel isContextualNoteEnabled] && [_userSettingsModel  isStickyNotesEnabled]){
        [noteDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:[LocalizationHelper localizedStringWithKey:@"Filter_All" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController] FilterType:FilterTypeALL isSubSection:NO isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_text_color hexStringFromColor]] andSeleted:YES]];}
    if(_isStickyNotesEnabled){
        if([_userSettingsModel isStickyNotesEnabled]){
            [noteDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:[LocalizationHelper localizedStringWithKey:@"NOTES_KEY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController] FilterType:FilterTypeNOTE isSubSection:NO isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_text_color hexStringFromColor]] andSeleted:YES]];}
        if([_userSettingsModel isContextualNoteEnabled]){
            [noteDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:[LocalizationHelper localizedStringWithKey:@"Contextual_notes" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController] FilterType:FilterTypeCONTEXTUAL isSubSection:NO isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_text_color hexStringFromColor]] andSeleted:YES]];}
    }else{
        for(FilterDataObject *filterObj in subSectionContextualArray){
            [noteDataArray addObject:filterObj];
        }
    }
    [self reloadCollectionView];
}

#pragma mark :- Button actions
-(void)dropDownButtonTapped:(UIButton*)sender{
    
}

#pragma mark - Collectionview delgate and dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(isHightlightFilter)
        return highlightDataArray.count;
    return noteDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = _themeVO.filterPopUp_background;
    cell.checkBoxIconColor = _themeVO.filterPopUp_all_box_border_color;
    cell.widthConstraintOfTitleBtn.constant = (collectionView.frame.size.width/3) - 30;
    cell.accessibilityIdentifier = [NSString stringWithFormat:@"filterCell%ld", (long)indexPath.row];
    cell.titleButton.accessibilityIdentifier = [NSString stringWithFormat:@"filterCellTitleButton%ld", (long)indexPath.row];
    cell.checkBoxLbl.accessibilityIdentifier = [NSString stringWithFormat:@"filterCellCheckBox%ld", (long)indexPath.row];
    cell.dropDownButton.accessibilityIdentifier = [NSString stringWithFormat:@"filterCellDropDown%ld", (long)indexPath.row];
    if(isHightlightFilter){
        FilterDataObject *filterObj =  [highlightDataArray objectAtIndex:indexPath.row];
        cell.seperatorView.backgroundColor = [UIColor clearColor];
        
        if(isRTL())
        {
            if((indexPath.row)%3 == 0)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            else if((indexPath.row)%3 == 1)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            else
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        else
        {
            if((indexPath.row)%3 == 0)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            else if((indexPath.row)%3 == 1)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            else
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        
        if(filterObj.filterType == FilterTypeNONE){
            cell.checkBoxIconColor = _themeVO.filterPopUp_color_box_border_color;
        }
        else{
            cell.checkBoxIconColor = _themeVO.filterPopUp_all_box_border_color;
        }
        [cell setDataForCell:filterObj];
        [cell setCheckBoxAction:^(FilterDataObject *filterObj) {
            if(filterObj.filterType == FilterTypeALL){
                if(filterObj.isSelected)
                    [self->highlightDataArray setValue:@YES forKey:@"isSelected"];
                else
                    [self->highlightDataArray setValue:@NO forKey:@"isSelected"];
            }
            else{
                if([self getAllSelectedFilterColors:highlightDataArray].count == highlightDataArray.count - 1 && filterObj.isSelected)
                    ((FilterDataObject *)[highlightDataArray firstObject]).isSelected = YES;
                else
                    ((FilterDataObject *)[highlightDataArray firstObject]).isSelected = NO;
            }
            [self updateApplyButtonStatus];
            [self reloadCollectionView];
        }];
    }
    else{
        
    FilterDataObject *filterObj =  [noteDataArray objectAtIndex:indexPath.row];
    cell.seperatorView.backgroundColor = _themeVO.toc_divider_color;
    [cell.dropDownButton setTitleColor:_themeVO.filterPopUp_arrow_color forState:UIControlStateNormal];
    [cell.dropDownButton setTitleColor:_themeVO.filterPopUp_arrow_color forState:UIControlStateSelected];
    cell.checkBoxIconColor = _themeVO.filterPopUp_all_box_border_color;
    cell.titleButton.contentHorizontalAlignment = NSTextAlignmentNatural;
    
    if(filterObj.filterType == FilterTypeALL || filterObj.filterType == FilterTypeNONE){
        cell.seperatorView.backgroundColor = [UIColor clearColor];
    }
        
    if(filterObj.filterType == FilterTypeNONE){
        cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        cell.checkBoxIconColor = _themeVO.filterPopUp_color_box_border_color;
        //get index of element in expand array and align change alignment of title according
        int index;
        if(_isStickyNotesEnabled){
            index = (int)[subSectionNotesArray indexOfObject:filterObj];
            if(index < 0)
                index = (int)[subSectionContextualArray indexOfObject:filterObj];
        }else{
            index = (int)[noteDataArray indexOfObject:filterObj];
        }
        if(isRTL())
        {
            if((index)%3 == 0)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            else if((index)%3 == 1)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            else
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        else
        {
            if((index)%3 == 0)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            else if((index)%3 == 1)
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            else
                cell.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
        }
    }
    else{
        cell.widthConstraintOfTitleBtn.constant = (collectionView.frame.size.width) - 50;
    }
        
    //render data on cell
    [cell setDataForCell:filterObj];
    //dropdown action
    [cell setDropDownAction:^(FilterDataObject *filterObj) {
        [self drowpDownBtnAction:filterObj];
    }];
    //check box action
    [cell setCheckBoxAction:^(FilterDataObject *filterObj) {
        selectedFilter = filterObj.filterType;
        if(_isStickyNotesEnabled){
            [self resetNoteArrayForSelection:filterObj];
        }else{
            if(filterObj.filterType == FilterTypeALL){
                if(filterObj.isSelected)
                    [self->noteDataArray setValue:@YES forKey:@"isSelected"];
                else
                    [self->noteDataArray setValue:@NO forKey:@"isSelected"];
            }
            else{
                if([self getAllSelectedFilterColors:noteDataArray].count == noteDataArray.count - 1 && filterObj.isSelected)
                    ((FilterDataObject *)[noteDataArray firstObject]).isSelected = YES;
                else
                    ((FilterDataObject *)[noteDataArray firstObject]).isSelected = NO;
            }
        }
        [self updateApplyButtonStatus];
        [self reloadCollectionView];
    }];
    }
    return cell;
}

-(void)resetNoteArrayForSelection:(FilterDataObject *)filterDataObj{
    switch (filterDataObj.filterType) {
        case FilterTypeALL:
            if(filterDataObj.isSelected){
                [noteDataArray setValue:@YES forKey:@"isSelected"];
                [subSectionNotesArray setValue:@YES forKey:@"isSelected"];
                [subSectionContextualArray setValue:@YES forKey:@"isSelected"];
            }
            else{
                [noteDataArray setValue:@NO forKey:@"isSelected"];
                [subSectionNotesArray setValue:@NO forKey:@"isSelected"];
                [subSectionContextualArray setValue:@NO forKey:@"isSelected"];
            }
            break;
        case FilterTypeNOTE:{
            if(filterDataObj.isSelected){
                [subSectionNotesArray setValue:@YES forKey:@"isSelected"];
            }
            else{
                [subSectionNotesArray setValue:@NO forKey:@"isSelected"];
            }
            
        }
            break;
        case FilterTypeCONTEXTUAL:{
            if(filterDataObj.isSelected){
                [subSectionContextualArray setValue:@YES forKey:@"isSelected"];
             
            }
            else{
                [subSectionContextualArray setValue:@NO forKey:@"isSelected"];
            }
        }
            break;
        case FilterTypeNONE:{
            NSArray *contextualNoteArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.filterType = %d",FilterTypeCONTEXTUAL]];
            NSArray *noteArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.filterType = %d",FilterTypeNOTE]];
            if([self getAllSelectedFilterColors:subSectionContextualArray].count == subSectionContextualArray.count){
                ((FilterDataObject *)[contextualNoteArray firstObject]).isSelected = YES;
            }
            else {
                ((FilterDataObject *)[contextualNoteArray firstObject]).isSelected = NO;
            }
            if([self getAllSelectedFilterColors:subSectionNotesArray].count == subSectionNotesArray.count){
               ((FilterDataObject *)[noteArray firstObject]).isSelected = YES;
            }
            else {
                ((FilterDataObject *)[noteArray firstObject]).isSelected = NO;
            }
        }
        default:
            break;
    }
    if(filterDataObj.filterType != FilterTypeALL){
        if(([self getAllSelectedFilterColors:subSectionContextualArray].count == subSectionContextualArray.count) && ([self getAllSelectedFilterColors:subSectionNotesArray].count == subSectionNotesArray.count)){
            ((FilterDataObject *)[noteDataArray firstObject]).isSelected = YES;
        }
        else{
            ((FilterDataObject *)[noteDataArray firstObject]).isSelected = NO;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(isHightlightFilter || !_isStickyNotesEnabled){
        return CGSizeMake(collectionView.frame.size.width/3, CollectionViewHeight);
    }
    else{
        FilterDataObject *filterObj =  [noteDataArray objectAtIndex:indexPath.row];
        //if 4th and count is 4 then widhth is equal to collection view width else if count is 5 and 4th element then width = (collectionView.frame.size.width/3,SubSectionCellHeight) and for 5th element - (collectionView.frame.size.width - collectionView.frame.size.width/3)
        if(filterObj.isSubSection){
            CGFloat itemWidth = collectionView.frame.size.width/3;
            
            NSMutableArray *expandedArray;
            NSArray *expadedDataArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpanded = 1"]];
            FilterDataObject *expandedFilterObj = [expadedDataArray firstObject];
            if(expandedFilterObj.filterType == FilterTypeNOTE)
                expandedArray = subSectionNotesArray;
            else
                expandedArray = subSectionContextualArray;

            if((expandedArray.count == 5 && [expandedArray indexOfObject:filterObj] == 4) || (expandedArray.count == 2 && [expandedArray indexOfObject:filterObj] == 1)){
                return CGSizeMake(collectionView.frame.size.width - itemWidth,SubSectionCellHeight);
            }
            else if((expandedArray.count == 4 && [expandedArray indexOfObject:filterObj] == 3)){
                CGSizeMake(collectionView.frame.size.width,SubSectionCellHeight);
            }
            return CGSizeMake(collectionView.frame.size.width/3,SubSectionCellHeight);
        }
        return CGSizeMake(collectionView.frame.size.width,SectionCellHeight);
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (!isIpad()) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
           
              [UIView animateWithDuration:0.0 animations:^{
//                  [self.view layoutIfNeeded];
                  NSArray *expadedDataArray = [noteDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isExpanded = 1"]];
                                FilterDataObject *expandedFilterObj = [expadedDataArray firstObject];
                  if(isHightlightFilter) {
                      heightConstraintOfView.constant = ((ceil(highlightDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
                  }else if(!_isStickyNotesEnabled) {
                      heightConstraintOfView.constant = ((ceil(noteDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
                  }else {
                               if(expandedFilterObj.isExpanded){
                                   if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
                                   heightConstraintOfView.constant = SectionCellHeight * 3  + ViewDefaultHeight + SubSectionCellHeight * ((subSectionNotesArray.count > 3) ? 2 : 1);
                                  else
                                   heightConstraintOfView.constant = SectionCellHeight  + ViewDefaultHeight + SubSectionCellHeight * ((subSectionNotesArray.count > 3) ? 2 : 1);
                                   
                               }
                               else
                                  if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
                                   heightConstraintOfView.constant = SectionCellHeight * 3 + ViewDefaultHeight + 8 /*margin*/;
                                  else
                                   heightConstraintOfView.constant = SectionCellHeight + ViewDefaultHeight
                                      + 8 ;
                  }
                  [self reloadCollectionView];
              }];

        }];
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,isHightlightFilter? 6 :4,0);
}

- (IBAction)applyButtonAction:(UIButton *)sender {
    if(sender.isEnabled){
        if(isHightlightFilter){
            /* parameters of filterHighlightsAction(NSArray *arrayOfHighlights,BOOL isAllSelected,BOOL isSharedHighlighFilter) */
            //if All selected
            if(((FilterDataObject *)[highlightDataArray firstObject]).isSelected){
                self.filterHighlightsAction([NSArray array],YES,YES);
            }
            else{
                //get all colors object except share and all
                NSMutableArray *highlightSelectedArray = [highlightDataArray mutableCopy];
                if([_userSettingsModel isSharingEnabled] && _isSharingEnabled){
                    [highlightSelectedArray removeObjectAtIndex:0];
                    [highlightSelectedArray removeLastObject];
                    
                    //use getAllSelectedFilterColors to get all seleted colors array
                    self.filterHighlightsAction([self getAllSelectedFilterColors:highlightSelectedArray],NO,((FilterDataObject *)[highlightDataArray lastObject]).isSelected);
                }else {
                    self.filterHighlightsAction([self getAllSelectedFilterColors:highlightSelectedArray],NO,NO);
                }
            }
        }
        else{
            // parameters of filterNotesAction (NSArray *arrayOFNotes, NSArray *arrayOFContextualNotes,BOOL isAllSelected,BOOL isSharedNoteFilter,BOOL isSharedContextualNoteFilter)
            if(((FilterDataObject *)[noteDataArray firstObject]).isSelected){
                //if All selected
                self.filterNotesAction(nil,nil,YES,YES,YES);
            }
            else{
                //get all colors object except share
                NSMutableArray *arrayOfNotesFilter = [subSectionNotesArray mutableCopy];
                
                //get all colors object except share and all
                NSMutableArray *arrayOfContextualFilter = [subSectionContextualArray mutableCopy];
                
                if([_userSettingsModel isSharingEnabled] && _isSharingEnabled){
                    [arrayOfNotesFilter removeLastObject];
                    [arrayOfContextualFilter removeLastObject];
                    
                    //use getAllSelectedFilterColors to get all seleted colors array
                    self.filterNotesAction([self getAllSelectedFilterColors:arrayOfNotesFilter],[self getAllSelectedFilterColors:arrayOfContextualFilter],NO,((FilterDataObject *)[subSectionNotesArray lastObject]).isSelected,((FilterDataObject *)[subSectionContextualArray lastObject]).isSelected);
                }else{
                    self.filterNotesAction([self getAllSelectedFilterColors:arrayOfNotesFilter],[self getAllSelectedFilterColors:arrayOfContextualFilter],NO,NO,NO);
                }
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
     
    }];
}

-(void)drowpDownBtnAction:(FilterDataObject *)filterObj{
    [noteDataArray removeObjectsInArray:subSectionNotesArray];
    [noteDataArray removeObjectsInArray:subSectionContextualArray];
    if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
        filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
    switch (filterObj.filterType) {
        case FilterTypeNOTE:{
            if(filterObj.isExpanded){
                [noteDataArray insertObjects:subSectionNotesArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([noteDataArray indexOfObject:filterObj] + 1, subSectionNotesArray.count)]];
                filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
            }
            else{
            }
            for (FilterDataObject *filter in noteDataArray){
                if(filter.filterType == FilterTypeCONTEXTUAL){
                    filter.isExpanded = NO;
                    break;
                }
            }
        }
            break;
        case FilterTypeCONTEXTUAL:{
            if(filterObj.isExpanded){
                [noteDataArray insertObjects:subSectionContextualArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([noteDataArray indexOfObject:filterObj] + 1, subSectionContextualArray.count)]];
                filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"CONTEXTUAL_NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
            }
            else{
            }
            for (FilterDataObject *filter in noteDataArray){
                if(filter.filterType == FilterTypeNOTE){
                    filter.isExpanded = NO;
                    break;
                }
            }
        }
            break;
        case FilterTypeALL:{
            
        }
            break;
        default:
            break;
    }
    if(filterObj.isExpanded){
        if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
        heightConstraintOfView.constant = SectionCellHeight * 3  + ViewDefaultHeight + SubSectionCellHeight * ((subSectionNotesArray.count > 3) ? 2 : 1);
       else
        heightConstraintOfView.constant = SectionCellHeight  + ViewDefaultHeight + SubSectionCellHeight * ((subSectionNotesArray.count > 3) ? 2 : 1);
    }
    else
       if(_userSettingsModel.isContextualNoteEnabled && _userSettingsModel.isStickyNotesEnabled)
        heightConstraintOfView.constant = SectionCellHeight * 3 + ViewDefaultHeight + 8 /*margin*/;
       else
        heightConstraintOfView.constant = SectionCellHeight + ViewDefaultHeight + 8 ;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self reloadCollectionView];

}

-(void)setColorsForFilter:(NSArray *)colorArray{
    colorsArray = colorArray;
    
    //initialise highlight array
    highlightDataArray = [[NSMutableArray alloc] init];
    [highlightDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:[LocalizationHelper localizedStringWithKey:@"Filter_All" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController] FilterType:FilterTypeALL isSubSection:NO isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_text_color hexStringFromColor]] andSeleted:YES]];
    for (NSString *color in colorsArray) {
        [highlightDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:ICON_HIGHLIGHTER_K12 FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:color andSeleted:YES]];
    }
    if([_userSettingsModel isSharingEnabled] && _isSharingEnabled)
    {
        [highlightDataArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:ICON_SHARE FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_check_color hexStringFromColor]] andSeleted:YES]];
    }
   

    //contextual data array
    subSectionNotesArray = [[NSMutableArray alloc] init];
    subSectionContextualArray = [[NSMutableArray alloc] init];
    for (NSString *color in colorsArray) {
        [subSectionNotesArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:ICON_TAPPABLE_STICKY_NOTE FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:color andSeleted:YES]];
        [subSectionContextualArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:NOTE_TEXT_ICON FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:color andSeleted:YES]];
    }
    if([_userSettingsModel isSharingEnabled] && _isSharingEnabled)
    {
    [subSectionNotesArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:ICON_SHARE FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_check_color hexStringFromColor]] andSeleted:YES]];
    [subSectionContextualArray addObject:[FilterDataObject getFilterTypeObjectWithTitle:ICON_SHARE FilterType:FilterTypeNONE isSubSection:YES isExpanded:NO textColor:[NSString stringWithFormat:@"#%@",[_themeVO.filterPopUp_check_color hexStringFromColor]] andSeleted:YES]];
    }
    [self.view layoutIfNeeded];
}

-(void)setIsHighlightFilter:(BOOL)isHighlightFilter{
    isHightlightFilter = isHighlightFilter;
    if(isHightlightFilter){
    filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"Highlights_filter_by" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
    heightConstraintOfView.constant = ((ceil(highlightDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
    }else if(!_isStickyNotesEnabled){
        filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        heightConstraintOfView.constant = ((ceil(noteDataArray.count/3.0)) * CollectionViewHeight) + 8 /*margin*/ +  ViewDefaultHeight;
    }else{
        if(_userSettingsModel.isContextualNoteEnabled)
            filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"CONTEXTUAL_NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        else
             filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"NOTES_FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
        if(_userSettingsModel.isContextualNoteEnabled &&  _userSettingsModel.isStickyNotesEnabled){
            filterByLabel.text = [LocalizationHelper localizedStringWithKey:@"FILTER_BY" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForFilterViewController];
            heightConstraintOfView.constant = SectionCellHeight * 3 + ViewDefaultHeight + 8 /*margin*/;
        }
        else
            heightConstraintOfView.constant = SectionCellHeight + ViewDefaultHeight + 8 ;
        [self.view layoutIfNeeded];
    }
    [self reloadCollectionView];
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)singleTapOnFilter:(UITapGestureRecognizer *)gesture
{
    //set changes to previous state
    if(isHightlightFilter){
        highlightDataArray = [previousStateArray mutableCopy];
    }
    else{
        noteDataArray = [previousStateArray mutableCopy];
        subSectionNotesArray = [subSectionNotesPreviousState mutableCopy];
        subSectionContextualArray = [subSectionContextualPreviousState mutableCopy];
    }
    previousStateArray = nil;
    subSectionNotesPreviousState = nil;
    subSectionContextualPreviousState = nil;
    if(_dissmisFilterController != nil)
        _dissmisFilterController();
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if (touch.view == self.view || touch.view == transaparentBackgroundView) {
            // Don't let selections of auto-complete entries fire the
            // gesture recognizer
            return YES;
        }
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if(_bookOrientationMode == kBookOrientationModeLandscapeOnePageOnly || _bookOrientationMode == kBookOrientationModeLandscapeTwoPageOnly)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else if(_bookOrientationMode == kBookOrientationModePortrait)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Accessibility

-(void)setAccessibilityForFilterItems
{
    filterByLabel.accessibilityIdentifier = FILTER_TITLE_LABEL;
    applyButton.accessibilityIdentifier = FILTER_APPLY_BUTTON;
}
@end
