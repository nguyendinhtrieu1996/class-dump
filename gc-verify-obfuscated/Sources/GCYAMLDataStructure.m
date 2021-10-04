//
//  GCYAMLDataStructure.m
//  gc-verify-obfuscated
//
//  Created by Trieu Nguyen on 01/10/2021.
//

#import "GCYAMLDataStructure.h"


@interface GCYAMLDataStructure ()
{
    NSMutableDictionary *_mutableInstaceMethodDict;
}
@end // @interface GCYAMLDataStructure ()


@implementation GCYAMLDataStructure

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mutableInstaceMethodDict = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithInterfaceName:(NSString *)interfaceName
                   instanceMethodDict:(NSDictionary<NSString *,NSString *> *)instanceMethodDict {
    self = [super init];
    if (self) {
        _interfaceName = interfaceName;
        _mutableInstaceMethodDict = [NSMutableDictionary dictionaryWithDictionary:instanceMethodDict];
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)instanceMethodDict {
    return _mutableInstaceMethodDict.copy;
}

- (void)addInstanceMethod:(NSString *)instanceMethod {
    _mutableInstaceMethodDict[instanceMethod] = @"1";
}

@end // @implementation GCYAMLDataStructure
