//
//  TFAddressFactory.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import <Foundation/Foundation.h>
#import "TFNA_Type.h"
#import "TFAddressData.h"
#import "TFAccountIdentifier.h"
#import "TFAccountInfo.h"
@class TFAccountInfo;
@class TFAccountIdentifier;

@interface TFAddressFactory : NSObject

@property (nonatomic) NetworkType _NetworkType;
@property (nonatomic) AccountType _AccountType;

- (TFAddressData*)DecodeAddressString:(NSString*)Base58Address;

- (BOOL)VerifyAddressWithAddress:(NSString*)Address PublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName networkType:(NetworkType)networkType accountType:(AccountType)accountType;

- (TFAccountIdentifier*)PublicKeyToAccountWithPublicKey:(NSMutableData*)PublicKey Name:(NSString*)Name;

- (TFAccountInfo*)CreateNewAccountWithName:(NSString*)Name networkType:(NetworkType)networkType;

- (TFAccountInfo*)CreateNewAccountWithOnlyName:(NSString*)Name;

//- (NSString *)hexadecimalString:(NSMutableData*)data;

- (BOOL)VerifyAddressWithAddress:(NSString*)Address PublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName;


@end
