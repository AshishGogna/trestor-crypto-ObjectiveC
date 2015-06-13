//
//  TFTransactionFactory.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/13/15.
//

#import "TFTransactionFactory.h"
#import "TFTransactionEntity.h"

@implementation TFTransactionFactory

long destValue, transactionFee = 0;

/**
 * Created new transaction data based on the given paramaters
 * Timestamp of transaction is set to the current time
 * @param source
 * @param destination
 * @param transactionFee
 * @param destValue
 */
- (id)initWithSource:(TFAccountIdentifier*)source destination:(TFAccountIdentifier*)destination transactionFee:(long)transactionFee1 destValue:(long long)destValue1
{
    if (self)
    {
        self.source = source;
        self.destination = destination;
        destValue = destValue1;
        transactionFee = transactionFee1;
        
        TFTransactionEntity *teSrc = [[TFTransactionEntity alloc] initWithAccount:self.source value:destValue+transactionFee];
        TFTransactionEntity *teDest = [[TFTransactionEntity alloc] initWithAccount:self.destination value:destValue];
        
        long timeUtc = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
        long zeroes = 10000000;
        long long miscno = 116444736000000000;
        unsigned long long timeWindows0 = (unsigned long long)timeUtc*zeroes;
        unsigned long long timeWindows = (unsigned long long)timeWindows0 + miscno;
        
        NSMutableArray *srcArray = [[NSMutableArray alloc] initWithObjects:teSrc, nil];
        NSMutableArray *destArray = [[NSMutableArray alloc] initWithObjects:teDest, nil];
        
        TFTransactionContent *TC = [[TFTransactionContent alloc] initWithSources:srcArray Destinations:destArray TransactionFee:transactionFee Timestamp:timeWindows];
        self.TC = TC;
        self.tranxData = [TC GetTransactionData];
        self.tranxDataAndSig = [TC GetTransactionDataAndSignature];
    }
    
    return self;
}

/**
 * Use signature data, with the transaction data to create TransactionContent
 * @param signature
 * @return TransactionProcessingResult
 */
- (TransactionProcessingResult)CreateSignature:(TFHash*)signature
{
    NSMutableArray *sigs = [[NSMutableArray alloc] initWithObjects:signature, nil];
    [self.TC setSigs:sigs];
    
    return [self.TC VerifySignature];
}


@end
