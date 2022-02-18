//
//  TeacherAnnotationViewController.h
//  Kitaboo
//
//  Created by Hurix System on 26/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderHeader.h"
typedef void(^FetchEachLearnerData)(NSString *learnerName,NSString *learnerId);
typedef void(^LearnerSelectionAction)(NSMutableDictionary *learnerDict,NSString *learnerId);
typedef void(^RemoveAnnotataionController)(void);
typedef void(^DidTapOnGenerateReport)(void);
typedef void(^ClassSelectionAction)(NSString *className);

@interface TeacherAnnotationViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

-(void)setClasses:(NSArray *)classesInfoArray;
-(NSArray*)getUGCForPageIdentifier:(NSString*)pageIdentifier;
-(NSArray*)getAnotationToSave;
-(void)updatePenDrawing:(SDKPentoolVO*)penDrawing;
-(void)updateFIBData:(SDKFIBVO*)fibVO;
-(void)addPenDrawing:(SDKPentoolVO*)penDrawing;
-(BOOL)doesCurrentPageHaveActiveUGC;
-(void)setSubmittedStudentUGCArray:(NSMutableDictionary *)submittedStudentUGCArray;
-(void)serviceFailedWithLearnerID:(NSString *)learnerID;
-(NSArray*)getFIBUGCForPageIdentifier:(NSString*)pageIdentifier;
-(NSArray*)getPenToolUGCForPageIdentifier:(NSString*)pageIdentifier;

@property(strong,nonatomic) NSLayoutConstraint *headerHeightConstraint;
@property(strong,nonatomic) NSMutableDictionary *studentPageUGCDictionary;
@property(strong,nonatomic) LearnerSelectionAction learnerSelectionAction;
@property(strong,nonatomic) FetchEachLearnerData fetchEachLearnerData;
@property(strong,nonatomic) RemoveAnnotataionController removeAnnotataionController;
@property(strong,nonatomic) ClassSelectionAction classSelectionAction;
@property(strong,nonatomic) DidTapOnGenerateReport didTapOnGenerateReport;
@property(strong,nonatomic) NSString  *selectedLearnerName;
@property(strong,nonatomic) NSString  *selectedLearnerImageUrl;
@property(strong,nonatomic) NSString  *selectedLearnerID;
@property(strong,nonatomic) NSString *selectedPageIdentifier;
@property(strong,nonatomic)NSMutableDictionary *classSubmittedData;
@property(strong,nonatomic)NSString *selectedClassName;
@property(strong,nonatomic) KBHDThemeVO *themeVo;
@property(strong,nonatomic) UIView *teacherAnnotationContainerView;
@property(strong,nonatomic) NSLayoutConstraint *topConstraintOfViewContainingPanGesture,*teacherLeftConstraint,*teacherRightConstraint;
@property(strong,nonatomic)UIView *topViewForClassAndSelectStudentLabel;
@property(strong,nonatomic)UIView *_activityIndicatorView;
@property(strong,nonatomic)UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic) UICollectionView *collectionView;
@property(strong,nonatomic)UIView *collectionContainerView;
@property(strong,nonatomic) UITableView *tableView;

-(BOOL)isEditingAllowedForLinkID:(NSInteger)linkID;
-(SDKFIBVO*)getSDKFIBVOForLinkID:(NSInteger)linkID;
-(void)clearAllFIBsForPageID:(NSString*)pageID;
-(BOOL)isFIBsAndPentoolAvailableOnPageID:(NSString*)pageID;
-(void)startActivityIndicator;
-(void)stopActivityIndicator;
-(void)setUpForClassAndSelectStudentLabel;
-(void)setConstraintsForIpad;
-(void)setConstraintsForIPhone;
@end
