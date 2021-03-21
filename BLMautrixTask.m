//
//  BLMautrixTask.m
//  xchighlight
//
//  Created by EthanRDoesMC on 3/20/21.
//

#import "BLMautrixTask.h"

@implementation BLMautrixTask
+ (instancetype)sharedTask {
    static BLMautrixTask *_sharedTask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTask = [[BLMautrixTask alloc] initAndLaunch];
    });
    
    return _sharedTask;
}
-(id)initAndLaunch {
    self = [super init];
    self.task = [NSTask new];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:@"-r/var/mobile/Documents/mautrix-imessage-armv7/registration.yaml"];
    self.task.launchPath = @"/var/mobile/Documents/mautrix-imessage-armv7/mautrix-imessage";
    self.task.arguments  = arguments;
    self.task.currentDirectoryPath = @"/var/mobile/Documents/mautrix-imessage-armv7/";
    NSMutableDictionary *defaultEnv = [[NSMutableDictionary alloc] initWithDictionary:[[NSProcessInfo processInfo] environment]];
    [defaultEnv setObject:@"YES" forKey:@"NSUnbufferedIO"];
    //            [defaultEnv setObject:@"/Users/ethanrdoesmc/" forKey:@"HOME"];
    
    self.task.environment = defaultEnv;
    
    //NSPipe *writePipe = [NSPipe pipe];
    //NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
    self.writePipe = [NSPipe pipe];
    [self.task setStandardInput: self.writePipe];
    
    self.task.standardOutput = [NSPipe pipe];
    [[self.task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData]; // this will read to EOF, so call only once
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Task output! %@", string);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->_outputString) {
                self->_outputString = @"Begin log \n";
            }
        self.outputString = [[self outputString] stringByAppendingString:string];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->_logField.text = [self->_logField.text stringByAppendingString: string];
//            [self->_logField scrollRangeToVisible: NSMakeRange(self->_logField.text.length, 0)];
//        });
    }];
    self.task.standardError = [NSPipe pipe];
    [[self.task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *errfile) {
        NSData *errdata = [errfile availableData]; // this will read to EOF, so call only once
        NSString *errstring = [[NSString alloc] initWithData:errdata encoding:NSUTF8StringEncoding];
        NSLog(@"Task output! %@", errstring);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->_outputString) {
                self->_outputString = @"Begin log \n";
            }
        self.outputString = [[self outputString] stringByAppendingString:errstring];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BLMautrixLogUpdated" object:nil];
        });
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self->_logField.text = [self->_logField.text stringByAppendingString: errstring];
//            [self->_logField scrollRangeToVisible: NSMakeRange(self->_logField.text.length, 0)];
//        });
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

-(void)sendDictionary:(NSDictionary *)dictionary {
    NSData *dataForSending = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:dataForSending encoding:NSUTF8StringEncoding];
    //jsonString = [jsonString stringByAppendingString:@""];
    NSLog(@"%@", jsonString);
//    [[self.task.standardInput fileHandleForWriting] setWriteabilityHandler:^(NSFileHandle *wfile) {
//        [wfile writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"%@", wfile);
//    }];
    [[self.task.standardInput fileHandleForWriting] writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)sendPing {
    NSMutableDictionary *pingDictionary = [NSMutableDictionary new];
    [pingDictionary setValue:@"ping" forKey:@"command"];
    [pingDictionary setValue:@"27" forKey:@"id"];
    [self sendDictionary:pingDictionary];
}
@end
