//
//  TFTransactionEntity.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/13/15.
//

#import "TFTransactionEntity.h"
#import "TFAccountIdentifier.h"

@implementation TFTransactionEntity

/**
 * Inititate the Class
 * @return id
 */
- (id)init
{
    self.publicKey = [[NSMutableData alloc] initWithLength:0];
    self._value = 0;
    self.name = @"";
    self.address = @"";

    return self;
}

/**
 * Inititate the Class
 * @param publicKey
 * @param name
 * @param address
 * @param value
 * @return id
 */
- (id)initWithPublicKey:(NSMutableData*)publicKey name:(NSString*)name address:(NSString*)address value:(long)value
{
    if (self)
    {
        self.publicKey = publicKey;
        self._value = value;
        self.name = name;
        self.address = address;
    }
    
    return self;
}

/**
 * Inititate the Class
 * @param publicKey
 * @param address
 * @param value
 * @return id
 */
- (id)initWithPublicKey:(NSMutableData*)publicKey address:(NSString*)address value:(long)value
{
    if (self)
    {
        self.publicKey = publicKey;
        self._value = value;
        self.name = @"";
        self.address = address;
    }
    
    return self;
}

/**
 * Inititate the Class
 * @param account
 * @param value
 * @return id
 */
- (id)initWithAccount:(TFAccountIdentifier*)account value:(long)value
{
    if (self)
    {
        self.publicKey = account.PublicKey;
        self._value = value;
        self.name = account.Name;
        self.address = account.AddressData.AddressString;
    }
    
    return self;
}

@end
