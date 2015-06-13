//
//  TFProofOfWork.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/18/15.
//

#import "TFProofOfWork.h"
#import "TFBitConverter.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "TFAddressFactory.h"
#import "TFUtilities.h"

@implementation TFProofOfWork

- (id)init
{
    /**
     * Specifies the number of zeros in increasing order
     */
    NSMutableData *bm = [[NSMutableData alloc] init];
    Byte bm0 = 0xFF;
    Byte bm1 = 0x7F;
    Byte bm2 = 0x3F;
    Byte bm3 = 0x1F;
    Byte bm4 = 0x0F;
    Byte bm5 = 0x07;
    Byte bm6 = 0x03;
    Byte bm7 = 0x01;
    [bm appendBytes:&bm0 length:1];
    [bm appendBytes:&bm1 length:1];
    [bm appendBytes:&bm2 length:1];
    [bm appendBytes:&bm3 length:1];
    [bm appendBytes:&bm4 length:1];
    [bm appendBytes:&bm5 length:1];
    [bm appendBytes:&bm6 length:1];
    [bm appendBytes:&bm7 length:1];
    self.bitMask = bm;
    
    return self;
}

/**
 * Calculates a Work Proof based on a given Difficulty
 * @param source
 * @param difficulty
 * @return NSString
 */
- (NSString*)CalculateProof:(NSString*)source difficulty:(int)difficulty;
{
    /*
    NSData *sourceBytes1 = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *sourceBytes = [sourceBytes1 mutableCopy];
    */
    
    source = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
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
    
    NSMutableData *outBytes = [self CalculateProof:commandToSend Difficulty:difficulty];
    
    TFAddressFactory *af = [[TFAddressFactory alloc] init];
    NSString *proofResult = [TFUtilities nsdataToHex:outBytes];
    
    return proofResult;
}

- (NSMutableData*)CalculateProof: (NSMutableData*)Initial Difficulty:(int)Difficulty
{
    TFBitConverter *bc = [[TFBitConverter alloc] init];
    TFAddressFactory *af = [[TFAddressFactory alloc] init];
    

    BOOL found = false;
    int InitialLength = Initial.length;
    
    int zeroBytes = Difficulty / 8;
    int zeroBits = Difficulty % 8;
    
    NSMutableData *content = [[NSMutableData alloc] initWithCapacity:InitialLength+4];
    NSMutableData *c0 = [[NSMutableData alloc] initWithLength:4];
    [content appendData:Initial];
    [content appendData:c0];

    int counter = 0;
    
    if (zeroBytes < 30)
    {
        while (!found)
        {
            NSMutableData *countBytes = [bc getBytes:counter];
            [content replaceBytesInRange:NSMakeRange(InitialLength, 4) withBytes:[countBytes mutableBytes]];
            
            NSMutableData *Hash = [self SHA256Hash:[self SHA256Hash:content]];
            
            BOOL bytesGood = true;
            
            for (int i=0; i<zeroBytes; i++)
            {
                //Hash Bytes
                NSUInteger len = [Hash length];
                Byte *byteData = (Byte*)malloc(len);
                memcpy(byteData, [Hash bytes], len);
                
                if (byteData[i] != 0)
                {
                    bytesGood = false;
                    break;
                }
            }
            
            if (bytesGood)
            {
                //bitMask Bytes
                NSUInteger len = [self.bitMask length];
                Byte *byteData = (Byte*)malloc(len);
                memcpy(byteData, [self.bitMask bytes], len);
                
                //Hash Bytes
                NSUInteger len1 = [Hash length];
                Byte *byteData1 = (Byte*)malloc(len1);
                memcpy(byteData1, [Hash bytes], len1);
                
                if ((byteData[zeroBits] | byteData1[zeroBytes]) == byteData[zeroBits])
                {
                    found = true;
                    
                    NSMutableData *d = [bc getBytes:counter];
                    return d;
                }
            }
            
            counter++;
        }
    }
    NSLog(@"Proof calculation failure");
    return nil;
}

- (NSMutableData *) SHA256Hash: (NSMutableData*)data {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [data bytes], (CC_LONG)[data length], hash );
    return ( [NSMutableData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}
@end
