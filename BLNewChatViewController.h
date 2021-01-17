//
//  BLNewChatViewController.h
//  brooklyn
//
//  Created by EthanRDoesMC on 12/31/20.
//

#import <UIKit/UIKit.h>
#import "BrooklynBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (brooklyn)
//an old secret of mine
-(void)_setBackgroundStyle:(long long)arg1;
@end

@interface BLNewChatViewController : UIViewController <UITextFieldDelegate>
-(void)doAThing:(NSString *)tf;
@end

NS_ASSUME_NONNULL_END
