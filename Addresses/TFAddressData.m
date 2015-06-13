//
//  TFAddressData.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import "TFAddressData.h"
#import "TFBase58.h"

@implementation TFAddressData

- (id)init
{
    
    return self;
}

/**
 * Initiate the class with base58 address
 * @author Ashish Gogna
 *
 * @param base58Address
 * @return id
 */
- (id)initWithBase58Address: (NSString*)Base58Address;
{
    if (self)
    {
        NSMutableData *add_bin = BTCDataFromBase58Check(Base58Address);

        NSUInteger len = [add_bin length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [add_bin bytes], len);
        
        if (add_bin.length == 22)
        {
            self.AddressString = Base58Address;
            
            self.Address = add_bin;// new byte[20];
            
            // Array.Copy(add_data, 2, Address, 0, 20);
            
            self.NetworkType = (NetworkType)byteData[0];
            self.AccountType = (AccountType)byteData[1];
        }
        else
        {
            NSLog(@"Invalid Decoded Address Length");
        }
    }
    
    return self;
}

@end
