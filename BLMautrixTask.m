//
//  BLMautrixTask.m
//  xchighlight
//
//  Created by EthanRDoesMC on 3/20/21.
//

#import "BLMautrixTask.h"
#import "IMCore.h"
#import "ChatKit.h"
#import "UIImage+Base64.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreFoundation/CoreFoundation.h>
#import "CPDistributedMessagingCenter.h"

#define MESSAGE_BACKLOG_SIZE_FOR_DEDUPLICATION 10

@interface UIApplication (BLSMSHelper)
-(BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)launchSuspended;
@end

// you're a god among men, kirb, but we need consolidation
// all credits go to https://github.com/hbang/libcephei/blob/master/HBOutputForShellCommand.m

NSString *HBOutputForShellCommandWithReturnCode(NSString *command, int *returnCode) {
    FILE *file = popen(command.UTF8String, "r");
    
    if (!file) {
        return nil;
    }
    
    char data[1024];
    NSMutableString *output = [NSMutableString string];
    
    while (fgets(data, 1024, file) != NULL) {
        [output appendString:[NSString stringWithUTF8String:data]];
    }
    
    int result = pclose(file);
    *returnCode = result;
    
    return output;
}

NSString *HBOutputForShellCommand(NSString *command) {
    int returnCode = 0;
    NSString *output = HBOutputForShellCommandWithReturnCode(command, &returnCode);
    return returnCode == 0 ? output : nil;
}



@implementation BLMautrixTask

NSInteger requestID = 0;

+ (instancetype)sharedTask {
    static BLMautrixTask *_sharedTask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTask = [[BLMautrixTask alloc] initAndLaunch];
    });
    
    return _sharedTask;
}
-(id)initAndLaunch {
    if (self.task) {
        [self.task suspend];
        [self.task interrupt];
    }
    // Register notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessage:) name:@"__kIMChatMessageReceivedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyzeNotification:) name:@"__kIMChatItemsInserted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExternal:) name:@"__kIMChatMessageDidChangeNotification" object:nil];
    self.sessionSentGUIDs = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTaskQuit:) name:@"NSTaskDidTerminateNotification" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessage:) name:@"__kIMChatMessageDidChangeNotification" object:nil];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Beeper/%@.txt", [NSDate date]]];
    //self.messageCenter = [CPDistributedMessagingCenter centerNamed:@"com.beeper.brooklyn"];
    //[[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
    
    NSString * fhp = [NSString stringWithFormat:@"/var/mobile/Documents/Beeper/%@.txt", [NSDate date]];
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:fhp];
    if ( !fh ) {
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"/var/mobile/Documents/Beeper/%@.txt", [NSDate date]] contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"/var/mobile/Documents/Beeper/%@.txt", [NSDate date]]];
    }
    
    freopen([fhp cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    NSLog(@"Brooklyn %@", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn"));
    NSLog(@"Brooklyn launching task");
    self = [super init];
    self.task = [NSTask new];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    self.task.launchPath = @"/var/mobile/Documents/mautrix-imessage-armv7/mautrix-imessage";
    if ([NSUserDefaults.standardUserDefaults stringForKey:@"configurl"]) {
        [arguments addObject:[NSString stringWithFormat:@"-u%@",[NSUserDefaults.standardUserDefaults stringForKey:@"configurl"]]];
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"redirect"]) {
            [arguments addObject:@"--output-redirect"];
        }
        NSLog(@"%@",arguments);
    }
        self.task.arguments  = arguments;
        self.task.currentDirectoryPath = @"/var/mobile/Documents/mautrix-imessage-armv7/"; //temporary location
        NSMutableDictionary *defaultEnv = [[NSMutableDictionary alloc] initWithDictionary:[[NSProcessInfo processInfo] environment]];
        [defaultEnv setObject:@"YES" forKey:@"NSUnbufferedIO"];
        
        self.task.environment = defaultEnv;
        
        //NSPipe *writePipe = [NSPipe pipe];
        //NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
        self.writePipe = [NSPipe pipe];
        [self.task setStandardInput: self.writePipe];
        
        self.task.standardOutput = [NSPipe pipe];
        [[self.task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
            NSData *data = [file availableData];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"mautrix-imessage sent output:%@", string); //writes to log file as well. neat!
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self->_outputString) {
                    self->_outputString = [NSString stringWithFormat:@"%@ \n", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn")]; //otherwise we're appending to nil
                }
                self.outputString = [[self outputString] stringByAppendingString:string];
                // i'd like to replace this way of outputting the log by reading directly from the file, but i only just learned about file handles, so let's be real here: if I did it now (4/16) it would only make things slower
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
                if (string) {
                    NSArray * commands = [string componentsSeparatedByString:@"\n"];
                    for (NSString * command in commands) {
                        if (![command isEqualToString:@""]) {
                            [self handleCommand:[NSJSONSerialization JSONObjectWithData:[command dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
                        }
                    }
                }
                else {
                    [self handleCommand:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
                }
                
            });
        }];
        self.task.standardError = [NSPipe pipe];
        [[self.task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *errfile) {
            NSData *errdata = [errfile availableData];
            NSString *errstring = [[NSString alloc] initWithData:errdata encoding:NSUTF8StringEncoding];
            NSLog(@"mautrix-imessage sent error:%@", errstring);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self->_outputString) {
                    self->_outputString = [NSString stringWithFormat:@"%@ \n", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn")];
                }
                //            [fh seekToEndOfFile];
                //            [fh writeData:errdata];
                self.outputString = [[self outputString] stringByAppendingString:errstring];
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
            });
        }];
        
        
    [self.task launch];
    return self;
}

-(void)handleTaskQuit:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:@"BLLaunchOnboarding" object:nil];
    //    [self.task.standardOutput fileHandleForReading].readabilityHandler = nil;
    //    [self.task.standardError fileHandleForReading].readabilityHandler = nil;
}

#pragma mark - Command Switch
-(void)handleCommand:(NSDictionary *)command {
    NSLog(@"Got command %@", command[@"command"]);
    if ([command[@"command"] isEqual:@"get_chat"]) {
        [self respondWithChatInfoForCommand:command];
    } else if ([command[@"command"] isEqual:@"get_contact"]) {
        [self getContactInfoForCommand:command];
    } else if ([command[@"command"] isEqual:@"send_message"]) {
        [self sendMessageCommand:command];
    } else if ([command[@"command"] isEqual:@"send_media"]) {
        [self sendAttachmentCommand:command];
    } else if ([command[@"command"] isEqual:@"set_typing"]) {
        [self setTypingCommand:command];
    } else if ([command[@"command"] isEqual:@"get_chats"]) {
        [self getChatListWithCommand:command];
    } else if ([command[@"command"] isEqual:@"get_recent_messages"]) {
        [self getMessagesForCommand:command];
    } else if ([command[@"command"] isEqual:@"send_read_receipt"]) {
        [self sendReadReceiptWithCommand:command];
    } else if ([command[@"command"] isEqual:@"config_url"]) {
        [self configURLCommand:command];
    } else if ([command[@"command"] isEqual:@"log"]) {
        NSLog(@"Log acknowledged");
    } else if ([command[@"command"] isEqual:@"response"]) {
        NSLog(@"Response acknowledged");
    } else if (command[@"command"]) {
        [self sendErrorCode:@"unknown_command" withDescription:[NSString stringWithFormat:@"Unknown command %@", command[@"command"]] forCommand:command];
    }
}

#pragma mark - Config URL
// lmao
-(void)configURLCommand:(NSDictionary *)command {
    [NSUserDefaults.standardUserDefaults setValue:command[@"data"][@"url"] forKey:@"configurl"];
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"redirect"];
    
}

#pragma mark - Notification Handlers
-(void)incomingMessage:(NSNotification *)notification {
    [self forwardMessage:notification.userInfo[@"__kIMChatValueKey"] fromChat:notification.object];
    NSLog(@"Forwarding incoming message to bridge");
}

-(void)analyzeNotification:(NSNotification *)notification {
    NSLog(@"Analyzed notification: %@ / %@ / %@", notification.name, notification.object, notification.userInfo);
}

-(void)handleExternal:(NSNotification *)notification {
    [self analyzeNotification:notification];
    IMMessage * thisMessage = notification.userInfo[@"__kIMChatValueKey"];
    NSLog(@"[handleExternal] IMMessage: %@", thisMessage);
    BOOL isDupe = false;
    
    if (thisMessage.isFromMe) {
        NSLog(@"[handleExternal] Deduplication: %@ and %@", thisMessage, self.mostRecentMessageGUID);
        if (self.mostRecentMessageGUID) {
            if ([thisMessage.guid isEqualToString: self.mostRecentMessageGUID]) {
                isDupe = true;
                NSLog(@"%hhd", isDupe);
            }
        }
        if (!isDupe) {
            NSLog(@"[handleExternal] Comparing GUIDs: %@ and %@", thisMessage.guid, self.sessionSentGUIDs);
            for (NSString * sentGUID in self.sessionSentGUIDs) {
                if ([thisMessage.guid isEqualToString:sentGUID]) {
                    isDupe = true;
                    NSLog(@"%hhd", isDupe);
                    NSLog(@"[handleExternal] Deduplication: MATCH between %@ and %@", thisMessage.guid, sentGUID);
                } else {
                    NSLog(@"[handleExternal] Deduplication: No match between %@ and %@", thisMessage.guid, sentGUID);
                }
            }
        }
    }
    if (![thisMessage isFromMe]) {
        isDupe = true;
        NSLog(@"[handleExternal] typing message: %hhd", thisMessage.isTypingMessage);
        NSLog(@"[handleExternal] retract typing indc: %hhd", thisMessage.isFinished);
        if (thisMessage.isTypingMessage) {
            [self forwardTypingIndicator:thisMessage fromChat:notification.object];
        }
    }
    if (thisMessage.isRead) {
        [self forwardReadReceipt:thisMessage fromChat:notification.object];
    }
    NSLog(@"[handleExternal] isDupe: %hhd", isDupe);
    if (isDupe == false) {
        [self forwardMessage:notification.userInfo[@"__kIMChatValueKey"] fromChat:notification.object];
    }
}

#pragma mark - Dictionary Handlers
-(void)sendDictionary:(NSDictionary *)dictionary {
    requestID += 1;
    [self sendDictionary:dictionary withID:[NSNumber numberWithInteger:requestID]];
}
-(void)sendDictionary:(NSDictionary *)dictionary withID:(NSNumber *)msgID {
    [dictionary setValue:msgID forKey: @"id"];
    //    if (msgID > [NSNumber numberWithInteger:requestID]) {
    //        requestID = (NSInteger)msgID;
    //    }
    NSData *dataForSending = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    //NSString *jsonString = [[NSString alloc] initWithData:dataForSending encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:dataForSending options:0 error:nil]);
    //NSLog(@"%@", jsonString);
    NSLog(@"Sending command (id: %@, contents: %@)", msgID, dictionary);
    [[self.task.standardInput fileHandleForWriting] writeData:dataForSending];
}

#pragma mark - Error Handler
-(void)sendErrorCode:(NSString *)code withDescription:(NSString *)description forCommand:(NSDictionary *)command {
    NSLog(@"Error: %@ (%@)",code,description);
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"error" forKey:@"command"];
    NSMutableDictionary * data = [NSMutableDictionary new];
    [data setValue:code forKey:@"code"];
    [data setValue:description forKey:@"message"];
    [request setValue:[NSDictionary dictionaryWithDictionary:data] forKey:@"data"];
    [self sendDictionary:request withID:command[@"id"]];
}

#pragma mark - Ping
-(void)sendPing {
    NSMutableDictionary *pingDictionary = [NSMutableDictionary new];
    [pingDictionary setValue:@"ping" forKey:@"command"];
    NSLog(@"Sending ping");
    [self sendDictionary:pingDictionary];
}

#pragma mark - Message Forward
-(void)forwardMessage:(IMMessage *)message fromChat:(IMChat *)chat {
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    
    [datadict setValue:[message guid] forKey:@"guid"];
    [datadict setValue:[message text].string forKey:@"text"];
    [datadict setValue:[chat guid] forKey:@"chat_guid"];
    [datadict setValue:[message messageSubject].string forKey:@"subject"];
    [datadict setValue:[NSNumber numberWithBool:[message isFromMe]] forKey:@"is_from_me"];
    [datadict setValue:[NSString stringWithFormat:@"%@;-;%@", [[message sender] accountTypeName], [[message sender] ID]] forKey:@"sender_guid"];
    if (message.fileTransferGUIDs) {
        NSMutableDictionary * attachmentDict = [NSMutableDictionary new];
        IMFileTransfer * ft = [[IMFileTransferCenter sharedInstance] transferForGUID:message.fileTransferGUIDs[0]];
        [attachmentDict setValue:ft.filename forKey:@"file_name"];
        [attachmentDict setValue:ft.mimeType forKey:@"mime_type"];
        [attachmentDict setValue:ft.localPath forKey:@"path_on_disk"];
        [datadict setObject:[NSDictionary dictionaryWithDictionary:attachmentDict] forKey:@"attachment"];
    }
    [datadict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"message" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSLog(@"Forwarding a message:%@ from chat:%@", message, chat);
    [self sendDictionary:request];
}

-(void)forwardTypingIndicator:(IMMessage *)typingIndicator fromChat:(IMChat *)chat {
    NSMutableDictionary * dataDictionary = [NSMutableDictionary new];
    [dataDictionary setValue:chat.guid forKey:@"chat_guid"];
    [dataDictionary setValue:[NSNumber numberWithBool:!(BOOL)typingIndicator.isFinished] forKey:@"typing"];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"typing" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:dataDictionary] forKey:@"data"];
    NSLog(@"Forwarding typing indicator:%@ from chat:%@", typingIndicator, chat);
    [self sendDictionary:request];
}

-(void)forwardReadReceipt:(IMMessage *)readReceipt fromChat:(IMChat *)chat {
    NSMutableDictionary * dataDictionary = [NSMutableDictionary new];
    [dataDictionary setValue:chat.guid forKey:@"chat_guid"];
    [dataDictionary setValue:chat.guid forKey:@"sender_guid"];
    // read receipts are "applied" to messages. i think.
    [dataDictionary setValue:[NSNumber numberWithBool:!(BOOL)readReceipt.isFromMe] forKey:@"is_from_me"];
    //[dataDictionary setValue:[NSString stringWithFormat:@"%@;-;%@", [[readReceipt sender] accountTypeName], [[readReceipt sender] ID]] forKey:@"sender_guid"];
    [dataDictionary setValue:readReceipt.guid forKey:@"read_up_to"];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"read_receipt" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:dataDictionary] forKey:@"data"];
    NSLog(@"Forwarding read receipt:%@ from chat:%@", readReceipt, chat);
    [self sendDictionary:request];
}

#pragma mark - Get Message GUIDs
-(void)getMessagesForCommand:(NSDictionary *)command {
    IMChat * chat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    [chat loadMessagesBeforeDate:[NSDate date] limit:100 loadImmediately:YES];
    NSMutableArray * messageArray = [NSMutableArray new];
    for (IMChatItem * chatItem in [chat chatItems]) {
        //if ([[chat lastMessage] time] > command[@"data"][@"min_timestamp"]) {
        if ([chatItem respondsToSelector:@selector(message)]) {
            NSMutableDictionary * messageDict = [NSMutableDictionary new];
            IMMessage * message = [(IMMessageChatItem *)chatItem message];
            [messageDict setValue:[message guid] forKey:@"guid"];
            [messageDict setValue:[message text].string forKey:@"text"];
            [messageDict setValue:[chat guid] forKey:@"chat_guid"];
            [messageDict setValue:[message messageSubject].string forKey:@"subject"];
            [messageDict setValue:[NSNumber numberWithBool:[message isFromMe]] forKey:@"is_from_me"];
            [messageDict setValue:[NSString stringWithFormat:@"%@;-;%@", [[message sender] accountTypeName], [[message sender] ID]] forKey:@"sender_guid"];
            [messageDict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
            
            // Attachments
            if (message.fileTransferGUIDs) {
                NSMutableDictionary * attachmentDict = [NSMutableDictionary new];
                IMFileTransfer * ft = [[IMFileTransferCenter sharedInstance] transferForGUID:message.fileTransferGUIDs[0]];
                [attachmentDict setValue:ft.filename forKey:@"file_name"];
                [attachmentDict setValue:ft.mimeType forKey:@"mime_type"];
                [attachmentDict setValue:ft.localPath forKey:@"path_on_disk"];
                [messageDict setObject:[NSDictionary dictionaryWithDictionary:attachmentDict] forKey:@"attachment"];
            }
            [messageArray addObject:[NSDictionary dictionaryWithDictionary:messageDict]];
        }
        
        //}
    }
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSArray arrayWithArray:messageArray] forKey:@"data"];
    NSLog(@"Got messages:%@", messageArray);
    [self sendDictionary:request withID:command[@"id"]];
}

#pragma mark - Send Message
-(void)sendMessageCommand:(NSDictionary *)command {
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
    CKComposition * composition = [[CKComposition alloc] initWithText:[[NSAttributedString alloc] initWithString:command[@"data"][@"text"]] subject:nil];
    IMMessage * message = [conversation messageWithComposition:composition];
    self.mostRecentMessageGUID = [message guid];
    [thisChat sendMessage:message];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [datadict setValue:[message guid] forKey:@"guid"];
    [self.sessionSentGUIDs addObject:[message guid]];
    // if we keep growing this array then comparisons for deduplication will take longer over time and we will have a memory leak, hence only keep a limited list of recent values
    if (self.sessionSentGUIDs.count > MESSAGE_BACKLOG_SIZE_FOR_DEDUPLICATION) {
        self.sessionSentGUIDs = [[self.sessionSentGUIDs subarrayWithRange:NSMakeRange(self.sessionSentGUIDs.count - MESSAGE_BACKLOG_SIZE_FOR_DEDUPLICATION, MESSAGE_BACKLOG_SIZE_FOR_DEDUPLICATION)] mutableCopy];
    }
    [datadict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSLog(@"Sent message:%@, telling bridge...",message);
    [self sendDictionary:request withID:command[@"id"]];
}

-(void)sendReadReceiptWithCommand:(NSDictionary *)command {
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
    [conversation markAllMessagesAsRead];
    [thisChat markAllMessagesAsRead];
    [self sendDictionary:request withID:command[@"id"]];
    NSLog(@"Read receipt for:%@",thisChat);
}

-(void)sendAttachmentCommand:(NSDictionary *)command {
    if ([[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES]) {
        NSLog(@"Launched successfully");
        NSDictionary * message = @{ @"path_on_disk" : [command[@"data"][@"path_on_disk"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]], @"file_name" : command[@"data"][@"file_name"], @"chat_guid" : command[@"data"][@"chat_guid"] };
        NSLog(@"Outgoing user info: %@", message);
        NSDictionary *reply;
        while (![self checkIfRunning:@"MobileSMS"]) {
            NSLog(@"sms isn't running!");
            [self checkIfRunning:@"MobileSMS"];
        }
        NSLog(@"sms is running!");
        
        CPDistributedMessagingCenter * messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.beeper.brooklyn"];
        NSLog(@"Ping!");
        //[messagingCenter sendMessageName:@"sendAttachment" userInfo:nil];
        while (![messagingCenter sendMessageAndReceiveReplyName:@"ping" userInfo:nil]) {
            NSLog(@"Pain");
            [messagingCenter sendMessageAndReceiveReplyName:@"ping" userInfo:nil];
            NSLog(@"Ping!");
        }
        NSLog(@"POG");
        //rocketbootstrap_distributedmessagingcenter_apply(messagingCenter);
        //[messagingCenter sendMessageName:@"sendAttachment" userInfo:[NSDictionary dictionaryWithDictionary:message]];
        if ((reply = [messagingCenter sendMessageAndReceiveReplyName:@"sendAttachment" userInfo:message])) {
            NSLog(@"Reply: %@", reply);
            [self.sessionSentGUIDs addObject:reply[@"sentGUID"]];
            NSLog(@"Sent message; telling bridge...");
            NSLog(@"Reply: %@", reply);
            NSLog(@"Command's ID: %@", command[@"id"]);
            [self sendDictionary:[NSMutableDictionary dictionaryWithDictionary:@{ @"command": @"response", @"data": @{ @"guid": reply[@"sentGUID"], @"timestamp": reply[@"request"][@"data"][@"timestamp"] } }] withID:command[@"id"]];
            
        }
    }
}
// source: https://github.com/iandwelker/libsmserver/blob/master/Tweak.xm
- (BOOL)checkIfRunning:(NSString *)bundle_id { /// Would return a _Bool but you can only send `id`s through MRYIPC funcs
                                               /// Just checks if a certain app with the bundle id `bundle_id` is running at all, background or foreground.
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"ps aux | grep %@ | grep -v grep", bundle_id]]];
    
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle* file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData* data = [file readDataToEndOfFile];
    NSString* out = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSNumber * temp = out.length > 0 ? @1 : @0;
    return [temp boolValue];
}

-(void)respondWithChatInfoForCommand:(NSDictionary *)command {
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    NSMutableArray * memberArray = [NSMutableArray new];
    for (IMHandle *h in [thisChat participants]) {
        [memberArray addObject:[h ID]];
    }
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
    if (conversation.hasDisplayName) {
        [datadict setValue:[conversation displayName] forKey:@"title"];
    } else {
        [datadict setValue:[conversation name] forKey:@"title"];
    }
    [datadict setObject:[NSArray arrayWithArray:memberArray] forKey:@"members"];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    //NSLog(@"member array: %@, dictionary: %@", memberArray, request);
    NSLog(@"Got chat info:%@, sending to bridge...", memberArray);
    [self sendDictionary:request withID:command[@"id"]];
}
-(void)getContactInfoForCommand:(NSDictionary *)command {
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    IMHandle * handle = [[[IMAccountController sharedInstance] bestAccountForService:[IMService iMessageService]] imHandleWithID:command[@"data"][@"user_guid"]];
    if ([handle person]) {
        [datadict setValue:[[handle person] firstName] forKey:@"first_name"];
        [datadict setValue:[[handle person] lastName] forKey:@"last_name"];
        [datadict setValue:[[handle person] nickname] forKey:@"nickname"];
        //[datadict setValue:[[[[CKEntity alloc] initWithIMHandle:handle] transcriptContactImage] encodeToBase64String] forKey:@"avatar"];
        //[datadict setValue:[[UIImage imageWithData:[[handle person] imageData]]encodeToBase64String] forKey:@"avatar"];
        //NSLog(@"%@", [[[[CKEntity alloc] initWithIMHandle:handle] transcriptContactImage] encodeToBase64String]);
        [datadict setValue:[[CKAddressBook contactImageOfDiameter:512 forRecordID:[handle person].recordID monogramStyle:1 tintMonogramText:NO] encodeToBase64String] forKey:@"avatar"];
        [datadict setValue:[[handle person] phoneNumbers] forKey:@"phones"];
        [datadict setValue:[[handle person] emails] forKey:@"emails"];
    } else {
        [datadict setValue:[handle firstName] forKey:@"first_name"];
        [datadict setValue:[handle lastName] forKey:@"last_name"];
        [datadict setValue:[handle nickname] forKey:@"nickname"];
        if (![handle emails]) {
            NSMutableArray * array = [NSMutableArray new];
            [array addObject:command[@"data"][@"user_guid"]];
            [datadict setValue:[NSArray arrayWithArray:array] forKey:@"phones"];
        } else {
            [datadict setValue:[handle emails] forKey:@"emails"];
        }
    }
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSLog(@"Got contact info:%@ sending to bridge...", datadict);
    [self sendDictionary:request withID:command[@"id"]];
}

-(void)getChatListWithCommand:(NSDictionary *)command {
    NSArray * chatArray = [[IMChatRegistry sharedInstance] _allCreatedChats];
    NSMutableArray * guidArray = [NSMutableArray new];
    for (IMChat * chat in chatArray) {
        if ([[[chat lastMessage] time] timeIntervalSince1970] >= [command[@"data"][@"min_timestamp"] doubleValue]) {
            NSLog(@"%d", [[[chat lastMessage] time] timeIntervalSince1970] >= [command[@"data"][@"min_timestamp"] doubleValue]);
            [guidArray addObject:chat.guid];
        }
    }
    //NSMutableDictionary * datadict = [NSMutableDictionary new];
    //[datadict setObject:[NSArray arrayWithArray:guidArray] forKey:@"chat_guids"];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSArray arrayWithArray:guidArray] forKey:@"data"];
    NSLog(@"Got chats list:%@, returning...", chatArray);
    [self sendDictionary:request withID:command[@"id"]];
}

#pragma mark - Typing
-(void)setTypingCommand:(NSDictionary *)command {
    NSMutableDictionary * request = [NSMutableDictionary new];
    [request setValue:@"response" forKey:@"command"];
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
//    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
//    [conversation setLocalUserIsTyping:[command[@"data"][@"typing"] boolValue]];
    [thisChat setLocalUserIsTyping:[command[@"data"][@"typing"] boolValue]];
    [self sendDictionary:request withID:command[@"id"]];
    NSLog(@"Typing indicator for:%@",thisChat);
}

-(void)clearLogs {
    HBOutputForShellCommand(@"rm /var/mobile/Documents/Beeper/*");
}

@end

