//
//  IMCore.h
//  brooklyn
//
//  Created by EthanRDoesMC
//

#pragma mark - Send Progress

#pragma mark - Chat
@interface IMChat : NSObject
//-(id<IMChatSendProgressDelegate>)sendProgressDelegate;
//-(void)setSendProgressDelegate:(id<IMChatSendProgressDelegate>)arg1;
// routing thru chatkit instead
-(void)loadMessagesBeforeDate:(NSDate *)arg1 limit:(NSInteger)arg2 loadImmediately:(char)arg3;
- (void)setLocalUserIsTyping:(BOOL)arg1;
-(void)sendMessage:(id)arg1;
@end

@interface IMMessage : NSObject
@end

#pragma mark - Chat Registry
@interface IMChatRegistry : NSObject
+(id)sharedInstance;

-(IMChat *)chatForIMHandle:(id)arg1;
-(IMChat *)chatForIMHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(char)arg3;
-(IMChat *)_ck_chatForHandles:(id)arg1 createIfNecessary:(char)arg2;
-(IMChat *)_ck_chatForHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(char)arg3 createIfNecessary:(char)arg4;

-(NSArray *)allExistingChats;
-(unsigned)numberOfExistingChats;
-(id)_allCreatedChats;

-(IMChat *)existingChatWithGUID:(id)arg1;
-(IMChat *)existingChatWithChatIdentifier:(id)arg1;
-(IMChat *)existingChatForIMHandle:(id)arg1;
-(IMChat *)existingChatWithGroupID:(id)arg1;

-(IMChat *)existingChatForIMHandle:(id)arg1 allowRetargeting:(char)arg2;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(char)arg2;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(char)arg2 groupID:(id)arg3;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(char)arg2 groupID:(id)arg3 displayName:(id)arg4 joinedChatsOnly:(char)arg5;

-(IMChat *)_createdChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 account:(id)arg3 ;
-(IMChat *)_existingChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 service:(id)arg3 ;
-(IMChat *)_existingChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 account:(id)arg3 ;

-(IMChat *)chatForIMHandles:(id)arg1;
-(IMChat *)chatForIMHandles:(id)arg1 chatName:(id)arg2;

-(unsigned)unreadCount;

-(unsigned)_defaultNumberOfMessagesToLoad;
-(void)_setDefaultNumberOfMessagesToLoad:(unsigned)arg1;
-(char)_isLoading;
@end


@interface IMService : NSObject
+(id)iMessageService;
+(id)smsService;
-(id)name;
-(id)localizedName;
-(id)localizedShortName;
-(char)__ck_displayColor;
-(char)__ck_isSMS;
-(char)__ck_isiMessage;
-(int)__ck_maxRecipientCount;
-(id)__ck_displayName;
@end

@interface IMDaemonController : NSObject
+(id)sharedController;
-(BOOL)connectToDaemon;
@end

@interface IMHandle : NSObject
// fighting ADHD; i can't cull thru this one tonight
// https://github.com/nvonbulow/iOS-8.4-Headers-Full/blob/master/PrivateFrameworks/IMCore/IMHandle.h
@end

@interface IMAccount : NSObject
-(NSArray *)__ck_handlesFromAddressStrings:(NSArray *)arg1;
@end

@interface IMAccountController : NSObject
+(id)sharedInstance;
-(id)__ck_defaultAccountForService:(id)arg1;
@end
