#import "BLAppDelegate.h"
#import "BLRootViewController.h"



@implementation BLAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    self.mautrixTask = [BLMautrixTask sharedTask];
//    BOOL shouldSaveLogs;
//    NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.beeper.brooklynsettings.plist"];
//    shouldSaveLogs = [prefs objectForKey:@"logging"] ? [[prefs objectForKey:@"logging"] boolValue] : NO;
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SaveLogs"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLRootViewController alloc] init]];
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
    //if (shouldSaveLogs) {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Beeper/%@.txt", [NSDate date]]];
//    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",self.mautrixTask.outputString);
    //}
//    NSLog(@"Beeper Build: %@", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn"));
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
    
}

@end
