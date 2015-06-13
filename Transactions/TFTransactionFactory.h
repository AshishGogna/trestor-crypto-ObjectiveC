//
//  TFTransactionFactory.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/13/15.
//

#import <Foundation/Foundation.h>
#import "TFAccountIdentifier.h"
#import "TFTransactionContent.h"

@interface TFTransactionFactory : NSObject

@property (nonatomic) TFAccountIdentifier *source;
@property (nonatomic) TFAccountIdentifier *destination;
@property (nonatomic) TFTransactionContent *TC;
@property (nonatomic) NSMutableData *tranxData;
@property (nonatomic) NSMutableData *tranxDataAndSig;

- (TransactionProcessingResult)CreateSignature:(TFHash*)signature;

- (id)initWithSource:(TFAccountIdentifier*)source destination:(TFAccountIdentifier*)destination transactionFee:(long)transactionFee1 destValue:(long long)destValue1;

@end
