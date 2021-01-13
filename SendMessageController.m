//
//  SendMessageController.m
//  brooklyn
//
//  Created by EthanRDoesMC on 1/5/21.
//

#import "SendMessageController.h"
#import "IMCore.h"

@interface SendMessageController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SendMessageController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //_textField.placeholder = self.chat.serviceDisplayName;
}

-(id)initWithConversation:(CKConversation *)chat {
    self.chat = chat;
    return [super init];
}

- (IBAction)sendTyping:(id)sender {
    [self.chat setLocalUserIsTyping:true];
}
//- (IBAction)sendMessage:(UITextField *)sender {
//    [self.chat setLocalUserIsTyping:false];
//    if (sender.hasText) {
//    CKComposition * composition = [[CKComposition alloc] initWithText:sender.text subject:nil];
//    [self.chat sendMessage:composition newComposition:true];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.chat.chat setLocalUserIsTyping:true];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.chat setLocalUserIsTyping:false];
    CKComposition * composition = [[CKComposition alloc] initWithText:[[NSAttributedString alloc] initWithString:textField.text] subject:nil];
    
    [self.chat.chat sendMessage:[self.chat messageWithComposition:composition]];
    [textField resignFirstResponder];
    //[self.navigationController popViewControllerAnimated:YES];
    return YES;
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
