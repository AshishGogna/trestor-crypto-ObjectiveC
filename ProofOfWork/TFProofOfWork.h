//
//  TFProofOfWork.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/18/15.
//

#import <Foundation/Foundation.h>

@interface TFProofOfWork : NSObject

@property (nonatomic) NSMutableData *bitMask;

- (NSString*)CalculateProof:(NSString*)source difficulty:(int)difficulty;

@end
