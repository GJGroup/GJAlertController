

#import "GJAlertController.h"
#import <objc/runtime.h>

static GJAlertController *defaultController;

@interface GJAlertController()<UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation GJAlertController
{
    UIAlertView *_gjAlertView;
    UIActionSheet *_gjActionSheet;
    NSMutableArray *_alertActionArr;
    NSMutableArray *_alertTextFieldArr;
    GJAlertControllerStyle _style;
}

+ (void)setupDefaultController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultController = [[GJAlertController alloc] init];
        defaultController->_alertActionArr = [NSMutableArray new];
    });
    if (defaultController->_alertActionArr.count > 0) {
        [defaultController->_alertActionArr removeAllObjects];
    }
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(GJAlertControllerStyle)preferredStyle
{
    [self setupDefaultController];
    defaultController->_style = preferredStyle;
    if (GJAlertControllerStyleAlert == preferredStyle) {
        defaultController->_gjAlertView = [UIAlertView new];
        defaultController->_gjAlertView.delegate = defaultController;
        defaultController->_gjAlertView.title = title;
        defaultController->_gjAlertView.message = message;
    } else if (GJAlertControllerStyleActionSheet == preferredStyle) {
        defaultController->_gjActionSheet = [UIActionSheet new];
        defaultController->_gjActionSheet.delegate = defaultController;
        defaultController->_gjActionSheet.title = title;
    }
    return defaultController;
}

- (void)addAction:(GJAlertAction *)action
{
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        [defaultController->_gjAlertView addButtonWithTitle:action.title];
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        [defaultController->_gjActionSheet addButtonWithTitle:action.title];
    }
    [defaultController->_alertActionArr addObject:action];
    //根据样式(cancel,destructive)将对应的cancelButtonIndex,destructiveButtonIndex指向当前button的index(取消必须在最后一个添加才能正确显示)
    if (action.style == UIAlertActionStyleCancel) {
        defaultController->_gjActionSheet.cancelButtonIndex = _gjActionSheet.numberOfButtons - 1;
    }
    if (action.style == UIAlertActionStyleDestructive) {
        defaultController->_gjActionSheet.destructiveButtonIndex = _gjActionSheet.numberOfButtons - 1;
    }
}

- (void)gj_showInView:(UIView *)aView
{
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        [defaultController->_gjAlertView show];
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        if (aView) {
            //防止iOS7系统下,如果不是控件触发的ActionSheet(直接present)导致的崩溃错误(http://blog.csdn.net/quanqinyang/article/details/17025225),或者tabbar的原因导致的最后一个按钮失效(http://stackoverflow.com/questions/4447563/last-button-of-actionsheet-does-not-get-clicked)
            [defaultController->_gjActionSheet showInView:[UIApplication sharedApplication].keyWindow];
            //[defaultController->_gjActionSheet showInView:aView];
        }
    }
}

- (void)testShow {
    [defaultController->_gjAlertView show];
}

- (void)testShowActonSheet {
    [defaultController->_gjActionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
}


#pragma mark - propterty methods
- (NSArray<GJAlertAction *> *)actions {
    return defaultController->_alertActionArr;
}

- (void)setPreferredAction:(GJAlertAction *)preferredAction {
    //UIAlertView并不能实现这个属性的功能，什么都不做
}

- (GJAlertAction *)preferredAction {
    //UIAlertView并不能实现这个属性的功能，返回空
    return nil;
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        //textField只对alert做处理，不对actionSheet做处理
        return;
    }
    if (UIAlertViewStyleLoginAndPasswordInput == defaultController->_gjAlertView.alertViewStyle) {
        //由于UIAlertView的API的限制，最多只能有两个TextField，已经有两个了，不做处理，直接返回
        return;
    } else if (UIAlertViewStyleDefault == defaultController->_gjAlertView.alertViewStyle) {
        if (!defaultController->_alertTextFieldArr) {
            defaultController->_alertTextFieldArr = [[NSMutableArray alloc] initWithCapacity:2];
        }
        UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        configurationHandler(tempTextField);
        [defaultController->_alertTextFieldArr addObject:tempTextField];
        if (tempTextField.secureTextEntry) {
            defaultController->_gjAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        } else {
            defaultController->_gjAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        UITextField *alertTextField = [defaultController->_gjAlertView textFieldAtIndex:0];
        [self setValueFrom:tempTextField to:alertTextField];
    } else if (UIAlertViewStylePlainTextInput == defaultController->_gjAlertView.alertViewStyle || UIAlertViewStyleSecureTextInput == defaultController->_gjAlertView.alertViewStyle) {
        UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        configurationHandler(tempTextField);
        [defaultController->_alertTextFieldArr addObject:tempTextField];
        defaultController->_gjAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *alertTextField = [defaultController->_gjAlertView textFieldAtIndex:1];
        [self setValueFrom:tempTextField to:alertTextField];
        //给上一个textField赋值
        [self setValueFrom:defaultController->_alertTextFieldArr[0] to:[defaultController->_gjAlertView textFieldAtIndex:0]];
    }
}

- (NSArray<UITextField *> *)textFields {
    if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        //textField只对alert做处理，不对actionSheet做处理
        return nil;
    }
    
    if (UIAlertViewStylePlainTextInput == defaultController->_gjAlertView.alertViewStyle || UIAlertViewStyleSecureTextInput == defaultController->_gjAlertView.alertViewStyle) {
        return @[[defaultController->_gjAlertView textFieldAtIndex:0]];
    } else if (UIAlertViewStyleLoginAndPasswordInput == defaultController->_gjAlertView.alertViewStyle) {
        return @[[defaultController->_gjAlertView textFieldAtIndex:0], [defaultController->_gjAlertView textFieldAtIndex:1]];
    } else return nil;
}

- (void)setTitle:(NSString *)title {
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        defaultController->_gjAlertView.title = title;
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        defaultController->_gjActionSheet.title = title;
    }
}

- (NSString *)title {
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        return defaultController->_gjAlertView.title;
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        return defaultController->_gjActionSheet.title;
    } else return nil;
}

- (void)setMessage:(NSString *)message {
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        defaultController->_gjAlertView.message = message;
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        //actionSheet没有message属性
    }
}

- (NSString *)message {
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        return defaultController->_gjAlertView.message;
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        //actionSheet没有message属性
        return nil;
    } else return nil;
}

- (GJAlertControllerStyle)preferredStyle {
    return defaultController->_style;
}


#pragma mark - alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    GJAlertAction *tempAlertAction = (defaultController->_alertActionArr)[buttonIndex];
    GJAlertBlock tempBlock = tempAlertAction.handler;
    if (tempBlock) {
        tempBlock(tempAlertAction);
    }
}

#pragma mark - actionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    GJAlertAction *tempAlertAction = (defaultController->_alertActionArr)[buttonIndex];
    GJAlertBlock tempBlock = tempAlertAction.handler;
    if (tempBlock) {
        tempBlock(tempAlertAction);
    }
}

#pragma mark - private methods
- (void)setValueFrom:(UITextField *)tempTextField to:(UITextField *)alertTextField {
    //给一些常用属性赋值
    alertTextField.text = tempTextField.text;
    alertTextField.attributedText = tempTextField.attributedText;
    alertTextField.textColor = tempTextField.textColor;
    alertTextField.font = tempTextField.font;
    alertTextField.textAlignment = tempTextField.textAlignment;
    alertTextField.placeholder = tempTextField.placeholder;
    alertTextField.attributedPlaceholder = tempTextField.attributedPlaceholder;
    alertTextField.clearsOnBeginEditing = tempTextField.clearsOnBeginEditing;
    alertTextField.delegate = tempTextField.delegate;
    alertTextField.background = tempTextField.background;
    alertTextField.disabledBackground = tempTextField.disabledBackground;
    alertTextField.clearButtonMode = tempTextField.clearButtonMode;
    alertTextField.leftView = tempTextField.leftView;
    alertTextField.leftViewMode = tempTextField.leftViewMode;
    alertTextField.rightView = tempTextField.rightView;
    alertTextField.rightViewMode = tempTextField.rightViewMode;
    alertTextField.inputView = tempTextField.inputView;
    alertTextField.inputAccessoryView = tempTextField.inputAccessoryView;
    alertTextField.tag = tempTextField.tag;
}


@end

#pragma mark - Runtime Injection

__asm(
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
#if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIAlertController:\n"
      ".quad           _OBJC_CLASS_$_UIAlertController\n"
#else
      ".align          2\n"
      "_OBJC_CLASS_UIAlertController:\n"
      ".long           _OBJC_CLASS_$_UIAlertController\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIAlertController\n"
      );

// Constructors are called after all classes have been loaded.
__attribute__((constructor)) static void GJAlertControllerPatchEntry(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            // >= iOS8.
            if (objc_getClass("UIAlertController")) {
                return;
            }
            
            Class *alertController = NULL;
            
#if TARGET_CPU_ARM
            __asm("movw %0, :lower16:(_OBJC_CLASS_UIAlertController-(LPC0+4))\n"
                  "movt %0, :upper16:(_OBJC_CLASS_UIAlertController-(LPC0+4))\n"
                  "LPC0: add %0, pc" : "=r"(alertController));
#elif TARGET_CPU_ARM64
            __asm("adrp %0, L_OBJC_CLASS_UIAlertController@PAGE\n"
                  "add  %0, %0, L_OBJC_CLASS_UIAlertController@PAGEOFF" : "=r"(alertController));
#elif TARGET_CPU_X86_64
            __asm("leaq L_OBJC_CLASS_UIAlertController(%%rip), %0" : "=r"(alertController));
#elif TARGET_CPU_X86
            void *pc = NULL;
            __asm("calll L0\n"
                  "L0: popl %0\n"
                  "leal _OBJC_CLASS_UIAlertController-L0(%0), %1" : "=r"(pc), "=r"(alertController));
#else
#error Unsupported CPU
#endif
            
            if (alertController && !*alertController) {
                Class class = objc_allocateClassPair([GJAlertController class], "UIAlertController", 0);
                if (class) {
                    objc_registerClassPair(class);
                    *alertController = class;
                }
            } 
        }
    });
}



