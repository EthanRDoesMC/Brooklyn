//
//  UIView+IB.m
//  xchighlight
//
//  Created by EthanRDoesMC on 4/24/21.
//

#import "UIView+IB.h"

@implementation UIView (IB)
@dynamic borderColor,borderWidth,cornerRadius;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
