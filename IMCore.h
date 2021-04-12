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
-(BOOL)isFinished;
-(BOOL)isFromMe;
-(NSString *)plainBody;
-(BOOL)isAudioMessage;
-(BOOL)isPlayed;
-(BOOL)hasDataDetectorResults;
-(NSArray *)fileTransferGUIDs;
-(BOOL)isTypingMessage;
-(BOOL)isDelivered;
-(BOOL)isSent;
-(BOOL)isLocatingMessage;
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
-(void)loadMessagesBeforeDate:(NSDate *)arg1 limit:(NSInteger)arg2 loadImmediately:(BOOL)arg3;
-(void)setLocalUserIsTyping:(BOOL)arg1;
-(void)sendMessage:(id)arg1;
-(IMMessage *)lastMessage;
-(NSMutableArray<IMChatItem *> *)chatItems;
-(id)loadMessagesBeforeDate:(id)arg1 limit:(unsigned)arg2;
-(void)markAllMessagesAsRead;
@end
#pragma mark - Chat Registry
@interface IMChatRegistry : NSObject
+(id)sharedInstance;

-(IMChat *)chatForIMHandle:(id)arg1;
-(IMChat *)chatForIMHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(BOOL)arg3;
-(IMChat *)_ck_chatForHandles:(id)arg1 createIfNecessary:(BOOL)arg2;
-(IMChat *)_ck_chatForHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(BOOL)arg3 createIfNecessary:(BOOL)arg4;

-(NSArray *)allExistingChats;
-(unsigned)numberOfExistingChats;
-(id)_allCreatedChats;

-(IMChat *)existingChatWithGUID:(id)arg1;
-(IMChat *)existingChatWithChatIdentifier:(id)arg1;
-(IMChat *)existingChatForIMHandle:(id)arg1;
-(IMChat *)existingChatWithGroupID:(id)arg1;

-(IMChat *)existingChatForIMHandle:(id)arg1 allowRetargeting:(BOOL)arg2;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(BOOL)arg2;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(BOOL)arg2 groupID:(id)arg3;
-(IMChat *)existingChatForIMHandles:(id)arg1 allowRetargeting:(BOOL)arg2 groupID:(id)arg3 displayName:(id)arg4 joinedChatsOnly:(BOOL)arg5;

-(IMChat *)_createdChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 account:(id)arg3 ;
-(IMChat *)_existingChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 service:(id)arg3 ;
-(IMChat *)_existingChatWithIdentifier:(id)arg1 style:(unsigned char)arg2 account:(id)arg3 ;

-(IMChat *)chatForIMHandles:(id)arg1;
-(IMChat *)chatForIMHandles:(id)arg1 chatName:(id)arg2;

-(unsigned)unreadCount;

-(unsigned)_defaultNumberOfMessagesToLoad;
-(void)_setDefaultNumberOfMessagesToLoad:(unsigned)arg1;
-(BOOL)_isLoading;

-(void)_chat_loadHistory:(id)arg1 limit:(unsigned)arg2 beforeGUID:(id)arg3 afterGUID:(id)arg4 queryID:(id)arg5;
@end


@interface IMService : NSObject
+(id)iMessageService;
+(id)smsService;
-(id)name;
-(id)localizedName;
-(id)localizedShortName;
-(BOOL)__ck_displayColor;
-(BOOL)__ck_isSMS;
-(BOOL)__ck_isiMessage;
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


@interface IMFileTransfer : NSObject {
    
    BOOL _isIncoming;
    BOOL _isDirectory;
    BOOL _shouldAttemptToResume;
    BOOL _wasRegisteredAsStandalone;
    BOOL _shouldForceArchive;
    BOOL _needsWrapper;
    unsigned short _hfsFlags;
    NSURL* _localURL;
    NSData* _localBookmark;
    NSString* _guid;
    NSString* _messageGUID;
    NSDate* _startDate;
    NSDate* _createdDate;
    int _transferState;
    NSString* _filename;
    NSURL* _transferDataURL;
    NSString* _utiType;
    NSString* _mimeType;
    unsigned long _hfsType;
    unsigned long _hfsCreator;
    NSString* _accountID;
    NSString* _otherPerson;
    int _error;
    NSString* _errorDescription;
    NSDictionary* _localUserInfo;
    NSString* _transferredFilename;
    NSDictionary* _transcoderUserInfo;
    double _lastUpdatedInterval;
    double _lastAveragedInterval;
    unsigned long long _lastAveragedBytes;
    unsigned long long _currentBytes;
    unsigned long long _totalBytes;
    unsigned long long _averageTransferRate;
    
}

@property (nonatomic,readonly) BOOL canBeAccepted;
@property (nonatomic,readonly) BOOL isFinished;
@property (nonatomic,retain,readonly) NSString * displayName;
@property (nonatomic,readonly) BOOL existsAtLocalPath;
@property (nonatomic,retain) NSString * guid;                                                               //@synthesize guid=_guid - In the implementation block
@property (nonatomic,retain) NSString * messageGUID;                                                        //@synthesize messageGUID=_messageGUID - In the implementation block
@property (nonatomic,retain) NSDate * createdDate;                                                          //@synthesize createdDate=_createdDate - In the implementation block
@property (nonatomic,retain) NSDate * startDate;                                                            //@synthesize startDate=_startDate - In the implementation block
@property (assign,nonatomic) int transferState;                                                             //@synthesize transferState=_transferState - In the implementation block
@property (assign,nonatomic) BOOL isIncoming;                                                               //@synthesize isIncoming=_isIncoming - In the implementation block
@property (nonatomic,retain) NSString * filename;                                                           //@synthesize filename=_filename - In the implementation block
@property (nonatomic,retain) NSString * transferredFilename;                                                //@synthesize transferredFilename=_transferredFilename - In the implementation block
@property (nonatomic,retain) NSString * localPath;
@property (nonatomic,retain) NSString * type;                                                               //@synthesize utiType=_utiType - In the implementation block
@property (nonatomic,retain,readonly) NSString * mimeType;                                                  //@synthesize mimeType=_mimeType - In the implementation block
@property (nonatomic,retain) NSURL * localURL;
@property (nonatomic,retain) NSURL * transferDataURL;                                                       //@synthesize transferDataURL=_transferDataURL - In the implementation block
@property (nonatomic,retain,readonly) NSURL * localURLWithoutBookmarkResolution;                            //@synthesize localURL=_localURL - In the implementation block
@property (nonatomic,retain) NSData * localBookmark;                                                        //@synthesize localBookmark=_localBookmark - In the implementation block
@property (assign,nonatomic) unsigned long hfsType;                                                         //@synthesize hfsType=_hfsType - In the implementation block
@property (assign,nonatomic) unsigned long hfsCreator;                                                      //@synthesize hfsCreator=_hfsCreator - In the implementation block
@property (assign,nonatomic) unsigned short hfsFlags;                                                       //@synthesize hfsFlags=_hfsFlags - In the implementation block
@property (nonatomic,retain) NSString * accountID;                                                          //@synthesize accountID=_accountID - In the implementation block
@property (nonatomic,retain) NSString * otherPerson;                                                        //@synthesize otherPerson=_otherPerson - In the implementation block
@property (assign,nonatomic) unsigned long long currentBytes;                                               //@synthesize currentBytes=_currentBytes - In the implementation block
@property (assign,nonatomic) unsigned long long totalBytes;                                                 //@synthesize totalBytes=_totalBytes - In the implementation block
@property (assign,nonatomic) unsigned long long averageTransferRate;                                        //@synthesize averageTransferRate=_averageTransferRate - In the implementation block
@property (assign,nonatomic) BOOL isDirectory;                                                              //@synthesize isDirectory=_isDirectory - In the implementation block
@property (assign,nonatomic) BOOL shouldAttemptToResume;                                                    //@synthesize shouldAttemptToResume=_shouldAttemptToResume - In the implementation block
@property (assign,nonatomic) BOOL shouldForceArchive;                                                       //@synthesize shouldForceArchive=_shouldForceArchive - In the implementation block
@property (assign,nonatomic) int error;                                                                     //@synthesize error=_error - In the implementation block
@property (nonatomic,retain) NSString * errorDescription;                                                   //@synthesize errorDescription=_errorDescription - In the implementation block
@property (nonatomic,retain) NSDictionary * transcoderUserInfo;                                             //@synthesize transcoderUserInfo=_transcoderUserInfo - In the implementation block
@property (nonatomic,retain) NSDictionary * userInfo;                                                       //@synthesize localUserInfo=_localUserInfo - In the implementation block
@property (assign,setter=setRegisteredAsStandalone:,nonatomic) BOOL wasRegisteredAsStandalone;              //@synthesize wasRegisteredAsStandalone=_wasRegisteredAsStandalone - In the implementation block
@property (assign,setter=_setLastUpdatedInterval:,nonatomic) double _lastUpdatedInterval;                   //@synthesize lastUpdatedInterval=_lastUpdatedInterval - In the implementation block
@property (assign,setter=_setLastAveragedInterval:,nonatomic) double _lastAveragedInterval;                 //@synthesize lastAveragedInterval=_lastAveragedInterval - In the implementation block
@property (nonatomic,readonly) unsigned long long _lastAveragedBytes;                                       //@synthesize lastAveragedBytes=_lastAveragedBytes - In the implementation block
@property (assign,setter=_setNeedsWrapper:,nonatomic) BOOL _needsWrapper;                                   //@synthesize needsWrapper=_needsWrapper - In the implementation block
+(BOOL)_doesLocalURLRequireArchiving:(id)arg1 ;
+(id)_invalidCharactersForFileTransferName;
-(void)_clear;
-(void)_setStartDate:(id)arg1 ;
-(void)_setError:(int)arg1 ;
-(void)dealloc;
-(id)init;
-(id)description;
-(void)setType:(NSString *)arg1 ;
-(NSString *)type;
-(void)setUserInfo:(NSDictionary *)arg1 ;
-(NSDictionary *)userInfo;
-(NSString *)mimeType;
-(NSURL *)localURL;
-(NSString *)displayName;
-(BOOL)isFinished;
-(NSString *)messageGUID;
-(void)setMessageGUID:(NSString *)arg1 ;
-(NSDictionary *)transcoderUserInfo;
-(unsigned long long)currentBytes;
-(void)setTranscoderUserInfo:(NSDictionary *)arg1 ;
-(int)error;
-(NSString *)filename;
-(NSString *)accountID;
-(BOOL)isDirectory;
-(void)setFilename:(NSString *)arg1 ;
-(void)setGuid:(NSString *)arg1 ;
-(NSString *)guid;
-(id)_initWithGUID:(id)arg1 filename:(id)arg2 isDirectory:(BOOL)arg3 localURL:(id)arg4 account:(id)arg5 otherPerson:(id)arg6 totalBytes:(unsigned long long)arg7 hfsType:(unsigned long)arg8 hfsCreator:(unsigned long)arg9 hfsFlags:(unsigned short)arg10 isIncoming:(BOOL)arg11 ;
-(void)_setAccount:(id)arg1 otherPerson:(id)arg2 ;
-(id)_dictionaryRepresentation;
-(void)_setForceArchive:(BOOL)arg1 ;
-(void)_setTransferState:(int)arg1 ;
-(void)_setLocalURL:(id)arg1 ;
-(NSString *)otherPerson;
-(void)setRegisteredAsStandalone:(BOOL)arg1 ;
-(BOOL)_updateWithDictionaryRepresentation:(id)arg1 ;
-(BOOL)wasRegisteredAsStandalone;
-(void)_setCurrentBytes:(unsigned long long)arg1 totalBytes:(unsigned long long)arg2 ;
-(void)_setAveragedTransferRate:(unsigned long long)arg1 lastAveragedInterval:(double)arg2 lastAveragedBytes:(unsigned long long)arg3 ;
-(BOOL)isIncoming;
-(int)transferState;
-(NSString *)localPath;
-(void)setCurrentBytes:(unsigned long long)arg1 ;
-(void)_setLocalPath:(id)arg1 ;
-(unsigned short)hfsFlags;
-(void)_calculateTypeInformation;
-(NSString *)transferredFilename;
-(void)_setDirectory:(BOOL)arg1 hfsType:(unsigned long)arg2 hfsCreator:(unsigned long)arg3 hfsFlags:(unsigned short)arg4 ;
-(BOOL)canBeAccepted;
-(BOOL)existsAtLocalPath;
-(void)_setTransferDataURL:(id)arg1 ;
-(unsigned long)hfsType;
-(NSURL *)localURLWithoutBookmarkResolution;
-(NSData *)localBookmark;
-(void)setLocalBookmark:(NSData *)arg1 ;
-(double)_lastUpdatedInterval;
-(void)_setLastUpdatedInterval:(double)arg1 ;
-(double)_lastAveragedInterval;
-(void)_setLastAveragedInterval:(double)arg1 ;
-(unsigned long long)_lastAveragedBytes;
-(NSDate *)createdDate;
-(void)setCreatedDate:(NSDate *)arg1 ;
-(void)setIsIncoming:(BOOL)arg1 ;
-(NSURL *)transferDataURL;
-(void)setHfsType:(unsigned long)arg1 ;
-(void)setHfsFlags:(unsigned short)arg1 ;
-(unsigned long)hfsCreator;
-(void)setHfsCreator:(unsigned long)arg1 ;
-(void)setAccountID:(NSString *)arg1 ;
-(void)setOtherPerson:(NSString *)arg1 ;
-(unsigned long long)averageTransferRate;
-(void)setAverageTransferRate:(unsigned long long)arg1 ;
-(void)setIsDirectory:(BOOL)arg1 ;
-(BOOL)shouldAttemptToResume;
-(void)setShouldAttemptToResume:(BOOL)arg1 ;
-(void)_setErrorDescription:(id)arg1 ;
-(BOOL)shouldForceArchive;
-(BOOL)_needsWrapper;
-(void)_setNeedsWrapper:(BOOL)arg1 ;
-(void)setTransferredFilename:(NSString *)arg1 ;
-(NSString *)errorDescription;
-(unsigned long long)totalBytes;
-(void)setTotalBytes:(unsigned long long)arg1 ;
-(NSDate *)startDate;
@end
