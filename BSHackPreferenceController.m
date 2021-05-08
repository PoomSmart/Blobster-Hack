#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>

__attribute__((visibility("hidden")))
@interface BSHackPreferenceController : PSListController
- (id)specifiers;
@end

@implementation BSHackPreferenceController

- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"BlobsterHack" target:self] retain];
    }
    return _specifiers;
}

@end
