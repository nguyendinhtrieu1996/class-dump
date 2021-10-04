//
//  GCObfuscatedVerificationError.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 04/10/2021.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const GCObfuscatedVerificationErrorDomain;


typedef NS_ENUM(int, GCObfuscatedVerificationError) {
    GCObfuscatedVerificationError_Unkown = 0,
    GCObfuscatedVerificationError_InvalidPath = 1,
    GCObfuscatedVerificationError_InvalidFormat = 2,
};


#pragma mark -

typedef NSString * GCObfuscatedVerificationErrDes NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT GCObfuscatedVerificationErrDes const GCObfuscatedVerificationErrDes_Unkown;

FOUNDATION_EXPORT GCObfuscatedVerificationErrDes const GCObfuscatedVerificationErrDes_InvalidPath;

FOUNDATION_EXPORT GCObfuscatedVerificationErrDes const GCObfuscatedVerificationErrDes_InvalidFormat;


#pragma mark -

#define GC_MAKE_ERROR(errorCode, description) \
        [NSError errorWithDomain:GCObfuscatedVerificationErrorDomain \
                            code:errorCode \
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys: \
                                    description, NSLocalizedDescriptionKey, \
                                    nil]]

NS_ASSUME_NONNULL_END
