//
//  TFED25519Helper.m
//  Trestor
//
//  Created by Ashish Gogna on 3/25/15.
//  Copyright (c) 2015 Softalgo. All rights reserved.
//

#import "TFED25519Helper.h"
#import "TFAddressFactory.h"
#import "TFTransactionFactory.h"
#import "ed25519.h"

@implementation TFED25519Helper

int PublicKeySizeInBytes = 32;
int SignatureSizeInBytes = 64;
int ExpandedPrivateKeySizeInBytes = 32 * 2;
int PrivateKeySeedSizeInBytes = 32;
int SharedKeySizeInBytes = 32;

- (id)init
{
//    [self createTranscation];
    return self;
}

- (NSMutableData*)hexToNSData: (NSString*)hex
{
    NSString *source = [hex stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [source length]/2; i++) {
        byte_chars[0] = [source characterAtIndex:i*2];
        byte_chars[1] = [source characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

- (BOOL)verify: (NSMutableData*)signature message: (NSMutableData*)message publicKey: (NSMutableData*)publicKey
{
    if (signature == nil)
        NSLog(@"signature");

    if (message == nil)
        NSLog(@"message");

    if (publicKey == nil)
        NSLog(@"public key");

    if (signature.length != SignatureSizeInBytes)
        NSLog(@"signature size must be 64");

    if (publicKey.length != PublicKeySizeInBytes)
        NSLog(@"public key size must be 32");

    return ed25519_verify([signature mutableBytes], [message mutableBytes], message.length, [publicKey mutableBytes]);
}

- (void)sign: (NSMutableData*)signature message: (NSMutableData*)message expandedPrivateKey: (NSMutableData*)expandedPrivatekey publicKey: (NSMutableData*)publicKey
{
    if (signature == nil)
        NSLog(@"signature.Array");
    
    if (message == nil)
        NSLog(@"message.Array");
    
    if (expandedPrivatekey == nil)
        NSLog(@"public key.Array");
    
    if (signature.length != SignatureSizeInBytes)
        NSLog(@"signature.count");

    if (expandedPrivatekey.length != ExpandedPrivateKeySizeInBytes)
        NSLog(@"expandedPrivateKey.count");

    ed25519_sign([signature mutableBytes], [message mutableBytes], message.length, [publicKey mutableBytes], [expandedPrivatekey mutableBytes]);
}

- (NSMutableData*)signMessage: (NSMutableData*)message expandedPrivateKey: (NSMutableData*)expandedPrivateKey publicKey: (NSMutableData*)publicKey
{
    NSMutableData *signature = [[NSMutableData alloc] initWithLength:SignatureSizeInBytes];
    [self sign:signature message:message expandedPrivateKey:expandedPrivateKey publicKey:publicKey];
    
    return signature;
}

- (NSMutableData*)publicKeyFromSeed: (NSMutableData*)privateKeySeed
{
    NSMutableData *privateKey = [[NSMutableData alloc] initWithLength:64];
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:32];
    
    [self keyPairFromSeed:publicKey expandedPrivateKey:privateKey privateKeySeed:privateKeySeed];

    return publicKey;
}

- (NSMutableData*)expandedPrivateKeyFromSeed: (NSMutableData*)privateKeySeed
{
    NSMutableData *privateKey = [[NSMutableData alloc] initWithLength:64];
    NSMutableData *publicKey = [[NSMutableData alloc] initWithLength:32];
    
    [self keyPairFromSeed:publicKey expandedPrivateKey:privateKey privateKeySeed:privateKeySeed];

    return privateKey;
}

- (void)keyPairFromSeed: (NSMutableData*)publicKey expandedPrivateKey: (NSMutableData*)expandedPrivateKey privateKeySeed: (NSMutableData*)privatekeySeed
{
    ed25519_create_keypair([publicKey mutableBytes], [expandedPrivateKey mutableBytes], [privatekeySeed mutableBytes]);
}


@end
