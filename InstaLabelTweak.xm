#import <UIKit/UIKit.h>
#import <substrate.h> // Added this import for MSHookIvar

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
        // Try to access private variables that might store the display name
        NSString *displayNameString = MSHookIvar<NSString *>(self, "_displayName");
        if (displayNameString) {
            MSHookIvar<NSString *>(self, "_displayName") = @"chama";
        }
        
        // Also try alternate variable names that might exist
        NSString *cachedDisplayName = MSHookIvar<NSString *>(self, "_cachedDisplayName");
        if (cachedDisplayName) {
            MSHookIvar<NSString *>(self, "_cachedDisplayName") = @"chama";
        }
        
        return @"chama"; // Return the custom name regardless
    }
    return originalName;
}
%end

// Hook the emoji label view that contains the Instagram label
%hook BSUIEmojiLabelView
- (void)layoutSubviews {
    %orig;
    
    // Look for text storage in the label view using MSHookIvar
    NSAttributedString *attributedText = MSHookIvar<NSAttributedString *>(self, "_attributedText");
    if (attributedText && [attributedText.string isEqualToString:@"Instagram"]) {
        // Create a new attributed string with the same attributes but different text
        NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] 
                                             initWithString:@"chama" 
                                             attributes:[attributedText attributesAtIndex:0 effectiveRange:NULL]];
        MSHookIvar<NSAttributedString *>(self, "_attributedText") = newText;
        [self setNeedsDisplay]; // Force redraw
    }
    
    // Still check subviews as a fallback
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            NSString *labelText = MSHookIvar<NSString *>(label, "_text");
            if ([labelText isEqualToString:@"Instagram"]) {
                MSHookIvar<NSString *>(label, "_text") = @"chama";
                [label setNeedsDisplay];
            }
        }
    }
}
%end

// Hook the app switcher label container
%hook SBFluidSwitcherItemContainerHeaderView
- (void)layoutSubviews {
    %orig;
    
    // Try to access any text storage directly
    NSString *titleText = MSHookIvar<NSString *>(self, "_titleText");
    if ([titleText isEqualToString:@"Instagram"]) {
        MSHookIvar<NSString *>(self, "_titleText") = @"chama";
        [self setNeedsLayout];
    }
    
    // Also try for a title label
    UILabel *titleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
    if (titleLabel && [titleLabel.text isEqualToString:@"Instagram"]) {
        MSHookIvar<NSString *>(titleLabel, "_text") = @"chama";
        [titleLabel setNeedsDisplay];
    }
    
    // Still check subviews as a fallback
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            NSString *labelText = MSHookIvar<NSString *>(label, "_text");
            if ([labelText isEqualToString:@"Instagram"]) {
                MSHookIvar<NSString *>(label, "_text") = @"chama";
                [label setNeedsDisplay];
            }
        }
    }
}
%end

// Direct hook for UILabel as a fallback
%hook UILabel
- (void)setText:(NSString *)text {
    if ([text isEqualToString:@"Instagram"]) {
        %orig(@"chama");
        // Also directly modify the internal storage
        MSHookIvar<NSString *>(self, "_text") = @"chama";
    } else {
        %orig;
    }
}

- (void)didMoveToWindow {
    %orig;
    // Check when the label is added to the window
    NSString *labelText = MSHookIvar<NSString *>(self, "_text");
    if ([labelText isEqualToString:@"Instagram"]) {
        MSHookIvar<NSString *>(self, "_text") = @"chama";
        [self setNeedsDisplay];
    }
}
%end