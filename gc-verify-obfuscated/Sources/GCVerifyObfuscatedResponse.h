//
//  GCVerifyObfuscatedResponse.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GCVerifyObfuscatedResult) {
    GCVerifyObfuscatedResult_Same = 0,
    GCVerifyObfuscatedResult_Different = 1,
};


@interface GCVerifyObfuscatedResponse : NSObject

@property (nonatomic, readonly) GCVerifyObfuscatedResult result;
@property (nonatomic, readonly) NSArray<NSString *> *messages;

- (instancetype)initWithResult:(GCVerifyObfuscatedResult)result
                      messages:(NSArray<NSString *> *)messages;

- (void)addMessage:(NSString *)message;

- (NSString *)finalizeMessages;

@end // @interface GCVerifyObfuscatedResponse

NS_ASSUME_NONNULL_END
