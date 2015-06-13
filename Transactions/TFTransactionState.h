//
//  TFTransactionState.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/15/15.
//

#import <Foundation/Foundation.h>
#import "TFTransactionContent.h"

@interface TFTransactionState : NSObject

@property (nonatomic) TransactionProcessingResult processingResult;
@property (nonatomic) TransactionStatusType statusType;
@property (nonatomic) NSDate *FetchTimeUTC;

- (id)initWithProcessingResult:(TransactionProcessingResult)ProcessingResult;
- (id)initWithStatusType:(TransactionStatusType)StatusType;

@end
