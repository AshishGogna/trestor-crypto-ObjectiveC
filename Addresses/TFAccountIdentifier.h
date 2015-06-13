//
//  TFAccountIdentifier.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import <Foundation/Foundation.h>
#import "TFAddressData.h"
#import "TFAddressFactory.h"

@interface TFAccountIdentifier : NSObject

@property (nonatomic) NSMutableData *PublicKey;
@property (nonatomic) NSString *Name;
@property (nonatomic) TFAddressData *AddressData;

/**
 * Initiate the class with publik key, name, address
 * @author Ashish Gogna
 *
 * @param publicKey
 * @param name
 * @param addressDataString
 * @return id
 */
- (id)initWithPublicKey:(NSMutableData*)publicKey name:(NSString*)name addressDataString:(NSString*)addressDataString;

@end
