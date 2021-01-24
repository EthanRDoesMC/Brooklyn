//
//  ChatViewController.h
//  brooklyn
//
//  Created by EthanRDoesMC on 1/5/21.
//

#import <UIKit/UIKit.h>
#import "ChatKit.h"
#import "BrooklynBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UITableViewController
@property (nonatomic, strong) CKConversation * chat;
-(id)initWithConversation:(CKConversation *)chat;
@end

NS_ASSUME_NONNULL_END
