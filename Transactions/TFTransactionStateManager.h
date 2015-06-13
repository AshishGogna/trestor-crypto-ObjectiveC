//
//  TFTransactionStateManager.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/15/15.
//

#import <Foundation/Foundation.h>
#import "TFTransactionContent.h"

@interface TFTransactionStateManager : NSObject

@property (nonatomic) NSMutableDictionary *TransactionProcessingMap;
@property (nonatomic) TransactionProcessingResult *tprtemp;

@end
