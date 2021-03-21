//
//  LogViewController.m
//  xchighlight
//
//  Created by EthanRDoesMC on 3/18/21.
//

#import "LogViewController.h"
#import <Foundation/Foundation.h>
#import "NSTask.h"
#import "BLMautrixTask.h"

@interface LogViewController ()
@property (strong, nonatomic) IBOutlet UITextView *logField;
@property (nonatomic, strong) NSTask* task;
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:[BLMautrixTask sharedTask] action:@selector(sendPing)];
    [BLMautrixTask sharedTask];
    [self updateLog];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLog) name:@"BLMautrixLogUpdated" object:nil];
}

-(void)updateLog {
    [self.logField setText:[[BLMautrixTask sharedTask] outputString]];
    [self.logField scrollRangeToVisible: NSMakeRange(_logField.text.length, 0)];
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
