//
//  GCYAMLDataStructure.h
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCYAMLDataStructure : NSObject

@property (nonatomic, readonly) NSString *interfaceName;

@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *instanceMethodDict;

- (instancetype)initWithInterfaceName:(NSString *)interfaceName
                   instanceMethodDict:(NSDictionary<NSString *, NSString *> *)instanceMethodDict;

- (void)addInstanceMethod:(NSString *)instanceMethod;

@end // @interface GCYAMLDataStructure

NS_ASSUME_NONNULL_END
