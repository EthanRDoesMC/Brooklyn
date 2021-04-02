//
//  UIImage+Base64.m
//  xchighlight
//
//  Created by EthanRDoesMC on 4/1/21.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)
-(NSString *)encodeToBase64String {
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}
@end
