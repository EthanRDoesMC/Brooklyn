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
+(id)locationSharingContactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 useCustomFont:(char)arg3 ;
+(id)monogrammerWithDiameter:(float)arg1 style:(int)arg2 useAppTintColor:(char)arg3 customFont:(id)arg4 ;
+(id)placeholderContactImageOfDiameter:(float)arg1 monogramStyle:(int)arg2 tintMonogramText:(char)arg3 ;
+(id)contactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 monogramStyle:(int)arg3 tintMonogramText:(char)arg4 ;
+(id)contactImageOfDiameter:(float)arg1 forRecordID:(int)arg2 monogramStyle:(int)arg3 tintMonogramText:(char)arg4 customFont:(id)arg5 ;
+(void*)addressBook;
@end


#pragma mark - Contents
@interface CKComposition : NSObject
+(id)composition;
+(id)compositionForMessageParts:(id)arg1 preserveSubject:(char)arg2;
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
-(char)hasContent;
-(char)isTextOnly;
-(void)setSubject:(NSAttributedString *)arg1;
-(NSAttributedString *)subject;
-(NSArray *)mediaObjects;
-(id)compositionByReplacingMediaObject:(id)arg1 withMediaObject:(id)arg2;
-(id)compositionByAppendingMediaObjects:(id)arg1;
-(id)initWithText:(id)arg1 subject:(id)arg2;
-(id)compositionByAppendingText:(id)arg1;
-(id)compositionByAppendingComposition:(id)arg1;
-(NSArray *)pasteboardItems;
-(char)isExpirableComposition;
-(char)hasNonwhiteSpaceContent;
-(void)saveCompositionWithGUID:(id)arg1;
-(id)compositionByAppendingMediaObject:(id)arg1;
-(id)messageWithGUID:(id)arg1;
-(char)isSaveable;
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
@property (getter=isFileURLFinalized,nonatomic,readonly) char fileURLFinalized;
@property (getter=isFileDataReady,nonatomic,readonly) char fileDataReady;
@property (getter=isDownloadable,nonatomic,readonly) char downloadable;
@property (getter=isDownloading,nonatomic,readonly) char downloading;
@property (getter=isRestoring,nonatomic,readonly) char restoring;
@required
-(char)isDownloadable;
-(NSURL *)fileURL;
-(IMMessage *)IMMessage;
-(char)isFileDataReady;
-(char)isRestoring;
-(void)mediaObjectRemoved;
-(void)mediaObjectAdded;
-(NSDictionary *)transcoderUserInfo;
-(char)isFileURLFinalized;
-(id)initWithFileURL:(id)arg1 transcoderUserInfo:(id)arg2;
-(id)initWithTransferGUID:(id)arg1 imMessage:(id)arg2;
-(unsigned long long)currentBytes;
-(void)setIMMessage:(IMMessage *)arg1;
-(NSError *)error;
-(NSString *)filename;
-(NSString *)guid;
-(unsigned long long)totalBytes;
-(char)isDownloading;
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
@end

#pragma mark - Messages
@interface CKChatItem : NSObject
-(UIImage *)contactImage;
-(id)loadTranscriptText;
-(NSAttributedString *)transcriptText; // contents (attributed string)
-(NSAttributedString *)transcriptDrawerText; // timestamp, attributed
-(id)loadTranscriptDrawerText;
-(char)canSave;
@end

@interface CKBalloonChatItem : CKChatItem
-(NSDate *)time; // pure timestamp
-(IMHandle *)sender; // sender object
-(char)isFromMe;
-(char)isFirstChatItem;
-(char)failed;
@end

@interface CKMessagePartChatItem : CKBalloonChatItem
-(id)composition; // comprehensive contents without size formatting or sender info
-(IMMessage *)message;
-(char)color; // either green/blue or out/in
-(char)canSendAsTextMessage;
-(NSArray *)pasteboardItems; // what is this??
@end

@interface CKTextMessagePartChatItem : CKMessagePartChatItem
-(NSAttributedString *)text;
-(NSAttributedString *)subject;
-(char)containsHyperlink;
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
+(char)_iMessage_canSendMessageWithMediaObjectTypes:(int*)arg1 ;
+(char)_sms_canSendMessageWithMediaObjectTypes:(int*)arg1 ;
+(double)_sms_maxTrimDurationForMediaType:(int)arg1 ;
+(double)_iMessage_maxTrimDurationForMediaType:(int)arg1 ;
+(char)_sms_canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
+(char)_iMessage_canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
+(char)_sms_canSendComposition:(id)arg1 error:(id*)arg2 ;
+(char)_iMessage_canSendComposition:(id)arg1 error:(id*)arg2 ;
+(int)_iMessage_maxAttachmentCount;
+(char)_iMessage_canSendMessageWithMediaObjectTypes:(int*)arg1 errorCode:(int*)arg2 ;
+(id)_iMessage_localizedErrorForReason:(int)arg1 ;
+(unsigned)_iMessage_maxTransferFileSizeForWiFi:(char)arg1 ;
+(int)_sms_maxAttachmentCount;
+(char)_sms_canSendMessageWithMediaObjectTypes:(int*)arg1 errorCode:(int*)arg2 ;
+(char)_sms_mediaObjectPassesRestriction:(id)arg1 ;
+(char)_sms_mediaObjectPassesDurationCheck:(id)arg1 ;
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
-(char)isGroupConversation;
-(char)supportsMutatingGroupMembers;
-(char)canLeave;
-(char)hasLeft;
-(IMService *)sendingService;
-(id)copyForPendingConversation;
-(char)canInsertMoreRecipients;
-(char)forceMMS;
-(void)setForceMMS:(char)arg1 ;
-(char)shouldShowCharacterCount;
-(char)isPending;
-(char)sendButtonColor;
-(unsigned)recipientCount;
-(char)canAcceptMediaObjectType:(int)arg1 givenMediaObjects:(id)arg2 ;
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
-(char)hasUnreadMessages;
-(id)displayNameForMediaObjects:(id)arg1 subject:(id)arg2 ;
-(void)sendMessage:(id)arg1 newComposition:(char)arg2 ;
-(void)setIgnoringTypingUpdates:(char)arg1 ;
-(id)messageWithComposition:(id)arg1 ;
-(double)maxTrimDurationForMediaType:(int)arg1 ;
-(void)resetCaches;
-(NSArray *)pendingHandles;
-(NSArray *)pendingEntities;
-(char)canSendToRecipients:(id)arg1 alertIfUnable:(char)arg2 ;
-(char)canSendComposition:(id)arg1 error:(id*)arg2 ;
-(void)setLocalUserIsRecording:(char)arg1 ;
-(void)setLocalUserIsTyping:(char)arg1 ;
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
-(char)isDowngraded;
-(int)maximumRecipientsForSendingService;
-(void)_clearTypingIndicatorsIfNecessary;
-(void)_deleteAllMessagesAndRemoveGroup:(char)arg1 ;
-(NSArray *)frequentReplies;
-(void)setLimitToLoad:(unsigned)arg1 ;
-(void)reloadIfNeeded;
-(void)enumerateMessagesWithOptions:(unsigned)arg1 usingBlock:(/*^block*/id)arg2 ;
-(char)_sms_canSendToRecipients:(id)arg1 alertIfUnable:(char)arg2 ;
-(char)_iMessage_canSendToRecipients:(id)arg1 alertIfUnable:(char)arg2 ;
-(char)_accountIsOperational:(id)arg1 forService:(id)arg2 ;
-(void)_recordRecentContact;
-(void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(char)arg3 ;
-(char)_chatSupportsTypingIndicators;
-(char)localUserIsTyping;
-(char)localUserIsRecording;
-(NSArray *)recipientStrings;
-(char)_sms_supportsCharacterCountForAddresses:(id)arg1 ;
-(char)_iMessage_supportsCharacterCountForAddresses:(id)arg1 ;
-(id)_nameForHandle:(id)arg1 ;
-(id)_headerTitleForPendingMediaObjects:(id)arg1 subject:(id)arg2 onService:(id)arg3 ;
-(id)_headerTitleForService:(id)arg1 ;
-(char)isIgnoringTypingUpdates;
-(char)_handleIsForThisConversation:(id)arg1 ;
-(char)noAvailableServices;
-(char)isToEmailAddress;
-(void)loadFrequentReplies;
-(void)loadMoreMessages;
-(char)_chatHasValidAccount:(id)arg1 forService:(id)arg2 ;
-(void)updateUserActivityWithComposition:(id)arg1 ;
-(unsigned)disclosureAtomStyle;
-(char)outgoingBubbleColor;
-(NSString *)serviceDisplayName;
-(char)needsReload;
-(NSArray *)thumbnailOrderABRecordIDs;
-(void)setThumbnailOrderABRecordIDs:(NSArray *)arg1 ;
-(char)_sms_willSendMMSByDefaultForAddresses:(id)arg1 ;
-(id)__generateThumbnailOfDiameter:(float)arg1 withRecipientImage:(id)arg2 andOtherRecipient:(id)arg3 ;
-(id)_messageOrderedABRecordIDsForChatItems:(id)arg1 ;
-(id)__generateThumbnailOfDiameter:(float)arg1 withRecordIDs:(id)arg2 recipientCount:(unsigned)arg3 ;
-(void)_postThumbnailChanged;
-(void)setDisplayName:(NSString *)arg1 ;
-(char)hasDisplayName;
-(unsigned)unreadCount;
-(char)isMuted;
-(NSString *)groupID;
-(char)isPlaceholder;
-(char)buttonColor;
@end

@interface CKConversationList : NSObject
+(id)sharedConversationList;
-(id)conversationForHandles:(id)arg1 displayName:(id)arg2 joinedChatsOnly:(char)arg3 create:(char)arg4;
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
@end


