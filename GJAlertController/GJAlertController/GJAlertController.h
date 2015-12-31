/*!
 @header     GJAlertController.h
 @abstract   该类提供与UIAlertViewController一样的api去实现UIAlertViewController的功能
 @discussion 在没有UIAlertViewController类实现的低版本的iOS系统中注册UIAlertViewController类并实现它的子类GJAlertController，用alertView的方式展示alert
 @author     guoxiaoliang850417@163.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GJAlertAction.h"

@interface GJAlertController : NSObject

typedef NS_ENUM(NSInteger, GJAlertControllerStyle) {
    GJAlertControllerStyleActionSheet = 0,
    GJAlertControllerStyleAlert
};

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(GJAlertControllerStyle)preferredStyle;

- (void)addAction:(GJAlertAction *)action;

- (void)gj_showInView:(UIView *)aView;

@end
