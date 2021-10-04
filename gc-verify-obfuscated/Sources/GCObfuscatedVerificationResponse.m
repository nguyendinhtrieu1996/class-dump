//
//  GCObfuscatedVerificationResponse.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCObfuscatedVerificationResponse.h"

@interface GCObfuscatedVerificationResponse ()
{
    NSMutableArray<NSString *> *_mutableMessages;
}
@end // @interface GCObfuscatedVerificationResponse ()

@implementation GCObfuscatedVerificationResponse

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mutableMessages = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithResult:(GCObfuscatedVerificationResult)result
                      messages:(NSArray<NSString *> *)messages {
    
    self = [self init];
    if (self) {
        _result = result;
        _mutableMessages = [NSMutableArray arrayWithArray:messages];
    }
    return self;
}

- (NSArray<NSString *> *)messages {
    return _mutableMessages.copy;
}

- (void)addMessage:(NSString *)message {
    [_mutableMessages addObject:message];
}

- (NSString *)finalizeMessages {
    return [_mutableMessages componentsJoinedByString:@" | "];
}

@end // @implementation GCObfuscatedVerificationResponse
