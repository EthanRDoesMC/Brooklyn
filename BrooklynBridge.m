//
//  BrooklynBridge.m
//  brooklyn
//
//  Created by EthanRDoesMC on 12/27/20.
//

#import "BrooklynBridge.h"

@implementation BrooklynBridge

+ (instancetype)sharedBridge {
    static BrooklynBridge *_sharedBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBridge = [BrooklynBridge new];
    });
    
    return _sharedBridge;
}

+ (BOOL)riseAndShineIMDaemon {
    IMDaemonController* controller = [NSClassFromString(@"IMDaemonController") sharedController];
    return [controller connectToDaemon];
}

+(NSArray *)conversationArray {
    [BrooklynBridge riseAndShineIMDaemon];
    NSMutableArray *returnArray = [NSMutableArray new];
    for (IMChat * c in [[IMChatRegistry sharedInstance] allExistingChats]) {
        [returnArray addObject:[[CKConversation alloc] initWithChat:c]];
    }
    // NOT GOOD. CREATES A BUNCH'A OBJECTS.
    return returnArray;
}
// soon
//-(id)sendMessage:(IMMessage *)message toChat:(IMChat *)chat
@end


