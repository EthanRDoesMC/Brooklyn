//
//  UIView+IB.h
//  xchighlight
//
//  Created by EthanRDoesMC on 4/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface UIView (IB)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end

NS_ASSUME_NONNULL_END
