//
//  TFPasswordAES.m
//  Trestor
//
//  Created by Ashish Gogna on 4/16/15.
//

#import "TFPasswordAES.h"
#import <openssl/aes.h>
#import <openssl/crypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>
#import "NSData+CommonCrypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonSymmetricKeywrap.h>

@implementation TFPasswordAES

- (NSMutableArray*)EncryptMessage: (NSString*)privateKeyString withPassword: (NSString*)password
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    NSData *privateKey = [self hexToNSData:privateKeyString];
    
    //Random salt
    uint8_t data[16];
    int err = 0;
    err = SecRandomCopyBytes(kSecRandomDefault, 16, data);
    if(err != noErr)
        @throw [NSException exceptionWithName:@"..." reason:@"..." userInfo:nil];
    NSData* randomData = [[NSData alloc] initWithBytes:data length:16];
    NSData *salt = randomData;

    /*Random iv
    uint8_t data1[16];
    int err1 = 0;
    err1 = SecRandomCopyBytes(kSecRandomDefault, 16, data1);
    if(err1 != noErr)
        @throw [NSException exceptionWithName:@"..." reason:@"..." userInfo:nil];
    NSData* randomData1 = [[NSData alloc] initWithBytes:data1 length:16];
    NSData *iv = randomData1;
    self.iv = iv;
    */
    
    NSData *iv = [[NSMutableData alloc] initWithLength:16];
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    CCCryptorStatus status = kCCSuccess;
    NSData *cipher = [privateKey dataEncryptedUsingAlgorithm:kCCAlgorithmAES key:key initializationVector:iv options:kCCOptionPKCS7Padding error:&status];
    
    [output addObject:[self hexadecimalString:[cipher mutableCopy]]];
    [output addObject:[self hexadecimalString:[salt mutableCopy]]];
    
    NSMutableData *all = [[NSMutableData alloc] init];
    [all appendData:[password dataUsingEncoding:NSASCIIStringEncoding]];
    [all appendData:salt];
    [all appendData:privateKey];
    NSData *hash = [self SHA1Hash:[all mutableCopy]];
    
    [output addObject:[self hexadecimalString:[hash mutableCopy]]];

    return output;
}


- (NSString*)DecryptMessage: (NSMutableArray*)input withPassword: (NSString*)password
{
    if(input.count != 3)
        NSLog(@"Bad arguments");
    NSData *cipherText = [self hexToNSData:input[0]];
    NSData *salt = [self hexToNSData:input[1]];
    NSData *hash = [self hexToNSData:input[2]];
    
    NSData *iv = [[NSMutableData alloc] initWithLength:16];

    NSData *key = [self AESKeyForPassword:password salt:salt];

    CCCryptorStatus status = kCCSuccess;
    NSData *dec = [cipherText decryptedDataUsingAlgorithm:kCCAlgorithmAES key:key initializationVector:iv  options:kCCOptionPKCS7Padding error:&status];

    NSMutableData *all = [[NSMutableData alloc] init];
    [all appendData:[password dataUsingEncoding:NSASCIIStringEncoding]];
    [all appendData:salt];
    [all appendData:dec];
    NSData *hashToCheck = [self SHA1Hash:[all mutableCopy]];

    if (![hash isEqualToData:hashToCheck])
    {
        NSLog(@"Hashes don't match");
        return nil;
    }
    
    return [self hexadecimalString:[dec mutableCopy]];
}


- (NSMutableData *) SHA1Hash: (NSMutableData*)data {
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [data bytes], (CC_LONG)[data length], hash );
    return ( [NSMutableData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}

- (NSString *)hexadecimalString:(NSMutableData*)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
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

/**
 * TODO
 * @author Ashish Gogna
 *
 * @param 
 * @param
 * @return 
 */
- (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:256];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  4096,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

@end
