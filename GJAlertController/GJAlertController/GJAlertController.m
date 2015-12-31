

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
    GJAlertControllerStyle _style;
}

+ (void)setupDefaultController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultController = [GJAlertController new];
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
}

- (void)gj_showInView:(UIView *)aView
{
    if (GJAlertControllerStyleAlert == defaultController->_style) {
        [defaultController->_gjAlertView show];
    } else if (GJAlertControllerStyleActionSheet == defaultController->_style) {
        if (aView) {
            [defaultController->_gjActionSheet showInView:aView];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    GJAlertAction *tempAlertAction = (defaultController->_alertActionArr)[buttonIndex];
    GJAlertBlock tempBlock = tempAlertAction.handler;
    if (tempBlock) {
        tempBlock(tempAlertAction);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    GJAlertAction *tempAlertAction = (defaultController->_alertActionArr)[buttonIndex];
    GJAlertBlock tempBlock = tempAlertAction.handler;
    if (tempBlock) {
        tempBlock(tempAlertAction);
    }
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



