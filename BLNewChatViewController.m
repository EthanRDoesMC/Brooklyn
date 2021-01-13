//
//  BLNewChatViewController.m
//  brooklyn
//
//  Created by EthanRDoesMC on 12/31/20.
//

#import "BLNewChatViewController.h"
#import "ChatKit.h"

@interface BLNewChatViewController ()
@property (strong, nonatomic) IBOutlet UILabel *logLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BLNewChatViewController

-(void)loadView {
    [super loadView];
    self.navigationItem.title = @"Create";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doAThing:textField.text];
    [textField resignFirstResponder];
    return YES;
}

-(void)doAThing:(NSString *)tf {
    _logLabel.text = @"called doathing";
    [BrooklynBridge riseAndShineIMDaemon];
    _logLabel.text = @"daemon called";
    if (![tf isEqual:@""]) {
        _logLabel.text = tf;
        //CKEntity *newEntity = [CKEntity copyEntityForAddressString:textField.text];
//        CKIMComposeRecipient * rec = [[CKRecipientGenerator sharedRecipientGenerator] recipientWithAddress:tf];
        IMHandle * handle = [[[IMAccountController sharedInstance] __ck_defaultAccountForService:nil] __ck_handlesFromAddressStrings:@[ tf ]][0];
        _logLabel.text = handle.description;
        IMChat * chat = [[IMChatRegistry sharedInstance] _ck_chatForHandles: @[ handle ] createIfNecessary:YES];
        _logLabel.text = IMChat.description;
         CKConversation * newconvo = [[CKConversation alloc] initWithChat:chat];
        _logLabel.text = newconvo.description;
        //[textField resignFirstResponder];
        [chat loadMessagesBeforeDate:[NSDate date] limit:100 loadImmediately:YES];
        CKTranscriptController * tc = [[CKTranscriptController alloc] init];
        _logLabel.text = tc.description;
        [tc setConversation:newconvo];
        [self.navigationController pushViewController:tc animated:YES];
}
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
