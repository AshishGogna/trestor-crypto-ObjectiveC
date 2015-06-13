//
//  TFTransactionState.m
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/15/15.
//

#import "TFTransactionState.h"

@implementation TFTransactionState

- (id)init
{
    self.FetchTimeUTC = [NSDate date];
    
    return self;
}

- (id)initWithProcessingResult:(TransactionProcessingResult)ProcessingResult
{
    if (self)
    {
        self.processingResult = ProcessingResult;
    }
    
    return self;
}

- (id)initWithStatusType:(TransactionStatusType)StatusType
{
    if (self)
    {
        self.statusType = StatusType;
    }
    
    return self;
}

- (id)initWithProcessingResult:(TransactionProcessingResult)ProcessingResult StatusType:(TransactionStatusType)StatusType
{
    if (self)
    {
        self.processingResult = ProcessingResult;
        self.statusType = StatusType;
    }
    
    return self;
}

- (id)initWithFetchTimeUTC:(NSDate*)FetchTimeUTC ProcessingResult:(TransactionProcessingResult)ProcessingResult StatusType:(TransactionStatusType)StatusType
{
    if (self)
    {
        self.processingResult = ProcessingResult;
        self.statusType = StatusType;
        self.FetchTimeUTC = FetchTimeUTC;
    }
    
    return self;
}

@end
