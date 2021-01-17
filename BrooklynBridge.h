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

@interface BrooklynBridge : NSObject
@property (nonatomic, retain) NSArray * conversations;
+(id)sharedBridge;
+ (BOOL)riseAndShineIMDaemon;
-(NSArray *)conversations;
@end

NS_ASSUME_NONNULL_END
