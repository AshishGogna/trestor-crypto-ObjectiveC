//
//  TFED25519Helper.h
//  Trestor
//
//  Created by Ashish Gogna on 3/25/15.
//  Copyright (c) 2015 Softalgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFED25519Helper : NSObject

- (NSMutableData*)expandedPrivateKeyFromSeed: (NSMutableData*)privateKeySeed;
- (NSMutableData*)publicKeyFromSeed: (NSMutableData*)privateKeySeed;
- (NSMutableData*)signMessage: (NSMutableData*)message expandedPrivateKey: (NSMutableData*)expandedPrivateKey publicKey: (NSMutableData*)publicKey;

@end
