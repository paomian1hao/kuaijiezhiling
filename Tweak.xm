#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *MSPWindow = nil;

static void MSPShowIndicator(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (MSPWindow) {
            MSPWindow.hidden = NO;
            return;
        }

        CGRect frame = CGRectMake(8, 52, 30, 30);

        MSPWindow = [[UIWindow alloc] initWithFrame:frame];
        MSPWindow.windowLevel = UIWindowLevelAlert + 1000;
        MSPWindow.backgroundColor = UIColor.clearColor;
        MSPWindow.userInteractionEnabled = NO;

        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = UIColor.clearColor;
        MSPWindow.rootViewController = vc;

        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        box.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.82];
        box.layer.cornerRadius = 8.0;
        box.userInteractionEnabled = NO;

        UIView *stop = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        stop.backgroundColor = UIColor.whiteColor;
        stop.layer.cornerRadius = 2.0;
        stop.userInteractionEnabled = NO;

        [box addSubview:stop];
        [vc.view addSubview:box];

        MSPWindow.hidden = NO;
    });
}

static void MSPHideIndicator(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        MSPWindow.hidden = YES;
    });
}

static void MSPDarwinCallback(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {
    NSString *notification = (__bridge NSString *)name;

    if ([notification isEqualToString:@"com.pm.minishortcutprogress.start"]) {
        MSPShowIndicator();
    } else if ([notification isEqualToString:@"com.pm.minishortcutprogress.stop"]) {
        MSPHideIndicator();
    }
}

static void MSPPostStart(void) {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.pm.minishortcutprogress.start"),
        NULL,
        NULL,
        YES
    );
}

static void MSPPostStop(void) {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.pm.minishortcutprogress.stop"),
        NULL,
        NULL,
        YES
    );
}


/*
 * WorkflowKit
 * 快捷指令开始运行
 */
%hook WFWorkflowRunCoordinator

- (void)runWorkflowWithRequest:(id)request
                       context:(id)context
                    completion:(id)completion {

    MSPPostStart();

    %orig;
}

/*
 * 快捷指令运行结束 / 取消
 */
- (void)outOfProcessWorkflowController:(id)controller
                    didFinishWithError:(id)error
                             cancelled:(BOOL)cancelled
                             reference:(id)reference
                     dialogAttribution:(id)attribution {

    %orig;

    MSPPostStop();
}

%end


%ctor {
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

        /*
         * SpringBoard 只负责显示小标记
         */
        if ([bundleID isEqualToString:@"com.apple.springboard"]) {

            CFNotificationCenterAddObserver(
                CFNotificationCenterGetDarwinNotifyCenter(),
                NULL,
                MSPDarwinCallback,
                CFSTR("com.pm.minishortcutprogress.start"),
                NULL,
                CFNotificationSuspensionBehaviorDeliverImmediately
            );

            CFNotificationCenterAddObserver(
                CFNotificationCenterGetDarwinNotifyCenter(),
                NULL,
                MSPDarwinCallback,
                CFSTR("com.pm.minishortcutprogress.stop"),
                NULL,
                CFNotificationSuspensionBehaviorDeliverImmediately
            );
        }
    }
}
