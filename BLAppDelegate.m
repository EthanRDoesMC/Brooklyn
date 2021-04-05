#import "BLAppDelegate.h"
#import "BLRootViewController.h"

// you're a god among men, kirb, but we need consolidation
// all credits go to https://github.com/hbang/libcephei/blob/master/HBOutputForShellCommand.m

NSString *HBOutputForShellCommandWithReturnCode(NSString *command, int *returnCode) {
    FILE *file = popen(command.UTF8String, "r");
    
    if (!file) {
        return nil;
    }
    
    char data[1024];
    NSMutableString *output = [NSMutableString string];
    
    while (fgets(data, 1024, file) != NULL) {
        [output appendString:[NSString stringWithUTF8String:data]];
    }
    
    int result = pclose(file);
    *returnCode = result;
    
    return output;
}

NSString *HBOutputForShellCommand(NSString *command) {
    int returnCode = 0;
    NSString *output = HBOutputForShellCommandWithReturnCode(command, &returnCode);
    return returnCode == 0 ? output : nil;
}

@implementation BLAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    BOOL shouldSaveLogs;
    NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.beeper.brooklynsettings.plist"];
    shouldSaveLogs = [prefs objectForKey:@"logging"] ? [[prefs objectForKey:@"logging"] boolValue] : NO;
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SaveLogs"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BLRootViewController alloc] init]];
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
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
