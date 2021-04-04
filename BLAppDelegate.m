#import "BLAppDelegate.h"
#import "BLRootViewController.h"
#import <Cephei/HBOutputForShellCommand.h>
#import <Cephei/HBPreferences.h>

@implementation BLAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    HBPreferences * appPreferences = [HBPreferences preferencesForIdentifier:@"com.beeper.brooklynsettings"];
    BOOL shouldSaveLogs;
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SaveLogs"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLRootViewController alloc] init]];
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
    [appPreferences registerBool:&shouldSaveLogs default:NO forKey:@"logging"];
    if (shouldSaveLogs) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Beeper/%@.txt", [NSDate date]]];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    }
    NSLog(@"Beeper Build: %@", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn"));
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
    self.mautrixTask = [BLMautrixTask sharedTask];
}

@end
