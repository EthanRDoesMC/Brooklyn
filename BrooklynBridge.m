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

-(NSArray *)conversations {
    if (!self.conversations) {
    [BrooklynBridge riseAndShineIMDaemon];
    self.conversations = [NSMutableArray new];
    }
    for (IMChat * c in [[IMChatRegistry sharedInstance] allExistingChats]) {
        //if ([[self.conversations containsObject:])
        // finish writing this
        [self.conversations addObject:[[CKConversation alloc] initWithChat:c]];
    }
    return returnArray;
}
@end


