//
//  BLNewChatViewController.h
//  brooklyn
//
//  Created by EthanRDoesMC on 12/31/20.
//

#import <UIKit/UIKit.h>
#import "BrooklynBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLNewChatViewController : UIViewController <UITextFieldDelegate>
-(void)doAThing:(NSString *)tf;
@end

NS_ASSUME_NONNULL_END
