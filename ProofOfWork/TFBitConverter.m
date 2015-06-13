//
//  TFBitConverter.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/18/15.
//

#import "TFBitConverter.h"

@implementation TFBitConverter

- (NSMutableData*)getBytes: (int)x
{
    Byte x0 = x;
    Byte x1 = x >> 8;
    Byte x2 = x >> 16;
    Byte x3 = x >> 24;

    NSMutableData *d = [[NSMutableData alloc] init];
    [d appendBytes:&x3 length:1];
    [d appendBytes:&x2 length:1];
    [d appendBytes:&x1 length:1];
    [d appendBytes:&x0 length:1];
    
//    NSMutableData *d = [[NSMutableData alloc] init];
//   [d appendBytes:&x0 length:1];
//    [d appendBytes:&x1 length:1];
//    [d appendBytes:&x2 length:1];
//    [d appendBytes:&x3 length:1];
    
    return d;
}

@end