//
//  LogViewController.m
//  xchighlight
//
//  Created by EthanRDoesMC on 3/18/21.
//

#import "LogViewController.h"
#import <Foundation/Foundation.h>
#import "NSTask.h"

@interface LogViewController ()
@property (strong, nonatomic) IBOutlet UITextView *logField;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Hello, World!");
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    //[arguments addObject:@"/Users/ethanrdoesmc/Downloads/mautrix-imessage-amd64/mautrix-imessage"];
    [arguments addObject:@"-c/User/Documents/mautrix-imessage-armv7/config.yaml"]; // Any arguments you want here...
    [arguments addObject:@"-r/User/Documents/mautrix-imessage-armv7/registration.yaml"]; // Any arguments you want here...
    
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = @"/User/Documents/mautrix-imessage-armv7/mautrix-imessage";
    task.arguments  = arguments;
    task.currentDirectoryPath = @"/User/Documents/mautrix-imessage-armv7/";
    NSLog(@"tell me about %@", task);
    NSMutableDictionary *defaultEnv = [[NSMutableDictionary alloc] initWithDictionary:[[NSProcessInfo processInfo] environment]];
    [defaultEnv setObject:@"YES" forKey:@"NSUnbufferedIO"];
    //            [defaultEnv setObject:@"/Users/ethanrdoesmc/" forKey:@"HOME"];
    
    task.environment = defaultEnv;
    
    task.standardOutput = [NSPipe pipe];
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData]; // this will read to EOF, so call only once
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Task output! %@", string);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_logField.text = [self->_logField.text stringByAppendingString: string];
            [self->_logField scrollRangeToVisible: NSMakeRange(self->_logField.text.length, 0)];
        });
    }];
    
    [task launch];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
