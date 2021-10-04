//
//  GCObfuscatedVerification.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class GCVerifyObfuscatedResponse;


@interface GCObfuscatedVerification : NSObject

- (GCVerifyObfuscatedResponse *)verifyWithBlackListFile:(NSString *)blacklistFile
                                             dumpedPath:(NSString *)dumpedPath;

@end // @interface GCObfuscatedVerification

NS_ASSUME_NONNULL_END
