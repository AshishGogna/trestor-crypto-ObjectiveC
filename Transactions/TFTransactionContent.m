//
//  TFTransactionContent.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/13/15.
//

#import "TFTransactionContent.h"
#import "TFTransactionEntity.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "ed25519.h"

@implementation TFTransactionContent

/**
 * Retur the Value
 * @return long
 */
- (long)Value
{
    long val = 0;
    for (TFTransactionEntity *te in self.Sources)
    {
        val += te._value;
    }
    return val;
}

/**
 * Initiate the Class
 * @return id
 */
- (id)init
{
    self.transactionFee = 0;
    
    Byte temp0[] = { 0, 0 };
    self.versionData = [[NSMutableData alloc] initWithBytes:temp0 length:2];
    self.executionData = [[NSMutableData alloc] init];

    self.Sources = [[NSMutableArray alloc] init];
    self.Destinations = [[NSMutableArray alloc] init];
    self.Signatures = [[NSMutableArray alloc] init];
    self.timeStamp = 0;
    self.transactionFee = 0;

    self.intTransactionID = [[TFHash alloc] init];
    
    return self;
}

/**
 * Set signatures
 * @param signatures
 * @return void
 */
- (void)setSigs: (NSMutableArray*)sigs
{
    self.Signatures = sigs;
    [self UpdateIntHash];
}

/**
 * Initiate the class
 * @param sources
 * @param destinations
 * @param transactionFee
 * @param signatures
 * @param timeStamp
 * @return id
 */
- (id)initWithSources:(NSMutableArray*)Sources Destinations:(NSMutableArray*)Destinations TransactionFee:(long)TransactionFee Signatures:(NSMutableArray*)Signatures Timestamp:(unsigned long long)Timestamp
{
    if (self)
    {
        self.Destinations = Destinations;
        self.timeStamp = Timestamp;
        self.Sources = Sources;
        self.Signatures = Signatures;
        self.transactionFee = TransactionFee;
        
        [self UpdateIntHash];
//        UpdateIntHash();
    }
    return self;
}

/**
 * Initiate the class
 * @param sources
 * @param destinations
 * @param transactionFee
 * @param timeStamp
 * @return id
 */
- (id)initWithSources:(NSMutableArray*)Sources Destinations:(NSMutableArray*)Destinations TransactionFee:(long)TransactionFee Timestamp:(unsigned long long)Timestamp
{
    if (self)
    {
        Byte temp0[] = { 0, 0 };
        self.versionData = [[NSMutableData alloc] initWithBytes:temp0 length:2];

        self.Destinations = Destinations;
        self.timeStamp = Timestamp;
        self.Sources = Sources;
        self.transactionFee = TransactionFee;

        self.intTransactionID = [[TFHash alloc] init];
    }
    return self;
}

/// Verifies all the signatures for all the sources.
- (TransactionProcessingResult) VerifySignature
{
    TransactionProcessingResult tp_result = [self IntegrityCheck];
    
    if (tp_result != (TransactionProcessingResult)Accepted)
    {
        return tp_result;
    }
    
    NSMutableData *transactionData = [self GetTransactionData];
    
    int PassedSignatures = 0;
    
    for (int i=0; i<self.Sources.count; i++)
    {
        TFHash *temp = self.Signatures[i];
        TFTransactionEntity *temp1 = self.Sources[i];
//        TFTransactionEntity *ts = self.Sources[i];
        
        BOOL good = ed25519_verify([temp.HashValue mutableBytes], [transactionData mutableBytes], transactionData.length, [temp1.publicKey mutableBytes]);
        
        if (good)
        {
            PassedSignatures++;
        }
        else
        {
            return (TransactionProcessingResult)SignatureInvalid;
        }
    }
    
    if (PassedSignatures == self.Sources.count)
    {
        return (TransactionProcessingResult)Accepted;
    }
    else
    {
        return (TransactionProcessingResult)InsufficientSignatureCount;
    }
}

- (BOOL)IsSource:(TFHash*)SourcePublicKey
{
    for (int i=0; i<self.Sources.count; i++)
    {
        TFTransactionEntity *te = self.Sources[i];
        if (te.publicKey == SourcePublicKey.HashValue)
            return true;
    }
    return false;
}

- (BOOL)IsDestination:(TFHash*)DestinationPublicKey
{
    for (int i=0; i<self.Destinations.count; i++)
    {
        TFTransactionEntity *te = self.Destinations[i];
        if (te.publicKey == DestinationPublicKey.HashValue)
            return true;
    }
    return false;
}

/**
 *
 * @return transactionData transaction data which needs to be signed by all the individual sources
 */
- (NSMutableData*)GetTransactionData
{
    NSMutableArray *transactionData = [[NSMutableArray alloc] init];
    
    
//    [self addRange:transactionData data:self.versionData];
//    [self addRange:transactionData data:self.executionData];
    [transactionData addObject:self.versionData];
    if (self.executionData != nil)
        [transactionData addObject:self.executionData];
    
    
    for (TFTransactionEntity *ts in self.Sources)
    {
//        [self addRange:transactionData data:ts.publicKey];
//        [self addRange:transactionData data:[self Int64ToVector:ts._value]];
        [transactionData addObject:ts.publicKey];
        [transactionData addObject:[self Int64ToVector:ts._value]];
    }

    // Adding Destinations
    for (TFTransactionEntity *td in self.Destinations)
    {
//        [self addRange:transactionData data:td.publicKey];
//        [self addRange:transactionData data:[self Int64ToVector:td._value]];
        [transactionData addObject:td.publicKey];
        [transactionData addObject:[self Int64ToVector:td._value]];
    }

//    [self addRange:transactionData data:[self Int64ToVector:self.transactionFee]];
//    [self addRange:transactionData data:[self Int64ToVector:self.timeStamp]];
    [transactionData addObject:[self Int64ToVector:self.transactionFee]];
    [transactionData addObject:[self Int64ToVector:self.timeStamp]];

    NSMutableData *data = [[NSMutableData alloc] init];
    for (int i=0; i<transactionData.count; i++)
    {
        NSMutableData *d = transactionData[i];
        [data appendData:d];
    }
    
    return data;
}

/**
 *
 * @returns transaction dta and signatures
 */
- (NSMutableData*)GetTransactionDataAndSignature
{
    NSMutableArray *tranDataSig = [[NSMutableArray alloc] init];
    
    NSMutableData *tranData = [self GetTransactionData];

    [tranDataSig addObject:tranData];
    
    for (TFHash *sig in self.Signatures)
    {
        [tranDataSig addObject:sig.HashValue];
//        [self addRange:tranDataSig data:sig.HashValue];
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    for (int i=0; i<tranDataSig.count; i++)
    {
        NSMutableData *d = tranDataSig[i];
        [data appendData:d];
    }

    return data;
}

/**
 * Updates the transaction id
 */
- (void)UpdateIntHash
{
    NSMutableData *tranDataSig = [self GetTransactionDataAndSignature];
    
    NSMutableData *output0 = [self SHA512Hash:tranDataSig];
    NSMutableData *output1 = [[output0 subdataWithRange:NSMakeRange(0, 32)] mutableCopy];
    self.intTransactionID = [[TFHash alloc] initHashWithValue:output1];
}

/**
 *
 * @param transactionData
 * @param data
 */
- (void)addRange:(NSMutableArray*)transactionData data:(NSMutableData*)data
{
    //data Bytes
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);

    
    for (int i = 0; i < data.length; i++) {

        [transactionData addObject:[NSNumber numberWithInt:byteData[i]]];
    }
}

- (NSMutableData*)Int64ToVector:(unsigned long long)data
{
    NSMutableData *_out = [[NSMutableData alloc] initWithCapacity:8];
    
    for (int i = 0; i < 8; i++) {
        Byte a = (Byte) (((data >> (8 * i)) & 0xFF));
        [_out appendBytes:&a length:1];
    }
    
    return _out;
}

- (NSMutableData *) SHA512Hash: (NSMutableData*)data {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [data bytes], (CC_LONG)[data length], hash );
    return ( [NSMutableData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

/**
 * Checks the general integrity of transaction. Does not guarantee signatures are valid
 * @return TransactionProcessingResult
 */
- (TransactionProcessingResult)IntegrityCheck
{

    //versionData Bytes
    NSUInteger len = [self.versionData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [self.versionData bytes], len);
    
    long incoming = 0;
    long outgoing = 0;

    for (TFTransactionEntity *src in self.Sources)
    {
        for (TFTransactionEntity *dst in self.Destinations)
        {
            if (src.address == dst.address)
            {
                return (TransactionProcessingResult)SourceDestinationRepeat;
            }
        }
    }

    if (self.Sources.count != self.Signatures.count)
        return (TransactionProcessingResult)InsufficientSignatureCount;

    for (TFTransactionEntity *te in self.Sources)
    {
        if (te._value <= 0)
            return (TransactionProcessingResult)NoProperSources;
        
        incoming += te._value;
    }
    
    for (TFTransactionEntity *te in self.Destinations)
    {
        if (te._value <=0)
            return (TransactionProcessingResult)NoProperDestinations;
        
        outgoing+= te._value;
    }
    
    outgoing += self.transactionFee;
    
    
    if ((incoming == outgoing) && (self.Sources.count>0) && (self.Destinations.count>0))
    {
        return (TransactionProcessingResult)Accepted;
    }
    else
    {
        return (TransactionProcessingResult)InsufficientFunds;
    }
}

@end
