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
    // Register notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessage:) name:@"__kIMChatMessageReceivedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyzeNotification:) name:@"__kIMChatItemsInserted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExternal:) name:@"__kIMChatMessageDidChangeNotification" object:nil];
    self.sessionSentGUIDs = [NSMutableArray new];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessage:) name:@"__kIMChatMessageDidChangeNotification" object:nil];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Beeper/%@.txt", [NSDate date]]];
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
        NSLog(@"mautrix-imessage sent output:%@", string);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->_outputString) {
                self->_outputString = [NSString stringWithFormat:@"%@ \n", HBOutputForShellCommand(@"dpkg-query --showformat='${Version}\n' --show com.beeper.brooklyn")]; //otherwise we're appending to nil
            }
            [fh seekToEndOfFile];
            [fh writeData:data];
            self.outputString = [[self outputString] stringByAppendingString:string];
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
            [self handleCommand:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
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
            [fh seekToEndOfFile];
            [fh writeData:errdata];
            self.outputString = [[self outputString] stringByAppendingString:errstring];
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
        });
    }];
    
    [self.task launch];
    return self;
}
//-(NSString *)outputString {
//    if (!self.outputString) {
//        _outputString = [NSString string];
//    }
//    return self.outputString;
//}

-(void)incomingMessage:(NSNotification *)notification {
    [self forwardMessage:notification.userInfo[@"__kIMChatValueKey"] fromChat:notification.object];
    NSLog(@"Forwarding incoming message to bridge");
}

-(void)analyzeNotification:(NSNotification *)notification {
    NSLog(@"%@ / %@ / %@", notification.name, notification.object, notification.userInfo);
}

-(void)handleExternal:(NSNotification *)notification {
    [self analyzeNotification:notification];
    IMMessage * thisMessage = notification.userInfo[@"__kIMChatValueKey"];
    NSLog(@"%@", thisMessage);
    BOOL isDupe = false;
    
    if (thisMessage.isFromMe) {
        if (self.mostRecentMessage) {
            if (thisMessage == self.mostRecentMessage) {
                isDupe = true;
                NSLog(@"%hhd", isDupe);
            }
        }
        for (NSString * sentGUID in self.sessionSentGUIDs) {
            if ([thisMessage.guid isEqualToString:sentGUID]) {
                isDupe = true;
                NSLog(@"%hhd", isDupe);
            }
        }
    }
    if (![thisMessage isFromMe]) {
        isDupe = true;
        NSLog(@"typing message: %hhd", thisMessage.isTypingMessage);
        NSLog(@"retract typing indc: %hhd", thisMessage.isFinished);
    }
    NSLog(@"%hhd", isDupe);
    if (isDupe == false) {
        [self forwardMessage:notification.userInfo[@"__kIMChatValueKey"] fromChat:notification.object];
    }
}

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
    NSLog(@"Writing data");
    [[self.task.standardInput fileHandleForWriting] writeData:dataForSending];
}


-(void)sendPing {
    NSMutableDictionary *pingDictionary = [NSMutableDictionary new];
    [pingDictionary setValue:@"ping" forKey:@"command"];
    NSLog(@"Sending ping");
    [self sendDictionary:pingDictionary];
}

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
    NSLog(@"Forwarding a message");
    [self sendDictionary:request];
}

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
    } else if ([command[@"command"] isEqual:@"get_chats"]) {
        [self getChatListWithCommand:command];
    } else if ([command[@"command"] isEqual:@"get_recent_messages"]) {
        [self getMessagesForCommand:command];
    } else if ([command[@"command"] isEqual:@"send_read_receipt"]) {
        [self sendReadReceiptWithCommand:command];
    }
}

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
    NSLog(@"Got messages; returning...");
    [self sendDictionary:request withID:command[@"id"]];
}

-(void)sendMessageCommand:(NSDictionary *)command {
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
    CKComposition * composition = [[CKComposition alloc] initWithText:[[NSAttributedString alloc] initWithString:command[@"data"][@"text"]] subject:nil];
    IMMessage * message = [conversation messageWithComposition:composition];
    self.mostRecentMessage = message;
    [thisChat sendMessage:message];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [datadict setValue:[message guid] forKey:@"guid"];
    [self.sessionSentGUIDs addObject:[message guid]];
    [datadict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSLog(@"Sent message; telling bridge...");
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
}

-(void)sendAttachmentCommand:(NSDictionary *)command {
    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    IMChat * thisChat = [[IMChatRegistry sharedInstance] existingChatWithGUID:command[@"data"][@"chat_guid"]];
    CKConversation * conversation = [[CKConversation alloc] initWithChat:thisChat];
    
    //CKMediaObject* object = [[CKMediaObjectManager sharedInstance] mediaObjectWithFileURL:fileUrl filename:nil transcoderUserInfo:nil attributionInfo:@{} hideAttachment:NO];
    
        //CKMediaObject * attachment = [[CKMediaObjectManager sharedInstance] mediaObjectWithFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///private/var%@",command[@"data"][@"path_on_disk"]]] filename:command[@"data"][@"file_name"] transcoderUserInfo:nil];
        // thank you https://gist.github.com/ddeville/1527517
        NSData * fileData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"/private/var%@",command[@"data"][@"path_on_disk"]]];
        CFStringRef MIMEType = (__bridge CFStringRef)command[@"data"][@"mime_type"];
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, MIMEType, NULL);
        NSString *UTIString = (__bridge_transfer NSString *)UTI;
        CKMediaObject * attachment = [[CKMediaObjectManager sharedInstance] mediaObjectWithData:fileData UTIType:UTIString filename:command[@"data"][@"file_name"] transcoderUserInfo:nil];
        NSLog(@"%@", attachment);
        [[IMFileTransferCenter sharedInstance] acceptTransfer:attachment.transfer];
//        NSAttributedString* text = [[NSAttributedString alloc] initWithString:@"Hello friend"];
        CKComposition* composition = [[CKComposition alloc] initWithText:nil subject:nil];
    composition = [composition compositionByAppendingMediaObject:attachment];
        NSLog(@"%@", composition);
        CKTranscriptController * tc = [CKTranscriptController new];
        [tc setConversation:conversation];
        [tc sendComposition:composition];
    //IMMessage * message = [conversation messageWithComposition:composition];
//        IMMessage * message = [IMMessage instantMessageWithText:nil messageSubject:nil fileTransferGUIDs:@[[attachment transferGUID]] flags:1093637];
       // NSLog(@"%@", message);
   // self.mostRecentMessage = message;
    //[thisChat sendMessage:message];
        //[conversation sendMessage:message newComposition:YES];
        IMMessage * message = [conversation.chat lastMessage];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [datadict setValue:[message guid] forKey:@"guid"];
    [self.sessionSentGUIDs addObject:[message guid]];
    [datadict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSLog(@"Sent message; telling bridge...");
    [self sendDictionary:request withID:command[@"id"]];
    });
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
    NSLog(@"Got chat info, sending to bridge...");
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
    //NSLog(@"member array: %@, dictionary: %@", memberArray, request);
    NSLog(@"Got contact info, sending to bridge...");
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
    NSLog(@"Got chat list, returning...");
    [self sendDictionary:request withID:command[@"id"]];
}
@end

