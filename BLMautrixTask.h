//
//  BLMautrixTask.h
//  xchighlight
//
//  Created by EthanRDoesMC on 3/20/21.
//

#import <Foundation/Foundation.h>
#import "NSTask.h"
#import "IMCore.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMautrixTask : NSObject
@property (strong, nonatomic) NSTask * task;
@property (strong, nonatomic) NSString * outputString;
@property (strong, nonatomic) NSPipe * writePipe;
@property (strong, nonatomic) NSMutableArray * sessionSentGUIDs;
@property (strong, nonatomic) IMMessage * mostRecentMessage;
+(id)sharedTask;
-(id)initAndLaunch;
-(void)sendPing;
//-(void)sendTest;
-(void)sendDictionary:(NSDictionary *)dictionary;
-(void)sendDictionary:(NSDictionary *)dictionary withID:(NSNumber *)msgID;
-(void)handleExternal:(NSNotification *)notification;
-(void)handleCommand:(NSDictionary *)command;
-(void)respondWithChatInfoForCommand:(NSDictionary *)command;
-(void)getContactInfoForCommand:(NSDictionary *)command;
-(void)getChatListWithCommand:(NSDictionary *)command;
-(void)sendMessageCommand:(NSDictionary *)command;
-(void)sendAttachmentCommand:(NSDictionary *)command;
-(void)forwardMessage:(IMMessage *)message fromChat:(IMChat *)chat;
-(void)getMessagesForCommand:(NSDictionary *)command;
@end

NS_ASSUME_NONNULL_END
