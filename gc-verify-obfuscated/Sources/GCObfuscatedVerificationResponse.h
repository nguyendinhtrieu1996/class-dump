//
//  GCObfuscatedVerificationResponse.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GCObfuscatedVerificationResult) {
        GCObfuscatedVerificationResult_Same = 0,
        GCObfuscatedVerificationResult_Different = 1,
};


@interface GCObfuscatedVerificationResponse : NSObject

@property (nonatomic, readonly) GCObfuscatedVerificationResult result;
@property (nonatomic, readonly) NSArray<NSString *> *messages;

- (instancetype)initWithResult:(GCObfuscatedVerificationResult)result
                      messages:(NSArray<NSString *> *)messages;

- (void)addMessage:(NSString *)message;

- (NSString *)finalizeMessages;

@end // @interface GCObfuscatedVerificationResponse

NS_ASSUME_NONNULL_END
