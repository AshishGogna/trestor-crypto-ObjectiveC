//
//  TFPasswordAES.h
//  Trestor
//
//  Created by Ashish Gogna on 4/16/15.
//

#import <Foundation/Foundation.h>

@interface TFPasswordAES : NSObject

/**
 * Encrypt a Message with a password (Used for encrypting Private Key)
 * @author Ashish Gogna
 *
 * @param NSString private key string
 * @param NSString password string
 * @return NSMutableArray
 */
- (NSMutableArray*)EncryptMessage: (NSString*)privateKeyString withPassword: (NSString*)password;

/**
 * Decrypt a Message with password (Used for decrypting Private Key)
 * @author Ashish Gogna
 *
 * @param NSMutableArray array containing cipher, salt and hash
 * @param NSString password string
 * @return NSString
 */
- (NSString*)DecryptMessage: (NSMutableArray*)input withPassword: (NSString*)password;

@property (nonatomic) NSData *iv;

@end
