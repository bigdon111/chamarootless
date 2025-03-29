#import <UIKit/UIKit.h>
#import <substrate.h>  // For MSHookIvar

@interface SBDockView : UIView
@property (nonatomic, retain) UIView *backgroundView;
@end

%hook SBDockView
- (void)didMoveToWindow {
    %orig;
    UIView *bgView = MSHookIvar<UIView *>(self, "_backgroundView");
    if (bgView) {
        bgView.hidden = YES;
    }
}
%end