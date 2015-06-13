//
//  TFBase58.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import <Foundation/Foundation.h>

@interface TFBase58 : NSObject

NSMutableData* BTCDataFromBase58(NSString* string);
NSMutableData* BTCDataFromBase58Check(NSString* string);
NSMutableData* BTCDataFromBase58CString(const char* cstring);
NSMutableData* BTCDataFromBase58CheckCString(const char* cstring);
char* BTCBase58CStringWithData(NSData* data);
char* BTCBase58CheckCStringWithData(NSData* immutabledata);
NSString* BTCBase58StringWithData(NSData* data);
NSString* BTCBase58CheckStringWithData(NSData* data);

@end
