//
//  TFAccountInfo.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import <Foundation/Foundation.h>
#import "TFAccountIdentifier.h"
@class TFAccountIdentifier;

@interface TFAccountInfo : NSObject

@property (nonatomic) TFAccountIdentifier *account;
@property (nonatomic) NSMutableData *secretSeed;

@end
