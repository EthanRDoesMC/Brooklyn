//
//  BrooklynBridge.h
//  brooklyn
//
//  Created by EthanRDoesMC on 12/27/20.
//

#import <Foundation/Foundation.h>
#import "IMCore.h"
#import "ChatKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (brooklyn)
//an old secret of mine
-(void)_setBackgroundStyle:(long long)arg1;
@end

@interface BrooklynBridge : NSObject
+(id)sharedBridge;
+ (BOOL)riseAndShineIMDaemon;
+(NSArray *)conversationArray;
@end

NS_ASSUME_NONNULL_END
