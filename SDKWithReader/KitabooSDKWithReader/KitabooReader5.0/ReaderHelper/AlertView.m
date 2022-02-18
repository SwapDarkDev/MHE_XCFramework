//
//  AlertView.m
//
//
//

#import "AlertView.h"
#import "Constant.h"
#import <Kitaboo_Reader_SDK/Kitaboo_Reader_SDK.h>

@interface AlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) AlertCompletionBlock completionBlock;

@end

@implementation AlertView

+ (instancetype)sharedManager {
    
    static AlertView *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
-(void)displayInformativeAlertwithTitle:(NSString *)title andMessage:(NSString*)message onController:(UIViewController*)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentAlertWithTitle:title message:message andButtonsWithTitle:[NSArray arrayWithObject:NSLocalizedStringFromTableInBundle(@"OK", READER_LOCALIZABLE_TABLE,(LocalizationHelper.readerLanguageBundle!=nil)?LocalizationHelper.readerLanguageBundle:[NSBundle bundleForClass:[self class]], nil)] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle) { }];
    });
}

-(void)presentAlertWithTitle:(NSString*)title
                     message:(NSString*)message
         andButtonsWithTitle:(NSArray*)buttonTitles
                onController:(UIViewController*)controller
               dismissedWith:(AlertCompletionBlock)completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        NSLog(@"AlertView ERROR ==> Invalid button title!");
        return;
    }
    
    self.completionBlock = completionBlock;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//
//        for (NSInteger index = 0; index < buttonTitles.count; index++)
//            [alertView addButtonWithTitle:[buttonTitles objectAtIndex:index]];
//        
//        [alertView show];
    }
    else
    {
        //display UIAlertController
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        for (NSInteger index = 0; index < buttonTitles.count; index++) {
            
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //  AlertActionBLock
                self.completionBlock(index, action.title);

            }];
            [alertController addAction:buttonAction];
        }
        
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

//#pragma mark * * * * UIAlertViewDelegate Method * * * *
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//
//    self.completionBlock(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
//}

@end
