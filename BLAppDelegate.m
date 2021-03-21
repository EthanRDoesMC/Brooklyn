#import "BLAppDelegate.h"
#import "BLRootViewController.h"

@implementation BLAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLRootViewController alloc] init]];
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
	//_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UITabBarController alloc] init]];
//    _rootViewController.viewControllers = @[
//        [[BLExistingChatsController alloc] initForBrooklynWithNC:_rootViewController], [[BLRecipientController alloc] initForBrooklynWithNC:_rootViewController]
//    ];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
    self.mautrixTask = [BLMautrixTask sharedTask];
}

@end
