//
//  TFAddressData.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import <Foundation/Foundation.h>
#import "TFNA_Type.h"

@interface TFAddressData : NSObject

@property (nonatomic) NSMutableData *Address;
@property (nonatomic) NSString* AddressString;
@property (nonatomic) NetworkType NetworkType;
@property (nonatomic) AccountType AccountType;

/**
 * Initiate the class with base58 address
 * @author Ashish Gogna
 *
 * @param base58Address
 * @return id
 */
- (id)initWithBase58Address: (NSString*)Base58Address;

@end
