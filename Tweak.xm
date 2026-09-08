#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

static UIWindow *MSPWindow = nil;
static UIButton *MSPButton = nil;

static void MSPHide(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        MSPWindow.hidden = YES;
    });
}

static void MSPShow(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!MSPWindow) {
            // iPhone XR friendly: small floating indicator below the status-bar/left side.
            MSPWindow = [[UIWindow alloc] initWithFrame:CGRectMake(10.0, 54.0, 30.0, 30.0)];
            MSPWindow.windowLevel = UIWindowLevelAlert + 100.0;
            MSPWindow.backgroundColor = UIColor.clearColor;
            MSPWindow.userInteractionEnabled = NO; // v0.1 deliberately never blocks taps beneath it.

            UIViewController *vc = [UIViewController new];
            vc.view.backgroundColor = UIColor.clearColor;
            MSPWindow.rootViewController = vc;

            MSPButton = [UIButton buttonWithType:UIButtonTypeCustom];
            MSPButton.frame = CGRectMake(0, 0, 30.0, 30.0);
            MSPButton.layer.cornerRadius = 9.0;
            MSPButton.backgroundColor = [UIColor colorWithWhite:0.10 alpha:0.78];
            MSPButton.userInteractionEnabled = NO;

            UIView *stopGlyph = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
            stopGlyph.backgroundColor = UIColor.whiteColor;
            stopGlyph.layer.cornerRadius = 2.0;
            stopGlyph.userInteractionEnabled = NO;
            [MSPButton addSubview:stopGlyph];
            [vc.view addSubview:MSPButton];
        }
        MSPWindow.hidden = NO;
    });
}

static void MSPWorkflowStarted(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    MSPShow();
}

static void MSPWorkflowStopped(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    MSPHide();
}

%ctor {
    @autoreleasepool {
        CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();
        CFNotificationCenterAddObserver(darwin, NULL, MSPWorkflowStarted,
                                        CFSTR("com.anthopak.powercuts/WorkflowDidStart"),
                                        NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        CFNotificationCenterAddObserver(darwin, NULL, MSPWorkflowStopped,
                                        CFSTR("com.anthopak.powercuts/WorkflowDidStop"),
                                        NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}
