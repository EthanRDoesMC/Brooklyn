//
//  IMCore.h
//  brooklyn
//
//  Created by EthanRDoesMC
//

#pragma mark - Send Progress


@class IMMessage, IMHandle, IMChat, IMChatRegistry, IMPerson;
#pragma mark - Chat

@interface IMFileTransferCenter : NSObject {
    
    NSMutableDictionary* _guidToTransferMap;
    NSMutableDictionary* _guidToRemovedTransferMap;
    NSMutableDictionary* _accountIDToTransferGUIDsMap;
    NSMutableArray* _preauthorizedInfos;
    NSMutableArray* _preauthorizedGUIDs;
    NSMutableSet* _activeTransfers;
    NSMutableSet* _pendingTransfers;
    
}

@property (nonatomic,readonly) NSDictionary * transfers;
@property (nonatomic,readonly) NSArray * activeTransferGUIDs;
@property (nonatomic,readonly) NSArray * orderedTransfersGUIDs;
@property (nonatomic,readonly) BOOL hasActiveFileTransfers;
@property (nonatomic,readonly) BOOL hasPendingFileTransfers;
@property (nonatomic,readonly) NSArray * activeTransfers;
@property (nonatomic,readonly) NSArray * orderedTransfers;
+(id)sharedInstance;
+(Class)transferCenterClass;
+(Class)fileTransferClass;
+(void)setTransferCenterClass:(Class)arg1 ;
-(void)dealloc;
-(id)transferForGUID:(id)arg1 ;
-(void)acceptTransfer:(id)arg1 ;
-(void)assignTransfer:(id)arg1 toMessage:(id)arg2 account:(id)arg3 ;
-(NSDictionary *)transfers;
-(void)removeTransfer:(id)arg1 ;
-(id)guidForNewOutgoingTransferWithLocalURL:(id)arg1 ;
-(id)transfersForAccount:(id)arg1 ;
-(void)stopTransfer:(id)arg1 ;
-(void)_handleStandaloneFileTransferRegistered:(id)arg1 ;
-(void)_handleFileTransfer:(id)arg1 createdWithProperties:(id)arg2 ;
-(void)_handleFileTransfer:(id)arg1 updatedWithProperties:(id)arg2 ;
-(void)_handleFileTransfer:(id)arg1 updatedWithCurrentBytes:(unsigned long long)arg2 totalBytes:(unsigned long long)arg3 averageTransferRate:(unsigned long long)arg4 ;
-(void)_handleAllFileTransfers:(id)arg1 ;
-(void)_removePendingTransfer:(id)arg1 ;
-(void)_removeActiveTransfer:(id)arg1 ;
-(void)_removeAllActiveTransfers;
-(void)acknowledgeAllPendingTransfers;
-(void)_addTransfer:(id)arg1 toAccount:(id)arg2 ;
-(void)_addPendingTransfer:(id)arg1 ;
-(void)_addTransfer:(id)arg1 ;
-(BOOL)doesLocalURLRequireArchiving:(id)arg1 toHandle:(id)arg2 ;
-(id)transferForGUID:(id)arg1 includeRemoved:(BOOL)arg2 ;
-(void)_addActiveTransfer:(id)arg1 ;
-(void)acceptTransfer:(id)arg1 withPath:(id)arg2 autoRename:(BOOL)arg3 overwrite:(BOOL)arg4 ;
-(BOOL)isFileTransfer:(id)arg1 preauthorizedWithDictionary:(id)arg2 ;
-(void)_clearTransfers;
-(void)acceptFileTransferIfPreauthorzed:(id)arg1 ;
-(BOOL)hasPendingFileTransfers;
-(void)acknowledgePendingTransfer:(id)arg1 ;
-(BOOL)hasActiveFileTransfers;
-(BOOL)registerGUID:(id)arg1 forNewOutgoingTransferWithLocalURL:(id)arg2 ;
-(void)assignTransfer:(id)arg1 toHandle:(id)arg2 ;
-(id)chatForTransfer:(id)arg1 ;
-(void)sendTransfer:(id)arg1 ;
-(void)deleteTransfer:(id)arg1 ;
-(void)retargetTransfer:(id)arg1 toPath:(id)arg2 ;
-(NSArray *)activeTransfers;
-(NSArray *)activeTransferGUIDs;
-(NSArray *)orderedTransfers;
-(NSArray *)orderedTransfersGUIDs;
-(void)clearFinishedTransfers;
-(void)preauthorizeFileTransferFromOtherPerson:(id)arg1 account:(id)arg2 filename:(id)arg3 saveToPath:(id)arg4 ;
-(BOOL)wasFileTransferPreauthorized:(id)arg1 ;
@end


@interface IMMessage : NSObject
+(id)instantMessageWithText:(id)arg1 messageSubject:(id)arg2 fileTransferGUIDs:(id)arg3 flags:(unsigned long long)arg4 ;
-(NSString *)guid;
-(NSDate *)time;
-(IMHandle *)sender;
-(IMHandle *)subject;
-(char)isFinished;
-(BOOL)isFromMe;
-(NSString *)plainBody;
-(char)isAudioMessage;
-(char)isPlayed;
-(char)hasDataDetectorResults;
-(NSArray *)fileTransferGUIDs;
-(char)isTypingMessage;
-(char)isDelivered;
-(char)isSent;
-(char)isLocatingMessage;
//-(IMMessageItem *)_imMessageItem;
-(NSAttributedString *)messageSubject;
-(NSAttributedString *)text;
@end

@interface IMChatItem : NSObject
-(id)_item;
@end

@interface IMMessageChatItem : IMChatItem
-(IMMessage *)message;
@end

@interface IMChat : NSObject
//-(id<IMChatSendProgressDelegate>)sendProgressDelegate;
//-(void)setSendProgressDelegate:(id<IMChatSendProgressDelegate>)arg1;
// routing thru chatkit instead
@property (nonatomic,readonly) NSString * guid;
-(NSArray *)participants;
-(NSString *)displayName;
-(void)loadMessagesBeforeDate:(NSDate *)arg1 limit:(NSInteger)arg2 loadImmediately:(char)arg3;
-(void)setLocalUserIsTyping:(BOOL)arg1;
-(void)sendMessage:(id)arg1;
-(IMMessage *)lastMessage;
-(NSMutableArray<IMChatItem *> *)chatItems;
-(id)loadMessagesBeforeDate:(id)arg1 limit:(unsigned)arg2;
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

-(void)_chat_loadHistory:(id)arg1 limit:(unsigned)arg2 beforeGUID:(id)arg3 afterGUID:(id)arg4 queryID:(id)arg5;
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

@interface IMPerson : NSObject
-(NSData *)imageData;
-(NSArray *)phoneNumbers;
-(NSString *)firstName;
-(NSString *)lastName;
-(NSString *)nickname;
-(NSArray *)emails;
-(int)recordID;
@end

@interface IMHandle : NSObject
// fighting ADHD; i can't cull thru this one tonight
// https://github.com/nvonbulow/iOS-8.4-Headers-Full/blob/master/PrivateFrameworks/IMCore/IMHandle.h
-(NSString *)ID;
-(NSString *)firstName;
-(NSString *)lastName;
-(NSString *)nickname;
-(IMPerson *)person;
-(NSArray *)emails;
-(id)_formattedPhoneNumber;
-(NSString *)accountTypeName;
@end

@interface IMAccount : NSObject
-(NSArray *)__ck_handlesFromAddressStrings:(NSArray *)arg1;
-(id)existingIMHandleWithID:(id)arg1;
-(id)imHandleWithID:(id)arg1;
@end

@interface IMAccountController : NSObject
+(id)sharedInstance;
-(id)__ck_defaultAccountForService:(id)arg1;
-(id)bestAccountForService:(id)service;
@end


