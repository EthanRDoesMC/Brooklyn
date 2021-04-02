//
//  UIImage+Base64.h
//  xchighlight
//
//  Created by EthanRDoesMC on 4/1/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// thank you, https://stackoverflow.com/questions/11251340/convert-between-uiimage-and-base64-string

@interface UIImage (Base64)
-(NSString *)encodeToBase64String;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
@end
