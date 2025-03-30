#import <UIKit/UIKit.h>

// Define interfaces for the classes we need to interact with
@interface SBApplicationIcon : NSObject
- (NSString *)displayName;
- (NSString *)applicationBundleID;
@end

@interface BSUIEmojiLabelView : UIView
@end

@interface SBFluidSwitcherItemContainerHeaderView : UIView
- (NSArray *)subviews;
@end

@interface UILabel (Private)
- (void)setText:(NSString *)text;
- (NSString *)text;
@end

// Hook the main icon class to change its display name
%hook SBApplicationIcon

- (NSString *)displayName {
    NSString *originalName = %orig;
    NSString *bundleID = [self applicationBundleID];
    
    // Check if this is the Instagram icon
    if ([bundleID isEqualToString:@"com.burbn.instagram"]) {
        return @"MyGram"; // Replace with your custom name
    }
    
    return originalName;
}

%end

// Hook the emoji label view that contains the Instagram label
%hook BSUIEmojiLabelView

- (void)layoutSubviews {
    %orig;
    
    // Look through subviews to find any UILabels with "Instagram" text
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label.text isEqualToString:@"Instagram"]) {
                [label setText:@"MyGram"]; // Replace with your custom name
            }
        }
    }
}

%end

// Hook the app switcher label container
%hook SBFluidSwitcherItemContainerHeaderView

- (void)layoutSubviews {
    %orig;
    
    // Look through subviews to find any UILabels with "Instagram" text
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label.text isEqualToString:@"Instagram"]) {
                [label setText:@"MyGram"]; // Replace with your custom name
            }
        }
    }
}

%end

// Direct hook for UILabel as a fallback
%hook UILabel

- (void)setText:(NSString *)text {
    if ([text isEqualToString:@"Instagram"]) {
        %orig(@"MyGram"); // Replace with your custom name
    } else {
        %orig;
    }
}

%end