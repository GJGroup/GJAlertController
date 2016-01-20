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

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly) GJAlertControllerStyle preferredStyle;

- (void)gj_showInView:(UIView *)aView;


/**
 *  如果没有iOS7的设备可以用来测试GJAlertController库的功能的话，可以直接调用GJAlertController等相关类来测试，用法和系统的UIAlertController一样，但由于GJAlertController内部是用UIAlertView和UIActionSheet来实现的，所以并不能调用[self presentViewController:alert animated:YES completion:nil];来显示，要调用下面的两个测试显示的方法，testShow用于显示Alert，testShowActionSheet用于显示actionsheet
 */
- (void)testShow;

- (void)testShowActonSheet;

@end
