//
//  BLMautrixTask.h
//  xchighlight
//
//  Created by EthanRDoesMC on 3/20/21.
//

#import <Foundation/Foundation.h>
#import "NSTask.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMautrixTask : NSObject
@property (strong, nonatomic) NSTask * task;
@property (strong, nonatomic) NSString * outputString;
@property (strong, nonatomic) NSPipe * writePipe;
+(id)sharedTask;
-(id)initAndLaunch;
-(void)sendPing;
-(void)sendDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
