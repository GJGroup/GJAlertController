

#import "GJAlertAction.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation GJAlertAction

+ (instancetype)actionWithTitle:(NSString *)aTitle style:(GJAlertActionStyle)aStyle handler:(GJAlertBlock)aHandler {
    GJAlertAction *tempAction = [GJAlertAction new];
    tempAction.title = aTitle;
    tempAction.style = aStyle;
    tempAction.handler = aHandler;
    return tempAction;
}

@end

#pragma mark - Runtime Injection

__asm(
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
#if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIAlertAction:\n"
      ".quad           _OBJC_CLASS_$_UIAlertAction\n"
#else
      ".align          2\n"
      "_OBJC_CLASS_UIAlertAction:\n"
      ".long           _OBJC_CLASS_$_UIAlertAction\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIAlertAction\n"
      );

// Constructors are called after all classes have been loaded.
__attribute__((constructor)) static void GJAlertActionPatchEntry(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            // >= iOS8.
            if (objc_getClass("UIAlertAction")) {
                return;
            }
            
            Class *alertAction = NULL;
            
#if TARGET_CPU_ARM
            __asm("movw %0, :lower16:(_OBJC_CLASS_UIAlertAction-(LPC0+4))\n"
                  "movt %0, :upper16:(_OBJC_CLASS_UIAlertAction-(LPC0+4))\n"
                  "LPC0: add %0, pc" : "=r"(alertAction));
#elif TARGET_CPU_ARM64
            __asm("adrp %0, L_OBJC_CLASS_UIAlertAction@PAGE\n"
                  "add  %0, %0, L_OBJC_CLASS_UIAlertAction@PAGEOFF" : "=r"(alertAction));
#elif TARGET_CPU_X86_64
            __asm("leaq L_OBJC_CLASS_UIAlertAction(%%rip), %0" : "=r"(alertAction));
#elif TARGET_CPU_X86
            void *pc = NULL;
            __asm("calll L0\n"
                  "L0: popl %0\n"
                  "leal _OBJC_CLASS_UIAlertAction-L0(%0), %1" : "=r"(pc), "=r"(alertAction));
#else
#error Unsupported CPU
#endif
            
            if (alertAction && !*alertAction) {
                Class class = objc_allocateClassPair([GJAlertAction class], "UIAlertAction", 0);
                if (class) {
                    objc_registerClassPair(class);
                    *alertAction = class;
                }
            }
        }
    });
}