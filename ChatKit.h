//
//  ChatKit.h
//  brooklyn
//
//  Created by EthanRDoesMC.
//
#import "IMCore.h"
#import <UIKit/UIKit.h>

#pragma mark - Contacts
@interface CKAddressBook : NSObject
+(id)transcriptContactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 ;
+(id)locationSharingContactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 useCustomFont:(BOOL)arg3 ;
+(id)monogrammerWithDiameter:(float)arg1 style:(int)arg2 useAppTintColor:(BOOL)arg3 customFont:(id)arg4 ;
+(id)placeholderContactImageOfDiameter:(float)arg1 monogramStyle:(int)arg2 tintMonogramText:(BOOL)arg3 ;
+(id)contactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 monogramStyle:(int)arg3 tintMonogramText:(BOOL)arg4 ;
+(id)contactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 monogramStyle:(int)arg3 tintMonogramText:(BOOL)arg4 customFont:(id)arg5 ;
+(void*)addressBook;
@end


#pragma mark - Contents
@interface CKComposition : NSObject
+(id)composition;
+(id)compositionForMessageParts:(id)arg1 preserveSubject:(BOOL)arg2;
+(id)audioCompositionWithMediaObject:(id)arg1;
+(id)expirableCompositionWithMediaObject:(id)arg1;
+(id)compositionWithMediaObject:(id)arg1 subject:(id)arg2;
+(id)quickImageCompositionWithMediaObject:(id)arg1;
+(id)photoPickerCompositionWithMediaObjects:(id)arg1;
+(id)savedCompositionForGUID:(id)arg1;
+(void)deleteCompositionWithGUID:(id)arg1;
+(id)compositionWithMediaObjects:(id)arg1 subject:(id)arg2;
+(id)photoPickerCompositionWithMediaObject:(id)arg1;

-(NSAttributedString *)text;
-(void)setText:(NSAttributedString *)arg1;
-(BOOL)hasContent;
-(BOOL)isTextOnly;
-(void)setSubject:(NSAttributedString *)arg1;
-(NSAttributedString *)subject;
-(NSArray *)mediaObjects;
-(id)compositionByReplacingMediaObject:(id)arg1 withMediaObject:(id)arg2;
-(id)compositionByAppendingMediaObjects:(id)arg1;
-(id)initWithText:(id)arg1 subject:(id)arg2;
-(id)compositionByAppendingText:(id)arg1;
-(id)compositionByAppendingComposition:(id)arg1;
-(NSArray *)pasteboardItems;
-(BOOL)isExpirableComposition;
-(BOOL)hasNonwhiteSpaceContent;
-(void)saveCompositionWithGUID:(id)arg1;
-(id)compositionByAppendingMediaObject:(id)arg1;
-(id)messageWithGUID:(id)arg1;
-(BOOL)isSaveable;
-(id)superFormatText:(id*)arg1;
-(id)superFormatSubject;
@end

@protocol CKFileTransfer <NSObject>
@property (nonatomic,retain) IMMessage * IMMessage;
@property (nonatomic,copy,readonly) NSString * guid;
@property (nonatomic,copy,readonly) NSURL * fileURL;
@property (nonatomic,copy,readonly) NSString * filename;
@property (nonatomic,copy,readonly) NSDictionary * transcoderUserInfo;
@property (nonatomic,copy,readonly) NSError * error;
@property (nonatomic,readonly) unsigned long long currentBytes;
@property (nonatomic,readonly) unsigned long long totalBytes;
@property (getter=isFileURLFinalized,nonatomic,readonly) BOOL fileURLFinalized;
@property (getter=isFileDataReady,nonatomic,readonly) BOOL fileDataReady;
@property (getter=isDownloadable,nonatomic,readonly) BOOL downloadable;
@property (getter=isDownloading,nonatomic,readonly) BOOL downloading;
@property (getter=isRestoring,nonatomic,readonly) BOOL restoring;
@required
-(BOOL)isDownloadable;
-(NSURL *)fileURL;
-(IMMessage *)IMMessage;
-(BOOL)isFileDataReady;
-(BOOL)isRestoring;
-(void)mediaObjectRemoved;
-(void)mediaObjectAdded;
-(NSDictionary *)transcoderUserInfo;
-(BOOL)isFileURLFinalized;
-(id)initWithFileURL:(id)arg1 transcoderUserInfo:(id)arg2;
-(id)initWithTransferGUID:(id)arg1 imMessage:(id)arg2;
-(unsigned long long)currentBytes;
-(void)setIMMessage:(IMMessage *)arg1;
-(NSError *)error;
-(NSString *)filename;
-(NSString *)guid;
-(unsigned long long)totalBytes;
-(BOOL)isDownloading;
@end

@interface CKMediaObject : NSObject
-(id<CKFileTransfer>)transfer;
-(NSString *)filename;
-(id)JPEGDataFromImage:(id)arg1;
-(id)title;
-(NSData *)data;
-(id)subtitle;
-(id)location;
-(int)mediaType;
-(NSString *)transferGUID;
-(NSString *)mimeType;
@end

@interface CKMediaObjectManager : NSObject {
    
    NSMutableDictionary* _transfers;
    NSArray* _classes;
    NSDictionary* _UTITypes;
    NSDictionary* _dynTypes;
    
}

@property (nonatomic,copy) NSArray * classes;                              //@synthesize classes=_classes - In the implementation block
@property (nonatomic,copy) NSDictionary * UTITypes;                        //@synthesize UTITypes=_UTITypes - In the implementation block
@property (nonatomic,copy) NSDictionary * dynTypes;                        //@synthesize dynTypes=_dynTypes - In the implementation block
@property (nonatomic,retain) NSMutableDictionary * transfers;              //@synthesize transfers=_transfers - In the implementation block
+(id)sharedInstance;
-(void)dealloc;
-(id)init;
-(id)mediaObjectWithData:(id)arg1 UTIType:(id)arg2 filename:(id)arg3 transcoderUserInfo:(id)arg4 ;
-(id)mediaObjectWithFileURL:(NSURL *)url filename:(id)fn transcoderUserInfo:(id)tui attributionInfo:(id)ai hideAttachment:(BOOL)ha;
-(NSDictionary *)UTITypes;
-(id)mediaObjectWithFileURL:(id)arg1 filename:(id)arg2 transcoderUserInfo:(id)arg3 ;
-(id)mediaObjectWithTransferGUID:(id)arg1 imMessage:(id)arg2 ;
-(id)UTITypeForFilename:(id)arg1 ;
-(Class)classForFilename:(id)arg1 ;
-(Class)classForUTIType:(id)arg1 ;
-(NSArray *)classes;
-(void)setTransfers:(NSMutableDictionary *)arg1 ;
-(void)setClasses:(NSArray *)arg1 ;
-(void)setUTITypes:(NSDictionary *)arg1 ;
-(void)setDynTypes:(NSDictionary *)arg1 ;
-(void)transferRemoved:(id)arg1 ;
-(NSDictionary *)dynTypes;
-(id)UTITypeForExtension:(id)arg1 ;
-(NSMutableDictionary *)transfers;
-(id)transferWithTransferGUID:(id)arg1 imMessage:(id)arg2 ;
-(id)transferWithFileURL:(id)arg1 transcoderUserInfo:(id)arg2 ;
-(Class)transferClass;
-(id)fileManager;
@end

#pragma mark - Messages
@interface CKChatItem : NSObject
-(UIImage *)contactImage;
-(id)loadTranscriptText;
-(NSAttributedString *)transcriptText; // contents (attributed string)
-(NSAttributedString *)transcriptDrawerText; // timestamp, attributed
-(id)loadTranscriptDrawerText;
-(BOOL)canSave;
@end

@interface CKBalloonChatItem : CKChatItem
-(NSDate *)time; // pure timestamp
-(IMHandle *)sender; // sender object
-(BOOL)isFromMe;
-(BOOL)isFirstChatItem;
-(BOOL)failed;
@end

@interface CKMessagePartChatItem : CKBalloonChatItem
-(id)composition; // comprehensive contents without size formatting or sender info
-(IMMessage *)message;
-(BOOL)color; // either green/blue or out/in
-(BOOL)canSendAsTextMessage;
-(NSArray *)pasteboardItems; // what is this??
@end

@interface CKTextMessagePartChatItem : CKMessagePartChatItem
-(NSAttributedString *)text;
-(NSAttributedString *)subject;
-(BOOL)containsHyperlink;
@end

@interface CKAttachmentMessagePartChatItem : CKMessagePartChatItem
-(NSString *)transferGUID;
-(CKMediaObject *)mediaObject;
@end

@interface CKAggregateMessagePartChatItem : CKTextMessagePartChatItem
-(NSArray *)subparts;
-(NSString *)title;
@end

#pragma mark - Entity
@interface CKEntity : NSObject

@property (nonatomic,retain,readonly) IMHandle * defaultIMHandle;
@property (nonatomic,readonly) void* abRecord;
@property (nonatomic,readonly) int propertyType;
@property (nonatomic,readonly) int identifier;
@property (nonatomic,copy,readonly) NSString * name;
@property (nonatomic,copy,readonly) NSString * fullName;
@property (nonatomic,copy,readonly) NSString * rawAddress;
@property (nonatomic,copy,readonly) NSString * originalAddress;
@property (nonatomic,copy,readonly) NSString * IDSCanonicalAddress;
@property (nonatomic,copy,readonly) NSString * textToneIdentifier;
@property (nonatomic,copy,readonly) NSString * textVibrationIdentifier;
//@property (nonatomic,retain,readonly) UIImage * transcriptContactImage;
//@property (nonatomic,retain,readonly) UIImage * transcriptDrawerContactImage;
//@property (nonatomic,retain,readonly) UIImage * locationMapViewContactImage;
//@property (nonatomic,retain,readonly) UIImage * locationShareBalloonContactImage;
@property (nonatomic,retain) IMHandle * handle;
+(id)copyEntityForAddressString:(id)arg1 ;
+(id)_copyEntityForAddressString:(id)arg1 onAccount:(id)arg2 ;
-(int)propertyType;
-(NSString *)name;
-(int)identifier;
-(id)initWithIMHandle:(id)arg1 ;
-(UIImage *)locationMapViewContactImage;
-(IMHandle *)defaultIMHandle;
-(NSString *)IDSCanonicalAddress;
-(NSString *)rawAddress;
-(void*)abRecord;
-(id)personViewControllerWithDelegate:(id)arg1 ;
-(UIImage *)transcriptDrawerContactImage;
-(NSString *)originalAddress;
-(NSString *)textToneIdentifier;
-(NSString *)textVibrationIdentifier;
-(UIImage *)transcriptContactImage;
-(UIImage *)locationShareBalloonContactImage;
-(IMHandle *)handle;
-(void)setHandle:(IMHandle *)arg1 ;
-(NSString *)fullName;
@end

#pragma mark - Conversation
#pragma mark CULL THROUGH THIS
@interface CKConversation : NSObject
+(id)newPendingConversation;
+(BOOL)_iMessage_canSendMessageWithMediaObjectTypes:(int*)arg1 ;
+(BOOL)_sms_canSendMessageWithMediaObjectTypes:(int*)arg1 ;
+(double)_sms_maxTrimDurationForMediaType:(int)arg1 ;
+(double)_iMessage_maxTrimDurationForMediaType:(int)arg1 ;
+(BOOL)_sms_canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
+(BOOL)_iMessage_canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
+(BOOL)_sms_canSendComposition:(id)arg1 error:(id*)arg2 ;
+(BOOL)_iMessage_canSendComposition:(id)arg1 error:(id*)arg2 ;
+(int)_iMessage_maxAttachmentCount;
+(BOOL)_iMessage_canSendMessageWithMediaObjectTypes:(int*)arg1 errorCode:(int*)arg2 ;
+(id)_iMessage_localizedErrorForReason:(int)arg1 ;
+(unsigned)_iMessage_maxTransferFileSizeForWiFi:(BOOL)arg1 ;
+(int)_sms_maxAttachmentCount;
+(BOOL)_sms_canSendMessageWithMediaObjectTypes:(int*)arg1 errorCode:(int*)arg2 ;
+(BOOL)_sms_mediaObjectPassesRestriction:(id)arg1 ;
+(BOOL)_sms_mediaObjectPassesDurationCheck:(id)arg1 ;
+(id)_sms_localizedErrorForReason:(int)arg1 ;
-(NSArray *)recipients;
-(void)setRecipients:(NSArray *)arg1 ;
-(CKEntity *)recipient;
-(void)dealloc;
-(id)init;
-(id)description;
-(NSString *)name;
-(id)date;
-(NSAttributedString *)groupName;
-(id)uniqueIdentifier;
-(id)shortDescription;
-(NSArray *)handles;
-(id)thumbnail;
-(NSString *)displayName;
-(IMChat *)chat;
-(BOOL)isGroupConversation;
-(BOOL)supportsMutatingGroupMembers;
-(BOOL)canLeave;
-(BOOL)hasLeft;
-(IMService *)sendingService;
-(id)copyForPendingConversation;
-(BOOL)canInsertMoreRecipients;
-(BOOL)forceMMS;
-(void)setForceMMS:(BOOL)arg1 ;
-(BOOL)shouldShowCharacterCount;
-(BOOL)isPending;
-(BOOL)sendButtonColor;
-(unsigned)recipientCount;
-(BOOL)canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
-(void)unmute;
-(void)setMutedUntilDate:(id)arg1 ;
-(void)removeRecipientHandles:(id)arg1 ;
-(void)addRecipientHandles:(id)arg1 ;
-(void)setUnsentComposition:(CKComposition *)arg1 ;
-(NSString *)deviceIndependentID;
-(void)markAllMessagesAsRead;
-(CKComposition *)unsentComposition;
-(void)setNeedsReload;
-(void)loadAllMessages;
-(void)refreshServiceForSending;
-(void)setPendingComposeRecipients:(id)arg1 ;
-(BOOL)hasUnreadMessages;
-(id)displayNameForMediaObjects:(id)arg1 subject:(id)arg2 ;
-(void)sendMessage:(id)arg1 newComposition:(BOOL)arg2 ;
-(void)setIgnoringTypingUpdates:(BOOL)arg1 ;
-(id)messageWithComposition:(id)arg1 ;
-(double)maxTrimDurationForMediaType:(int)arg1 ;
-(void)resetCaches;
-(NSArray *)pendingHandles;
-(NSArray *)pendingEntities;
-(BOOL)canSendToRecipients:(id)arg1 alertIfUnable:(BOOL)arg2 ;
-(BOOL)canSendComposition:(id)arg1 error:(id*)arg2 ;
-(void)setLocalUserIsRecording:(BOOL)arg1 ;
-(void)setLocalUserIsTyping:(BOOL)arg1 ;
-(void)deleteAllMessages;
-(void)acceptTransfer:(id)arg1 ;
-(id)initWithChat:(id)arg1 ;
-(void)setPendingHandles:(NSArray *)arg1 ;
-(void)regenerateThumbnail;
-(int)compareBySequenceNumberAndDateDescending:(id)arg1 ;
-(void)deleteAllMessagesAndRemoveGroup;
-(NSString *)previewText;
-(unsigned)limitToLoad;
-(void)setLoadedMessageCount:(unsigned)arg1 ;
-(void)setChat:(IMChat *)arg1 ;
-(void)_messageReceived:(id)arg1 ;
-(void)_handleChatParticipantsDidChange:(id)arg1 ;
-(void)_handleChatJoinStateDidChange:(id)arg1 ;
-(void)_handlePreferredServiceChangedNotification:(id)arg1 ;
-(void)resetNameCaches;
-(void)resetThumbnailCaches;
-(void)updateGroupThumbnailIfNeeded;
-(BOOL)isDowngraded;
-(int)maximumRecipientsForSendingService;
-(void)_clearTypingIndicatorsIfNecessary;
-(void)_deleteAllMessagesAndRemoveGroup:(BOOL)arg1 ;
-(NSArray *)frequentReplies;
-(void)setLimitToLoad:(unsigned)arg1 ;
-(void)reloadIfNeeded;
-(void)enumerateMessagesWithOptions:(unsigned)arg1 usingBlock:(/*^block*/id)arg2 ;
-(BOOL)_sms_canSendToRecipients:(id)arg1 alertIfUnable:(BOOL)arg2 ;
-(BOOL)_iMessage_canSendToRecipients:(id)arg1 alertIfUnable:(BOOL)arg2 ;
-(BOOL)_accountIsOperational:(id)arg1 forService:(id)arg2 ;
-(void)_recordRecentContact;
-(void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(BOOL)arg3 ;
-(BOOL)_chatSupportsTypingIndicators;
-(BOOL)localUserIsTyping;
-(BOOL)localUserIsRecording;
-(NSArray *)recipientStrings;
-(BOOL)_sms_supportsCharacterCountForAddresses:(id)arg1 ;
-(BOOL)_iMessage_supportsCharacterCountForAddresses:(id)arg1 ;
-(id)_nameForHandle:(id)arg1 ;
-(id)_headerTitleForPendingMediaObjects:(id)arg1 subject:(id)arg2 onService:(id)arg3 ;
-(id)_headerTitleForService:(id)arg1 ;
-(BOOL)isIgnoringTypingUpdates;
-(BOOL)_handleIsForThisConversation:(id)arg1 ;
-(BOOL)noAvailableServices;
-(BOOL)isToEmailAddress;
-(void)loadFrequentReplies;
-(void)loadMoreMessages;
-(BOOL)_chatHasValidAccount:(id)arg1 forService:(id)arg2 ;
-(void)updateUserActivityWithComposition:(id)arg1 ;
-(unsigned)disclosureAtomStyle;
-(BOOL)outgoingBubbleColor;
-(NSString *)serviceDisplayName;
-(BOOL)needsReload;
-(NSArray *)thumbnailOrderABRecordIDs;
-(void)setThumbnailOrderABRecordIDs:(NSArray *)arg1 ;
-(BOOL)_sms_willSendMMSByDefaultForAddresses:(id)arg1 ;
-(id)__generateThumbnailOfDiameter:(float)arg1 withRecipientImage:(id)arg2 andOtherRecipient:(id)arg3 ;
-(id)_messageOrderedABRecordIDsForChatItems:(id)arg1 ;
-(id)__generateThumbnailOfDiameter:(float)arg1 withRecordIDs:(id)arg2 recipientCount:(unsigned)arg3 ;
-(void)_postThumbnailChanged;
-(void)setDisplayName:(NSString *)arg1 ;
-(BOOL)hasDisplayName;
-(unsigned)unreadCount;
-(BOOL)isMuted;
-(NSString *)groupID;
-(BOOL)isPlaceholder;
-(BOOL)buttonColor;
@end

@interface CKConversationList : NSObject
+(id)sharedConversationList;
-(id)conversationForHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(BOOL)arg3 create:(BOOL)arg4;
-(id)conversations;
-(id)_conversationForChat:(id)arg1;
-(id)activeConversations;
-(id)unreadLastMessages;
-(int)unreadCount;
-(id)_copyEntitiesForAddressStrings:(id)arg1;
-(void)deleteConversation:(id)arg1;
@end

@interface CKIMComposeRecipient : NSObject {

    IMHandle* _handle;

}

@property (nonatomic,retain,readonly) IMHandle * handle;              //@synthesize handle=_handle - In the implementation block
-(id)address;
-(id)uncommentedAddress;
-(void)dealloc;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)displayString;
-(int)identifier;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setIdentifier:(int)arg1 ;
-(id)label;
-(BOOL)isRemovableFromSearchResults;
-(id)compositeName;
-(id)commentedAddress;
-(id)initWithRecord:(void*)arg1 recordID:(int)arg2 property:(int)arg3 identifier:(int)arg4 address:(id)arg5 ;
-(id)initWithHandle:(id)arg1 ;
-(id)unlocalizedLabel;
-(id)supportedDragTypes;
-(id)objectForDragType:(id)arg1 ;
-(void)setRecord:(void*)arg1 recordID:(int)arg2 identifier:(int)arg3 ;
-(void*)record;
-(int)recordID;
-(IMHandle *)handle;
-(int)property;
@end


@interface CKRecipientGenerator : NSObject
+(id)sharedRecipientGenerator;
-(id)resultsForText:(id)arg1;
-(CKIMComposeRecipient *)recipientWithAddress:(NSString *)arg1;
-(NSArray *)searchABPropertyTypes;
@end

@interface CKTranscriptController : UIViewController
-(void)setConversation:(CKConversation *)arg1;
-(void)sendComposition:(id)arg1;
@end


