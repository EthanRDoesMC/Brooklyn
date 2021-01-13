//
//  SendMessageController.h
//  brooklyn
//
//  Created by EthanRDoesMC on 1/5/21.
//

#import <UIKit/UIKit.h>
#import "ChatKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface SendMessageController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) CKConversation * chat;
-(id)initWithConversation:(CKConversation *)chat;
@end

NS_ASSUME_NONNULL_END
