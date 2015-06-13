//
//  TFAccountIdentifier.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import "TFAccountIdentifier.h"

@implementation TFAccountIdentifier

- (id)init
{
    return self;
}

/**
 * Initiate the class with publik key, name, address
 * @author Ashish Gogna
 *
 * @param publicKey
 * @param name
 * @param addressDataString
 * @return id
 */
- (id)initWithPublicKey:(NSMutableData*)publicKey name:(NSString*)name addressDataString:(NSString*)addressDataString
{
    if (self)
    {
        self.PublicKey = publicKey;
        self.Name = name;
        
        TFAddressFactory *af = [[TFAddressFactory alloc] init];
        
        self.AddressData = [af DecodeAddressString:addressDataString];
        
        /*
        if ([af VerifyAddressWithAddress:addressDataString PublicKey:publicKey UserName:name networkType:self.AddressData.NetworkType accountType:self.AddressData.AccountType] == false)
        {
            NSLog(@"AccountIdentifier: Invalid Address Arguments");
        }
        */
    }
    
    return self;
}

@end
