//
//  MultiLinkController.m
//  KItabooSDK
//
//  Created by amol shelke on 12/05/18.
//  Copyright © 2018 Hurix Systems. All rights reserved.
//

#import "MultiLinkController.h"
#import "MultiLinkCell.h"
#import "IconFontConstants.h"

@interface MultiLinkController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_multiLinkArray;
}
@end

@implementation MultiLinkController


-(id)initWithFrame:(CGRect)rect WithMultiLinkArray:(NSArray*)multiLinkArray
{
    self = [super init];
    if(self)
    {
        self.tableView.dataSource=self;
        self.tableView.delegate=self;
        _multiLinkArray = multiLinkArray;
        [self.view setFrame:rect];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius=5.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _multiLinkArray.count;
}
-(MultiLinkCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    MultiLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    KFLinkVO *link = [_multiLinkArray objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[MultiLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier linkIconWidth:link.transformedRect.size.height/1.5];
    }
    
    [cell.linkIcon setText:link.iconView.titleLabel.text];
    cell.linkIcon.textColor=link.iconView.titleLabel.textColor;
    cell.linkIcon.backgroundColor=link.iconView.backgroundColor;
    [cell.linkIcon setFont:[UIFont fontWithName:[IconFontConstants getFontForCharacter:link.iconView.titleLabel.text] size:CGRectGetHeight(link.iconView.frame)*0.35]];
    [cell.linkName setText:link.type];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KFLinkVO *selectedLinkVo= [_multiLinkArray objectAtIndex:indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectLinkVo:)])
    {
        [_delegate didSelectLinkVo:selectedLinkVo];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KFLinkVO *link = [_multiLinkArray objectAtIndex:indexPath.row];
    return link.boxTansformedRect.size.height*0.90;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
}

@end
