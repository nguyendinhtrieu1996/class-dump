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

@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *instanceMethodsDict;

@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *classMethodsDict;

@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *propertiesDict;

@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *ivarsDict;

- (instancetype)initWithInterfaceName:(NSString *)interfaceName;

@end // @interface GCYAMLDataStructure

NS_ASSUME_NONNULL_END
