//
//  TFHash.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/12/15.
//

#import "TFHash.h"

@implementation TFHash

- (id)init
{
    /*
    NSString *xs = @"ashish";
    NSData *xd = [xs dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *data = [xd mutableCopy];

    NSString *xs1 = @"shila";
    NSData *xd1 = [xs1 dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *data1 = [xd1 mutableCopy];

    [self CompareX:data Y:data1];
    */
    return self;
}

/**
 * Initiate the class
 * @param hashValue
 * @return id
 */
- (id)initHashWithValue:(NSMutableData*)Value
{
    if (self)
    {
        self.HashValue = Value;
    }
    
    return self;
}

/**
 * Initiate the Hash
 * @return id
 */
- (id)initHash
{
    if (self)
    {
        self.HashValue = [[NSMutableData alloc] init];
    }
    
    return self;
}

/**
 * Return the Hash value
 * @return NSMutableData
 */
- (NSMutableData*)Hex
{
    return self.HashValue;
}

/// Returns if the compared value is equal to the Hash value.
- (BOOL)Equals:(TFHash*)obj
{
    if (obj == nil)
        return false;
    
    if (self.HashValue.length == obj.HashValue.length)
    {
        //self.HashValue Bytes
        NSUInteger len = self.HashValue.length;
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [self.HashValue bytes], len);

        //obj Bytes
        NSUInteger len1 = obj.HashValue.length;
        Byte *byteData1 = (Byte*)malloc(len1);
        memcpy(byteData1, [obj.HashValue bytes], len);

        BOOL equal = true;
        for (int i = 0; i < self.HashValue.length; i++)
        {
            if (byteData[i] != byteData1[i])
            {
                equal = false;
                break;
            }
        }
        return equal;
    }
    return false;
}

- (int)CompareX:(NSMutableData*)x Y:(NSMutableData*)y
{
    
    if (x == nil && y == nil) return 0;
    if (x == nil && y != nil) return -1;
    if (x != nil && y == nil) return 1;

    int bytesToCompare = MIN(x.length, y.length);

    //x Bytes
    NSUInteger len = x.length;
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [x bytes], len);
    
    //y Bytes
    NSUInteger len1 = y.length;
    Byte *byteData1 = (Byte*)malloc(len1);
    memcpy(byteData1, [y bytes], len);

    for (int index=0; index<bytesToCompare; ++index)
    {
        Byte xByte = byteData[index];
        Byte yByte = byteData1[index];
        
        int compareResult;
        if (xByte == yByte)
            compareResult = 0;
        else if (xByte < yByte)
            compareResult = -1;
        else if (xByte > yByte)
            compareResult = 1;

        if (compareResult != 0) return compareResult;
    }
    
    if (x.length == y.length) return 0;
    
    return x.length < y.length ? -1 : 1;
}

- (int)CompareToOther:(TFHash*)other
{
    if (self == other)
        return 0;
    
    if (other == nil)
    {
        NSLog(@"Arguement is Nil");
    }
    return [self CompareX:self.HashValue Y:[other Hex]];
}

- (int)CompareTFHashX:(TFHash*)x Y:(TFHash*)y
{
    if (x == y)
        return 0;
    
    if (x == nil || y == nil)
        NSLog(@"Arguements Nil");
    
    return [self CompareX:[x Hex] Y:[y Hex]];
}

- (int)compareHash:(TFHash*)h
{
    NSMutableData *thisHash = [self Hex];
    NSMutableData *otherHash = [h Hex];
    
    //thisHash Bytes
    NSUInteger len = thisHash.length;
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [thisHash bytes], len);
    
    //otherHash Bytes
    NSUInteger len1 = otherHash.length;
    Byte *byteData1 = (Byte*)malloc(len1);
    memcpy(byteData1, [otherHash bytes], len);

    
    if (thisHash.length > otherHash.length)
        return 1;

    else if (thisHash.length < otherHash.length)
        return -1;
    
    else
    {
        for (int i = thisHash.length - 1; i >= 0; i--) {
            if (byteData[i] > byteData1[i])
                return 1;
            else if (byteData[i] < byteData1[i])
                return -1;
        }
        return 0;
    }
}

@end
