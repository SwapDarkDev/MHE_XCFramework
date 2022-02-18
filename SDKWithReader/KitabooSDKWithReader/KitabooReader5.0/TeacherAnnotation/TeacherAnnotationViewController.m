//
//  TeacherAnnotationViewController.m
//  Kitaboo
//
//  Created by Hurix System on 26/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import "TeacherAnnotationViewController.h"
#import "TeacherAnnotationViewCell.h"
#import "TeacherAnnotationTableViewCell.h"
#import "HSUIColor-Expanded.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>
#import "Constant.h"
#import "ReaderHeader.h"
#import <KitabooSDKWithReader/KitabooSDKWithReader-Swift.h>

#define defaultBackgroundColor  [UIColor colorWithHexString:@"#FAFAFA"];
#define themeColor              [UIColor colorWithHexString:@"#105D85"];
#define selectedItemColor       [UIColor blackColor];
#define _unSelectedColor        [UIColor colorWithHexString:@"#525252"];
#define LocalizationBundleForTeacherAnnotationViewController  (LocalizationHelper.readerLanguageBundle != nil) ? LocalizationHelper.readerLanguageBundle : [NSBundle bundleForClass:[self class]]
#define activityIndicator_Width isIpad()?300:250
#define activityIndicator_Height isIpad()?130:100

typedef enum : int {
    defaultState = 0,
    dataLoaded = 1,
    dataLoading = 2,
    dataFailed = 3
} DataLoadState;

@interface TeacherAnnotationViewController ()<UIGestureRecognizerDelegate>
{
    UIView *_classSelectedView;
    NSInteger _selectedIndex;
    NSString *cellIdentifier;
    NSMutableArray *_classesInfoArray;
    NSMutableDictionary *_learnersDict;
    NSMutableArray *learnerImages;
    CGFloat previousStateYPosition;
    
    
}

@end

@implementation TeacherAnnotationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self defaultInitialization];
    [self constructUI];
    if (isIpad())
    {
        [self setConstraintsForIpad];
    }else
    {
        [self setConstraintsForIPhone];
    }
    [self addCategorySelectionView];
    [self animationTopIconForIpad];
    if(isIpad())
    {
      [self setupForIpad];
    }
    
    cellIdentifier = @"reuseIdentiier";
    [_tableView registerNib:[UINib nibWithNibName:@"TeacherAnnotationTableViewCell" bundle:[NSBundle bundleForClass:[TeacherAnnotationViewController class]]] forCellReuseIdentifier:cellIdentifier];
    UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesRecognizer.delegate = self;
    [self.view addGestureRecognizer:gesRecognizer];
    
    _classSubmittedData = [[NSMutableDictionary alloc] init];
    for(NSString *classTitle in _classesInfoArray)
    {
        NSArray *learners = [self getAllLearnersForSelectedClass:classTitle];
        NSMutableDictionary *studentData = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *pageDic = [[NSMutableDictionary alloc] init];
        for(NSArray *learner in learners)
        {
            NSDictionary *usersDict = [learner valueForKey:@"user"];
            NSString *studentId = [NSString stringWithFormat:@"%d",[[usersDict valueForKey:@"id"] intValue]];
            [pageDic setObject:[NSNumber numberWithInt:dataLoading] forKey:@"status"];
            [studentData setObject:pageDic forKey:studentId];
        }
        [_classSubmittedData setObject:studentData forKey:classTitle];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_teacherAnnotationContainerView layoutIfNeeded];
    [[_collectionView collectionViewLayout] invalidateLayout];
    [_collectionView layoutSubviews];
    [self animateSelectedViewForCategory:nil];
    [_tableView layoutIfNeeded];
}

-(void)setupForIpad
{
    [self addPanGestureToView:_teacherAnnotationContainerView];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)serviceFailedWithLearnerID:(NSString *)learnerID
{
    NSMutableDictionary *pageDictionary = [[NSMutableDictionary alloc] init];
    [pageDictionary setObject:[NSNumber numberWithInt:dataFailed] forKey:@"status"];
    NSMutableDictionary *classData = _classSubmittedData[_selectedClassName];
    [classData setObject:pageDictionary forKey:learnerID];
    _classSubmittedData[_selectedClassName] = classData;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (TeacherAnnotationTableViewCell *techerCell in self->_tableView.visibleCells)
        {
            if ([learnerID isEqualToString:techerCell.studenId])
            {
                if (techerCell.indexpath)
                {
                    [_tableView reloadRowsAtIndexPaths:@[techerCell.indexpath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
        }
    });
}

-(void)setSubmittedStudentUGCArray:(NSMutableDictionary *)submittedStudentUGCArray
{
    NSString *studentId = submittedStudentUGCArray.allKeys[0];
    NSMutableDictionary *pageDic  = [submittedStudentUGCArray[studentId] objectForKey:@"pageUgc"];
    NSMutableDictionary *pageDictionary = [[NSMutableDictionary alloc] init];
    [pageDictionary setObject:pageDic forKey:@"pageUgc"];
    [pageDictionary setObject:[NSNumber numberWithInt:dataLoaded] forKey:@"status"];
    NSMutableDictionary *classData = _classSubmittedData[_selectedClassName];
    [classData setObject:pageDictionary forKey:studentId];
    _classSubmittedData[_selectedClassName] = classData;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (TeacherAnnotationTableViewCell *techerCell in _tableView.visibleCells)
        {
            if ([studentId isEqualToString:techerCell.studenId])
            {
                if (techerCell.indexpath)
                {
                    [_tableView reloadRowsAtIndexPaths:@[techerCell.indexpath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    });

}

-(void)defaultInitialization
{
    _selectedIndex=0;
}

-(void)constructUI
{
    _teacherAnnotationContainerView=[[UIView alloc]init];
    [self.view addSubview:_teacherAnnotationContainerView];
    _teacherAnnotationContainerView.backgroundColor = self.themeVo.teacherSettings_popup_background;
    
    _topViewForClassAndSelectStudentLabel=[[UIView alloc]init];
    _topViewForClassAndSelectStudentLabel.backgroundColor = UIColor.clearColor;
    [_teacherAnnotationContainerView addSubview:_topViewForClassAndSelectStudentLabel];
    
    _collectionContainerView=[[UIView alloc]init];
    [_teacherAnnotationContainerView addSubview:_collectionContainerView];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=0.0f;
    layout.minimumInteritemSpacing=0.0f;
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[TeacherAnnotationViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionContainerView addSubview:_collectionView];
    

    _collectionView.backgroundColor=defaultBackgroundColor;
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    _collectionView.bounces=false;
    _collectionView.showsHorizontalScrollIndicator=false;
    
    _tableView= [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_teacherAnnotationContainerView addSubview:_tableView];
    _tableView.backgroundColor = _themeVo.teacherSettings_popup_background;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)setConstraintsForIpad
{
    _teacherAnnotationContainerView.translatesAutoresizingMaskIntoConstraints=NO;
    _topConstraintOfViewContainingPanGesture= [_teacherAnnotationContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0];
    _topConstraintOfViewContainingPanGesture.active=true;
    
    _teacherLeftConstraint = [_teacherAnnotationContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0];
    _teacherLeftConstraint.active=true;
    _teacherRightConstraint = [_teacherAnnotationContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0];
    _teacherRightConstraint.active=true;
    [_teacherAnnotationContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active=true;
    
    _topViewForClassAndSelectStudentLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [_topViewForClassAndSelectStudentLabel.topAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.topAnchor constant:20].active=true;
    [_topViewForClassAndSelectStudentLabel.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_topViewForClassAndSelectStudentLabel.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_topViewForClassAndSelectStudentLabel.heightAnchor constraintEqualToConstant:80].active=true;
    [self setUpForClassAndSelectStudentLabel];
    
    _collectionContainerView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionContainerView.topAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.bottomAnchor constant:0].active=true;
    [_collectionContainerView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_collectionContainerView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_collectionContainerView.heightAnchor constraintEqualToConstant:40].active=true;
    
    _collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionView.topAnchor constraintEqualToAnchor:_collectionContainerView.topAnchor constant:0].active=true;
    [_collectionView.leadingAnchor constraintEqualToAnchor:_collectionContainerView.leadingAnchor constant:0].active=true;
    [_collectionView.trailingAnchor constraintEqualToAnchor:_collectionContainerView.trailingAnchor constant:0].active=true;
    [_collectionView.heightAnchor constraintEqualToConstant:40].active=true;
    
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [_tableView.topAnchor constraintEqualToAnchor:_collectionContainerView.bottomAnchor constant:10].active=true;
    [_tableView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_tableView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_tableView.bottomAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.bottomAnchor constant:-70.0].active=true;
    
    [self addGenerateReportButton];
    
    UIView *lineView=[[UIView alloc]init];
    [_teacherAnnotationContainerView addSubview:lineView];
    lineView.backgroundColor = self.themeVo.teacher_studentlist_popup_border;
    lineView.translatesAutoresizingMaskIntoConstraints=NO;
    [lineView.topAnchor constraintEqualToAnchor:_collectionContainerView.bottomAnchor constant:1].active=true;
    [lineView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [lineView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [lineView.heightAnchor constraintEqualToConstant:1].active=true;
}

-(void)setConstraintsForIPhone
{
    _teacherAnnotationContainerView.translatesAutoresizingMaskIntoConstraints=NO;
    _topConstraintOfViewContainingPanGesture= [_teacherAnnotationContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0];
    _topConstraintOfViewContainingPanGesture.active=true;
    
    _teacherLeftConstraint = [_teacherAnnotationContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0];
    _teacherLeftConstraint.active=true;
    _teacherRightConstraint = [_teacherAnnotationContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0];
    _teacherRightConstraint.active=true;
    [_teacherAnnotationContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active=true;
    
    _topViewForClassAndSelectStudentLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [_topViewForClassAndSelectStudentLabel.topAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.topAnchor constant:20].active=true;
    [_topViewForClassAndSelectStudentLabel.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_topViewForClassAndSelectStudentLabel.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_topViewForClassAndSelectStudentLabel.heightAnchor constraintEqualToConstant:80].active=true;
    [self setUpForClassAndSelectStudentLabel];
    
    _collectionContainerView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionContainerView.topAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.bottomAnchor constant:0].active=true;
    [_collectionContainerView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_collectionContainerView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_collectionContainerView.heightAnchor constraintEqualToConstant:40].active=true;
    
    _collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionView.topAnchor constraintEqualToAnchor:_collectionContainerView.topAnchor constant:0].active=true;
    [_collectionView.leadingAnchor constraintEqualToAnchor:_collectionContainerView.leadingAnchor constant:0].active=true;
    [_collectionView.trailingAnchor constraintEqualToAnchor:_collectionContainerView.trailingAnchor constant:0].active=true;
    [_collectionView.heightAnchor constraintEqualToConstant:40].active=true;
    
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [_tableView.topAnchor constraintEqualToAnchor:_collectionContainerView.bottomAnchor constant:10].active=true;
    [_tableView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [_tableView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [_tableView.bottomAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.bottomAnchor constant:-70.0].active=true;
    
    [self addGenerateReportButton];
    
    UIView *lineView=[[UIView alloc]init];
    [_teacherAnnotationContainerView addSubview:lineView];
    lineView.backgroundColor = self.themeVo.teacher_studentlist_popup_border;
    lineView.translatesAutoresizingMaskIntoConstraints=NO;
    [lineView.topAnchor constraintEqualToAnchor:_collectionContainerView.bottomAnchor constant:1].active=true;
    [lineView.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [lineView.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [lineView.heightAnchor constraintEqualToConstant:1].active=true;
}

-(void)setUpForClassAndSelectStudentLabel
{
    UIButton *backButton = nil;
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton.titleLabel setFont:[UIFont fontWithName:[HDKitabooFontManager getFontName] size:17]];
    [backButton setTitle:@"G" forState:UIControlStateNormal];
    [backButton setTitleColor:self.themeVo.teacher_studentlist_title_color forState:UIControlStateNormal];
    [_topViewForClassAndSelectStudentLabel addSubview:backButton];
    backButton.translatesAutoresizingMaskIntoConstraints = false;
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton.topAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.topAnchor constant:11].active=true;
    [backButton.leadingAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.leadingAnchor constant:20].active=true;
    [backButton.heightAnchor constraintEqualToConstant:18].active=true;
    [backButton.widthAnchor constraintEqualToConstant:18].active=true;
    
    UILabel *classLabel = [[UILabel alloc] init];
    classLabel.text = NSLocalizedStringFromTableInBundle(@"CLASS", READER_LOCALIZABLE_TABLE, LocalizationBundleForTeacherAnnotationViewController, "");
    classLabel.font = getCustomFont(isIpad()?22:18);
    classLabel.textColor = self.themeVo.teacher_studentlist_title_color;
    [_topViewForClassAndSelectStudentLabel addSubview:classLabel];
    
    classLabel.translatesAutoresizingMaskIntoConstraints = false;
    [classLabel.topAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.topAnchor constant:7].active=true;
    [classLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:15].active=true;
    [classLabel.heightAnchor constraintEqualToConstant:isIpad()?30:25].active=true;
    //[classLabel.widthAnchor constraintEqualToConstant:isIpad()?80:45].active=true;
    [classLabel.rightAnchor constraintLessThanOrEqualToAnchor:_topViewForClassAndSelectStudentLabel.rightAnchor constant:-8].active=true;
    
    UILabel *selectStudentLabel = [[UILabel alloc] init];
    selectStudentLabel.text =  NSLocalizedStringFromTableInBundle(@"SELECT_STUDENT_FOR_REVIEW", READER_LOCALIZABLE_TABLE, LocalizationBundleForTeacherAnnotationViewController, "");
    selectStudentLabel.textColor = self.themeVo.teacher_studentlist_title_color;
    selectStudentLabel.font = getCustomFont(isIpad()?16:12);
    [_topViewForClassAndSelectStudentLabel addSubview:selectStudentLabel];
    
    selectStudentLabel.translatesAutoresizingMaskIntoConstraints = false;
    [selectStudentLabel.topAnchor constraintEqualToAnchor:classLabel.bottomAnchor constant:10].active=true;
    [selectStudentLabel.leadingAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.leadingAnchor constant:53].active=true;
    [selectStudentLabel.leftAnchor constraintEqualToAnchor:_topViewForClassAndSelectStudentLabel.leftAnchor constant:53].active=true;
    [selectStudentLabel.heightAnchor constraintEqualToConstant:isIpad()?20:15].active=true;
    //[selectStudentLabel.widthAnchor constraintGreaterThanOrEqualToConstant:isIpad()?100:80].active=true;
    [selectStudentLabel.rightAnchor constraintLessThanOrEqualToAnchor:_topViewForClassAndSelectStudentLabel.rightAnchor constant:-8].active=true;
}

-(void)backButtonPressed:(UIButton *)button
{
    if(_removeAnnotataionController != nil)
    {
        self.removeAnnotataionController();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)animationTopIconForIpad
{
    UILabel *upDirectionIconLbl=[[UILabel alloc]init];
    [_teacherAnnotationContainerView addSubview:upDirectionIconLbl];
    [upDirectionIconLbl setText:ICON_MOVE_SHELF_UP];
    [upDirectionIconLbl setFont:[UIFont fontWithName:[HDIconFontConstants getFontName] size:25]];
    upDirectionIconLbl.contentMode=UIViewContentModeScaleAspectFill;
    [upDirectionIconLbl setTextColor:[UIColor whiteColor]];
    upDirectionIconLbl.translatesAutoresizingMaskIntoConstraints = false;
    [upDirectionIconLbl.topAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.topAnchor constant:-30].active=true;
    [upDirectionIconLbl.centerXAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.centerXAnchor constant:0].active=true;
    [upDirectionIconLbl.heightAnchor constraintEqualToConstant:20].active=true;
    [upDirectionIconLbl.widthAnchor constraintEqualToConstant:30].active=true;
}

-(void)addCategorySelectionView
{
    if(!_classSelectedView)
    {
        _classSelectedView = [[UIView alloc] init];
    }
    _classSelectedView.backgroundColor= self.themeVo.teacher_studentlist_tab_selected_bar;
    [_collectionContainerView addSubview:_classSelectedView];
}

-(void)updateBorderShadowColor
{
    _teacherAnnotationContainerView.layer.borderColor = self.themeVo.teacher_studentlist_popup_border.CGColor;
    _teacherAnnotationContainerView.layer.borderWidth = 1;
    _teacherAnnotationContainerView.layer.masksToBounds = false;
    _teacherAnnotationContainerView.layer.shadowOffset = CGSizeMake(0,-1);
    _teacherAnnotationContainerView.layer.shadowRadius = 4.0;
    _teacherAnnotationContainerView.layer.shadowOpacity = 0.6;
}

- (void)animateSelectedViewForCategory:(TeacherAnnotationViewCell *)celll
{
        TeacherAnnotationViewCell* cell =  (TeacherAnnotationViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        if(cell)
        {
            CGRect rect =  [_collectionView convertRect:cell.frame toView:[_collectionView superview]];
            [UIView animateWithDuration:0.4 animations:^{
                
                self->_classSelectedView.frame = CGRectMake(rect.origin.x,  CGRectGetMaxY(self->_collectionView.frame)-1, cell.frame.size.width, 3);
                
                [self.view layoutIfNeeded];
            }];
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    TeacherAnnotationViewCell* cell =  (TeacherAnnotationViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    if(cell)
    {
        CGRect rect =  [_collectionView convertRect:cell.frame toView:[_collectionView superview]];
        [UIView animateWithDuration:0.2 animations:^{
            
            self->_classSelectedView.frame = CGRectMake(rect.origin.x,  CGRectGetMaxY(self->_collectionView.frame)-1, cell.frame.size.width, 3);
        }];
    }
}

-(void)setClasses:(NSArray *)classesInfoArray
{
    _classesInfoArray =[[NSMutableArray alloc]init];
    _learnersDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    for(SDKBookClassInfoVO *classInfoVO in classesInfoArray)
    {
        [_classesInfoArray addObject:classInfoVO.classTitle];
        [_learnersDict setObject:classInfoVO.learners forKey:classInfoVO.classTitle];
    }
    if(classesInfoArray)
    {
        SDKBookClassInfoVO *classInfo = [classesInfoArray firstObject];
        _selectedClassName = classInfo.classTitle;
    }
}

-(NSArray *)getAllLearnersForSelectedClass:(NSString *)selectedClass
{
    if(((NSArray*)[_learnersDict valueForKey:selectedClass]).count)
    {
        return [_learnersDict valueForKey:selectedClass];
    }
    else
    {
        return  0;
    }
}

-(NSArray*)getUGCForPageIdentifier:(NSString*)pageIdentifier
{
    _selectedPageIdentifier=pageIdentifier;
    return [_studentPageUGCDictionary objectForKey:pageIdentifier];
}

-(BOOL)doesCurrentPageHaveActiveUGC
{
    for (SDKPentoolVO *pentoolVO in [self getUGCForPageIdentifier:_selectedPageIdentifier]) {
        if(pentoolVO.status != DELETE)
        {
            return YES;
        }
    }
    return NO;
}
-(NSArray*)getPenToolUGCForPageIdentifier:(NSString*)pageIdentifier
{
    _selectedPageIdentifier=pageIdentifier;
    NSArray *ugcDrawings= [_studentPageUGCDictionary objectForKey:pageIdentifier];
    NSMutableArray *penToolArray = [[NSMutableArray alloc]init];;
    if(ugcDrawings.count)
    {
        for(id object in ugcDrawings)
        {
            if([object isKindOfClass:[SDKPentoolVO class]])
            {
                SDKPentoolVO *sdkPenToolVo = (SDKPentoolVO*)object;
                [penToolArray addObject:sdkPenToolVo];
            }
        }
    }
    return penToolArray;
}
-(NSArray*)getFIBUGCForPageIdentifier:(NSString*)pageIdentifier
{
    _selectedPageIdentifier=pageIdentifier;
    NSArray *ugcDrawings= [_studentPageUGCDictionary objectForKey:pageIdentifier];
    NSMutableArray *fibArray = [[NSMutableArray alloc]init];;
    if(ugcDrawings.count)
    {
        for(id object in ugcDrawings)
        {
            if([object isKindOfClass:[SDKFIBVO class]])
            {
                SDKFIBVO *sdkFIBVo = (SDKFIBVO*)object;
                if (sdkFIBVo.status != DELETE) {
                    [fibArray addObject:sdkFIBVo];
                }
            }
        }
    }
    return fibArray;
}
-(void)updatePenDrawing:(SDKPentoolVO*)penDrawing
{
    NSMutableArray *loadedUGC=[[NSMutableArray alloc] initWithArray:[_studentPageUGCDictionary objectForKey:_selectedPageIdentifier]];
    [loadedUGC removeObject:[self getSDKPentoolVOWithLocalID:penDrawing.localID]];
    if(penDrawing.ugcID && ![penDrawing.ugcID isEqualToString:@"-1"] && ![penDrawing.ugcID isEqualToString:@""])
    {
        [loadedUGC addObject:penDrawing];
    }
    [_studentPageUGCDictionary removeObjectForKey:_selectedPageIdentifier];
    [_studentPageUGCDictionary setObject:[NSArray arrayWithArray:loadedUGC] forKey:_selectedPageIdentifier];
}
-(void)updateFIBData:(SDKFIBVO*)fibVO
{
    NSMutableArray *loadedUGC=[[NSMutableArray alloc] initWithArray:[_studentPageUGCDictionary objectForKey:_selectedPageIdentifier]];
    [loadedUGC removeObject:[self getSDKFIBVOWithLocalID:fibVO.localID]];
    NSString *ugcID = [self getUGCId:fibVO.ugcID];
    if(fibVO.ugcID && ![ugcID isEqualToString:@"-1"] && ![ugcID isEqualToString:@""])
    {
        fibVO.status = UPDATE;
        [loadedUGC addObject:fibVO];
    }
    [_studentPageUGCDictionary removeObjectForKey:_selectedPageIdentifier];
    [_studentPageUGCDictionary setObject:[NSArray arrayWithArray:loadedUGC] forKey:_selectedPageIdentifier];
}
-(NSString*)getUGCId:(id)ugcID
{
    if([ugcID isKindOfClass:[NSString class]])
    {
        return ugcID;
    }
    return [ugcID stringValue];
}
-(void)addPenDrawing:(SDKPentoolVO*)penDrawing
{
    NSMutableArray *loadedUGC=[[NSMutableArray alloc] initWithArray:[_studentPageUGCDictionary objectForKey:_selectedPageIdentifier]];
    [loadedUGC addObject:penDrawing];
    [_studentPageUGCDictionary removeObjectForKey:_selectedPageIdentifier];
    [_studentPageUGCDictionary setObject:[NSArray arrayWithArray:loadedUGC] forKey:_selectedPageIdentifier];
}

-(SDKPentoolVO*)getSDKPentoolVOWithLocalID:(NSString*)localID
{
    for (NSArray *ugcarray in [_studentPageUGCDictionary allValues])
    {
        for (SDKPentoolVO *ugc in ugcarray)
        {
            if([ugc.localID isEqualToString:localID])
            {
                return ugc;
            }
        }
    }
    return nil;
}
-(SDKFIBVO*)getSDKFIBVOWithLocalID:(NSString*)localID
{
    for (NSArray *ugcarray in [_studentPageUGCDictionary allValues])
    {
        for (SDKFIBVO* ugc in ugcarray)
        {
            if([ugc.localID isEqualToString:localID])
            {
                return ugc;
            }
        }
    }
    
    return nil;
}
#pragma mark - Collection view delegates and datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_learnersDict.allKeys count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_classesInfoArray.count<=4){
        return CGSizeMake(_collectionContainerView.frame.size.width/_classesInfoArray.count, _collectionView.frame.size.height);
    }
    else{
        return CGSizeMake(_collectionContainerView.frame.size.width/4, _collectionView.frame.size.height);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherAnnotationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.classButton.text = [_learnersDict.allKeys objectAtIndex:indexPath.row];
    cell.backgroundColor = _themeVo.teacherSettings_popup_background;
    if(indexPath.row == _selectedIndex)
    {
        cell.classButton.font = getCustomFont(isIpad()?20:18);
        cell.classButton.textColor = self.themeVo.teacherSettings_title_color;
    }else
    {
        cell.classButton.font = getCustomFontForWeight(isIpad()?20:18,UIFontWeightLight);
        cell.classButton.textColor= self.themeVo.teacherSettings_title_color;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        _selectedIndex = indexPath.row;
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self animateSelectedViewForCategory:nil];
        _selectedClassName = [_classesInfoArray objectAtIndex:indexPath.row];
        [_collectionView reloadData];
        [_tableView reloadData];
    });
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *learnersArray = [self getAllLearnersForSelectedClass:_selectedClassName];
    return learnersArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherAnnotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *learnersArray = [self getAllLearnersForSelectedClass:_selectedClassName];
    NSDictionary *usersDict = [[learnersArray objectAtIndex:indexPath.row] valueForKey:@"user"];
    NSString *learnerName =[[usersDict valueForKey:@"firstName"]stringByAppendingString:@" "];
    learnerName = [learnerName stringByAppendingString:[usersDict valueForKey:@"lastName"]];
    NSString *studentId = [NSString stringWithFormat:@"%d",[[usersDict valueForKey:@"id"] intValue]];
    cell.nameLabel.text = [[@"  "stringByAppendingString:learnerName]capitalizedString];
    [cell.nameLabel setTextColor:self.themeVo.teacher_studentlist_name_color];
    [cell.nameLabel setFont:getCustomFont(isIpad()?18:14)];
    cell.backgroundColor = _themeVo.teacherSettings_popup_background;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.checkMarkLabel setHidden:YES];
    [cell.checkMarkLabel setTextColor:_themeVo.teacherSettings_check_color];
    [cell.refreshButton.layer setBorderColor:[self.themeVo.teacher_studentlist_refresh_button_text_color CGColor]];
    [cell.refreshButton setTitleColor:self.themeVo.teacher_studentlist_refresh_button_text_color forState:UIControlStateNormal];
    cell.studenId = studentId;
    cell.indexpath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(TeacherAnnotationTableViewCell) *weakCell = cell;
    [cell setRefreshButtonAction:^(NSString *studentName, NSString *studenId, NSIndexPath *indexpath)
    {
        [weakSelf refreshButtonTapped:studentName withStudentID:studenId withCell:weakCell];
    }];
    
    if (_classSubmittedData[_selectedClassName])
    {
        NSDictionary *studentData = _classSubmittedData[_selectedClassName];
        if (studentData[studentId])
        {
            NSDictionary *studentIDData = studentData[studentId];
            if (studentIDData[@"status"]==[NSNumber numberWithInt:dataLoading])
            {
                cell.dotView.backgroundColor = UIColor.clearColor;
                cell.refreshButton.hidden = YES;
                cell.dotViewLabel.text = @"";
                [cell.activityIndicatorView startAnimating];
            }else if (studentIDData[@"status"]==[NSNumber numberWithInt:dataLoaded])
            {
                NSDictionary *pageDic = studentIDData[@"pageUgc"];
                if (([pageDic count]>0))
                {
                    [cell.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;
                    cell.dotView.layer.cornerRadius = isIpad()?10:10;
                    cell.dotView.clipsToBounds = YES;
                    cell.dotView.backgroundColor = self.themeVo.teacher_studentlist_data_added_color;
                    cell.refreshButton.hidden = YES;
                }else
                {
                    [cell.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;
                    cell.dotView.layer.cornerRadius = isIpad()?10:10;
                    cell.dotView.clipsToBounds = YES;
                    cell.refreshButton.hidden = YES;
                    cell.dotView.backgroundColor = self.themeVo.teacher_studentlist_nodata_added_color;
                }
            }else if (studentIDData[@"status"]==[NSNumber numberWithInt:dataFailed])
            {
                [cell.activityIndicatorView stopAnimating];
                self.view.userInteractionEnabled = YES;
                cell.dotView.backgroundColor = UIColor.clearColor;
                cell.dotViewLabel.text = @"?";
                cell.dotViewLabel.textColor = self.themeVo.teacher_studentlist_nodata_added_color;
                [cell.dotView bringSubviewToFront:cell.dotViewLabel];
                cell.refreshButton.hidden = NO;
            }
        }
    }
    
    if ([_classSubmittedData count]>0 && _classSubmittedData[_selectedClassName])
    {
       NSDictionary *studentData = _classSubmittedData[_selectedClassName];
       NSDictionary *studentDictID = studentData[studentId];
       if (studentDictID[@"status"]==[NSNumber numberWithInt:dataLoading])
       {
//           [studentDictID setValue:[NSNumber numberWithInt:defaultState] forKey:@"status"];
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
           {
               if(_fetchEachLearnerData != nil)
               {
                   self.fetchEachLearnerData(learnerName,studentId);
               }
           });
       }
    }
    return cell;
}

-(void)refreshButtonTapped:(NSString *)studentName withStudentID:(NSString *)studentID withCell:(TeacherAnnotationTableViewCell *)cell
{
    if (![[cell.dotView.backgroundColor hexStringFromColor] isEqual:[self.themeVo.teacher_studentlist_nodata_added_color hexStringFromColor]])
    {
        [cell.activityIndicatorView startAnimating];
        cell.dotView.backgroundColor = UIColor.clearColor;
        cell.dotViewLabel.text = @"";
        cell.refreshButton.hidden= YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            if(_fetchEachLearnerData != nil)
            {
                self.fetchEachLearnerData(studentName,studentID);
            }
        });
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isIpad()?65:38;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherAnnotationTableViewCell* cell = (TeacherAnnotationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *learnersArray = [self getAllLearnersForSelectedClass:_selectedClassName];
    NSDictionary *userDict = [[learnersArray objectAtIndex:indexPath.row] valueForKey:@"user"];
    NSString *urlString = [userDict valueForKey:@"profilePicURL"];
    self.selectedLearnerImageUrl = urlString;
    NSString *learnerName = [[userDict valueForKey:@"firstName"] stringByAppendingString:[userDict valueForKey:@"lastName"]];
    self.selectedLearnerName = learnerName;
    NSString *studentId = [NSString stringWithFormat:@"%d",[[userDict valueForKey:@"id"] intValue]];
    NSMutableDictionary *dic = _classSubmittedData[_selectedClassName];
    NSMutableDictionary *pageUgc = dic[studentId];
    if([pageUgc[@"pageUgc"] count]>0)
    {
       if(_learnerSelectionAction != nil)
       {
           [cell.checkMarkLabel setHidden:NO];
           self.learnerSelectionAction(pageUgc[@"pageUgc"],studentId);
       }
    }
    else
    {
        if(pageUgc[@"pageUgc"] != nil)
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[learnerName stringByAppendingString:[LocalizationHelper localizedStringWithKey:@"HAS_NOT_SUBMITTED_ANY_ANSWER" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForTeacherAnnotationViewController]] andButtonsWithTitle:@[[LocalizationHelper localizedStringWithKey:@"OK" tableName:READER_LOCALIZABLE_TABLE bundle:LocalizationBundleForTeacherAnnotationViewController]] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        }];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherAnnotationTableViewCell* cell = (TeacherAnnotationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.checkMarkLabel setHidden:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if(gestureRecognizer.view == self.view)
            return YES;
        else
            return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if (touch.view == self.view)
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

-(void)handlePan:(UIPanGestureRecognizer*)panGes
{
    CGPoint t = [panGes translationInView:self.view];
    CGPoint velocity = [panGes velocityInView:self.view];
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        previousStateYPosition = _topConstraintOfViewContainingPanGesture.constant;
        _topConstraintOfViewContainingPanGesture.constant = MAX(0,(previousStateYPosition+t.y));
        [self.view layoutIfNeeded];
    }else if (panGes.state == UIGestureRecognizerStateChanged)
    {
        _topConstraintOfViewContainingPanGesture.constant = MAX(0,previousStateYPosition+t.y);
        if(_topConstraintOfViewContainingPanGesture.constant <= 0)
        {
            _teacherRightConstraint.constant = 0;
            _teacherLeftConstraint.constant = 0;
        }
        else
        {
            _teacherRightConstraint.constant = -34;
            _teacherLeftConstraint.constant = 34;
        }
        [UIView animateWithDuration:0.3 animations:^
        {
            [self.view layoutIfNeeded];
        }];
    }else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        panGes.view.alpha = 1.0;
        if(_topConstraintOfViewContainingPanGesture.constant < (windowHeight/2 - 130) && velocity.y < 0){
            _topConstraintOfViewContainingPanGesture.constant = 0.0;
            _teacherRightConstraint.constant = 0;
            _teacherLeftConstraint.constant = 0;
        }
        else if (_topConstraintOfViewContainingPanGesture.constant < (windowHeight/2 - 130) && velocity.y > 0){
            _topConstraintOfViewContainingPanGesture.constant = (windowHeight/2 - 130);
            _teacherRightConstraint.constant = -34;
            _teacherLeftConstraint.constant = 34;
        }
        else if (_topConstraintOfViewContainingPanGesture.constant > windowHeight/3 && velocity.y > 0){
            [self handleTap:nil];
            return;
        }

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if(_removeAnnotataionController != nil)
    self.removeAnnotataionController();
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPanGestureToView:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    pan.cancelsTouchesInView = NO;
    [view addGestureRecognizer:pan];
    _topConstraintOfViewContainingPanGesture.constant =  isIpad()? (windowHeight/2 - 130): 0;
    _teacherLeftConstraint.constant = isIPAD? 34:0;
    _teacherRightConstraint.constant = isIPAD? -34:0;
    [self updateBorderShadowColor];
}

-(NSArray*)getAnotationToSave{
    NSMutableArray *ugctosave=[[NSMutableArray alloc]init];
    for (NSArray *ugcArray in [_studentPageUGCDictionary allValues])
    {
        for (id ugc in ugcArray)
        {
            if([ugc isKindOfClass:[SDKPentoolVO class]])
            {
                SDKPentoolVO *penToolVO = (SDKPentoolVO*)ugc;
                NSString *ugcID;
                if( [penToolVO.ugcID isKindOfClass:[NSNumber class]])
                {
                    ugcID=[NSString stringWithFormat:@"%d",penToolVO.ugcID.intValue];
                }
                else
                {
                    ugcID=penToolVO.ugcID;
                }
                
                if(!ugcID || [ugcID isEqualToString:@"-1"] || [ugcID isEqualToString:@""])
                {
                    if(penToolVO.status == NEW || penToolVO.status == UPDATE)
                    {
                        [ugctosave addObject:penToolVO];
                    }
                }
                else
                {
                    if(penToolVO.status == DELETE)
                    {
                        [ugctosave addObject:penToolVO];
                    }
                }
            }
            else if ([ugc isKindOfClass:[SDKFIBVO class]])
            {
                SDKFIBVO *fibVO = (SDKFIBVO*)ugc;
                NSString *ugcID;
                if( [fibVO.ugcID isKindOfClass:[NSNumber class]])
                {
                    ugcID=[NSString stringWithFormat:@"%d",fibVO.ugcID.intValue];
                }
                else
                {
                    ugcID=fibVO.ugcID;
                }
                
                if(ugcID || ![ugcID isEqualToString:@"-1"] || ![ugcID isEqualToString:@""])
                {
                    if(fibVO.status == UPDATE || fibVO.status == DELETE)
                    {
                        [ugctosave addObject:fibVO];
                    }
                }
            }
        }
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"modifiedDate" ascending:YES];
    [ugctosave sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    ugctosave = [[[NSOrderedSet orderedSetWithArray:ugctosave] array] mutableCopy];
    return [NSArray arrayWithArray:ugctosave];
}

-(void)dealloc{
    _classesInfoArray=nil;
    _learnersDict=nil;
    _classSelectedView=nil;
    _collectionView=nil;
    _collectionContainerView=nil;
    _tableView=nil;
    learnerImages=nil;
    _teacherAnnotationContainerView=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isEditingAllowedForLinkID:(NSInteger)linkID
{
    for (NSArray *ugcarray in [_studentPageUGCDictionary allValues])
    {
        for (id ugc in ugcarray)
        {
            if([ugc isKindOfClass:[SDKFIBVO class]])
            {
                SDKFIBVO *fibUgc= (SDKFIBVO*)ugc;
                if(fibUgc.linkID.integerValue == linkID)
                {
                    return true;
                }
            }
        }
    }
    
    return false;
}


-(SDKFIBVO*)getSDKFIBVOForLinkID:(NSInteger)linkID
{
    for (NSArray *ugcarray in [_studentPageUGCDictionary allValues])
    {
        for (id ugc in ugcarray)
        {
            if([ugc isKindOfClass:[SDKFIBVO class]])
            {
                SDKFIBVO *fibUgc= (SDKFIBVO*)ugc;
                if(fibUgc.linkID.integerValue == linkID)
                {
                    return fibUgc;
                }
            }
        }
    }
    
    return nil;
}
-(void)clearAllFIBsForPageID:(NSString*)pageID
{
    for(id object in [_studentPageUGCDictionary objectForKey:pageID])
    {
        if([object isKindOfClass:[SDKFIBVO class]])
        {
            SDKFIBVO *sdkFIBVo = (SDKFIBVO*)object;
            sdkFIBVo.text = @"";
            sdkFIBVo.status= DELETE;
        }
    }
}
-(BOOL)isFIBsAndPentoolAvailableOnPageID:(NSString*)pageID
{
    for(id object in [_studentPageUGCDictionary objectForKey:pageID])
    {
        if([object isKindOfClass:[SDKFIBVO class]])
        {
            SDKFIBVO *sdkFIBVo = (SDKFIBVO*)object;
            if(![sdkFIBVo.text isEqualToString:@""] && [[sdkFIBVo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
            {
                return true;
            }
        }
        if([object isKindOfClass:[SDKPentoolVO class]])
        {
            SDKPentoolVO *penToolVO = (SDKPentoolVO*)object;
            if(penToolVO.status != DELETE)
            {
                return true;
            }
        }
    }
    return false;
}

- (void)addGenerateReportButton
{
    UIButton *generateReportButton = [[UIButton alloc] init];
    [generateReportButton setTitle:NSLocalizedStringFromTableInBundle(@"GENERATE_REPORT", READER_LOCALIZABLE_TABLE, LocalizationBundleForTeacherAnnotationViewController, "") forState:UIControlStateNormal];
    [generateReportButton setTitle:NSLocalizedStringFromTableInBundle(@"GENERATE_REPORT", READER_LOCALIZABLE_TABLE, LocalizationBundleForTeacherAnnotationViewController, "") forState:UIControlStateSelected];
    [generateReportButton setBackgroundColor:[UIColor whiteColor]];
    [generateReportButton setTitleColor:self.themeVo.teacher_studentlist_title_color forState:UIControlStateNormal];
    [generateReportButton setTitleColor:self.themeVo.teacher_studentlist_title_color forState:UIControlStateSelected];
    [generateReportButton addTarget:self action:@selector(didTapOnGenerateReportButton:) forControlEvents:UIControlEventTouchUpInside];
    generateReportButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [_teacherAnnotationContainerView addSubview:generateReportButton];
    
    [generateReportButton.topAnchor constraintEqualToAnchor:_tableView.bottomAnchor constant:0].active=true;
    [generateReportButton.leadingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.leadingAnchor constant:0].active=true;
    [generateReportButton.trailingAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.trailingAnchor constant:0].active=true;
    [generateReportButton.bottomAnchor constraintEqualToAnchor:_teacherAnnotationContainerView.bottomAnchor constant:0].active=true;
}


- (void)didTapOnGenerateReportButton:(UIButton *)button
{
    if(_didTapOnGenerateReport != nil)
    {
        self.didTapOnGenerateReport();
    }
}

/**
 Create activity indicator view, call this method to add activity indicator
 */

-(void)addActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [_activityIndicator startAnimating];
}

/**
 To start activity indicator
 */
-(void)startActivityIndicator
{
    [self addActivityIndicator];
    self.view.userInteractionEnabled=NO;
}

/**
 TO stop activity indicator
 */
-(void)stopActivityIndicator
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    _activityIndicator = nil;
    self.view.userInteractionEnabled=YES;
}


@end
