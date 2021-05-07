//
//  ExportLogsViewController.m
//  xchighlight
//
//  Created by EthanRDoesMC on 4/2/21.
//

#import "ExportLogsViewController.h"
#import "BLMautrixTask.h"

@interface ExportLogsViewController<UIPickerViewDataSource, UIPickerViewController> () {
    NSString * logDirectory;
}
@property (strong, nonatomic) NSArray *dirContents;
@end

@interface LogProvider : UIActivityItemProvider
@end

@implementation LogProvider

-(id)item {
    return self.placeholderItem;
}

@end

@implementation ExportLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/Beeper" error:nil];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dirContents.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dirContents[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    logDirectory = self.dirContents[row];
}

- (IBAction)shareButtonPressed:(id)sender {
    LogProvider *provider = [[LogProvider alloc] initWithPlaceholderItem:[NSURL fileURLWithPath:[NSString stringWithFormat:@"file:///var/mobile/Documents/Beeper/%@", logDirectory]]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[provider] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

- (IBAction)clearLogs:(id)sender {
    [BLMautrixTask.sharedTask clearLogs];
    [self viewDidLoad];
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
