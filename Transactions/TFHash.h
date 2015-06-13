//
//  TFHash.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/12/15.
//

#import <Foundation/Foundation.h>

@interface TFHash : NSObject

@property (nonatomic) NSMutableData *HashValue;

- (id)initHashWithValue:(NSMutableData*)Value;

- (NSMutableData*)Hex;

@end
