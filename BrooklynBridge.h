//
//  BrooklynBridge.h
//  brooklyn
//
//  Created by EthanRDoesMC on 12/27/20.
//

#import <Foundation/Foundation.h>
#import "IMCore.h"
#import "ChatKit.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (brooklyn)
//an old secret of mine
-(void)_setBackgroundStyle:(long long)arg1;
@end

@interface BrooklynBridge : NSObject
@property (nonatomic, assign) CKConversationList * conversationList;

+(id)sharedBridge;
+ (BOOL)riseAndShineIMDaemon;
+(NSArray *)conversationArray;
-(void)playLoadingChime;
-(void)stopLoadingChime;
@end

NS_ASSUME_NONNULL_END
