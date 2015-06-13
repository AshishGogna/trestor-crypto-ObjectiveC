//
//  TFAddressFactory.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 1/30/15.
//

#import "TFAddressFactory.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "TFBase58.h"
#import "TFAccountInfo.h"
#import "ed25519.h"

@implementation TFAddressFactory

/**
 * Initiate the class
 * @author Ashish Gogna
 *
 * @return id
 */
- (id)init
{
    self._NetworkType = (NetworkType)MainNet;
    self._AccountType = (AccountType)MainNormal;
    
    //    Below is just test code (Android)
    //    public static void main(String[] args) throws Exception {
    //        AccountIdentifier sss = AddressFactory.PublicKeyToAccount(AddressFactory.hexStringToByteArray("99173BC8DAC05F6F9636F0D7E4F4C636D93BD690C1F23F1520BA4ECC5168D121"), "GENESIS_TEST_6248");
    //        System.out.println("Name - " + sss.getName());
    //        System.out.println("Address - " + sss.getAddressData().getAddressString());
    //        System.out.println("Public Key - " + AddressFactory.bytesToHex(sss.getPublicKey()));
    //
    //
    //        AccountInfo asd = AddressFactory.CreateNewAccount("SHILA");
    //        System.out.println("Account info for SHILA");
    //        System.out.println("address -" + asd.getAccount().getAddressData().getAddressString());
    //        System.out.println("public -" + AddressFactory.bytesToHex(asd.getAccount().getPublicKey()));

    return self;
}

/**
 * Initiate the class with network type and account type
 * @author Ashish Gogna
 *
 * @param networkType
 * @param accountType
 * @return id
 */
- (id)initWithNetworkType:(NetworkType)networkType accountType:(AccountType)accountType
{
    if (self)
    {
        self._NetworkType = networkType;
        self._AccountType = accountType;
    }
    
    return self;
}

/**
 * Create account
 * @author Ashish Gogna
 *
 * @param name
 * @return TFAccountInfo
 */
- (TFAccountInfo*)CreateNewAccountWithOnlyName:(NSString*)Name
{
    return [self CreateNewAccountWithName:Name networkType:self._NetworkType];
}

/**
 * Create account
 * @author Ashish Gogna
 *
 * @param name
 * @param networkType
 * @return TFAccountInfo
 */
- (TFAccountInfo*)CreateNewAccountWithName:(NSString*)Name networkType:(NetworkType)networkType
{
    //Random privateSecretSeed
    NSMutableData *PrivateSecrerSeed = [[NSMutableData alloc] initWithCapacity:32];
    uint8_t data[32];
    int err = 0;
    err = SecRandomCopyBytes(kSecRandomDefault, 32, data);
    if(err != noErr)
        @throw [NSException exceptionWithName:@"..." reason:@"..." userInfo:nil];
    NSData* randomData = [[NSData alloc] initWithBytes:data length:32];
    PrivateSecrerSeed = [randomData mutableCopy];
    
    NSMutableData *PublicKey = [[NSMutableData alloc] initWithCapacity:32];
    NSMutableData *SecretKeyExpanded = [[NSMutableData alloc] initWithCapacity:64];

    //PrivateSecretKey Bytes
    NSUInteger len = [PrivateSecrerSeed length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [PrivateSecrerSeed bytes], len);

    //PublicKey Bytes
    NSUInteger len1 = 32;
    Byte *byteData1 = (Byte*)malloc(len1);
    memcpy(byteData1, [PublicKey bytes], len1);

    //SecretKeyExpanded Bytes
    NSUInteger len2 = 64;
    Byte *byteData2 = (Byte*)malloc(len2);
    memcpy(byteData2, [SecretKeyExpanded bytes], len2);

    ed25519_create_keypair(byteData1, byteData2, byteData);

    [PublicKey appendBytes:byteData1 length:len1];
    [SecretKeyExpanded appendBytes:byteData2 length:len2];

    NSMutableData *Address = [self GetAddressWithPublicKey:PublicKey UserName:Name networkType:networkType accountType:(AccountType)MainNormal];
    
    NSString *ADD = BTCBase58CheckStringWithData(Address);
  
    TFAccountIdentifier *accIdentifier = [[TFAccountIdentifier alloc] initWithPublicKey:PublicKey name:Name addressDataString:ADD];
    TFAccountInfo *accInformation = [[TFAccountInfo alloc] init];
    accInformation.account = accIdentifier;
    accInformation.secretSeed = PrivateSecrerSeed;

    return accInformation;
}

- (NSMutableData*)GetAddressWithPublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName
{
    return [self GetAddressWithPublicKey:PublicKey UserName:UserName networkType:self._NetworkType accountType:self._AccountType];
}

/**
 * Returns SHA512 hashed byte array of the given format
 * Address Format : Address = NetType || AccountType || [H(H(PK) || PK || NAME || NetType || AccountType)], Take first 20 bytes}
 * @param PublicKey
 * @param UserName
 * @param networkType
 * @param accountType
 * @return NSMutableData
 */
- (NSMutableData*)GetAddressWithPublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName networkType:(NetworkType)networkType accountType:(AccountType)accountType
{
    
    if ([self isAlphaNumeric:UserName] == false)
    {
        NSLog(@"Usernames should be lowercase, uppercase or alphanumeric, _ is allowed");
        return nil;
    }
    
    if (networkType == (NetworkType)MainNet) {
        if (accountType == (AccountType)TestGenesis ||
            accountType == (AccountType)TestValidator ||
            accountType == (AccountType)TestNormal) {
            NSLog(@"Invalid AccountType for the provided NetworkType.");
            return nil;
        }
    }

    NSData *na = [UserName dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *NAME = [na mutableCopy];
    NSMutableData *Hpk = [self SHA512Hash:PublicKey];

    Byte a[2] = {(Byte)networkType, (Byte)accountType};
    NSMutableData *NA_Type = [[NSMutableData alloc] init];
    [NA_Type appendBytes:a length:2];

    NSMutableData *Hpk_PK_NAME = [[NSMutableData alloc] init];
    [Hpk_PK_NAME appendData:Hpk];
    [Hpk_PK_NAME appendData:PublicKey];
    [Hpk_PK_NAME appendData:NAME];
    [Hpk_PK_NAME appendData:NA_Type];

    NSMutableData *H_Hpk_PK_NAME0 = [self SHA512Hash:Hpk_PK_NAME];
    NSData *H_Hpk_PK_NAME1 = [H_Hpk_PK_NAME0 subdataWithRange:NSMakeRange(0, 20)];
    NSMutableData *H_Hpk_PK_NAME = [H_Hpk_PK_NAME1 mutableCopy];
    
    NSMutableData *Address_PH = [[NSMutableData alloc] init];

    //Address_PH Bytes
    NSUInteger len = [Address_PH length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [Address_PH bytes], len);

    //NA_Type Bytes
    NSUInteger len1 = [NA_Type length];
    Byte *byteData1 = (Byte*)malloc(len1);
    memcpy(byteData1, [NA_Type bytes], len1);

    byteData[0] = byteData1[0];
    byteData[1] = byteData1[1];
    
    [Address_PH appendBytes:byteData length:2];
    [Address_PH appendData:H_Hpk_PK_NAME];
    
    return Address_PH;
 
    return nil;
}

/**
 * Get address string
 * @author Ashish Gogna
 *
 * @param address address data
 * @return NSMutableData
 */
- (NSString*)GetAddressStringWithAddress:(NSMutableData*)Address
{
    if (Address.length != 22)
    {
        NSLog(@"Invalid Address Length. Must be 22 bytes");
        return nil;
    }
    else
    {
        return BTCBase58CheckStringWithData(Address);
    }
}

/**
 * Returns true if the address, is consistent with the provided UserName and PublicKey
 * @param Address Address without checksum
 * @param PublicKey 32 byte Public Key
 * @param UserName UserName / can be zero length.
 * @return BOOL
 */
- (BOOL)VerifyAddressWithAddressData:(NSMutableData*)Address PublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName
{
    if ([Address isEqualToData:[self GetAddressWithPublicKey:PublicKey UserName:UserName]])
    {
        return true;
    }
    return false;
}

- (BOOL)VerifyAddressWithAddress:(NSString*)Address PublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName
{
    if ([Address isEqualToString:BTCBase58CheckStringWithData([self GetAddressWithPublicKey:PublicKey UserName:UserName])])
    {
        return true;
    }
    return false;
}

- (BOOL)VerifyAddressWithAddress:(NSString*)Address PublicKey:(NSMutableData*)PublicKey UserName:(NSString*)UserName networkType:(NetworkType)networkType accountType:(AccountType)accountType
{
    if ([Address isEqualToString:BTCBase58CheckStringWithData([self GetAddressWithPublicKey:PublicKey UserName:UserName networkType:networkType accountType:accountType])])
    {
        return true;
    }
    return false;
}

//Helpers

/**
 * Check if a string is alphanumeric (contains valid characrters)
 * @author Ashish Gogna
 *
 * @param NSString string to be converted
 * @return BOOL
 */
- (BOOL)isAlphaNumeric: (NSString*)string
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];
    s = [s invertedSet];
    
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return false;
    }
    else
    {
        return true;
    }
}

/**
 * SHA512 Hash
 * @author Ashish Gogna
 *
 * @param NSMutableData data to be hashed
 * @return NSMutableData
 */
- (NSMutableData *) SHA512Hash: (NSMutableData*)data {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [data bytes], (CC_LONG)[data length], hash );
    return ( [NSMutableData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}


- (TFAccountIdentifier*)PrivateKeyToAccountWithPrivateSecretSeed:(NSMutableData*)PrivateSecretSeed
{
    return [self PrivateKeyToAccountWithPrivateSecretSeed:PrivateSecretSeed Name:@""];
}

- (TFAccountIdentifier*)PrivateKeyToAccountWithPrivateSecretSeed:(NSMutableData*)PrivateSecretSeed Name:(NSString*)Name
{
    NSMutableData *PublicKey = nil;
    NSMutableData *SecretKeyExpanded = nil;
    
    //PrivateSecretKey Bytes
    NSUInteger len = [PrivateSecretSeed length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [PrivateSecretSeed bytes], len);
    
    //PublicKey Bytes
    NSUInteger len1 = 32;
    Byte *byteData1 = (Byte*)malloc(len1);
    memcpy(byteData1, [PublicKey bytes], len1);
    
    //SecretKeyExpanded Bytes
    NSUInteger len2 = 64;
    Byte *byteData2 = (Byte*)malloc(len2);
    memcpy(byteData2, [SecretKeyExpanded bytes], len2);

    ed25519_create_keypair(byteData1, byteData2, byteData);
    return [self PublicKeyToAccountWithPublicKey:PublicKey Name:Name];
}
- (TFAccountIdentifier*)PublicKeyToAccountWithPublicKey:(NSMutableData*)PublicKey
{
    return [self PublicKeyToAccountWithPublicKey:PublicKey Name:@""];
}

- (TFAccountIdentifier*)PublicKeyToAccountWithPublicKey:(NSMutableData*)PublicKey Name:(NSString*)Name
{
    NSMutableData *Address = [self GetAddressWithPublicKey:PublicKey UserName:Name networkType:(NetworkType)MainNet accountType:(AccountType)MainNormal];
    NSString *ADD = BTCBase58CheckStringWithData(Address);
    TFAccountIdentifier *accIdentifier = [[TFAccountIdentifier alloc] initWithPublicKey:PublicKey name:Name addressDataString:ADD];
    return accIdentifier;
}

- (TFAddressData*)DecodeAddressString:(NSString*)Base58Address
{
    TFAddressData *ad = [[TFAddressData alloc] initWithBase58Address:Base58Address];
    return ad;
}

- (TFAccountIdentifier*)CreateNewAccountIdenntifierWithPublicKey:(NSMutableData*)publicKey name:(NSString*)name addressDataString:(NSString*)addressDataString
{
    TFAccountIdentifier *ai = [[TFAccountIdentifier alloc] initWithPublicKey:publicKey name:name addressDataString:addressDataString];
    return ai;
}

/**
 * Conver NSData to hexadecimal string
 * @author Ashish Gogna
 *
 * @param NSMutableData data to be converted
 * @return NSString
 */
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

/**
 * Conver hexadecimal string to NSData
 * @author Ashish Gogna
 *
 * @param NSString string to be converted
 * @return NSMutableData
 */
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

@end
