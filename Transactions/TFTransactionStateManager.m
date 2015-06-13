//
//  TFTransactionStateManager.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/15/15.
//

#import "TFTransactionStateManager.h"
#import "TFHash.h"
#import "TFTransactionContent.h"
#import "TFTransactionState.h"

@implementation TFTransactionStateManager


- (id)init
{
    self.TransactionProcessingMap = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)Set:(TFHash*)TransactionID TransactionProcessingResult:(TransactionProcessingResult)transactionProcessingResult
{
    if ([[self.TransactionProcessingMap allKeys] containsObject:TransactionID])
    {
        TFTransactionState *ts = [self.TransactionProcessingMap objectForKey:TransactionID];
        ts.processingResult = transactionProcessingResult;
        [self.TransactionProcessingMap setObject:ts forKey:TransactionID];
    }
    else
    {
        TFTransactionState *ts = [[TFTransactionState alloc] initWithProcessingResult:transactionProcessingResult];
        [self.TransactionProcessingMap setObject:ts forKey:TransactionID];
    }
}

- (void)Set:(TFHash*)TransactionID transactionStatusType:(TransactionStatusType)transactionStatusType
{
    if ([[self.TransactionProcessingMap allKeys] containsObject:TransactionID])
    {
        TFTransactionState *ts = [self.TransactionProcessingMap objectForKey:TransactionID];
        ts.statusType = transactionStatusType;
        [self.TransactionProcessingMap setObject:ts forKey:TransactionID];
    }
    else
    {
        TFTransactionState *ts = [[TFTransactionState alloc] initWithStatusType:transactionStatusType];
        [self.TransactionProcessingMap setObject:ts forKey:TransactionID];
    }
}

- (BOOL)Fetch:(out TFTransactionState*)transactionState TransactionID:(TFHash*)TransactionID
{
    if ([[self.TransactionProcessingMap allKeys] containsObject:TransactionID])
    {
        transactionState = [self.TransactionProcessingMap objectForKey:TransactionID];
        return true;
    }
    
    transactionState = [[TFTransactionState alloc] init];
    return false;
}

- (void)ProcessAndClear
{
    NSDate *NOW = [NSDate date];
    
    NSArray *tsmKeys1 = [self.TransactionProcessingMap allKeys];
    NSMutableArray *tsmkeys = [tsmKeys1 mutableCopy];
    
    for (TFHash *key in tsmkeys)
    {
        TFTransactionState *ts;
        if ([self.TransactionProcessingMap valueForKey:key] == ts)
        {
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *span = [currentCalendar components:unitFlags
                                                                      fromDate:NOW
                                                                        toDate:ts.FetchTimeUTC
                                                                       options:0];
            if ([span second] > 30)
            {
                [self.TransactionProcessingMap removeObjectForKey:key];
            }
        }
    }
}

@end
