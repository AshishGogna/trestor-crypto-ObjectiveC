//
//  TFNA_Type.h
//  Trestor Wallet Crypto
//
//  Created by Ashish Gogna on 2/12/15.
//

#import <Foundation/Foundation.h>

@interface TFNA_Type : NSObject

typedef enum NetworkType { MainNet = 14, TestNet = 29 } NetworkType;
typedef enum AccountType
{
    MainGenesis = 201, MainValidator = 234, MainNormal = 217,
    TestGenesis = 25, TestValidator = 59, TestNormal = 40
} AccountType;

@end
