//
//  NativeClass.m
//  IOSRecoder-mobile
//
//  Created by Abhishek Rawat on 08/02/23.
//

#import <Foundation/Foundation.h>
@interface NativeClass : NSObject
+(BOOL)callNativeUIWithTitle:(NSString *)title andContent:(NSString *)content;
+(BOOL)callNativeUIWithTitle:(NSString *) title andContent:(NSString *)content{
    printf("Native class function call");
  return true;
}

@end
