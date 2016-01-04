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
@property (nonatomic, readonly) NSArray<GJAlertAction *> *actions;

/**
 *  该属性是iOS9针对UIAlertControllerStyleAlert添加的，并不能用UIAlertView实现该属性的功能，
    这里仅仅是提供方法调用使得不发生crash，这里改属性并没有意义
 */
@property (nonatomic, strong) GJAlertAction *preferredAction;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly) GJAlertControllerStyle preferredStyle;

- (void)gj_showInView:(UIView *)aView;

@end
