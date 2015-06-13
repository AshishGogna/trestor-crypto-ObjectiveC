//
//  TFTransactionEntity.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/13/15.
//

#import <Foundation/Foundation.h>
#import "TFAddressData.h"
#import "TFAccountIdentifier.h"

@interface TFTransactionEntity : NSObject

@property (nonatomic) NSMutableData *publicKey;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) long _value;

- (id)initWithAccount:(TFAccountIdentifier*)account value:(long)value;

@end
