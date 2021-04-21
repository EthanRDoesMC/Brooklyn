#import <Foundation/Foundation.h>
#import "IMCore.h"
#import "ChatKit.h"
#import "CPDistributedMessagingCenter.h"
#import <rocketbootstrap/rocketbootstrap.h>

@interface BLSMSHelper : NSObject
+(id)sharedInstance;
-(id)init;
-(NSDictionary *)ping;
-(NSDictionary *)handleCommand:(NSString *)command withDictionary:(NSDictionary *)dictionary;
@property (strong,nonatomic) CPDistributedMessagingCenter * messagingCenter;
@end

@implementation BLSMSHelper

+ (instancetype)sharedInstance {
    static BLSMSHelper *_sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[BLSMSHelper alloc] init];
    });
    
    return _sharedHelper;
}

-(id)init {
    NSLog(@"init blsmshelper");
    self.messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.beeper.brooklyn"];
    rocketbootstrap_distributedmessagingcenter_apply(self.messagingCenter);
    [self.messagingCenter runServerOnCurrentThread];
    [self.messagingCenter registerForMessageName:@"sendAttachment" target:self selector:@selector(handleCommand:withDictionary:)];
    [self.messagingCenter registerForMessageName:@"ping" target:self selector:@selector(ping)];
    return [super init];
}

-(NSDictionary *)ping {
    NSLog(@"Pong!");
    return @{ @"ping" : @YES };
}

-(NSDictionary *)handleCommand:(NSString *)command withDictionary:(NSDictionary *)dictionary {
    NSLog(@"command: %@, dictionary: %@", command, dictionary);
    CKConversation * conversation = [CKConversationList.sharedConversationList conversationForExistingChatWithGUID:dictionary[@"chat_guid"]];
    CKMediaObject * mediaObject = [CKMediaObjectManager.sharedInstance mediaObjectWithFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///private/var%@", dictionary[@"path_on_disk"]]] filename:dictionary[@"file_name"] transcoderUserInfo:@{}];
    CKComposition* composition = [CKComposition compositionWithMediaObject:mediaObject subject:nil];
    IMMessage * message = [conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];
    
    NSMutableDictionary * datadict = [NSMutableDictionary new];
    NSMutableDictionary * request = [NSMutableDictionary new];
    [datadict setValue:[message guid] forKey:@"guid"];
    NSLog(@"sent message guid %@", [message guid]);
    [datadict setValue:[NSNumber numberWithDouble:[[message time] timeIntervalSince1970]] forKey:@"timestamp"];
    [request setValue:@"response" forKey:@"command"];
    [request setObject:[NSDictionary dictionaryWithDictionary:datadict] forKey:@"data"];
    NSDictionary * reply = @{ @"request" : [NSDictionary dictionaryWithDictionary:request], @"sentGUID" : [message guid] };
    NSLog(@"Reply from SMS: %@", reply);
    return reply;
}
@end

@interface SMSApplication
@property (nonatomic,strong) BLSMSHelper * helper;
@end

%hook SMSApplication
%property (nonatomic, strong) BLSMSHelper * helper;
-(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    self.helper = [BLSMSHelper sharedInstance];
    return %orig;
}
%end


