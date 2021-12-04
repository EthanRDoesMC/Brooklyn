//
//  BLMautrixTask.h
//  xchighlight
//
//  Created by EthanRDoesMC on 3/20/21.
//

#import <Foundation/Foundation.h>
#import "NSTask.h"
#import "IMCore.h"
#import "CPDistributedMessagingCenter.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMautrixTask : NSObject
@property (strong, nonatomic) NSTask * task;
@property (strong, nonatomic) NSString * outputString;
@property (strong, nonatomic) NSPipe * writePipe;
@property (strong, nonatomic) NSMutableArray * sessionSentGUIDs;
@property (strong, nonatomic) NSString * mostRecentMessageGUID;
@property (strong, nonatomic) CPDistributedMessagingCenter * messageCenter;
+(id)sharedTask;
-(id)initAndLaunch;
-(void)sendPing;
//-(void)sendTest;
-(void)sendDictionary:(NSDictionary *)dictionary;
-(void)sendDictionary:(NSDictionary *)dictionary withID:(NSNumber *)msgID;
-(void)handleExternal:(NSNotification *)notification;
-(void)handleCommand:(NSDictionary *)command;
-(void)sendErrorCode:(NSString *)code withDescription:(NSString *)description forCommand:(NSDictionary *)command;
-(void)respondWithChatInfoForCommand:(NSDictionary *)command;
-(void)getContactInfoForCommand:(NSDictionary *)command;
-(void)getChatListWithCommand:(NSDictionary *)command;
-(void)sendMessageCommand:(NSDictionary *)command;
-(void)sendAttachmentCommand:(NSDictionary *)command;
-(void)forwardMessage:(IMMessage *)message fromChat:(IMChat *)chat;
-(void)forwardTypingIndicator:(IMMessage *)typingIndicator fromChat:(IMChat *)chat;
-(void)forwardReadReceipt:(IMMessage *)readReceipt fromChat:(IMChat *)chat;
-(void)getMessagesForCommand:(NSDictionary *)command;
-(void)setTypingCommand:(NSDictionary *)command;
-(void)sendReadReceiptWithCommand:(NSDictionary *)command;
-(void)configURLCommand:(NSDictionary *)command;
-(BOOL)checkIfRunning:(NSString *)bundle_id;
-(void)clearLogs;
-(void)handleTaskQuit:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
